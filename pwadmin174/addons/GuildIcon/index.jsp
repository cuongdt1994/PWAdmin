<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.zip.*"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.Graphics2D"%>
<%@page import="java.awt.image.*"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.util.ArrayList"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%@include file="../../WEB-INF/lang_vi.jsp"%>

<%
	boolean admin_mode = false;
	List<String> logMessages = new ArrayList<String>();


		logMessages.add(new java.util.Date() + ": Starting Icon Manager");

		if(request.getSession().getAttribute("ssid") != null)
		{
			admin_mode = true;
			logMessages.add(new java.util.Date() + ": Admin mode detected");
		} else {
			logMessages.add(new java.util.Date() + ": Not admin mode");
		}


%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="../../include/fav.ico">
	<link rel="stylesheet" type="text/css" href="../../include/phoenix.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

	<script type="text/javascript" language="JavaScript">

		var icon = new Image();

		function changeIcon()
		{
    			icon.src = "icons/1_" + document.forms["changeicon"].factionid.value + ".gif" + "?" + (new Date()).getTime();
			document.icon.src = icon.src;
		}

		function errorIcon()
		{
    			icon.src = "icons/0_0.gif" + "?" + (new Date()).getTime();
			document.icon.src = icon.src;
		}

	</script>
</head>

<body>

