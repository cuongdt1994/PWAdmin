<%@page import="java.util.*"%>
<%@page import="protocol.*"%>
<%@page import="com.goldhuman.Common.Octets"%>
<%@include file="../../../WEB-INF/.pwadminconf.jsp"%>
<%@include file="../../../WEB-INF/lang_vi.jsp"%>

<%@include file="items-20.jsp"%>

<%!
    byte[] hextoByteArray(String x)
    {
        if (x.length() < 2) { return new byte[0]; }
        if (x.length() % 2 != 0) { System.err.println("hextoByteArray error!"); }
        byte[] rb = new byte[x.length() / 2];
        for (int i = 0; i < rb.length; ++i) {
            rb[i] = 0;
            int n = x.charAt(i + i);
            if ((n >= 48) && (n <= 57)) n -= 48;
            else if ((n >= 97) && (n <= 102)) n = n - 97 + 10;
            rb[i] = (byte)(rb[i] | n << 4 & 0xF0);
            n = x.charAt(i + i + 1);
            if ((n >= 48) && (n <= 57)) n -= 48;
            else if ((n >= 97) && (n <= 102)) n = n - 97 + 10;
            rb[i] = (byte)(rb[i] | n & 0xF);
        }
        return rb;
    }
%>

<%
    String message = "";
    String msgType = "";
    boolean allowed = false;
    if(request.getSession().getAttribute("ssid") == null) {
        message = "Login to use Send Mail...";
        msgType = "error";
    } else {
        allowed = true;
    }
%>

<%
    if(allowed && request.getParameter("process") != null && request.getParameter("process").compareTo("mail") == 0) {
        if(request.getParameter("roleid") != "" && request.getParameter("title") != "" && request.getParameter("content") != "" && request.getParameter("coins") != "" && request.getParameter("itemnumber") != "") {
            int roleid = Integer.parseInt(request.getParameter("roleid"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int coins = Integer.parseInt(request.getParameter("coins"));
            int itemnumber = Integer.parseInt(request.getParameter("itemnumber"));
            GRoleInventory gri = new GRoleInventory();
            if(itemnumber > 0) {
                gri.id = Integer.parseInt(items[itemnumber][0]);
                gri.guid1 = 0; gri.guid2 = 0;
                gri.mask = Integer.parseInt(items[itemnumber][3]);
                gri.proctype = Integer.parseInt(items[itemnumber][4]);
                gri.pos = 0;
                gri.count = Integer.parseInt(items[itemnumber][5]);
                gri.max_count = Integer.parseInt(items[itemnumber][6]);
                gri.expire_date = Integer.parseInt(items[itemnumber][7]);
                gri.data = new Octets(hextoByteArray(items[itemnumber][2]));
            }
            if(protocol.DeliveryDB.SysSendMail(roleid, title, content, gri, coins)) {
                message = "Mail Sent"; msgType = "success";
            } else {
                message = "Sending Mail Failed"; msgType = "error";
            }
        } else {
            message = "Enter Valid Values"; msgType = "error";
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="../../../include/fav.ico">
    <link rel="stylesheet" type="text/css" href="../../../include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<script>
<!--
function land(ref, target)
{
lowtarget=target.toLowerCase();
if (lowtarget=="_self") {window.location=loc;}
else {if (lowtarget=="_top") {top.location=loc;}
else {if (lowtarget=="_blank") {window.open(loc);}
else {if (lowtarget=="_parent") {parent.location=loc;}
else {parent.frames[target].location=loc;};
}}}
}
function jump(menu)
{
ref=menu.choice.options[menu.choice.selectedIndex].value;
splitc=ref.lastIndexOf("*");
target="";
if (splitc!=-1)
{loc=ref.substring(0,splitc);
target=ref.substring(splitc+1,1000);}
else {loc=ref; target="_self";};
if (ref != "") {land(loc,target);}
}
//-->
</script>

</head>
<body style="background:transparent; padding:16px;">

<div class="phx-page-header">
    <h1><i class="fa-solid fa-envelope" style="color:var(--phx-primary)"></i> SEND MAIL</h1>
    <p><%= T("sendmail.subtitle") %> &nbsp;&nbsp;(<a href="../manual.jsp"><%= T("sendmail.manual") %></a>)</p>
</div>

<% if(!message.isEmpty()) { %>
    <div class="phx-notify phx-notify-<%= msgType.isEmpty() ? "warning" : msgType %> phx-mb-4">
        <i class="fa-solid fa-<%= msgType.equals("success") ? "circle-check" : "circle-xmark" %>"></i>
        <span><%= message %></span>
    </div>
<% } %>

<div class="phx-card">
    <form action="index.jsp?process=mail" method="post">
        <div class="phx-form-group">
            <label class="phx-label">Role ID:</label>
            <input class="phx-input" type="text" name="roleid">
        </div>
        <div class="phx-form-group">
            <label class="phx-label">Title:</label>
            <input class="phx-input" type="text" name="title">
        </div>
        <div class="phx-form-group">
            <label class="phx-label">Content:</label>
            <textarea class="phx-input" name="content" rows="5"></textarea>
        </div>
        <div class="phx-form-group">
            <label class="phx-label">Coins:</label>
            <input class="phx-input" type="text" name="coins" value="0">
        </div>

        <div class="phx-form-group">
            <label class="phx-label">Category:</label>
            <form action="Category" method="post">
            <select class="phx-select" name="choice" size="1" onChange="jump(this.form)">
                <option value="">CHOOSE AN ITEM CATEGORY</option>
                <option value="../index.jsp">Send Mail (GM List)</option>
                <option value="./index-01.jsp">Mounts</option>
                <option value="./index-02.jsp">Pets</option>
                <option value="./index-03.jsp">Utility</option>
                <option value="./index-04.jsp">Clothing</option>
                <option value="./index-05.jsp">Materials</option>
                <option value="./index-06.jsp">Apothecary</option>
                <option value="./index-07.jsp">Chi</option>
                <option value="./index-08.jsp">Wines</option>
                <option value="./index-09.jsp">Oracles</option>
                <option value="./index-10.jsp">Cube Of Fate</option>
                <option value="./index-11.jsp">Misc.</option>
                <option value="./index-12.jsp">Twilight Temple</option>
                <option value="./index-13.jsp">Twilight Temple Souledges</option>
                <option value="./index-14.jsp">Frost</option>
                <option value="./index-15.jsp">Lunar Glade</option>
                <option value="./index-16.jsp">Sage & God</option>
                <option value="./index-17.jsp">DragonQuest</option>
                <option value="./index-18.jsp">Projectiles</option>
                <option value="./index-19.jsp">Gems</option>
                <option value="./index-20.jsp">Legendary Weapon Molds</option>
                <option value="./index-21.jsp">Legendary Arm Molds</option>
                <option value="./index-22.jsp">Misc. Legendary</option>
                <option value="./index-23.jsp">Legendary Ornament Molds</option>
            </select>
            </form>
        </div>

        <div class="phx-form-group">
            <label class="phx-label">Item ID:</label>
            <select class="phx-select" name="itemnumber">
                <%
                    for(int i=0; i<items.length; i++)
                    {
                        out.println("<option value=\"" + i + "\">" + items[i][0] + " - " + items[i][1] + "</option>");
                    }
                %>
            </select>
        </div>
        <button class="phx-btn phx-btn-primary"><i class="fa-solid fa-paper-plane"></i> Send Mail</button>
    </form>
</div>

</body>
</html>
