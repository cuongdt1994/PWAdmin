<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="org.apache.catalina.util.Base64"%>
<%@page import="java.util.Date"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%
    String logFilePath = application.getRealPath("iplog.txt");
    String lastRotatedPath = application.getRealPath("lastrotated.txt");
    String clientIP = request.getRemoteAddr();
    StringWriter sw = new StringWriter();
    PrintWriter pw = new PrintWriter(sw);
      Boolean logged = (Boolean)session.getAttribute("ipLogged");
  	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String timestamp = sdf.format(new Date());
     File lastRotatedFile = new File(lastRotatedPath);
     File logFile = new File(logFilePath);
     
     try {
       if(lastRotatedFile.exists()) {
         BufferedReader br = new BufferedReader(new FileReader(lastRotatedFile));
           String lastRotated = br.readLine();
            br.close();
         if(lastRotated != null) {
                SimpleDateFormat logDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date lastRotatedDate = logDateFormat.parse(lastRotated);
            Calendar c = Calendar.getInstance();
            c.setTime(lastRotatedDate);
             c.add(Calendar.DATE, 2);
              Date nextRotated = c.getTime();
             Date today = new Date();
              if(today.after(nextRotated)) {
                 if (logFile.exists()) {
                   logFile.delete();
                }
                FileWriter fw = new FileWriter(lastRotatedFile, false);
                 BufferedWriter bw = new BufferedWriter(fw);
                  bw.write(logDateFormat.format(today));
                   bw.close();
               }
           } else
           {
            FileWriter fw = new FileWriter(lastRotatedFile, false);
             BufferedWriter bw = new BufferedWriter(fw);
              bw.write(sdf.format(new Date()).substring(0,10));
               bw.close();
           }
         } else {
          FileWriter fw = new FileWriter(lastRotatedFile, false);
             BufferedWriter bw = new BufferedWriter(fw);
              bw.write(sdf.format(new Date()).substring(0,10));
               bw.close();
         }
     } catch(Exception e) {
        
     }
    
        try {
           if(logged == null || !logged) {
               FileWriter fw = new FileWriter(logFile, true);
            BufferedWriter bw = new BufferedWriter(fw);
             bw.write(timestamp + " - IP: " + clientIP + "\n");
            bw.close();
              session.setAttribute("ipLogged", true);
           }
           
            boolean showLog = request.getParameter("showlog") != null && request.getParameter("showlog").equals("true");
            if(request.getParameter("showlog") == null) {
                 showLog = true;
            }
             if(showLog) {
                    out.println("<h1>IP Logs</h1>");
              out.println("<table border=1 style='width: 100%; border-collapse: collapse;'>");
              out.println("<thead style='background-color: #f0f0f0;'>");
              out.println("<tr>");
            out.println("<th style='padding: 8px; border: 1px solid #ddd;'>Time</th>");
              out.println("<th style='padding: 8px; border: 1px solid #ddd;'>IP</th>");
              out.println("</tr>");
             out.println("</thead>");
                out.println("<tbody>");
                    if(logFile.exists()) {
                       BufferedReader br = new BufferedReader(new FileReader(logFile));
                     String line;
                     while((line = br.readLine()) != null) {
                       out.println("<tr>");
                    out.println("<td style='padding: 8px; border: 1px solid #ddd;'>" + StringEscapeUtils.escapeHtml(line.substring(0,19)) + "</td>");
                       out.println("<td style='padding: 8px; border: 1px solid #ddd;'>" + StringEscapeUtils.escapeHtml(line.substring(23)) + "</td>");
                        out.println("</tr>");
                   }
                  br.close();
             }
                out.println("</tbody>");
             out.println("</table>");
             }
        } catch (IOException e) {
          
        }
        
%>