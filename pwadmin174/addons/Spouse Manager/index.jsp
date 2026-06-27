<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="protocol.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%@include file="../../WEB-INF/lang_vi.jsp"%>

<%
    Boolean same_sex = false;
%>

<%
    String message = "";
    String msgType = "";
    boolean allowed = false;

    if(request.getSession().getAttribute("ssid") == null)
    {
        message = "Đăng nhập để sử dụng Quản lý Hôn nhân...";
        msgType = "error";
    }
    else
    {
        allowed = true;
    }
%>

<%
    if(allowed && request.getParameter("process") != null)
    {
        if(request.getParameter("process").compareTo("marry") == 0)
        {
            if(request.getParameter("groom") != null && request.getParameter("bride") != null)
            {
                message = "";
                msgType = "";

                int groomid = GameDB.getRoleIdByName(request.getParameter("groom"));
                if(groomid < 0)
                {
                    try
                    {
                        groomid = Integer.parseInt(request.getParameter("groom"));
                    }
                    catch(Exception e)
                    {
                        if(!message.isEmpty()) message += "<br>";
                        message += "Invalid Groom";
                        msgType = "error";
                    }
                }

                int brideid = GameDB.getRoleIdByName(request.getParameter("bride"));
                if(brideid < 0)
                {
                    try
                    {
                        brideid = Integer.parseInt(request.getParameter("bride"));
                    }
                    catch(Exception e)
                    {
                        if(!message.isEmpty()) message += "<br>";
                        message += "Invalid Bride";
                        msgType = "error";
                    }
                }

                if(groomid > 31 && brideid > 31)
                {
                    if(groomid != brideid)
                    {
                        XmlRole.Role groom = XmlRole.getRoleFromDB(groomid);
                        XmlRole.Role bride = XmlRole.getRoleFromDB(brideid);

                        if(groom != null && bride != null)
                        {
                            if(groom.base.spouse == 0 && bride.base.spouse == 0)
                            {
                                if(same_sex || groom.base.gender != bride.base.gender)
                                {
                                    try
                                    {
                                        groom.base.spouse = brideid;
                                        bride.base.spouse = groomid;

                                        XmlRole.putRoleToDB(groomid, groom);
                                        XmlRole.putRoleToDB(brideid, bride);

                                        message = "Characters Married";
                                        msgType = "success";
                                    }
                                    catch(Exception e)
                                    {
                                        message = "Marriage Failed";
                                        msgType = "error";
                                    }
                                }
                                else
                                {
                                    message = "Same Gender";
                                    msgType = "error";
                                }
                            }
                            else
                            {
                                message = "Groom or Bride already Married";
                                msgType = "error";
                            }
                        }
                        else
                        {
                            message = "Invalid Groom or Bride";
                            msgType = "error";
                        }
                    }
                    else
                    {
                        message = "Groom and Bride are Identical";
                        msgType = "error";
                    }
                }
            }
        }

        if(request.getParameter("process").compareTo("divorce") == 0)
        {
            if(request.getParameter("spouse") != null)
            {
                message = "";
                msgType = "";

                int groomid = GameDB.getRoleIdByName(request.getParameter("spouse"));
                int brideid = -1;

                if(groomid < 0)
                {
                    try
                    {
                        groomid = Integer.parseInt(request.getParameter("spouse"));
                    }
                    catch(Exception e)
                    {
                        if(!message.isEmpty()) message += "<br>";
                        message += "Invalid Spouse";
                        msgType = "error";
                    }
                }

                if(groomid > 31)
                {
                    XmlRole.Role groom = XmlRole.getRoleFromDB(groomid);

                    if(groom != null)
                    {
                        if(groom.base.spouse != 0)
                        {
                            brideid = groom.base.spouse;

                            try
                            {
                                groom.base.spouse = 0;
                                XmlRole.putRoleToDB(groomid, groom);
                                message = "Groom Divorced";
                                msgType = "success";
                            }
                            catch(Exception e)
                            {
                                if(!message.isEmpty()) message += "<br>";
                                message += "Groom Divorce Failed";
                                msgType = "error";
                            }
                        }
                        else
                        {
                            message = "Groom already Divorced";
                            msgType = "error";
                        }
                    }
                    else
                    {
                        message = "Invalid Groom";
                        msgType = "error";
                    }
                }

                if(!"error".equals(msgType)) message += "<br>";

                if(brideid > 31)
                {
                    XmlRole.Role bride = XmlRole.getRoleFromDB(brideid);
                    if(bride != null)
                    {
                        if(bride.base.spouse == groomid)
                        {
                            try
                            {
                                bride.base.spouse = 0;
                                XmlRole.putRoleToDB(brideid, bride);
                                if(message.endsWith("<br>")) message = message.substring(0, message.length()-4);
                                message += "Bride Divorced";
                                msgType = "success";
                            }
                            catch(Exception e)
                            {
                                if(!message.isEmpty()) message += "<br>";
                                message += "Bride Divorce Failed";
                                msgType = "error";
                            }
                        }
                        else
                        {
                            if(!message.isEmpty()) message += "<br>";
                            message += "Bride not married with Groom";
                            msgType = "error";
                        }
                    }
                    else
                    {
                        if(!message.isEmpty()) message += "<br>";
                        message += "Invalid Bride";
                        msgType = "error";
                    }
                }
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
<body style="background:transparent; padding:16px;">

<div class="phx-page-header">
    <h1><i class="fa-solid fa-heart" style="color:var(--phx-primary)"></i> <%= T("spouse.title") %></h1>
    <p><%= T("spouse.subtitle") %></p>
</div>

<% if(!message.isEmpty()) { %>
    <div class="phx-notify phx-notify-<%= msgType.isEmpty() ? "warning" : msgType %> phx-mb-4">
        <i class="fa-solid fa-<%= msgType.equals("success") ? "circle-check" : "circle-xmark" %>"></i>
        <span><%= message %></span>
    </div>
<% } %>

<div class="phx-card phx-mb-4">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-ring"></i> <%= T("spouse.marry") %></h2>
    </div>
    <form action="index.jsp?process=marry" method="post">
        <div class="phx-form-group">
            <label class="phx-label">Groom + Bride:</label>
            <div style="display:flex; gap:8px; align-items:center;">
                <input class="phx-input" type="text" name="groom" placeholder="<%= T("spouse.groom") %>" style="flex:1;">
                <span style="color:var(--phx-text-2);">+</span>
                <input class="phx-input" type="text" name="bride" placeholder="<%= T("spouse.bride") %>" style="flex:1;">
            </div>
        </div>
        <button class="phx-btn phx-btn-primary"><i class="fa-solid fa-check"></i> <%= T("spouse.marry_btn") %></button>
    </form>
</div>

<div class="phx-card">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-heart-crack"></i> <%= T("spouse.divorce") %></h2>
    </div>
    <form action="index.jsp?process=divorce" method="post">
        <div class="phx-form-group">
            <label class="phx-label"><%= T("spouse.char_name") %>:</label>
            <input class="phx-input" type="text" name="spouse" placeholder="Tên nhân vật hoặc ID">
        </div>
        <button class="phx-btn phx-btn-danger"><i class="fa-solid fa-xmark"></i> <%= T("spouse.divorce_btn") %></button>
    </form>
</div>

<div style="text-align:center; margin-top:16px;">
    <p class="phx-text-sm phx-text-3">*nhân vật nên được đăng xuất khỏi game</p>
</div>

</body>
</html>
