<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.security.*"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%@include file="../../WEB-INF/lang_vi.jsp"%>

<%!
    String pw_encode(String salt, MessageDigest alg)
    {
        alg.reset();
        alg.update(salt.getBytes());
        byte[] digest = alg.digest();
        StringBuffer hashedpasswd = new StringBuffer();
        String hx;
        for(int i=0; i<digest.length; i++)
        {
            hx =  Integer.toHexString(0xFF & digest[i]);
            if(hx.length() == 1)
            {
                hx = "0" + hx;
            }
            hashedpasswd.append(hx);
        }
        salt = "0x" + hashedpasswd.toString();

        return salt;
    }
%>

<div style="display:flex; align-items:center; gap:8px; flex-wrap:wrap;">
<%
    if(request.getParameter("logout") != null && request.getParameter("logout").compareTo("true") == 0)
    {
        request.getSession().removeAttribute("user");
    }

    if(request.getParameter("username") != null && request.getParameter("password") != null)
    {
        String username = request.getParameter("username");
        String password = pw_encode(username + request.getParameter("password"), MessageDigest.getInstance("MD5"));

        Class.forName("com.mysql.jdbc.Driver").newInstance();
        Connection connection = DriverManager.getConnection("jdbc:mysql://" + db_host + ":" + db_port + "/" + db_database, db_user, db_password);
        CallableStatement cs = connection.prepareCall("{call acquireuserpasswd(?,?,?)}");
        cs.setString(1, username);
        cs.registerOutParameter(3, Types.VARCHAR);
        cs.execute();

        if(username != "" && password.compareTo(cs.getString(3)) == 0)
        {
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery("SELECT ID FROM users WHERE name='" + username + "'");
            rs.next();
            request.getSession().setAttribute("user", rs.getString("ID"));
        }
    }

    if(request.getSession().getAttribute("user") == null)
    {
        out.println("<form action=\"index.jsp\" method=\"post\" style=\"display:flex;align-items:center;gap:8px;\">");
        out.println("<input class=\"phx-input\" type=\"text\" name=\"username\" placeholder=\"Login\" style=\"width:100px;\">");
        out.println("<input class=\"phx-input\" type=\"password\" name=\"password\" placeholder=\"Pass\" style=\"width:100px;\">");
        out.println("<button class=\"phx-btn phx-btn-primary phx-btn-sm\"><i class=\"fa-solid fa-right-to-bracket\"></i> " + T("guildicon.login_btn") + "</button>");
        out.println("</form>");
    }
    else
    {
        out.println("<a href=\"index.jsp?logout=true\" class=\"phx-btn phx-btn-ghost phx-btn-sm\"><i class=\"fa-solid fa-right-from-bracket\"></i> " + T("guildicon.logout_btn") + "</a>");
    }
%>
</div>
