<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%@include file="../../WEB-INF/lang_vi.jsp"%>

<%
    String chatFilePath = application.getRealPath("chat_messages.txt");
    String lastRotatedPath = application.getRealPath("last_chat_rotated.txt");
    File chatFile = new File(chatFilePath);
    File lastRotatedFile = new File(lastRotatedPath);

	String user = (String) session.getAttribute("chatUser");
    boolean nameSet = session.getAttribute("nameSet") != null && (Boolean) session.getAttribute("nameSet");

    Object onlineUsersObj = application.getAttribute("onlineUsers");
	Map<String, Long> onlineUsers;

	if(onlineUsersObj instanceof Map){
        onlineUsers = (Map<String, Long>) onlineUsersObj;
    } else {
        onlineUsers = new HashMap<String, Long>();
    }

    application.setAttribute("onlineUsers", onlineUsers);

	if(user != null){
		onlineUsers.put(user, System.currentTimeMillis());
	}


	if (request.getParameter("setUsername") != null) {
        String newName = request.getParameter("newName");
        if (newName != null && !newName.trim().isEmpty()) {
             session.setAttribute("chatUser", newName);
            session.setAttribute("nameSet", true);
            user = newName;
			if(user != null){
				onlineUsers.put(user, System.currentTimeMillis());
			}
        }
        response.sendRedirect("index.jsp");
    }

    if (request.getParameter("editUsername") != null) {
		session.removeAttribute("nameSet");
        response.sendRedirect("index.jsp");
    }

	if(user == null){
		user = "Guest" + new Random().nextInt(1000);
		session.setAttribute("chatUser", user);
	}


    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String timestamp = sdf.format(new java.util.Date());

    try {
        if(lastRotatedFile.exists()) {
            java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader(lastRotatedFile));
            String lastRotated = br.readLine();
            br.close();
            if(lastRotated != null) {
                SimpleDateFormat logDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date lastRotatedDate = logDateFormat.parse(lastRotated);
                Calendar c = Calendar.getInstance();
                c.setTime(lastRotatedDate);
                c.add(Calendar.DATE, 1); // Rotate daily
                java.util.Date nextRotated = c.getTime();
                java.util.Date today = new java.util.Date();
                if(today.after(nextRotated)) {
                    if (chatFile.exists()) {
                        chatFile.delete();
                    }
                     java.io.FileWriter fw = new java.io.FileWriter(lastRotatedFile, false);
                     java.io.BufferedWriter bw = new java.io.BufferedWriter(fw);
                     bw.write(logDateFormat.format(today));
                     bw.close();
                }
            } else {
				 java.io.FileWriter fw = new java.io.FileWriter(lastRotatedFile, false);
                 java.io.BufferedWriter bw = new java.io.BufferedWriter(fw);
                  bw.write(sdf.format(new java.util.Date()).substring(0,10));
                   bw.close();
			}
        } else {
             java.io.FileWriter fw = new java.io.FileWriter(lastRotatedFile, false);
             java.io.BufferedWriter bw = new java.io.BufferedWriter(fw);
              bw.write(sdf.format(new java.util.Date()).substring(0,10));
               bw.close();
		}
    } catch(Exception e) {
        e.printStackTrace();
    }

    if(request.getParameter("clearChat") != null) {
        if (chatFile.exists()) {
            chatFile.delete();
        }
        response.sendRedirect("index.jsp");
    }

    if(request.getParameter("message") != null) {
        String message = request.getParameter("message");
         java.io.FileWriter fw = null;
		 java.io.BufferedWriter bw = null;
        try {
            fw = new java.io.FileWriter(chatFile, true);
            bw = new java.io.BufferedWriter(fw);
             bw.write("<div class='chat-message'><span class='timestamp'>" + timestamp + "</span> - <span class='user'>" + StringEscapeUtils.escapeHtml(user) + "</span>: <span class='text'>" + StringEscapeUtils.escapeHtml(message) + "</span></div>\n");
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
			 try { if (bw != null) bw.close(); } catch (IOException e) {}
             try { if(fw != null) fw.close(); } catch(IOException e) {}
		}

        response.sendRedirect("index.jsp");
    }


	if(session.getAttribute("chatUser") != null){
		String sessionUser = (String) session.getAttribute("chatUser");

		if (onlineUsers.containsKey(sessionUser)) {
			onlineUsers.put(sessionUser, System.currentTimeMillis());
		}

	}


	long currentTime = System.currentTimeMillis();
	long timeout = 60000; //1 minute in milliseconds


	List<String> usersToRemove = new ArrayList<String>();
	for(Map.Entry<String, Long> entry: onlineUsers.entrySet()){
		if(currentTime - entry.getValue() > timeout){
			usersToRemove.add(entry.getKey());
		}
	}

	for(String removeUser: usersToRemove){
		onlineUsers.remove(removeUser);
	}


