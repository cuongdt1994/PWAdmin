<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="protocol.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>

<%
    String message = "<br>";
    boolean allowed = false;
    String debugOutput = "";

    // Check Login session
    if (request.getSession().getAttribute("ssid") == null) {
        out.println("<p align=\"right\"><font color=\"#ee0000\"><b>" + T("role.login_required") + "</b></font></p>");
    } else {
        allowed = true;
    }

    String rolelist = "";
    // read data
    File workingDir = new File(pw_server_path + "/gamedbd/");
    debugOutput += "<br>Debug: Working Directory = " + workingDir.getAbsolutePath();

    String command = "./gamedbd ./gamesys.conf listrole";
    debugOutput += "<br>Debug: Command = " + command;

    ProcessBuilder processBuilder = new ProcessBuilder("/bin/bash", "-c", command);
    processBuilder.directory(workingDir);

    StringBuilder result = new StringBuilder();
    StringBuilder errorResult = new StringBuilder();

    Process process = processBuilder.start();

    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));

    String line;
    while ((line = reader.readLine()) != null) {
        result.append(line).append("\n");
    }
    while ((line = errorReader.readLine()) != null) {
        errorResult.append(line).append("\n");
        debugOutput += "<font color=\"#ee0000\"><br>Debug: Process Error Code = " + errorResult + "</font>";
    }

    reader.close();
    errorReader.close();

    int exitCode = process.waitFor();
    debugOutput += "<br>Debug: Process Exit Code = " + exitCode;

    if (exitCode != 0) {
        debugOutput += "<br>Debug: Process Error Output = " + errorResult.toString();
        message = "<font color=\"#ee0000\"><b>" + T("role.process_error") + "</b></font>";
    } else {
        message = "<font color=\"#00ee00\"><b></b></font>";
    }
    message = "<font style=\"size: 10em;\" color=\"#ee0000\"><b>" + errorResult.toString() + "</b></font>";
    rolelist = result.toString();
    debugOutput += "<br>Debug: Game database = " + rolelist;
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= T("role.title") %></title>

    <style>
        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: #121212;
        }

        .section {
            padding: 2rem 1rem;
            width: 100%;
            height: 100%;

        }
        .container {
            width: 100%;
            height: 100%;



        }
         .role-list-table{
           background-color: #222222;
        }
         .debug-output {
            background-color: #333333;
            color: #ffffff;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .debug-output pre {
            white-space: pre-wrap;
            color: #ffffff;

            margin: 0;

            font-size: 0.8rem;

        }
        .pagination{
            background-color: #333333;
            color: #ffffff;
            padding: 10px;
            margin-top: 10px;
            border-radius: 10px;
            width: 100%;
            display: flex;
            justify-content: center;
        }

        .pagination-previous,
        .pagination-next {
            background-color: #333333;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 4px;
            margin: 0 4px;
            display: inline-block;
        }
       .pagination-list{

            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
        }
        .pagination-list li{

        }
         .pagination-link {
            background-color: #333333;
            color: white;
             padding: 8px 12px;
            text-decoration: none;
            border-radius: 4px;
             margin: 0 2px;
            display: inline-block;
        }
         a:hover{
                color: #2980b9 !important;
            }
            .table{
             width: 100%;
            }
          table{
                 background-color: #222222 !important;
            }
            .table th, .table td{
                color: white;
            }
              .button.is-small{
                font-size:0.8rem;
            }
    </style>
