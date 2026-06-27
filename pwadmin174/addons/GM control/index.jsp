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
</head>
<body style="background:transparent; padding:16px;">

<%!

    String int2occupation(int c)
    {
        String s;
        switch(c)
        {
            case 0: s = "Blademaster"; break;
            case 1: s = "Wizard"; break;
            case 2: s = "Monk"; break;
            case 3: s = "Venomancer"; break;
            case 4: s = "Barbarian"; break;
            case 5: s = "Assassin"; break;
            case 6: s = "Archer"; break;
            case 7: s = "Cleric"; break;
            case 8: s = "Seeker"; break;
            case 9: s = "Mystic"; break;
            case 10: s = "Duskblade"; break;
            case 11: s = "Stormbringer"; break;
            case 14: s = "Wildwalker"; break;
            default: s = "Không rõ";
        }
        return s;
    }
%>

<div class="phx-page-header">
    <h1><i class="fa-solid fa-shield-halved" style="color:var(--phx-primary)"></i> <%= T("gmctrl.title") %></h1>
    <p><%= T("gmctrl.subtitle") %></p>
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
%>
<div class="phx-card">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-users"></i> <%= T("gmctrl.gm_list") %></h2>
    </div>
    <div class="phx-table-wrap">
        <table class="phx-table">
            <thead>
                <tr><th><%= T("gmctrl.account_char") %></th><th><%= T("gmctrl.occupation") %></th><th style="text-align:center;"><%= T("gmctrl.level") %></th></tr>
            </thead>
            <tbody>
<%
                try
                {
                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                    Connection connection = DriverManager.getConnection("jdbc:mysql://" + db_host + ":" + db_port + "/" + db_database, db_user, db_password);
                    Statement statement = connection.createStatement();
                    ResultSet rs;
                    rs = (statement.executeQuery("SELECT * FROM auth GROUP BY userid;"));
                    while(rs.next())
                    {
                        Statement statement2 = connection.createStatement();
                        ResultSet rs2;
                        rs2 = (statement2.executeQuery("SELECT name FROM users WHERE ID = '" + rs.getString("userid") + "';"));
                        while (rs2.next())
                        {
                            out.println("<tr>");
                            out.println("<td><b>Account:" + rs.getString("userid") + ": " + rs2.getString("name") + "</b></td>");
                            out.println("<td>");
                            out.println("<div class=\"phx-btn-group\">");
                            out.println("<a href=\"../../index.jsp?page=account&action=changegm&type=id&ident=" + rs.getString("userid") + "&act=delete\" target=\"_parent\" class=\"phx-btn phx-btn-danger phx-btn-sm\"><i class=\"fa-solid fa-trash\"></i> " + T("gmctrl.remove_gm") + "</a>");
                            out.println("<a href=\"details.jsp?process=view&userid=" + rs.getString("userid") + "\" class=\"phx-btn phx-btn-ghost phx-btn-sm\"><i class=\"fa-solid fa-key\"></i> " + T("gmctrl.permissions") + "</a>");
                            out.println("</div>");
                            out.println("</td>");
                            out.println("<td></td>");
                            out.println("</tr>");
                        }
                        DataVector dv = GameDB.getRolelist(Integer.parseInt(rs.getString("userid")));
                        if(dv != null)
                        {
                            Iterator itr = dv.iterator();
                            while(itr.hasNext())
                            {
                                IntOctets ios = (IntOctets)itr.next();
                                int roleid = ios.m_int;
                                String rolename = ios.m_octets.getString();
                                int rolelevel = GameDB.getRoleStatus(roleid).level;
                                String roleoccupation = int2occupation(GameDB.get(roleid).base.cls);
                                out.println("<tr>");
                                out.println("<td style=\"padding-left:24px;\"><a href=\"../../index.jsp?page=role&show=details&ident=" + roleid + "&type=id\" target=\"_parent\"><i class=\"fa-solid fa-user\"></i> " + rolename + "</a></td>");
                                out.println("<td>" + roleoccupation + "</td>");
                                out.println("<td style=\"text-align:center;\"><span class=\"phx-badge phx-badge-info\">" + rolelevel + "</span></td>");
                                out.println("</tr>");
                            }
                        }
                    }
                }
                catch(Exception e)
                {
                    out.println("<tr><td colspan=\"3\" style=\"text-align:center;\"><div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("gmctrl.db_failed") + "</div></td></tr>");
                }
%>
            </tbody>
        </table>
    </div>
</div>
<%
    }
%>

</body>
</html>
