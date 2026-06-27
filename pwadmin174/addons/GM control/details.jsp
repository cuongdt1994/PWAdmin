<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="protocol.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.goldhuman.Common.Octets"%>
<%@page import="com.goldhuman.IO.Protocol.Rpc.Data.DataVector"%>
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
    <script language="JavaScript">
    function checkAll()
    {
        document.getElementById("rid0").checked = true ;
        document.getElementById("rid1").checked = true ;
        document.getElementById("rid2").checked = true ;
        document.getElementById("rid3").checked = true ;
        document.getElementById("rid4").checked = true ;
        document.getElementById("rid5").checked = true ;
        document.getElementById("rid6").checked = true ;
        document.getElementById("rid11").checked = true ;
        document.getElementById("rid100").checked = true ;
        document.getElementById("rid101").checked = true ;
        document.getElementById("rid102").checked = true ;
        document.getElementById("rid103").checked = true ;
        document.getElementById("rid104").checked = true ;
        document.getElementById("rid105").checked = true ;
        document.getElementById("rid200").checked = true ;
        document.getElementById("rid206").checked = true ;
    }

    function uncheckAll()
    {
        document.getElementById("rid0").checked = false ;
        document.getElementById("rid1").checked = false ;
        document.getElementById("rid2").checked = false ;
        document.getElementById("rid3").checked = false ;
        document.getElementById("rid4").checked = false ;
        document.getElementById("rid5").checked = false ;
        document.getElementById("rid6").checked = false ;
        document.getElementById("rid11").checked = false ;
        document.getElementById("rid100").checked = false ;
        document.getElementById("rid101").checked = false ;
        document.getElementById("rid102").checked = false ;
        document.getElementById("rid103").checked = false ;
        document.getElementById("rid104").checked = false ;
        document.getElementById("rid105").checked = false ;
        document.getElementById("rid200").checked = false ;
        document.getElementById("rid206").checked = false ;
    }
    </script>
</head>
<body style="background:transparent; padding:16px;">

<div class="phx-page-header">
    <h1><i class="fa-solid fa-shield-halved" style="color:var(--phx-primary)"></i> <a href="index.jsp" style="color:var(--phx-text);"><%= T("gmctrl.title") %></a> &gt; <%= T("gmctrl.perm_editor") %></h1>
    <p><%= T("gmctrl.perm_subtitle") %></p>
</div>

<%
    boolean allowed = false;
    if(request.getSession().getAttribute("ssid") == null)
    {
        out.println("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("gmctrl.login_required") + "</div>");
    }
    else
    {
        allowed = true;
    }
    if(allowed)
    {
        if(request.getParameter("process").compareTo("view") == 0)
        {
            int id = Integer.parseInt(request.getParameter("userid"));
            String restrict0 = "";
            String restrict1 = "";
            String restrict2 = "";
            String restrict3 = "";
            String restrict4 = "";
            String restrict5 = "";
            String restrict6 = "";
            String restrict11 = "";
            String restrict100 = "";
            String restrict101 = "";
            String restrict102 = "";
            String restrict103 = "";
            String restrict104 = "";
            String restrict105 = "";
            String restrict200 = "";
            String restrict206 = "";

            try
            {
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                Connection connection = DriverManager.getConnection("jdbc:mysql://" + db_host + ":" + db_port + "/" + db_database, db_user, db_password);
                Statement statement = connection.createStatement();
                ResultSet rs;
                rs = (statement.executeQuery("SELECT * FROM auth WHERE userid = '" + id + "';"));
                while(rs.next())
                {
                    if(rs.getInt("rid") == 0) { restrict0 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 1) { restrict1 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 2) { restrict2 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 3) { restrict3 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 4) { restrict4 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 5) { restrict5 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 6) { restrict6 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 11) { restrict11 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 100) { restrict100 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 101) { restrict101 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 102) { restrict102 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 103) { restrict103 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 104) { restrict104 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 105) { restrict105 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 200) { restrict200 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 206) { restrict206 = "checked=\"checked\""; }
                }
            }
            catch(Exception e)
            {
                out.println("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("gmctrl.db_failed") + "</div>");
            }
%>
<div class="phx-card">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-key"></i> <%= Tf("gmctrl.perm_for_acct", id) %></h2>
        <div class="phx-btn-group">
            <a href="#" class="phx-btn phx-btn-ghost phx-btn-sm" onclick="checkAll()"><i class="fa-solid fa-check-double"></i> <%= T("gmctrl.enable_all") %></a>
            <a href="#" class="phx-btn phx-btn-ghost phx-btn-sm" onclick="uncheckAll()"><i class="fa-solid fa-ban"></i> <%= T("gmctrl.disable_all") %></a>
        </div>
    </div>
    <div class="phx-table-wrap">
        <table class="phx-table">
            <thead>
                <tr><th><%= T("gmctrl.description") %></th><th><%= T("gmctrl.cmd_id") %></th><th style="text-align:center;"><%= T("gmctrl.allowed") %></th></tr>
            </thead>
            <tbody>
            <form name="frm" id="frm" action="details.jsp?process=save&userid=<%= id %>" method="post">
                <tr><td><%= T("gmctrl.perm.gm_tag") %></td><td>-</td><td style="text-align:center;"><%= T("gmctrl.always") %></td></tr>
                <tr><td><%= T("gmctrl.perm.create_object") %></td><td>-</td><td style="text-align:center;"><%= T("gmctrl.always") %></td></tr>
                <tr><td><%= T("gmctrl.perm.switch_name_id") %></td><td>0</td><td style="text-align:center;"><input name="rid0" id="rid0" type="checkbox" value="true" <%= restrict0 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.hidden_invincible") %></td><td>1</td><td style="text-align:center;"><input name="rid1" id="rid1" type="checkbox" value="true" <%= restrict1 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.switch_online") %></td><td>2</td><td style="text-align:center;"><input name="rid2" id="rid2" type="checkbox" value="true" <%= restrict2 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.hide_online") %></td><td>3</td><td style="text-align:center;"><input name="rid3" id="rid3" type="checkbox" value="true" <%= restrict3 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.teleport_to_player") %></td><td>4</td><td style="text-align:center;"><input name="rid4" id="rid4" type="checkbox" value="true" <%= restrict4 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.teleport_player_to_gm") %></td><td>5</td><td style="text-align:center;"><input name="rid5" id="rid5" type="checkbox" value="true" <%= restrict5 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.teleport_ctrl_click") %></td><td>6</td><td style="text-align:center;"><input name="rid6" id="rid6" type="checkbox" value="true" <%= restrict6 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.show_online") %></td><td>11</td><td style="text-align:center;"><input name="rid11" id="rid11" type="checkbox" value="true" <%= restrict11 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.ban_player") %></td><td>100</td><td style="text-align:center;"><input name="rid100" id="rid100" type="checkbox" value="true" <%= restrict100 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.mute_player") %></td><td>101</td><td style="text-align:center;"><input name="rid101" id="rid101" type="checkbox" value="true" <%= restrict101 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.ban_trading") %></td><td>102</td><td style="text-align:center;"><input name="rid102" id="rid102" type="checkbox" value="true" <%= restrict102 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.ban_selling") %></td><td>103</td><td style="text-align:center;"><input name="rid103" id="rid103" type="checkbox" value="true" <%= restrict103 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.gm_broadcast") %></td><td>104</td><td style="text-align:center;"><input name="rid104" id="rid104" type="checkbox" value="true" <%= restrict104 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.restart_gameserver") %></td><td>105</td><td style="text-align:center;"><input name="rid105" id="rid105" type="checkbox" value="true" <%= restrict105 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.create_monster") %></td><td>200</td><td style="text-align:center;"><input name="rid200" id="rid200" type="checkbox" value="true" <%= restrict200 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.activate_monster") %></td><td>206</td><td style="text-align:center;"><input name="rid206" id="rid206" type="checkbox" value="true" <%= restrict206 %>></td></tr>
                <tr><td colspan="3" style="text-align:center;">
                    <button class="phx-btn phx-btn-primary"><i class="fa-solid fa-floppy-disk"></i> <%= T("gmctrl.save") %></button>
                </td></tr>
            </form>
            </tbody>
        </table>
    </div>
