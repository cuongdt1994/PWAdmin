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
      function showhidefield()
      {
        if (document.frm.chkbox.checked)
      {
      document.getElementById("hide0").style.display = '';
      document.getElementById("hide1").style.display = '';
      document.getElementById("hide2").style.display = '';
      document.getElementById("hide3").style.display = '';
      document.getElementById("hide4").style.display = '';
      document.getElementById("hide5").style.display = '';
      document.getElementById("hide6").style.display = '';
      document.getElementById("hide7").style.display = '';
      document.getElementById("hide8").style.display = '';
      document.getElementById("hide9").style.display = '';
      document.getElementById("hide10").style.display = '';
      document.getElementById("hide11").style.display = '';
      document.getElementById("hide12").style.display = '';
      document.getElementById("hide13").style.display = '';
      document.getElementById("hide14").style.display = '';
      document.getElementById("hide15").style.display = '';
      document.getElementById("hide16").style.display = '';
      document.getElementById("hide17").style.display = '';
      document.getElementById("hide18").style.display = '';
      document.getElementById("hide19").style.display = '';
      document.getElementById("hide20").style.display = '';
      document.getElementById("hide21").style.display = '';
      document.getElementById("hide22").style.display = '';
      document.getElementById("hide23").style.display = '';
      document.getElementById("hide24").style.display = '';
      document.getElementById("hide25").style.display = '';
      document.getElementById("hide26").style.display = '';
      document.getElementById("hide27").style.display = '';
      document.getElementById("hide28").style.display = '';
      document.getElementById("hide29").style.display = '';
      document.getElementById("hide30").style.display = '';
      document.getElementById("hide31").style.display = '';
      document.getElementById("hide32").style.display = '';
      document.getElementById("hide33").style.display = '';
      document.getElementById("hide34").style.display = '';
      }
      else
      {
      document.getElementById("hide0").style.display = 'none';
      document.getElementById("hide1").style.display = 'none';
      document.getElementById("hide2").style.display = 'none';
      document.getElementById("hide3").style.display = 'none';
      document.getElementById("hide4").style.display = 'none';
      document.getElementById("hide5").style.display = 'none';
      document.getElementById("hide6").style.display = 'none';
      document.getElementById("hide7").style.display = 'none';
      document.getElementById("hide8").style.display = 'none';
      document.getElementById("hide9").style.display = 'none';
      document.getElementById("hide10").style.display = 'none';
      document.getElementById("hide11").style.display = 'none';
      document.getElementById("hide12").style.display = 'none';
      document.getElementById("hide13").style.display = 'none';
      document.getElementById("hide14").style.display = 'none';
      document.getElementById("hide15").style.display = 'none';
      document.getElementById("hide16").style.display = 'none';
      document.getElementById("hide17").style.display = 'none';
      document.getElementById("hide18").style.display = 'none';
      document.getElementById("hide19").style.display = 'none';
      document.getElementById("hide20").style.display = 'none';
      document.getElementById("hide21").style.display = 'none';
      document.getElementById("hide22").style.display = 'none';
      document.getElementById("hide23").style.display = 'none';
      document.getElementById("hide24").style.display = 'none';
      document.getElementById("hide25").style.display = 'none';
      document.getElementById("hide26").style.display = 'none';
      document.getElementById("hide27").style.display = 'none';
      document.getElementById("hide28").style.display = 'none';
      document.getElementById("hide29").style.display = 'none';
      document.getElementById("hide30").style.display = 'none';
      document.getElementById("hide31").style.display = 'none';
      document.getElementById("hide32").style.display = 'none';
      document.getElementById("hide33").style.display = 'none';
      document.getElementById("hide34").style.display = 'none';
      }
    }
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
    <p><%= T("gmctrl.perm_full") %></p>
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
            String restrict7 = "";
            String restrict8 = "";
            String restrict9 = "";
            String restrict10 = "";
            String restrict11 = "";

            String restrict100 = "";
            String restrict101 = "";
            String restrict102 = "";
            String restrict103 = "";
            String restrict104 = "";
            String restrict105 = "";

            String restrict200 = "";
            String restrict201 = "";
            String restrict202 = "";
            String restrict203 = "";
            String restrict204 = "";
            String restrict205 = "";
            String restrict206 = "";
            String restrict207 = "";
            String restrict208 = "";
            String restrict209 = "";
            String restrict210 = "";
            String restrict211 = "";
            String restrict212 = "";
            String restrict213 = "";
            String restrict214 = "";

            String restrict501 = "";
            String restrict502 = "";
            String restrict503 = "";
            String restrict504 = "";
            String restrict505 = "";
            String restrict506 = "";
            String restrict507 = "";
            String restrict508 = "";
            String restrict509 = "";
            String restrict510 = "";
            String restrict511 = "";
            String restrict512 = "";
            String restrict513 = "";
            String restrict514 = "";
            String restrict515 = "";
            String restrict516 = "";
            String restrict517 = "";
            String restrict518 = "";

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
                    else if(rs.getInt("rid") == 7) { restrict7 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 8) { restrict8 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 9) { restrict9 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 10) { restrict10 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 11) { restrict11 = "checked=\"checked\""; }

                    else if(rs.getInt("rid") == 100) { restrict100 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 101) { restrict101 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 102) { restrict102 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 103) { restrict103 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 104) { restrict104 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 105) { restrict105 = "checked=\"checked\""; }

                    else if(rs.getInt("rid") == 200) { restrict200 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 201) { restrict201 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 202) { restrict202 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 203) { restrict203 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 204) { restrict204 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 205) { restrict205 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 206) { restrict206 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 207) { restrict207 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 208) { restrict208 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 209) { restrict209 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 210) { restrict210 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 211) { restrict211 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 212) { restrict212 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 213) { restrict213 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 214) { restrict214 = "checked=\"checked\""; }

                    else if(rs.getInt("rid") == 501) { restrict501 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 502) { restrict502 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 503) { restrict503 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 504) { restrict504 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 505) { restrict505 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 506) { restrict506 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 507) { restrict507 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 508) { restrict508 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 509) { restrict509 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 510) { restrict510 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 511) { restrict511 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 512) { restrict512 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 513) { restrict513 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 514) { restrict514 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 515) { restrict515 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 516) { restrict516 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 517) { restrict517 = "checked=\"checked\""; }
                    else if(rs.getInt("rid") == 518) { restrict518 = "checked=\"checked\""; }
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
    <div class="phx-table-wrap" style="max-height:600px;">
        <table class="phx-table">
            <thead>
                <tr><th><%= T("gmctrl.description") %></th><th><%= T("gmctrl.cmd_id") %></th><th style="text-align:center;"><%= T("gmctrl.allowed") %></th></tr>
            </thead>
            <tbody>
            <form name="frm" id="frm" action="detailsfull.jsp?process=save&userid=<%= id %>" method="post">
                <tr><td><%= T("gmctrl.perm.gm_tag") %></td><td>-</td><td style="text-align:center;"><%= T("gmctrl.always") %></td></tr>
                <tr><td><%= T("gmctrl.perm.create_object") %></td><td>-</td><td style="text-align:center;"><%= T("gmctrl.always") %></td></tr>
                <tr><td><%= T("gmctrl.perm.switch_name_id") %></td><td>0</td><td style="text-align:center;"><input name="rid0" id="rid0" type="checkbox" value="true" <%= restrict0 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.hidden_invincible") %></td><td>1</td><td style="text-align:center;"><input name="rid1" id="rid1" type="checkbox" value="true" <%= restrict1 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.switch_online") %></td><td>2</td><td style="text-align:center;"><input name="rid2" id="rid2" type="checkbox" value="true" <%= restrict2 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.hide_online") %></td><td>3</td><td style="text-align:center;"><input name="rid3" id="rid3" type="checkbox" value="true" <%= restrict3 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.teleport_to_player") %></td><td>4</td><td style="text-align:center;"><input name="rid4" id="rid4" type="checkbox" value="true" <%= restrict4 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.teleport_player_to_gm") %></td><td>5</td><td style="text-align:center;"><input name="rid5" id="rid5" type="checkbox" value="true" <%= restrict5 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.teleport_ctrl_click") %></td><td>6</td><td style="text-align:center;"><input name="rid6" id="rid6" type="checkbox" value="true" <%= restrict6 %>></td></tr>
                <tr id="hide0" style="display:none"><td><%= T("gmctrl.perm.move_to_npc") %></td><td>7</td><td style="text-align:center;"><input name="rid7" type="checkbox" value="true" <%= restrict7 %>></td></tr>
                <tr id="hide1" style="display:none"><td><%= T("gmctrl.perm.move_to_map") %></td><td>8</td><td style="text-align:center;"><input name="rid8" type="checkbox" value="true" <%= restrict8 %>></td></tr>
                <tr id="hide2" style="display:none"><td><%= T("gmctrl.perm.increase_speed") %></td><td>9</td><td style="text-align:center;"><input name="rid9" type="checkbox" value="true" <%= restrict9 %>></td></tr>
                <tr id="hide3" style="display:none"><td><%= T("gmctrl.perm.follow_player") %></td><td>10</td><td style="text-align:center;"><input name="rid10" type="checkbox" value="true" <%= restrict10 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.show_online") %></td><td>11</td><td style="text-align:center;"><input name="rid11" id="rid11" type="checkbox" value="true" <%= restrict11 %>></td></tr>

                <tr><td><%= T("gmctrl.perm.ban_player") %></td><td>100</td><td style="text-align:center;"><input name="rid100" id="rid100" type="checkbox" value="true" <%= restrict100 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.mute_player") %></td><td>101</td><td style="text-align:center;"><input name="rid101" id="rid101" type="checkbox" value="true" <%= restrict101 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.ban_trading") %></td><td>102</td><td style="text-align:center;"><input name="rid102" id="rid102" type="checkbox" value="true" <%= restrict102 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.ban_selling") %></td><td>103</td><td style="text-align:center;"><input name="rid103" id="rid103" type="checkbox" value="true" <%= restrict103 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.gm_broadcast") %></td><td>104</td><td style="text-align:center;"><input name="rid104" id="rid104" type="checkbox" value="true" <%= restrict104 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.restart_gameserver") %></td><td>105</td><td style="text-align:center;"><input name="rid105" id="rid105" type="checkbox" value="true" <%= restrict105 %>></td></tr>

                <tr><td><%= T("gmctrl.perm.create_monster") %></td><td>200</td><td style="text-align:center;"><input name="rid200" id="rid200" type="checkbox" value="true" <%= restrict200 %>></td></tr>
                <tr id="hide4" style="display:none"><td><%= T("gmctrl.perm.delete_monster") %></td><td>201</td><td style="text-align:center;"><input name="rid201" type="checkbox" value="true" <%= restrict201 %>></td></tr>
                <tr id="hide5" style="display:none"><td><%= T("gmctrl.perm.morph_monster") %></td><td>202</td><td style="text-align:center;"><input name="rid202" type="checkbox" value="true" <%= restrict202 %>></td></tr>
                <tr id="hide6" style="display:none"><td><%= T("gmctrl.perm.gm_admin") %></td><td>203</td><td style="text-align:center;"><input name="rid203" type="checkbox" value="true" <%= restrict203 %>></td></tr>
                <tr id="hide7" style="display:none"><td><%= T("gmctrl.perm.set_double_exp") %></td><td>204</td><td style="text-align:center;"><input name="rid204" type="checkbox" value="true" <%= restrict204 %>></td></tr>
                <tr id="hide8" style="display:none"><td><%= T("gmctrl.perm.set_ip_limit") %></td><td>205</td><td style="text-align:center;"><input name="rid205" type="checkbox" value="true" <%= restrict205 %>></td></tr>
                <tr><td><%= T("gmctrl.perm.activate_monster") %></td><td>206</td><td style="text-align:center;"><input name="rid206" id="rid206" type="checkbox" value="true" <%= restrict206 %>></td></tr>
                <tr id="hide9" style="display:none"><td><%= T("gmctrl.perm.forbid_trade_all") %></td><td>207</td><td style="text-align:center;"><input name="rid207" type="checkbox" value="true" <%= restrict207 %>></td></tr>
                <tr id="hide10" style="display:none"><td><%= T("gmctrl.perm.forbid_auction_all") %></td><td>208</td><td style="text-align:center;"><input name="rid208" type="checkbox" value="true" <%= restrict208 %>></td></tr>
                <tr id="hide11" style="display:none"><td><%= T("gmctrl.perm.forbid_mail_all") %></td><td>209</td><td style="text-align:center;"><input name="rid209" type="checkbox" value="true" <%= restrict209 %>></td></tr>
                <tr id="hide12" style="display:none"><td><%= T("gmctrl.perm.forbid_faction_all") %></td><td>210</td><td style="text-align:center;"><input name="rid210" type="checkbox" value="true" <%= restrict210 %>></td></tr>
                <tr id="hide13" style="display:none"><td><%= T("gmctrl.perm.set_double_money") %></td><td>211</td><td style="text-align:center;"><input name="rid211" type="checkbox" value="true" <%= restrict211 %>></td></tr>
                <tr id="hide14" style="display:none"><td><%= T("gmctrl.perm.set_double_item") %></td><td>212</td><td style="text-align:center;"><input name="rid212" type="checkbox" value="true" <%= restrict212 %>></td></tr>
                <tr id="hide15" style="display:none"><td><%= T("gmctrl.perm.set_double_sp") %></td><td>213</td><td style="text-align:center;"><input name="rid213" type="checkbox" value="true" <%= restrict213 %>></td></tr>
                <tr id="hide16" style="display:none"><td><%= T("gmctrl.perm.forbid_point_card") %></td><td>214</td><td style="text-align:center;"><input name="rid214" type="checkbox" value="true" <%= restrict214 %>></td></tr>

                <tr id="hide17" style="display:none"><td><%= T("gmctrl.perm.edit_char_data") %></td><td>501</td><td style="text-align:center;"><input name="rid501" type="checkbox" value="true" <%= restrict501 %>></td></tr>
                <tr id="hide18" style="display:none"><td><%= T("gmctrl.perm.check_server_status") %></td><td>502</td><td style="text-align:center;"><input name="rid502" type="checkbox" value="true" <%= restrict502 %>></td></tr>
                <tr id="hide19" style="display:none"><td><%= T("gmctrl.perm.check_log") %></td><td>503</td><td style="text-align:center;"><input name="rid503" type="checkbox" value="true" <%= restrict503 %>></td></tr>
                <tr id="hide20" style="display:none"><td><%= T("gmctrl.perm.reboot_gameserver") %></td><td>504</td><td style="text-align:center;"><input name="rid504" type="checkbox" value="true" <%= restrict504 %>></td></tr>
                <tr id="hide21" style="display:none"><td><%= T("gmctrl.perm.reboot_db") %></td><td>505</td><td style="text-align:center;"><input name="rid505" type="checkbox" value="true" <%= restrict505 %>></td></tr>
                <tr id="hide22" style="display:none"><td><%= T("gmctrl.perm.find_char_id") %></td><td>506</td><td style="text-align:center;"><input name="rid506" type="checkbox" value="true" <%= restrict506 %>></td></tr>
                <tr id="hide23" style="display:none"><td><%= T("gmctrl.perm.view_char_data") %></td><td>507</td><td style="text-align:center;"><input name="rid507" type="checkbox" value="true" <%= restrict507 %>></td></tr>
                <tr id="hide24" style="display:none"><td><%= T("gmctrl.perm.char_online_status") %></td><td>508</td><td style="text-align:center;"><input name="rid508" type="checkbox" value="true" <%= restrict508 %>></td></tr>
                <tr id="hide25" style="display:none"><td><%= T("gmctrl.perm.send_item_mail") %></td><td>509</td><td style="text-align:center;"><input name="rid509" type="checkbox" value="true" <%= restrict509 %>></td></tr>
                <tr id="hide26" style="display:none"><td><%= T("gmctrl.perm.see_ban_history") %></td><td>510</td><td style="text-align:center;"><input name="rid510" type="checkbox" value="true" <%= restrict510 %>></td></tr>
                <tr id="hide27" style="display:none"><td><%= T("gmctrl.perm.see_cubi_payments") %></td><td>511</td><td style="text-align:center;"><input name="rid511" type="checkbox" value="true" <%= restrict511 %>></td></tr>
                <tr id="hide28" style="display:none"><td><%= T("gmctrl.perm.see_cubi_amount") %></td><td>512</td><td style="text-align:center;"><input name="rid512" type="checkbox" value="true" <%= restrict512 %>></td></tr>
                <tr id="hide29" style="display:none"><td><%= T("gmctrl.perm.add_cubigold") %></td><td>513</td><td style="text-align:center;"><input name="rid513" type="checkbox" value="true" <%= restrict513 %>></td></tr>
                <tr id="hide30" style="display:none"><td><%= T("gmctrl.perm.view_by_username") %></td><td>514</td><td style="text-align:center;"><input name="rid514" type="checkbox" value="true" <%= restrict514 %>></td></tr>
                <tr id="hide31" style="display:none"><td><%= T("gmctrl.perm.edit_username") %></td><td>515</td><td style="text-align:center;"><input name="rid515" type="checkbox" value="true" <%= restrict515 %>></td></tr>
                <tr id="hide32" style="display:none"><td><%= T("gmctrl.perm.remove_ban") %></td><td>516</td><td style="text-align:center;"><input name="rid516" type="checkbox" value="true" <%= restrict516 %>></td></tr>
                <tr id="hide33" style="display:none"><td><%= T("gmctrl.perm.get_role_list") %></td><td>517</td><td style="text-align:center;"><input name="rid517" type="checkbox" value="true" <%= restrict517 %>></td></tr>
                <tr id="hide34" style="display:none"><td><%= T("gmctrl.perm.change_password") %></td><td>518</td><td style="text-align:center;"><input name="rid518" type="checkbox" value="true" <%= restrict518 %>></td></tr>

                <tr><td><%= T("gmctrl.show_non_impl") %></td><td><input type="checkbox" name="chkbox" onclick="showhidefield()"></td><td style="text-align:center;">-</td></tr>

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
                statement.executeUpdate("DELETE FROM auth WHERE userid='" + id + "' AND rid != 500");

                if(request.getParameter("rid0") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '0')"); }
                if(request.getParameter("rid1") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '1')"); }
                if(request.getParameter("rid2") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '2')"); }
                if(request.getParameter("rid3") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '3')"); }
                if(request.getParameter("rid4") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '4')"); }
                if(request.getParameter("rid5") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '5')"); }
                if(request.getParameter("rid6") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '6')"); }
                if(request.getParameter("rid7") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '7')"); }
                if(request.getParameter("rid8") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '8')"); }
                if(request.getParameter("rid9") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '9')"); }
                if(request.getParameter("rid10") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '10')"); }
                if(request.getParameter("rid11") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '11')"); }

                if(request.getParameter("rid100") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '100')"); }
                if(request.getParameter("rid101") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '101')"); }
                if(request.getParameter("rid102") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '102')"); }
                if(request.getParameter("rid103") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '103')"); }
                if(request.getParameter("rid104") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '104')"); }
                if(request.getParameter("rid105") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '105')"); }

                if(request.getParameter("rid200") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '200')"); }
                if(request.getParameter("rid201") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '201')"); }
                if(request.getParameter("rid202") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '202')"); }
                if(request.getParameter("rid203") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '203')"); }
                if(request.getParameter("rid204") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '204')"); }
                if(request.getParameter("rid205") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '205')"); }
                if(request.getParameter("rid206") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '206')"); }
                if(request.getParameter("rid207") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '207')"); }
                if(request.getParameter("rid208") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '208')"); }
                if(request.getParameter("rid209") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '209')"); }
                if(request.getParameter("rid210") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '210')"); }
                if(request.getParameter("rid211") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '211')"); }
                if(request.getParameter("rid212") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '212')"); }
                if(request.getParameter("rid213") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '213')"); }
                if(request.getParameter("rid214") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '214')"); }

                if(request.getParameter("rid501") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '501')"); }
                if(request.getParameter("rid502") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '502')"); }
                if(request.getParameter("rid503") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '503')"); }
                if(request.getParameter("rid504") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '504')"); }
                if(request.getParameter("rid505") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '505')"); }
                if(request.getParameter("rid506") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '506')"); }
                if(request.getParameter("rid507") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '507')"); }
                if(request.getParameter("rid508") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '508')"); }
                if(request.getParameter("rid509") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '509')"); }
                if(request.getParameter("rid510") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '510')"); }
                if(request.getParameter("rid511") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '511')"); }
                if(request.getParameter("rid512") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '512')"); }
                if(request.getParameter("rid513") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '513')"); }
                if(request.getParameter("rid514") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '514')"); }
                if(request.getParameter("rid515") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '515')"); }
                if(request.getParameter("rid516") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '516')"); }
                if(request.getParameter("rid517") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '517')"); }
                if(request.getParameter("rid518") != null) { statement.executeUpdate("INSERT INTO auth (userid, zoneid, rid) VALUES ('" + id + "', 1, '518')"); }
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
