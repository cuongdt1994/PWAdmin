<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.axis.encoding.Base64"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%@include file="../../WEB-INF/lang_vi.jsp"%>

<%
    String message = "";
    String msgType = "";
    boolean allowed = false;

    if(request.getSession().getAttribute("ssid") == null)
    {
        message = T("livechat.login_required");
        msgType = "error";
    }
    else
    {
        allowed = true;
    }
%>

<%
    if(request.getParameter("process") != null && allowed)
    {
        if(request.getParameter("process").compareTo("delete") == 0)
        {
            try
            {
                FileWriter fw = new FileWriter(pw_server_path + "/logs/world2.chat");
                fw.close();
                message = T("livechat.cleared");
                msgType = "success";
            }
            catch(Exception e)
            {
                message = T("livechat.clear_failed");
                msgType = "error";
            }
        }

        if(request.getParameter("broadcast") != null)
        {
            String broadcast = request.getParameter("broadcast");

            if(protocol.DeliveryDB.broadcast((byte)9, -1, broadcast))
            {
                message = T("livechat.sent");
                msgType = "success";
                try
                {
                    BufferedWriter bw = new BufferedWriter(new FileWriter(pw_server_path + "/logs/world2.chat", true));
                    bw.write((new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Calendar.getInstance().getTime())) + " pwserver glinkd-0: chat : Chat: src=-1 chl=9 msg=" + Base64.encode(broadcast.getBytes("UTF-16LE")) + "\n") ;
                    bw.close() ;
                }
                catch(Exception e)
                {
                    message += " - " + T("livechat.append_failed");
                    msgType = "error";
                }
            }
            else
            {
                message = T("livechat.send_failed");
                msgType = "error";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="../../include/fav.ico">
    <link rel="stylesheet" type="text/css" href="../../include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body style="background:transparent; padding:16px; display:flex; flex-direction:column; height:100vh;">

<div class="phx-page-header" style="margin-bottom:12px;">
    <h1><i class="fa-solid fa-comments" style="color:var(--phx-primary)"></i> <%= T("livechat.title") %></h1>
    <p><%= T("livechat.subtitle") %></p>
</div>

<% if(!message.isEmpty()) { %>
    <div class="phx-notify phx-notify-<%= msgType.isEmpty() ? "warning" : msgType %> phx-mb-2">
        <i class="fa-solid fa-<%= msgType.equals("success") ? "circle-check" : "circle-xmark" %>"></i>
        <span><%= message %></span>
    </div>
<% } %>

<div class="phx-card" style="padding:12px; margin-bottom:8px; flex-shrink:0;">
    <form action="index.jsp?process=broadcast" method="post" style="display:flex; gap:8px; align-items:center;">
        <input class="phx-input" type="text" name="broadcast" value="System Message: " style="flex:1;">
        <button class="phx-btn phx-btn-primary"><i class="fa-solid fa-paper-plane"></i> <%= T("livechat.send_btn") %></button>
    </form>
</div>

<div style="flex:1; margin-bottom:8px; min-height:300px;">
    <iframe src="chat.jsp" width="100%" height="100%" frameborder="0" style="border:1px solid var(--phx-border);border-radius:var(--phx-radius);background:var(--phx-surface);"></iframe>
</div>

<div style="text-align:center; padding-bottom:8px; flex-shrink:0;">
    <a href="index.jsp?process=delete" class="phx-btn phx-btn-danger phx-btn-sm" title="Xóa toàn bộ file nhật ký chat"><i class="fa-solid fa-trash-can"></i> <%= T("livechat.clear_btn") %></a>
</div>

</body>
</html>
