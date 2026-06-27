<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="protocol.*"%>
<%@page import="com.goldhuman.Common.Octets"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%@include file="../../WEB-INF/lang_vi.jsp"%>

<%!
	byte[] hextoByteArray(String x)
  	{
    		if (x.length() < 2)
		{
      			return new byte[0];
		}
    		if (x.length() % 2 != 0)
		{
      			System.err.println("hextoByteArray error! hex size=" + Integer.toString(x.length()));
    		}
    		byte[] rb = new byte[x.length() / 2];
   		for (int i = 0; i < rb.length; ++i)
    		{
      			rb[i] = 0;

      			int n = x.charAt(i + i);
      			if ((n >= 48) && (n <= 57))
        			n -= 48;
      			else
				if ((n >= 97) && (n <= 102))
        				n = n - 97 + 10;
      					rb[i] = (byte)(rb[i] | n << 4 & 0xF0);

      					n = x.charAt(i + i + 1);
      					if ((n >= 48) && (n <= 57))
        					n -= 48;
      					else
					if ((n >= 97) && (n <= 102))
        					n = n - 97 + 10;
      				rb[i] = (byte)(rb[i] | n & 0xF);
    	}
    	return rb;
  }
%>

<%
	String message = "";
	String msgType = "info";
	boolean allowed = false;

	if(request.getSession().getAttribute("ssid") == null)
	{
		message = "Login to use Send Mail...";
		msgType = "error";
	}
	else
	{
		allowed = true;
	}
%>

<%
	if(allowed && request.getParameter("process") != null && request.getParameter("process").compareTo("mail") == 0)
	{
		if(request.getParameter("roleid") != "" && request.getParameter("title") != "" && request.getParameter("content") != "" && request.getParameter("coins") != "" && request.getParameter("itemid") != "")
		{
			int roleid = Integer.parseInt(request.getParameter("roleid"));
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			int coins = Integer.parseInt(request.getParameter("coins"));

			int itemnumber = Integer.parseInt(request.getParameter("itemid"));
			GRoleInventory gri = new GRoleInventory();

			if(itemnumber > 0)
			{
				gri.id = Integer.parseInt(request.getParameter("itemid"));
				gri.guid1 = 0;
				gri.guid2 = 0;
				gri.mask = Integer.parseInt(request.getParameter("itemmask"));
				gri.proctype = Integer.parseInt(request.getParameter("itemproc"));
				gri.pos = 0;
				gri.count = Integer.parseInt(request.getParameter("itemstacked"));
				gri.max_count = Integer.parseInt(request.getParameter("itemstackmax"));
				gri.expire_date = Integer.parseInt(request.getParameter("itemexpire"));
				gri.data = new Octets(hextoByteArray(request.getParameter("itemhex")));
			}

			if(protocol.DeliveryDB.SysSendMail(roleid, title, content, gri, coins))
			{
				message = "Mail Sent";
				msgType = "success";
			}
			else
			{
				message = "Sending Mail Failed";
				msgType = "error";
			}
		}
		else
		{
			message = "Enter Valid Values";
			msgType = "error";
		}
	}
%>

<!DOCTYPE html>
<html lang="vi">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="../../include/fav.ico">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
	<link rel="stylesheet" type="text/css" href="../../include/phoenix.css">
</head>

<body style="background:transparent; padding:16px;">

<div class="phx-page-header">
	<h3><i class="fas fa-envelope"></i> Send Mail</h3>
	<div class="phx-page-header-actions">
		<a href="./index.jsp" class="phx-btn phx-btn-ghost"><i class="fas fa-arrow-left"></i> <%= T("sendmail.back") %></a>
	</div>
</div>