</div>
<%
        } else if(request.getParameter("process").compareTo("save") == 0)
        {
            int id = Integer.parseInt(request.getParameter("userid"));
            boolean mysqlsuccessful = true;
            try
            {
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                Connection connection = DriverManager.getConnection("jdbc:mysql://" + db_host + ":" + db_port + "/" + db_database, db_user, db_password);
                Statement statement = connection.createStatement();
                statement.executeUpdate("DELETE FROM auth WHERE userid='" + id + "' AND rid != 500 AND rid != 501");
                if (request.getParameter("rid0") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '0')"); }
                if (request.getParameter("rid1") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '1')"); }
                if (request.getParameter("rid2") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '2')"); }
                if (request.getParameter("rid3") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '3')"); }
                if (request.getParameter("rid4") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '4')"); }
                if (request.getParameter("rid5") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '5')"); }
                if (request.getParameter("rid6") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '6')"); }
                if (request.getParameter("rid11") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '11')"); }
                if (request.getParameter("rid100") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '100')"); }
                if (request.getParameter("rid101") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '101')"); }
                if (request.getParameter("rid102") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '102')"); }
                if (request.getParameter("rid103") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '103')"); }
                if (request.getParameter("rid104") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '104')"); }
                if (request.getParameter("rid105") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '105')"); }
                if (request.getParameter("rid200") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '200')"); }
                if (request.getParameter("rid206") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '206')"); }
            }
            catch(Exception e)
            {
                out.println("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("gmctrl.db_failed") + "</div>");
                out.println("<div style=\"text-align:center;margin-top:16px;\"><a href=\"index.jsp\" class=\"phx-btn phx-btn-ghost\"><i class=\"fa-solid fa-arrow-left\"></i> " + T("gmctrl.back") + "</a></div>");
                mysqlsuccessful = false;
            }
            if(mysqlsuccessful)
            {
%>
<div class="phx-card">
    <div class="phx-notify phx-notify-success"><i class="fa-solid fa-circle-check"></i> <%= T("gmctrl.perm_applied") %></div>
    <div style="text-align:center;margin-top:16px;">
        <a href="index.jsp" class="phx-btn phx-btn-primary"><i class="fa-solid fa-arrow-left"></i> <%= T("gmctrl.back") %></a>
    </div>
</div>
<%
            }
        } else
        {
            out.println("<div class=\"phx-notify phx-notify-warning\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("gmctrl.no_search") + "</div>");
        }
    }
%>

</body>
</html>