<div class="phx-main" style="max-width: 540px; margin: 40px auto;">

	<div class="phx-page-header">
		<h1><i class="fa-solid fa-chess-queen"></i> <%= T("guildicon.title") %></h1>
		<p><%= T("guildicon.subtitle") %></p>
	</div>

	<div class="phx-card phx-card-glow">

		<%
			try {
			if(admin_mode)
			{
				out.println("<div class=\"phx-flex-between\" style=\"margin-bottom: 16px;\">");
				out.println("<span class=\"phx-text-success\"><i class=\"fa-solid fa-shield-halved\"></i> " + T("guildicon.root_access") + "</span>");
				out.println("<a href=\"index.jsp?download\" class=\"phx-btn phx-btn-primary phx-btn-sm\"><i class=\"fa-solid fa-download\"></i> " + T("guildicon.download_btn") + "</a>");
				out.println("</div>");
			}
			else
			{
				pageContext.include("login.jsp");
			}
		}catch (Exception e) {

				logMessages.add(new java.util.Date() + ": Error in admin access check : " + e.getMessage());

			out.println("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> Error: " + e.getMessage() + "</div>");
		}
		%>

		<%
			if(admin_mode && request.getParameter("download") != null)
			{
				try {
				String basePath = request.getRealPath(request.getServletPath().replaceAll("index.jsp", ""));

				File[] imageFiles = (new File(basePath + "/icons")).listFiles();

				if(imageFiles == null) {
						logMessages.add(new java.util.Date() + ": Error getting images directory or images directory does not exist!");

					out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("guildicon.error_get_dir") + "</div>");
					return;
				}


				int tile = 1;
				while(imageFiles.length > tile*tile)
				{
					tile = 2*tile;
				}

				BufferedImage iconlist = new BufferedImage(tile*16, tile*16, BufferedImage.TYPE_4BYTE_ABGR);
				Graphics2D iconGraphics = iconlist.createGraphics();
				BufferedWriter bw = new BufferedWriter(new FileWriter(basePath + "/iconlist_guild.txt"));
				bw.write("16\r\n");
				bw.write("16\r\n");
				bw.write(tile + "\r\n");
				bw.write(tile + "\r\n");

				BufferedImage bimg;
				int imageCount = 0;
				int tileX = 0;
				int tileY = 0;
				for(int i=0; i<imageFiles.length; i++)
				{
					if(imageFiles[i].getName().endsWith(".gif"))
					{
						bw.write(imageFiles[i].getName().replaceAll(".gif", ".dds") + "\r\n");
						bimg = ImageIO.read(imageFiles[i]);
						tileX = imageCount%tile;
						tileY = imageCount/tile;
						iconGraphics.drawImage(bimg, tileX*16, tileY*16, null);
						imageCount++;
					}
				}

				bw.close();
				iconGraphics.dispose();
				ImageIO.write(iconlist, "png", new File(basePath + "/iconlist_guild.png"));

				String[] zfiles = new String[]{"iconlist_guild.txt", "iconlist_guild.png"};
				ZipOutputStream z_out = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(basePath + "/iconlist_guild.zip")));
				byte[] buffer = new byte[1024];
				for(int i=0; i<zfiles.length; i++)
				{
					BufferedInputStream z_in = new BufferedInputStream(new FileInputStream(basePath + "/" + zfiles[i]));
					z_out.putNextEntry(new ZipEntry(zfiles[i]));
					int bcount;
					while((bcount = z_in.read(buffer, 0, buffer.length)) != -1)
					{
						z_out.write(buffer, 0, bcount);
					}
					z_in.close();
					(new File(basePath + "/" + zfiles[i])).delete();
				}
				z_out.flush();
				z_out.close();

				// Redirect to download file
				response.sendRedirect("iconlist_guild.zip");

				logMessages.add(new java.util.Date() + ": Successfully created the icon download file");


			}catch (Exception e) {
				logMessages.add(new java.util.Date() + ": Error while creating download file: " + e.getMessage());

					out.println("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> Error: " + e.getMessage() + "</div>");
				}
			}

			if(admin_mode || request.getSession().getAttribute("user") != null)
			{
				int uid = 0;
				if(request.getSession().getAttribute("user") != null)
				{
					uid = Integer.parseInt((String)request.getSession().getAttribute("user"));
				}

				int factionid = 0;
				Boolean delete = false;
				byte[] icon = new byte[0];

				if(request.getContentType() != null && request.getContentType().indexOf("multipart/form-data") > -1)
				{
					try {
					List items = (List) (new org.apache.commons.fileupload.servlet.ServletFileUpload(new org.apache.commons.fileupload.disk.DiskFileItemFactory())).parseRequest(request);

					for(int i=0; i< items.size(); i++)
					{
						FileItem item = (FileItem)items.get(i);
						if(item.isFormField())
						{
							if(item.getFieldName().equals("factionid"))
							{
								factionid = Integer.parseInt(item.getString());
							}
							if(item.getFieldName().equals("delete"))
							{
								delete = true;
							}
						}
						else
						{
							icon = new byte[(int)item.getSize()];
							item.getInputStream().read(icon, 0, icon.length);
						}
                    			}
					}catch(Exception e)
					{
						logMessages.add(new java.util.Date() + ": Error parsing multipart form data: " + e.getMessage());
						out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("guildicon.error_parse") + "</div>");
					}
				}

				Connection connection = null;
				Statement statement = null;
				ResultSet rs = null;
				try{
				    Class.forName("com.mysql.jdbc.Driver").newInstance();
				    connection = DriverManager.getConnection("jdbc:mysql://" + db_host + ":" + db_port + "/" + db_database, db_user, db_password);

					logMessages.add(new java.util.Date() + ": Database Connection Successful.");


					statement = connection.createStatement();


				if(factionid > 0)
				{
					String query = "SELECT account_id FROM roles WHERE faction_id=" + factionid + " AND role_faction_rank=2";
					logMessages.add(new java.util.Date() + ": Executing Query: " + query);

					rs = statement.executeQuery(query);
					if(rs.next())
					{
						logMessages.add(new java.util.Date() + ": Faction found in roles table");
						if(admin_mode || rs.getInt("account_id") == uid)
						{
							String iconFile = request.getRealPath(request.getServletPath().replaceAll("index.jsp", "")) + "/icons/1_" + factionid + ".gif";

							if(delete)
							{
								try
								{
									(new File(iconFile)).delete();
									out.print("<div class=\"phx-notify phx-notify-success\"><i class=\"fa-solid fa-circle-check\"></i> " + T("guildicon.icon_removed") + "</div>");
									logMessages.add(new java.util.Date() + ": Icon Removed: " + iconFile);

								}
								catch(Exception e)
								{
									out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("guildicon.remove_failed") + "</div>");
									logMessages.add(new java.util.Date() + ": Error Removing Icon : " + e.getMessage());

								}
							}
							else
							{
								if(icon.length > 0 && icon[0] == 'G' && icon[1] == 'I' && icon[2] == 'F' && icon[6] == 16 && icon[8] == 16)
								{
									FileOutputStream fos = new FileOutputStream(iconFile);
									fos.write(icon);
									fos.close();
									out.print("<div class=\"phx-notify phx-notify-success\"><i class=\"fa-solid fa-circle-check\"></i> " + T("guildicon.icon_committed") + "</div>");
									logMessages.add(new java.util.Date() + ": Icon Committed: " + iconFile);

								}
								else
								{
									out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("guildicon.required_gif") + "</div>");
									logMessages.add(new java.util.Date() + ": Icon Upload Failed, Required GIF 16x16!");

								}
							}
						}
						else
						{
							out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("guildicon.no_permission") + "</div>");
							logMessages.add(new java.util.Date() + ": Permission Denied for faction id " + factionid);

						}
					}
					else
					{
						out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> " + T("guildicon.faction_not_found") + "</div>");
						logMessages.add(new java.util.Date() + ": Faction Not Found! for faction id " + factionid);

					}
				}

				String factionQuery = "";
				if(admin_mode)
				{
					factionQuery = "SELECT role_name, faction_id FROM roles WHERE role_faction_rank=2";
				}
				else
				{
					factionQuery = "SELECT role_name, faction_id FROM roles WHERE account_id=" + uid + " AND role_faction_rank=2";
				}
				logMessages.add(new java.util.Date() + ": Executing Query: " + factionQuery);

				rs = statement.executeQuery(factionQuery);

				out.println("<form name=\"changeicon\" action=\"index.jsp\" method=\"post\" enctype=\"multipart/form-data\">");

				out.println("<div class=\"phx-form-group\">");
				out.println("<label class=\"phx-label\"><i class=\"fa-solid fa-users\"></i> " + T("guildicon.faction_leader") + "</label>");
				out.println("<select class=\"phx-select\" name=\"factionid\" onchange=\"changeIcon();\">");

				int count = 0;
				while(rs.next())
				{
					if(factionid == 0)
					{
						factionid = rs.getInt("faction_id");
					}

					String label = rs.getString("role_name");
					if(admin_mode)
					{
						label = "FID: " + rs.getString("faction_id") + " (" + label + ")";
					}

					if(factionid == rs.getInt("faction_id"))
					{
						out.println("<option value=\"" + rs.getString("faction_id") + "\" selected>" + label + "</option>");
					}
					else
					{
						out.println("<option value=\"" + rs.getString("faction_id") + "\">" + label + "</option>");
					}
					count++;
				}

				if(count == 0){
						logMessages.add(new java.util.Date() + ": No Factions found");

					out.println("<option value=\"0\" selected>" + T("guildicon.no_factions") + "</option>");
				}

				logMessages.add(new java.util.Date() + ": Factions retrieved successfully, Faction Count = " + count);

				out.println("</select>");
				out.println("</div>");

				out.println("<div class=\"phx-form-group\">");
				out.println("<label class=\"phx-label\"><i class=\"fa-solid fa-image\"></i> " + T("guildicon.current_icon") + "</label>");
				out.println("<img name=\"icon\" onerror=\"errorIcon();\" style=\"max-width: 64px; margin-top: 4px;\">");
				out.println("</div>");

				out.println("<div class=\"phx-form-group\">");
				out.println("<label class=\"phx-label\"><i class=\"fa-solid fa-rotate-left\"></i> " + T("guildicon.reset_icon") + "</label>");
				out.println("<div style=\"display: flex; align-items: center; gap: 8px;\">");
				out.println("<input type=\"checkbox\" name=\"delete\" value=\"true\" id=\"deleteIcon\"> <label for=\"deleteIcon\" class=\"phx-text-sm\" style=\"color: var(--phx-text-2); cursor: pointer;\">" + T("guildicon.reset_hint") + "</label>");
				out.println("</div>");
				out.println("</div>");

				out.println("<div class=\"phx-form-group\">");
				out.println("<label class=\"phx-label\"><i class=\"fa-solid fa-upload\"></i> " + T("guildicon.commit_icon") + "</label>");
				out.println("<input class=\"phx-input\" type=\"file\" name=\"icon\">");
				out.println("</div>");

				out.println("<div class=\"phx-form-group phx-text-center\">");
				out.println("<button type=\"submit\" class=\"phx-btn phx-btn-primary phx-btn-lg\"><i class=\"fa-solid fa-check\"></i> " + T("guildicon.submit_btn") + "</button>");
				out.println("</div>");

				out.println("</form>");
				} catch (SQLException e) {
				logMessages.add(new java.util.Date() + ": SQL Exception: " + e.getMessage());
				out.println("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> Error: SQL Error: " + e.getMessage() + "</div>");
				}
				catch (Exception e){
				logMessages.add(new java.util.Date() + ": Exception: " + e.getMessage());
				out.println("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> Error: Exception: " + e.getMessage() + "</div>");
				}
				finally{
					try {
						if (rs != null) rs.close();
						if(statement != null) statement.close();
						if(connection != null) connection.close();

					} catch (SQLException e) {
						logMessages.add(new java.util.Date() + ": Error closing database resources: " + e.getMessage());

					}
				}
			}
			else
			{
				out.println("");
			}
		%>

	</div>

	<div class="phx-card phx-mt-4">
		<div class="phx-card-header">
			<h2><i class="fa-solid fa-bug"></i> <%= T("guildicon.debug_log") %></h2>
		</div>
		<div class="phx-code" style="font-size: var(--phx-font-size-sm); max-height: 250px;">
			<% for (String message : logMessages) { %><%= message %><br><% } %>
		</div>
	</div>

</div>

<script>
	window.onload = changeIcon;
</script>

</body>

</html>
