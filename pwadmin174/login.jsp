<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.security.*"%>
<%@page import="java.sql.*"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>

<%!
    private String generateSalt() {
        return BCrypt.gensalt();
    }

    private static String hashPassword(String password, String salt) {
        return BCrypt.hashpw(password, salt);
    }

    private static Connection getConnection(String db_host, String db_port, String db_database, String db_user, String db_password) throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Failed to load MySQL JDBC driver.", e);
        }
         String url = "jdbc:mysql://" +  db_host  + ":" + db_port  + "/" + db_database ;
        return DriverManager.getConnection(url,db_user, db_password);
    }


%>
<style>
    body {
        background-color: #333;
        color: #eee;
    }
    .login-container {
        width: 350px;
        margin: 100px auto;
        padding: 20px;
        border: 1px solid #555;
        border-radius: 5px;
        background-color: #444;
    }
    .login-container h2 {
        text-align: center;
        margin-bottom: 20px;
    }
    .login-form label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }
    .login-form input[type="text"],
    .login-form input[type="password"] {
        width: 100%;
        padding: 8px;
        margin-bottom: 10px;
        border: 1px solid #777;
        border-radius: 3px;
        background-color: #555;
        color: #eee;
    }
    .login-form input[type="image"] {
        display: block;
        margin: 10px auto;
        border: 0px;
    }
    .logout-button {
        display: block;
        margin: 10px auto;
    }
    .error-message {
        color: #ff0000;
        text-align: center;
        margin-bottom: 10px;
    }
     .return-button {
       display: block;
       margin: 10px auto;
       text-align: center;
       padding: 10px 15px;
       background-color: #666;
       color: white;
       border: none;
       border-radius: 5px;
       text-decoration: none;
       cursor: pointer;
    }
    .return-button:hover {
       background-color: #888;
    }
     #reload-image{
        width: 6%;
    }

</style>

