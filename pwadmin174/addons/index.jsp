<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@include file="../WEB-INF/lang_vi.jsp"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="../include/fav.ico">
    <link rel="stylesheet" type="text/css" href="../include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body style="background:transparent; padding:16px;">

<div class="phx-page-header">
    <h1><i class="fa-solid fa-puzzle-piece" style="color:var(--phx-primary)"></i> <%= T("addons.title") %></h1>
    <p><%= T("addons.subtitle") %></p>
</div>

<div class="phx-card">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-box-archive"></i> <%= T("addons.plugins") %></h2>
    </div>
    <div class="phx-table-wrap">
        <table class="phx-table">
            <tbody>
            <%
                File f = new File(request.getRealPath("addons"));
                String[] files = f.list();
                java.util.Arrays.sort(files);
                if (files.length > 0) {
                    for (int i = 0; i < files.length; i++) {
                        f = new File(request.getRealPath("addons") + "/" + files[i]);
                        if (f.isDirectory()) {
                            out.println("<tr><td><a href=\"../index.jsp?plugin=" + files[i] + "\" target=\"_parent\"><i class=\"fa-solid fa-folder\"></i> " + files[i] + "</a></td></tr>");
                        }
                    }
                }
            %>
                <tr><td><a href="http://pwadmin.codeplex.com/Thread/List.aspx"><i class="fa-solid fa-magnifying-glass"></i> <%= T("addons.search_plugins") %></a></td></tr>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
