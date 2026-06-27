<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%@include file="../../WEB-INF/lang_vi.jsp"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="../../include/fav.ico">
    <link rel="stylesheet" type="text/css" href="../../include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body style="background:transparent; padding:16px;">
<%
    Connection connection = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    StringWriter sw = new StringWriter();
    PrintWriter pw = new PrintWriter(sw);

    try {
        String dbHost = db_host;
        String dbPort = db_port;
        String dbName = db_database;
        String dbUser = db_user;
        String dbPass = db_password;
        String dbUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?useUnicode=true&characterEncoding=utf8";

        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(dbUrl, dbUser, dbPass);
%>
<div class="phx-page-header">
    <h1><i class="fa-solid fa-user-shield" style="color:var(--phx-primary)"></i> <%= T("gmlist.title") %></h1>
    <p><%= T("gmlist.subtitle") %></p>
</div>
<div class="phx-table-wrap">
    <table class="phx-table">
        <thead>
            <tr><th><%= T("gmlist.id") %></th><th><%= T("gmlist.name") %></th><th><%= T("gmlist.creation_time") %></th></tr>
        </thead>
        <tbody>
<%
          ps = connection.prepareStatement("SELECT DISTINCT userid FROM auth");
          rs = ps.executeQuery();
           ArrayList<Integer> gm = new ArrayList<Integer>();
         while(rs.next())
         {
           gm.add(rs.getInt("userid"));
         }
          rs.close();
           ps.close();

            ps = connection.prepareStatement("SELECT ID, name, creatime FROM users");
         rs = ps.executeQuery();
           while(rs.next())
         {
           if(gm.contains(rs.getInt("ID")))
           {
            out.println("<tr>");
            out.println("<td style=\"font-family:var(--phx-font-mono);\">" + rs.getString("ID") + "</td>");
            out.println("<td style=\"color:var(--phx-danger);font-weight:600;\">" + StringEscapeUtils.escapeHtml(rs.getString("name")) + "</td>");
            out.println("<td style=\"color:var(--phx-text-2);\">" + rs.getString("creatime").substring(0, 16) + "</td>");
            out.println("</tr>");
             }

          }
%>
        </tbody>
    </table>
</div>
<%
    } catch (Exception e) {
         out.println("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + Tf("gmlist.error", StringEscapeUtils.escapeHtml(e.getMessage())) + "</div>");
         e.printStackTrace(pw);
        out.println("<pre class=\"phx-code\" style=\"margin-top:8px;\">" + StringEscapeUtils.escapeHtml(sw.toString()) + "</pre>");
    } finally {
        try {
          if (rs != null) rs.close();
          if(ps != null) ps.close();
            if (connection != null) connection.close();
        } catch (Exception e) {
            out.println("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + Tf("gmlist.error_closing", StringEscapeUtils.escapeHtml(e.getMessage())) + "</div>");
            e.printStackTrace(pw);
            out.println("<pre class=\"phx-code\" style=\"margin-top:8px;\">" + StringEscapeUtils.escapeHtml(sw.toString()) + "</pre>");
        }
    }
%>
</body>
</html>