<div class="phx-card">
	<div class="phx-card-body">
		<form action="manual.jsp?process=mail" method="post">

			<% if(!"".equals(message)) { %>
			<div class="phx-notify phx-notify-<%= msgType %>">
				<i class="fas <%= msgType.equals("success") ? "fa-check-circle" : "fa-exclamation-circle" %>"></i>
				<%= message %>
			</div>
			<% } %>

			<div class="phx-form-group">
				<label class="phx-label">Role ID:</label>
				<input type="text" name="roleid" class="phx-input">
			</div>

			<div class="phx-form-group">
				<label class="phx-label">Title:</label>
				<input type="text" name="title" class="phx-input">
			</div>

			<div class="phx-form-group">
				<label class="phx-label">Content:</label>
				<textarea name="content" rows="5" class="phx-input"></textarea>
			</div>

			<div class="phx-form-group">
				<label class="phx-label">Coins:</label>
				<input type="text" name="coins" value="0" class="phx-input">
			</div>

			<hr class="phx-divider">

			<div class="phx-form-group">
				<label class="phx-label">Item ID:</label>
				<input type="text" name="itemid" value="0" class="phx-input">
			</div>

			<div class="phx-form-group">
				<label class="phx-label">Item Hex:</label>
				<input type="text" name="itemhex" value="" class="phx-input">
			</div>

			<div class="phx-form-group">
				<label class="phx-label">Item Mask:</label>
				<input type="text" name="itemmask" value="0" class="phx-input">
			</div>

			<div class="phx-form-group">
				<label class="phx-label">Item Proctype:</label>
				<input type="text" name="itemproc" value="0" class="phx-input">
			</div>

			<div class="phx-form-group">
				<label class="phx-label">Item Stack:</label>
				<input type="text" name="itemstacked" value="0" class="phx-input">
			</div>

			<div class="phx-form-group">
				<label class="phx-label">Item Max Stack:</label>
				<input type="text" name="itemstackmax" value="0" class="phx-input">
			</div>

			<div class="phx-form-group">
				<label class="phx-label">Item Expire Date:</label>
				<input type="text" name="itemexpire" value="0" class="phx-input">
			</div>

			<div style="text-align: center; margin-top: 16px;">
				<button type="submit" class="phx-btn phx-btn-primary">
					<i class="fas fa-paper-plane"></i> Send Mail
				</button>
			</div>

		</form>
	</div>
</div>

<div class="phx-card" style="margin-top: 16px;">
	<div class="phx-card-header">
		<i class="fas fa-book"></i> Item Reference
	</div>
	<div class="phx-card-body">
		<div class="phx-code">
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br>
		ITEM MASK:<br>
		<br>
		0 = Not To Be Equipped<br>
		1 = Weapon<br>
		2 = Helmet<br>
		4 = Necklace<br>
		8 = Robe<br>
		16 = Chest Armor<br>
		32 = Belt<br>
		64 = Leg Armor<br>
		128 = Foot Armor<br>
		256 = Arm Armor<br>
		1536 = Ring<br>
		1536 = Ring<br>
		2048 = Ammunition<br>
		4096 = Flyer Mount<br>
		8192 = Chest Clothing/Fashion<br>
		16384 = Leg Clothing/Fashion<br>
		32768 = Foot Clothing/Fashion<br>
		65536 = Arm Clothing/Fashion<br>
		131072 = Hierogram<br>
		262144 = Heaven Book/Tome<br>
		524288 = Chat Smiley<br>
		1048576 = HP Charm<br>
		2097152 = MP Charm<br>
		<br>
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br>
		ITEM PROCTYPE:<br>
		<br>
		32791 = SoulBound<br>
		64 = Bind on equipping<br>
		55 = (? CHRONO KEY){cannot drop , cannot trade , cannot sell to npc}<br>
		19 = (? FB Tabs){cannot drop , cannot trade}<br>
		8 = (? Clothing/Binding Charm){}<br>
		1 = (? Revival Scroll){}<br>
		<br>
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br>
		Expire Date:<br>
		value is equal to the unix clock time you want the item to expire<br>
		ie...<br>
		to get current unix time type "date +%s"<br>
		(or... (it) is the time in seconds that have elapsed since 01-01-1970 00:00:00 UTC)<br>
		add the amount of time you want the item to last, in seconds, to current unix time<br>
		(ie. 7 days = 604800 seconds, so you would add 604800 to current time)<br>
		<br>
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br>
		</div>
	</div>
</div>

</body>
</html>
