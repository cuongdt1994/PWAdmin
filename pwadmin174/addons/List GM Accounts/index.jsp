<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%
    Connection connection = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    StringWriter sw = new StringWriter();
    PrintWriter pw = new PrintWriter(sw);
     
    try {
        // Get database properties from .pwadminconf.jsp
        String dbHost = db_host;
        String dbPort = db_port;
        String dbName = db_database;
        String dbUser = db_user;
        String dbPass = db_password;
        // Construct the database connection URL
        String dbUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?useUnicode=true&characterEncoding=utf8";

        // Load the database driver and connect
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        out.println("<h1>GM Players</h1>");
        out.println("<table border=1 style='width: 100%; border-collapse: collapse;'>");
        out.println("<thead style='background-color: #f0f0f0;'>");
        out.println("<tr>");
        out.println("<th style='padding: 8px; border: 1px solid #ddd;'>ID</th>");
        out.println("<th style='padding: 8px; border: 1px solid #ddd;'>Name</th>");
        out.println("<th style='padding: 8px; border: 1px solid #ddd;'>Creation Time</th>");
        out.println("</tr>");
        out.println("</thead>");
        out.println("<tbody>");
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
            out.println("<td style='padding: 8px; border: 1px solid #ddd;'>" + rs.getString("ID") + "</td>");
            out.println("<td style='padding: 8px; border: 1px solid #ddd; color: red;'>" + StringEscapeUtils.escapeHtml(rs.getString("name")) + "</td>");
            out.println("<td style='padding: 8px; border: 1px solid #ddd;'>" + rs.getString("creatime").substring(0, 16) + "</td>");
            out.println("</tr>");
             }
           
          }
      out.println("</tbody>");
     out.println("</table>");
        
    } catch (Exception e) {
         out.println("<h1>Error during database operations: " + e.getMessage() + "</h1>");
         e.printStackTrace(pw);
        out.println("<pre>" + StringEscapeUtils.escapeHtml(sw.toString()) + "</pre>");
    } finally {
        try {
          if (rs != null) rs.close();
          if(ps != null) ps.close();
            if (connection != null) connection.close();
        } catch (Exception e) {
            out.println("<h1>Error closing resources: " + e.getMessage() + "</h1>");
            e.printStackTrace(pw);
            out.println("<pre>" + StringEscapeUtils.escapeHtml(sw.toString()) + "</pre>");
        }
    }
%>