</head>
<body>
    <section class="section">
        <div class="container">
            <h1 class="title has-text-centered" style="color: white;"><%= T("role.title") %></h1>
            <table class="table is-fullwidth is-striped role-list-table">
                <thead>
                    <tr>
                        <th><%= T("role.table.id") %></th>
                        <th><%= T("role.table.name") %></th>
                        <th><%= T("role.table.class") %></th>
                        <th><%= T("role.table.level") %></th>
                        <th><%= T("role.table.action") %></th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String[] rows = rolelist.split("\n");
                        debugOutput += "<br>Debug: Total rows = " + rows.length;

                        List<String> filteredRows = new ArrayList<String>();
                        for (String dataRow : rows) {
                            String[] columns = dataRow.split(",");
                            try {
                                int roleid = Integer.parseInt(columns[0]);
                                if (roleid > 1000) {
                                    filteredRows.add(dataRow);
                                }
                            } catch (NumberFormatException e) {
                                // Skip invalid rows
                            }
                        }

                        rows = filteredRows.toArray(new String[0]);
                        debugOutput += "<br>Debug: Filtered rows count = " + rows.length;
                         int rowsPerPage = 10;

                         int p = 1;
                        String pParam = request.getParameter("p");

                        debugOutput += "<br>Debug: Pagination page parameter = " + pParam;

                         if (pParam != null) {
                            try {
                                p = Integer.parseInt(pParam);
                            } catch (NumberFormatException e) {
                                p = 1;
                            }
                        }

                         debugOutput += "<br>Debug: Pagination page = " + p;
                          int totalPages = (int) Math.ceil((double) rows.length / rowsPerPage);
                        debugOutput += "<br>Debug: Total pages = " + totalPages;

                        if (p > totalPages) {
                            p = totalPages;
                        }

                        if (rows.length == 0) {
                    %>
                        <tr>
                            <td colspan="5" class="has-text-centered" style="color:white;"><%= T("role.no_players") %></td>
                        </tr>
                    <%
                        }
                        else {

                            int startIndex = (p - 1) * rowsPerPage;
                            int endIndex = Math.min(startIndex + rowsPerPage, rows.length);

                            debugOutput += "<br>Debug: Start index = " + startIndex + " End index = " + endIndex;

                            for (int i = startIndex; i < endIndex; i++) {
                                String currentRow = rows[i];
                                String[] columns = currentRow.split(",");
                                if (columns.length < 15) {
                    %>
                                <tr>
                                    <td colspan="5" style="color:white;"><%= T("role.invalid_data") %></td>
                                </tr>
                    <%
                                    continue;
                                }

                                // Get Class/Occupation based on index
                                String occupation = "";
                                switch (Integer.parseInt(columns[4])) {
                                    case 0: occupation = T("class.0"); break;
                                    case 1: occupation = T("class.1"); break;
                                    case 2: occupation = T("class.2"); break;
                                    case 3: occupation = T("class.3"); break;
                                    case 4: occupation = T("class.4"); break;
                                    case 5: occupation = T("class.5"); break;
                                    case 6: occupation = T("class.6"); break;
                                    case 7: occupation = T("class.7"); break;
                                    case 8: occupation = T("class.8"); break;
                                    case 9: occupation = T("class.9"); break;
                                    case 10: occupation = T("class.10"); break;
                                    case 11: occupation = T("class.11"); break;
                                    case 14: occupation = T("class.14"); break;
                                    default: occupation = T("class.unknown"); break;
                                }
                    %>
                                <tr>
                                    <td width="10%"><%= columns[0] %></td> <!-- Role ID -->
                                    <td><%= columns[2].replace("\"", "") %></td> <!-- Name -->
                                    <td><%= occupation %></td> <!-- Class/Occupation -->
                                    <td><%= columns[13] %></td> <!-- Level -->
                                    <td>
                                         <a href="index.jsp?page=rolexml&ident=<%= columns[0] %>">
                                            <button class="button is-info is-small"><%= T("role.btn.view_xml") %></button>
                                        </a>
                                        <a href="index.jsp?page=rolegui&ident=<%= columns[0] %>">
                                            <button class="button is-info is-small"><%= T("role.btn.view_gui") %></button>
                                        </a>
                                    </td>
                                </tr>
                    <%
                            }
                        }
                   %>
                </tbody>
            </table>
             <% if (rows.length > 0) { %>
            <div class="pagination is-centered" role="navigation" aria-label="pagination" >
                <%
                    debugOutput += "<br>Debug: Total pages in pagination = " + totalPages;

                    if (p > 1) {
                %><a class="pagination-previous" href="index.jsp?page=role&p=<%= p - 1 %>"><%= T("role.pagination.prev") %></a>
                <%}%>
                <ul class="pagination-list">
                <%for (int paginationLink = 1; paginationLink <= totalPages; paginationLink++) {%>
                    <li><a class="pagination-link" href="index.jsp?page=role&p=<%= paginationLink %>"><%= paginationLink %></a></li>
                <%}%>
                </ul>
                <%if (p < totalPages) {%>
                    <a class="pagination-next" href="index.jsp?page=role&p=<%= p + 1 %>"><%= T("role.pagination.next") %></a>
                <%}%>
            </div>
            <%}%>
        </div>
    </section>
</body>
</html>