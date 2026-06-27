<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.security.*"%>
<%@page import="java.sql.*"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%!
    private String generateSalt() { return BCrypt.gensalt(); }
    private static String hashPassword(String password, String salt) { return BCrypt.hashpw(password, salt); }
    private static Connection getConnection(String db_host, String db_port, String db_database, String db_user, String db_password) throws SQLException {
        try { Class.forName("com.mysql.jdbc.Driver"); } catch (ClassNotFoundException e) { throw new SQLException("Failed to load MySQL JDBC driver.", e); }
        return DriverManager.getConnection("jdbc:mysql://" + db_host + ":" + db_port + "/" + db_database, db_user, db_password);
    }
%>
<%
    String errorMessage = "";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean initialLogin = false;

    if(request.getParameter("logout") != null && request.getParameter("logout").compareTo("true") == 0) {
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
        if(!tables.next()) {
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
            if(request.getMethod().equalsIgnoreCase("POST") && request.getParameter("createadmin") != null) {
                String enteredUsername = request.getParameter("username");
                String enteredPassword = request.getParameter("password");
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
                    errorMessage = "<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i>" + Tf("login.error.store_creds", e.getMessage()) + "</div>";
                }
            }
        } else {
            if(request.getMethod().equalsIgnoreCase("POST")) {
                if(request.getParameter("username") != null && request.getParameter("password") != null) {
                    String enteredUsername = request.getParameter("username");
                    String enteredPassword = request.getParameter("password");
                    String clientIP = request.getRemoteAddr();
                    boolean ipAllowed = true;
                    String enteredCaptcha = request.getParameter("captcha");
                    String sessionCaptcha = (String) session.getAttribute("captcha");

                    if (sessionCaptcha != null && enteredCaptcha != null && sessionCaptcha.equals(enteredCaptcha)) {
                        try {
                            String sql = "SELECT password_hash, salt FROM admin_users WHERE username = ?";
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, enteredUsername);
                            rs = pstmt.executeQuery();

                            if (rs.next()) {
                                String storedHash = rs.getString("password_hash");
                                if (BCrypt.checkpw(enteredPassword, storedHash)) {
                                    if(enable_ip_whitelist) {
                                        ipAllowed = false;
                                        try {
                                            File whiteListFile = new File(request.getRealPath("WEB-INF/whitelist.txt"));
                                            if(whiteListFile.exists()) {
                                                BufferedReader reader = new BufferedReader(new FileReader(whiteListFile));
                                                String line;
                                                while((line = reader.readLine()) != null) {
                                                    if(clientIP.trim().equalsIgnoreCase(line.trim())) { ipAllowed = true; break; }
                                                }
                                                reader.close();
                                            }
                                        } catch (IOException e) { errorMessage = "<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i>" + T("login.error.whitelist") + "</div>"; }
                                    }
                                    if(ipAllowed) {
                                        request.getSession().setAttribute("ssid", request.getRemoteAddr());
                                        request.getSession().setAttribute("ipAllowed", true);
                                        request.getSession().removeAttribute("gmUser");
                                        request.getSession().removeAttribute("gmAccess");
                                        response.sendRedirect("index.jsp");
                                        return;
                                    } else {
                                        errorMessage = "<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i>" + Tf("login.error.ip_denied", clientIP) + "</div>";
                                    }
                                } else {
                                    // Check GM users
                                    String gmSql = "SELECT password_hash, salt, settings_access, whitelist_access, account_access, role_access, server_access, serverctrl_access FROM gmpanel_users WHERE username = ?";
                                    pstmt = conn.prepareStatement(gmSql);
                                    pstmt.setString(1, enteredUsername);
                                    rs = pstmt.executeQuery();
                                    if (rs.next()) {
                                        String storedGmHash = rs.getString("password_hash");
                                        if (BCrypt.checkpw(enteredPassword, storedGmHash)) {
                                            Map<String, Boolean> accessMap = new HashMap<String, Boolean>();
                                            accessMap.put("settings", rs.getBoolean("settings_access"));
                                            accessMap.put("whitelist", rs.getBoolean("whitelist_access"));
                                            accessMap.put("account", rs.getBoolean("account_access"));
                                            accessMap.put("role", rs.getBoolean("role_access"));
                                            accessMap.put("server", rs.getBoolean("server_access"));
                                            accessMap.put("serverctrl", rs.getBoolean("serverctrl_access"));
                                            request.getSession().setAttribute("ssid", request.getRemoteAddr());
                                            request.getSession().setAttribute("gmUser", true);
                                            request.getSession().setAttribute("gmAccess", accessMap);
                                            response.sendRedirect("index.jsp");
                                            return;
                                        }
                                    }
                                    errorMessage = "<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i>" + T("login.error.invalid") + "</div>";
                                }
                            } else {
                                // Check GM users (username not in admin_users)
                                String gmSql = "SELECT password_hash, salt, settings_access, whitelist_access, account_access, role_access, server_access, serverctrl_access FROM gmpanel_users WHERE username = ?";
                                pstmt = conn.prepareStatement(gmSql);
                                pstmt.setString(1, enteredUsername);
                                rs = pstmt.executeQuery();
                                if (rs.next()) {
                                    if (BCrypt.checkpw(enteredPassword, rs.getString("password_hash"))) {
                                        Map<String, Boolean> accessMap = new HashMap<String, Boolean>();
                                        accessMap.put("settings", rs.getBoolean("settings_access"));
                                        accessMap.put("whitelist", rs.getBoolean("whitelist_access"));
                                        accessMap.put("account", rs.getBoolean("account_access"));
                                        accessMap.put("role", rs.getBoolean("role_access"));
                                        accessMap.put("server", rs.getBoolean("server_access"));
                                        accessMap.put("serverctrl", rs.getBoolean("serverctrl_access"));
                                        request.getSession().setAttribute("ssid", request.getRemoteAddr());
                                        request.getSession().setAttribute("gmUser", true);
                                        request.getSession().setAttribute("gmAccess", accessMap);
                                        response.sendRedirect("index.jsp");
                                        return;
                                    }
                                }
                                errorMessage = "<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i>" + T("login.error.invalid") + "</div>";
                            }
                        } catch (SQLException e) {
                            errorMessage = "<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i>" + Tf("login.error.db", e.getMessage()) + "</div>";
                        }
                    } else {
                        errorMessage = "<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i>" + T("login.error.captcha") + "</div>";
                    }
                }
            }
        }
    } catch (SQLException e) {
        errorMessage = "<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i>" + Tf("login.error.db", e.getMessage()) + "</div>";
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<div class="phx-login-bg">
    <div class="phx-login-card">
        <div class="phx-login-logo">
            <h1>PWADMIN</h1>
            <p>Perfect World Server Management</p>
        </div>

        <%= errorMessage %>

        <% if (initialLogin) { %>
            <p style="text-align:center;color:var(--phx-text-2);margin-bottom:16px;font-size:var(--phx-font-size-sm);"><%= T("login.initial_desc") %></p>
            <form action="login.jsp" method="post">
                <input type="hidden" name="createadmin" value="true">
                <div class="phx-form-group">
                    <label class="phx-label"><%= T("login.username") %></label>
                    <input class="phx-input" type="text" name="username" required>
                </div>
                <div class="phx-form-group">
                    <label class="phx-label"><%= T("login.password") %></label>
                    <input class="phx-input" type="password" name="password" required>
                </div>
                <button type="submit" class="phx-btn phx-btn-primary phx-btn-full">
                    <i class="fa-solid fa-user-plus"></i> <%= T("login.create_admin_btn") %>
                </button>
            </form>
        <% } else if(request.getSession().getAttribute("ssid") != null) { %>
            <a href="index.jsp?logout=true" class="phx-btn phx-btn-danger phx-btn-full" style="text-decoration:none;">
                <i class="fa-solid fa-right-from-bracket"></i> <%= T("login.logout") %>
            </a>
        <% } else {
            Random random = new Random();
            int num1 = random.nextInt(50) + 1;
            int num2 = random.nextInt(50) + 1;
            int answer = num1 + num2;
            session.setAttribute("captcha", String.valueOf(answer));
        %>
            <form action="login.jsp" method="post">
                <div class="phx-form-group">
                    <label class="phx-label"><%= T("login.username") %></label>
                    <input class="phx-input" type="text" name="username" required>
                </div>
                <div class="phx-form-group">
                    <label class="phx-label"><%= T("login.password") %></label>
                    <input class="phx-input" type="password" name="password" required>
                </div>
                <div class="phx-form-group">
                    <label class="phx-label"><%= Tf("login.captcha_q", num1, num2) %></label>
                    <input type="hidden" name="num1" value="<%= num1 %>">
                    <input type="hidden" name="num2" value="<%= num2 %>">
                    <input class="phx-input" type="text" name="captcha" required style="max-width:120px;">
                </div>
                <button type="submit" class="phx-btn phx-btn-primary phx-btn-full">
                    <i class="fa-solid fa-right-to-bracket"></i> <%= T("login.button") %>
                </button>
            </form>
        <% } %>
    </div>
</div>
</body>
</html>