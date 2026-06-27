<%@page import="java.sql.*"%>
<%@page import="protocol.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.goldhuman.Common.Octets"%>
<%@page import="com.goldhuman.IO.Protocol.Rpc.Data.DataVector"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>

<html>
<head>
<link rel="shortcut icon" href="../../include/fav.ico">
<link rel="stylesheet" type="text/css" href="../../include/style.css">
<style type="text/css">
a.whitetext
{
font-size: 13.5pt;
font-weight: bold;
color: #ffffff;
}
</style>
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
<body>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td colspan="3">
			<br>
		</td>
	</tr>
	<tr>
		<th height="1" align="left" valign="middle" style="padding: 5px;">
			<font size="+1"><b>
				<a class ="whitetext" href="index.jsp">GameMaster Control</a> > Permissions Editor:
			</b></font>
		</th>
		<th height="1" colspan="2" align="right" valign="middle" style="padding: 5px;">
			<table cellpadding="0" cellspacing="2" border="0">
				<tr>
				</tr>
			</table>
		</th>
	</tr>
	<tr bgcolor="#f0f0f0">
		<td colspan="3" align="center" style="padding: 5px;">
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center" style="padding: 5px;">
		</td>
	</tr>
	<%
	boolean allowed = false;
		if(request.getSession().getAttribute("ssid") == null)
		{
			out.println("<p align=\"right\"><font color=\"#ee0000\"><b>Login for GM Control...</b></font></p>");
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
					out.println("<tr><td align=\"center\" colspan=\"3\" style=\"border-top: 1px solid #cccccc\"><font color=\"#ee0000\"><b>Connection to MySQL Database Failed</b></font></td></tr>");
				}
				out.println("<tr><td colspan=\"3\" align=\"center\" valign=\"top\">");
				out.println("<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td align=\"center\" valign=\"top\">");
				out.println("<table width=\"350\" cellpadding=\"2\" cellspacing=\"0\" style=\"border: 1px solid #cccccc;\">");
				out.println("<tr><th align=\"center\" colspan=\"3\" style=\"padding: 5;\">Permissions for Account: " + id + " &nbsp;&nbsp;&nbsp;( <a href=\"#\" onclick=\"checkAll()\">Enable All</a> | <a href=\"#\"  onclick=\"uncheckAll()\">Disable All</a> )</th></tr>");
				out.println("<tr bgcolor=\"#f0f0f0\"><td><b>Description</b></td><td><b>cmd ID</b></td><td align=\"center\"><b>Allowed</b></td></tr>");
				out.println("<form name=\"frm\" id=\"frm\" action=\"details.jsp?process=save&userid=" + id + "\" method=\"post\" style=\"margin: 0px;\">");

				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">GM tag</td><td style=\"border-top: 1px solid #cccccc\">-</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\">always</td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Create object</td><td style=\"border-top: 1px solid #cccccc\">-</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\">always</td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Switch player's name and ID</td><td style=\"border-top: 1px solid #cccccc\">0</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid0\" id=\"rid0\" type=\"checkbox\" value=\"true\" " + restrict0 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Turn into hidden or invincible status</td><td style=\"border-top: 1px solid #cccccc\">1</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid1\" id=\"rid1\" type=\"checkbox\" value=\"true\" " + restrict1 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Switch online status</td><td style=\"border-top: 1px solid #cccccc\">2</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid2\" id=\"rid2\" type=\"checkbox\" value=\"true\" " + restrict2 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Hide online status in wisper</td><td style=\"border-top: 1px solid #cccccc\">3</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid3\" id=\"rid3\" type=\"checkbox\" value=\"true\" " + restrict3 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Teleport to player</td><td style=\"border-top: 1px solid #cccccc\">4</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid4\" id=\"rid4\" type=\"checkbox\" value=\"true\" " + restrict4 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Teleport player to GM</td><td style=\"border-top: 1px solid #cccccc\">5</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid5\" id=\"rid5\" type=\"checkbox\" value=\"true\" " + restrict5 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Teleport by ctrl+clicking map</td><td style=\"border-top: 1px solid #cccccc\">6</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid6\" id=\"rid6\" type=\"checkbox\" value=\"true\" " + restrict6 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Show online number</td><td style=\"border-top: 1px solid #cccccc\">11</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid11\" id=\"rid11\" type=\"checkbox\" value=\"true\" " + restrict11 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Ban player account/character</td><td style=\"border-top: 1px solid #cccccc\">100</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid100\" id=\"rid100\" type=\"checkbox\" value=\"true\" " + restrict100 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Mute player account/character</td><td style=\"border-top: 1px solid #cccccc\">101</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid101\" id=\"rid101\" type=\"checkbox\" value=\"true\" " + restrict101 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Ban trading for a player</td><td style=\"border-top: 1px solid #cccccc\">102</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid102\" id=\"rid102\" type=\"checkbox\" value=\"true\" " + restrict102 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Ban selling for a player</td><td style=\"border-top: 1px solid #cccccc\">103</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid103\" id=\"rid103\" type=\"checkbox\" value=\"true\" " + restrict103 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">GM announcement broadcast</td><td style=\"border-top: 1px solid #cccccc\">104</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid104\" id=\"rid104\" type=\"checkbox\" value=\"true\" " + restrict104 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Restart gameserver</td><td style=\"border-top: 1px solid #cccccc\">105</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid105\" id=\"rid105\" type=\"checkbox\" value=\"true\" " + restrict105 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Create Monster</td><td style=\"border-top: 1px solid #cccccc\">200</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid200\" id=\"rid200\" type=\"checkbox\" value=\"true\" " + restrict200 + "></td></tr>");
				out.println("<tr><td style=\"border-top: 1px solid #cccccc\">Activate Monster Creator</td><td style=\"border-top: 1px solid #cccccc\">206</td><td align=\"center\" style=\"border-top: 1px solid #cccccc\"><input name=\"rid206\" id=\"rid206\" type=\"checkbox\" value=\"true\" " + restrict206 + "></td></tr>");

				out.println("<tr><td colspan=\"3\" align=\"center\" style=\"border-top: 1px solid #cccccc;\"><input type=\"image\" src=\"../../include/btn_save.jpg\" style=\"border: 0px;\"></td></tr></table></form>");
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
					out.println("<tr><td align=\"center\" colspan=\"3\" style=\"border-top: 1px solid #cccccc\"><font color=\"#ee0000\"><b>Connection to MySQL Database Failed</b></font></td></tr>");
					out.println("<tr><td colspan=\"3\" align=\"center\" style=\"border-top: 1px solid #cccccc;\"><a href=\"index.jsp\"><img src=\"btn_back.PNG\" border=\"0\" alt=\"Back\"/></a></td></tr></table>");
					mysqlsuccessful = false;
				}
				if(mysqlsuccessful)
				{
					out.println("<tr><td align=\"center\" colspan=\"3\" style=\"border-top: 1px solid #cccccc\">Permissions applied, you may need to restart your authd for the changes to take effect.</td></tr>");
					out.println("<tr><td colspan=\"3\" align=\"center\" style=\"border-top: 1px solid #cccccc;\"><a href=\"index.jsp\"><img src=\"btn_back.PNG\" border=\"0\" alt=\"Back\"/></a></td></tr></table>");
				}
			} else
			{
				out.println("<p align=\"right\"><font color=\"#ee0000\"><b>No search terms...</b></font></p>");
			}
		}
	%>
</td></tr></table>
</td></tr>
</table>
</body>
</html>