<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>

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
    <title>Simple Chat Plugin</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #222;
            color: #eee;
            margin: 20px;
			display: flex;
			flex-direction: column;
        }
		h1 {
		  margin-bottom: 20px;
		}
        #chat-box {
            border: 1px solid #555;
            padding: 10px;
            height: 300px;
            overflow-y: scroll;
            margin-bottom: 10px;
            background-color: #333;
			flex: 1;
        }

        .chat-message {
            margin-bottom: 5px;
            padding: 5px;
            background-color: #444;
			border-radius: 5px;
        }

        .timestamp {
            color: #999;
            font-size: 0.8em;
			margin-right: 5px;
        }

        .user {
            font-weight: bold;
			margin-right: 5px;
        }
		.text {

		}

        form input[type="text"] {
            padding: 8px;
            border: 1px solid #555;
            background-color: #444;
            color: #eee;
        }
		
		form button {
			padding: 8px 15px;
			background-color: #555;
			color: #eee;
			border: none;
		}
		form button:hover{
			background-color: #777;
		}
		
		label{
			display: block;
			margin-bottom: 5px;
		}
		#user-list {
			background-color: #333;
			border: 1px solid #555;
			padding: 10px;
			margin-top: 10px;
			max-height: 150px;
			overflow-y: auto;
			width: 200px;
			position: absolute;
			top: 20px;
			right: 20px;
		}

		
    </style>
</head>
<body>
    <h1>Chat</h1>
    <% if (!nameSet) {%>
    <form action="index.jsp" method="post">
        <label for="newName">Set Your Name:</label>
        <input type="text" id="newName" name="newName" required>
         <button type="submit" name="setUsername">Set Name</button>
    </form>
    <% } else {%>
    
	    <p>Logged in as: <%= StringEscapeUtils.escapeHtml(user) %> </p>
		<div style="display: flex; flex-direction: row; align-items: flex-start; ">
		<div id="user-list">
				<p><b>Online Users:</b></p>
				<ul>
					<%
						for (String onlineUser : onlineUsers.keySet()) {
							out.println("<li>" + StringEscapeUtils.escapeHtml(onlineUser) + "</li>");
						}
					%>
				</ul>
		</div>
			<div style="flex: 1;">
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
				<form action="index.jsp" method="post" style="display: flex;">
					<input type="text" name="message" autocomplete="off" required style="flex: 1;">
					<button type="submit">Send</button>
				</form>
				<form action="index.jsp" method="post">
					<button type="submit" name="clearChat">Clear Chat</button>
				</form>
				<form action="index.jsp" method="post">
					<button type="submit" name="editUsername">Edit Name</button>
				</form>
			</div>
		</div>
		
    <% } %>
</body>
</html>