%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Chat</title>
    <link rel="stylesheet" type="text/css" href="../../include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        #chat-box {
            border: 1px solid var(--phx-border);
            padding: 10px;
            height: 300px;
            overflow-y: scroll;
            margin-bottom: 10px;
            background: var(--phx-surface-2);
            border-radius: var(--phx-radius);
            flex: 1;
        }
        .chat-message {
            margin-bottom: 5px;
            padding: 8px 12px;
            background: var(--phx-surface-3);
            border-radius: var(--phx-radius-sm);
            border-left: 3px solid var(--phx-primary);
        }
        .timestamp {
            color: var(--phx-text-3);
            font-size: 0.75em;
            margin-right: 5px;
        }
        .user {
            font-weight: bold;
            color: var(--phx-primary);
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="phx-main" style="max-width: 800px; margin: 40px auto;">
        <div class="phx-page-header">
            <h1><i class="fa-solid fa-comments"></i> <%= T("chat.title") %></h1>
            <p><%= T("chat.subtitle") %></p>
        </div>

        <% if (!nameSet) {%>
        <div class="phx-card">
            <div class="phx-card-header">
                <h2><i class="fa-solid fa-user-pen"></i> <%= T("chat.set_name") %></h2>
            </div>
            <form action="index.jsp" method="post" style="display: flex; align-items: end; gap: 10px; flex-wrap: wrap;">
                <div style="flex: 1; min-width: 200px;">
                    <label class="phx-label" for="newName"><i class="fa-solid fa-tag"></i> Chọn tên hiển thị:</label>
                    <input class="phx-input" type="text" id="newName" name="newName" required placeholder="Nhập tên hiển thị">
                </div>
                <button type="submit" name="setUsername" class="phx-btn phx-btn-primary"><i class="fa-solid fa-check"></i> <%= T("chat.set_name_btn") %></button>
            </form>
        </div>
        <% } else {%>

        <div class="phx-card" style="position: relative; min-height: 420px;">
            <!-- User list -->
            <div id="user-list" class="phx-card" style="position: absolute; top: 16px; right: 16px; width: 220px; max-height: 180px; overflow-y: auto; padding: 16px; z-index: 10;">
                <div style="font-weight: 600; font-size: var(--phx-font-size-sm); color: var(--phx-text-2); margin-bottom: 8px; border-bottom: 1px solid var(--phx-border); padding-bottom: 8px;">
                    <i class="fa-solid fa-users" style="color: var(--phx-primary); margin-right: 6px;"></i> Người dùng Online
                </div>
                <ul style="list-style: none; padding: 0; margin: 0;">
                    <%
                        for (String onlineUser : onlineUsers.keySet()) {
                            out.println("<li style=\"padding: 4px 0; border-bottom: 1px solid var(--phx-border); font-size: var(--phx-font-size-sm); display: flex; align-items: center;\">");
                            out.println("<span class=\"phx-status-dot online\" style=\"margin-right: 8px; flex-shrink: 0;\"></span>");
                            out.println(StringEscapeUtils.escapeHtml(onlineUser));
                            out.println("</li>");
                        }
                    %>
                </ul>
            </div>

            <!-- Chat area -->
            <div style="margin-right: 240px;">
                <p style="margin-bottom: 12px; font-size: var(--phx-font-size-sm); color: var(--phx-text-2);">
                    <i class="fa-solid fa-circle" style="color: var(--phx-success); font-size: 0.5rem; vertical-align: middle; margin-right: 4px;"></i>
                    Đã đăng nhập: <strong style="color: var(--phx-primary);"><%= StringEscapeUtils.escapeHtml(user) %></strong>
                </p>

                <div id="chat-box">
                <% if (chatFile.exists()) {
                    java.io.BufferedReader br = null;
                    try {
                        br = new java.io.BufferedReader(new java.io.FileReader(chatFile));
                        String line;
                        while ((line = br.readLine()) != null) {
                             out.println(line);
                         }
                     } catch (IOException e) {
                        e.printStackTrace();
                     } finally {
                         try { if (br != null) br.close(); } catch (IOException e) {}
                     }
                 } %>
                </div>

                <form action="index.jsp" method="post" style="display: flex; gap: 8px; margin-bottom: 8px;">
                    <input class="phx-input" type="text" name="message" autocomplete="off" required placeholder="Nhập tin nhắn..." style="flex: 1;">
                    <button type="submit" class="phx-btn phx-btn-primary"><i class="fa-solid fa-paper-plane"></i> <%= T("chat.send_btn") %></button>
                </form>

                <div class="phx-btn-group">
                    <form action="index.jsp" method="post">
                        <button type="submit" name="clearChat" class="phx-btn phx-btn-danger phx-btn-sm"><i class="fa-solid fa-trash-can"></i> <%= T("chat.clear_btn") %></button>
                    </form>
                    <form action="index.jsp" method="post">
                        <button type="submit" name="editUsername" class="phx-btn phx-btn-ghost phx-btn-sm"><i class="fa-solid fa-pen"></i> <%= T("chat.edit_name_btn") %></button>
                    </form>
                </div>
            </div>
        </div>

        <% } %>
    </div>
</body>
</html>