<div class="login-container">
    <h2><%= T("login.title") %></h2>
    <%
        String errorMessage = "";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean initialLogin = false;

        if(request.getParameter("logout") != null && request.getParameter("logout").compareTo("true") == 0)
        {
            request.getSession().removeAttribute("ssid");
            request.getSession().removeAttribute("items");
            request.getSession().removeAttribute("captcha");
            request.getSession().removeAttribute("gmUser");
            request.getSession().removeAttribute("gmAccess");
        }

        try {
            conn = getConnection(db_host, db_port, db_database, db_user, db_password);

           DatabaseMetaData dbm = conn.getMetaData();
           ResultSet tables = dbm.getTables(null, null, "admin_users", null);
            if(!tables.next())
            {
                String createTableSql = "CREATE TABLE admin_users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) UNIQUE NOT NULL, password_hash VARCHAR(255) NOT NULL, salt VARCHAR(255) NOT NULL)";
                pstmt = conn.prepareStatement(createTableSql);
                pstmt.executeUpdate();
            }

            String countSql = "SELECT COUNT(*) FROM admin_users";
            pstmt = conn.prepareStatement(countSql);
            rs = pstmt.executeQuery();
            rs.next();
            int rowCount = rs.getInt(1);

            initialLogin = rowCount == 0;


          if (initialLogin) {
                 if(request.getMethod().equalsIgnoreCase("POST") && request.getParameter("createadmin") != null)
                 {
                    String enteredUsername = request.getParameter("username");
                    String enteredPassword = request.getParameter("password");
                    String clientIP = request.getRemoteAddr();

                     String salt = generateSalt();
                      String hashedPassword = hashPassword(enteredPassword, salt);

                           try {
                                String sql = "INSERT INTO admin_users (username, password_hash, salt) VALUES (?, ?, ?)";
                                pstmt = conn.prepareStatement(sql);
                                pstmt.setString(1, enteredUsername);
                                pstmt.setString(2, hashedPassword);
                                pstmt.setString(3, salt);
                                pstmt.executeUpdate();

                                 request.getSession().setAttribute("ssid", request.getRemoteAddr());
                                 request.getSession().setAttribute("ipAllowed", true);

                                 response.sendRedirect("index.jsp");
                                 return;


                           } catch (SQLException e) {
                                errorMessage = "<p class=\"error-message\">" + Tf("login.error.store_creds", e.getMessage()) + "</p>";
                                 e.printStackTrace();
                           }

                 }else
                   {
                    out.println("<p style=\"text-align:center\">" + T("login.initial_desc") + "</p>");
                    out.println("<form action=\"login.jsp\" method=\"post\" class=\"login-form\">");
                    out.println(errorMessage);
                    out.println("<input type=\"hidden\" name=\"createadmin\" value=\"true\">");
                    out.println("<label for=\"username\">" + T("login.username") + "</label>");
                    out.println("<input type=\"text\" id=\"username\" name=\"username\" required>");
                    out.println("<label for=\"password\">" + T("login.password") + "</label>");
                    out.println("<input type=\"password\" id=\"password\" name=\"password\" required>");
                     out.println("<input type=\"image\" src=\"include/btn_login.jpg\" style=\"border: 0px;\" alt=\"" + T("login.create_admin_btn") + "\"></input>");
                    out.println("</form>");
                }
             }else
               {
                  if(request.getMethod().equalsIgnoreCase("POST"))
                    {
                        if(request.getParameter("username") != null && request.getParameter("password") != null)
                        {
                             String enteredUsername = request.getParameter("username");
                            String enteredPassword = request.getParameter("password");
                             String clientIP = request.getRemoteAddr();
                            boolean ipAllowed = true;
                            String enteredCaptcha = request.getParameter("captcha");
                            String sessionCaptcha = (String) session.getAttribute("captcha");

                            if (sessionCaptcha != null && enteredCaptcha != null && sessionCaptcha.equals(enteredCaptcha))
                           {
                                    try {
                                         String sql = "SELECT password_hash, salt FROM admin_users WHERE username = ?";
                                         pstmt = conn.prepareStatement(sql);
                                        pstmt.setString(1,  enteredUsername);
                                        rs = pstmt.executeQuery();

                                         if (rs.next()) {
                                            String storedHash = rs.getString("password_hash");
                                            String salt = rs.getString("salt");

                                                if (BCrypt.checkpw(enteredPassword, storedHash)) {


                                                    if(enable_ip_whitelist)
                                                    {
                                                         ipAllowed = false;
                                                            try {
                                                                File whiteListFile = new File(request.getRealPath("WEB-INF/whitelist.txt"));
                                                                   if(whiteListFile.exists())
                                                                {
                                                                    BufferedReader reader = new BufferedReader(new FileReader(whiteListFile));
                                                                    String line;
                                                                    while((line = reader.readLine()) != null)
                                                                    {
                                                                        if(clientIP.trim().equalsIgnoreCase(line.trim()))
                                                                        {
                                                                            ipAllowed = true;
                                                                            break;
                                                                        }
                                                                    }
                                                                    reader.close();
                                                                }
                                                            }
                                                        catch (IOException e) {
                                                            errorMessage = "<p class=\"error-message\">" + T("login.error.whitelist") + "</p>";
                                                            e.printStackTrace();
                                                        }

                                                    }
                                                     if(ipAllowed)
                                                     {
                                                        request.getSession().setAttribute("ssid", request.getRemoteAddr());
                                                        request.getSession().setAttribute("ipAllowed", true);
                                                        request.getSession().removeAttribute("gmUser");
                                                        request.getSession().removeAttribute("gmAccess");
                                                        response.sendRedirect("index.jsp");
                                                        return;

                                                     }
                                                    else
                                                     {
                                                            errorMessage = "<p class=\"error-message\">" + Tf("login.error.ip_denied", clientIP) + "</p>";
                                                     }


                                               }else
                                               {
                                                     String gmSql = "SELECT password_hash, salt, settings_access, whitelist_access, account_access, role_access, server_access, serverctrl_access FROM gmpanel_users WHERE username = ?";
                                                      pstmt = conn.prepareStatement(gmSql);
                                                     pstmt.setString(1,  enteredUsername);
                                                     rs = pstmt.executeQuery();

                                                       if (rs.next()) {
                                                            String storedGmHash = rs.getString("password_hash");
                                                           String gmSalt = rs.getString("salt");
                                                            boolean settingsAccess = rs.getBoolean("settings_access");
                                                            boolean whitelistAccess = rs.getBoolean("whitelist_access");
                                                            boolean accountAccess = rs.getBoolean("account_access");
                                                           boolean roleAccess = rs.getBoolean("role_access");
                                                            boolean serverAccess = rs.getBoolean("server_access");
                                                              boolean serverCtrlAccess = rs.getBoolean("serverctrl_access");

                                                          if (BCrypt.checkpw(enteredPassword, storedGmHash)) {

                                                                request.getSession().setAttribute("ssid", request.getRemoteAddr());
                                                                  request.getSession().setAttribute("gmUser", true);

                                                                  Map<String, Boolean> accessMap = new HashMap<String, Boolean>();
                                                                  accessMap.put("settings", settingsAccess);
                                                                  accessMap.put("whitelist", whitelistAccess);
                                                                  accessMap.put("account", accountAccess);
                                                                  accessMap.put("role", roleAccess);
                                                                  accessMap.put("server", serverAccess);
                                                                  accessMap.put("serverctrl", serverCtrlAccess);
                                                                    request.getSession().setAttribute("gmAccess", accessMap);
                                                                   response.sendRedirect("index.jsp");
                                                                    return;

                                                            } else
                                                            {
                                                                   errorMessage = "<p class=\"error-message\">" + T("login.error.invalid") + "</p>";
                                                                 }
                                                        }else
                                                        {
                                                              errorMessage = "<p class=\"error-message\">" + T("login.error.invalid") + "</p>";
                                                       }
                                               }
                                        } else {

                                                     String gmSql = "SELECT password_hash, salt, settings_access, whitelist_access, account_access, role_access, server_access, serverctrl_access FROM gmpanel_users WHERE username = ?";
                                                      pstmt = conn.prepareStatement(gmSql);
                                                     pstmt.setString(1,  enteredUsername);
                                                     rs = pstmt.executeQuery();

                                                       if (rs.next()) {
                                                            String storedGmHash = rs.getString("password_hash");
                                                           String gmSalt = rs.getString("salt");
                                                            boolean settingsAccess = rs.getBoolean("settings_access");
                                                            boolean whitelistAccess = rs.getBoolean("whitelist_access");
                                                            boolean accountAccess = rs.getBoolean("account_access");
                                                           boolean roleAccess = rs.getBoolean("role_access");
                                                            boolean serverAccess = rs.getBoolean("server_access");
                                                              boolean serverCtrlAccess = rs.getBoolean("serverctrl_access");

                                                          if (BCrypt.checkpw(enteredPassword, storedGmHash)) {

                                                                request.getSession().setAttribute("ssid", request.getRemoteAddr());
                                                                  request.getSession().setAttribute("gmUser", true);

                                                                  Map<String, Boolean> accessMap = new HashMap<String, Boolean>();
                                                                  accessMap.put("settings", settingsAccess);
                                                                  accessMap.put("whitelist", whitelistAccess);
                                                                  accessMap.put("account", accountAccess);
                                                                  accessMap.put("role", roleAccess);
                                                                  accessMap.put("server", serverAccess);
                                                                  accessMap.put("serverctrl", serverCtrlAccess);
                                                                    request.getSession().setAttribute("gmAccess", accessMap);
                                                                   response.sendRedirect("index.jsp");
                                                                    return;

                                                            } else
                                                            {
                                                                   errorMessage = "<p class=\"error-message\">" + T("login.error.invalid") + "</p>";
                                                                 }
                                                        }else
                                                        {
                                                              errorMessage = "<p class=\"error-message\">" + T("login.error.invalid") + "</p>";
                                                       }
                                        }


                                    } catch (SQLException e) {
                                        errorMessage = "<p class=\"error-message\">" + Tf("login.error.db", e.getMessage()) + "</p>";
                                         e.printStackTrace();
                                    }
                             }else
                                   {
                                         errorMessage = "<p class=\"error-message\">" + T("login.error.captcha") + "</p>";
                                   }
                        }
                    }



                   if(request.getSession().getAttribute("ssid") == null)
                   {
                         Random random = new Random();
                         int num1 = random.nextInt(50) + 1;
                         int num2 = random.nextInt(50) + 1;
                        int answer = num1 + num2;
                       session.setAttribute("captcha", String.valueOf(answer));

                       out.println("<form action=\"login.jsp\" method=\"post\" class=\"login-form\">");
                        out.println(errorMessage);
                         out.println("<label for=\"username\">" + T("login.username") + "</label>");
                        out.println("<input type=\"text\" id=\"username\" name=\"username\" required>");
                         out.println("<label for=\"password\">" + T("login.password") + "</label>");
                        out.println("<input type=\"password\" id=\"password\" name=\"password\" required>");
                        out.println("<label for=\"captcha\">" + Tf("login.captcha_q", num1, num2) + "</label>");
                        out.println("<input type=\"hidden\" name=\"num1\" value=\"" + num1 + "\">");
                        out.println("<input type=\"hidden\" name=\"num2\" value=\"" + num2 + "\">");
                        out.println("<input type=\"text\" id=\"captcha\" name=\"captcha\" required>");

                         out.println("<input type=\"image\" src=\"include/btn_login.jpg\"  style=\"border: 0px;\" alt=\"" + T("login.button") + "\"></input>");
                         out.println("</form>");
                     }
                    else
                    {
                        out.println("<a href=\"index.jsp?logout=true\" class=\"logout-button\"><img src=\"include/btn_logout.jpg\" border=\"0\" alt=\"" + T("login.logout") + "\"></img></a>");
                    }
               }


        } catch (SQLException e) {
            errorMessage = "<p class=\"error-message\">" + Tf("login.error.db", e.getMessage()) + "</p>";
            e.printStackTrace();
        }  finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }

        }


    %>
</div>
<script>

</script>