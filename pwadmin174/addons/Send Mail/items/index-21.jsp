<%@page import="java.util.*"%>
<%@page import="protocol.*"%>
<%@page import="com.goldhuman.Common.Octets"%>
<%@include file="../../../WEB-INF/.pwadminconf.jsp"%>

<%@include file="items-21.jsp"%>

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
	String message = "<br>";
	boolean allowed = false;

	if(request.getSession().getAttribute("ssid") == null)
	{
		message = "<font color=\"#ee0000\"><b>Login to use Send Mail...</b></font>";
	}
	else
	{
		allowed = true;
	}
%>

<%
	if(allowed && request.getParameter("process") != null && request.getParameter("process").compareTo("mail") == 0)
	{
		if(request.getParameter("roleid") != "" && request.getParameter("title") != "" && request.getParameter("content") != "" && request.getParameter("coins") != "" && request.getParameter("itemnumber") != "")
		{
			int roleid = Integer.parseInt(request.getParameter("roleid"));
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			int coins = Integer.parseInt(request.getParameter("coins"));

			int itemnumber = Integer.parseInt(request.getParameter("itemnumber"));
			GRoleInventory gri = new GRoleInventory();

			if(itemnumber > 0)
			{
				gri.id = Integer.parseInt(items[itemnumber][0]);
				gri.guid1 = 0;
				gri.guid2 = 0;
				gri.mask = Integer.parseInt(items[itemnumber][3]);
				gri.proctype = Integer.parseInt(items[itemnumber][4]);
				gri.pos = 0;
				gri.count = Integer.parseInt(items[itemnumber][5]);
				gri.max_count = Integer.parseInt(items[itemnumber][6]);
				gri.expire_date = Integer.parseInt(items[itemnumber][7]);
				gri.data = new Octets(hextoByteArray(items[itemnumber][2]));
			}

			if(protocol.DeliveryDB.SysSendMail(roleid, title, content, gri, coins))
			{
				message = "<font color=\"#00cc00\"><b>Mail Sent</b></font>";
			}
			else
			{
				message = "<font color=\"#ee0000\"><b>Sending Mail Failed</b></font>";
			}
		}
		else
		{
			message = "<font color=\"#ee0000\"><b>Enter Valid Values</b></font>";
		}
	}
%>

<html>

<head>
	<link rel="shortcut icon" href="../../../include/fav.ico">
	<link rel="stylesheet" type="text/css" href="../../../include/style.css">

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

<body>

<form action="index-21.jsp?process=mail" method="post">

<table align="center" width="480" cellpadding="2" cellspacing="0" style="border: 1px solid #cccccc;">
	<tr>
		<th height="1" colspan="2" style="padding: 5;">
			<b>SEND MAIL</b>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp(<a href="../manual.jsp">Manual</a>)
		</th>
	</tr>
	<tr bgcolor="#f0f0f0">
		<td colspan="2" align="center" height="1">
			<% out.print(message); %>
		</td>
	</tr>
	<tr>
		<td height="1">
			Role ID:
		</td>
		<td height="1">
			<input type="text" name="roleid" style="width: 100%; text-align: left;"></input>
		</td>
	</tr>
	<tr>
		<td height="1">
			Title:
		</td>
		<td height="1">
			<input type="text" name="title" style="width: 100%; text-align: left;"></input>
		</td>
	</tr>
	<tr>
		<td height="1" valign="top">
			Content:
		</td>
		<td height="1">
			<textarea name="content" rows="5" style="width: 100%; text-align: left;"></textarea>
		</td>
	</tr>
	<tr>
		<td height="1">
			Coins:
		</td>
		<td height="1">
			<input type="text" name="coins" value="0" style="width: 100%; text-align: left;"></input>
		</td>
	</tr>

<tr>
<td height="1">Category:</td>
<td colspan="2" align="right" height="4">
<form action="Category" method="post">
<select name="choice" size="1" onChange="jump(this.form)">
<option value=""> &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CHOOSE AN ITEM CATEGORY &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; </option>
<option value="../index.jsp">Send Mail (GM List)</option>
<option value="index-01.jsp">Mounts</option><br>
<option value="index-02.jsp">Pets</option><br>
<option value="index-03.jsp">Utility</option><br>
<option value="index-04.jsp">Clothing</option><br>
<option value="index-05.jsp">Materials</option><br>
<option value="index-06.jsp">Apothecary</option><br>
<option value="index-07.jsp">Chi</option><br>
<option value="index-08.jsp">Wines</option><br>
<option value="index-09.jsp">Oracles</option><br>
<option value="index-10.jsp">Cube Of Fate</option><br>
<option value="index-11.jsp">Misc.</option><br>
<option value="index-12.jsp">Twilight Temple</option><br>
<option value="index-13.jsp">Twilight Temple Souledges</option><br>
<option value="index-14.jsp">Frost</option><br>
<option value="index-15.jsp">Lunar Glade</option><br>
<option value="index-16.jsp">Sage & God</option><br>
<option value="index-17.jsp">DragonQuest</option><br>
<option value="index-18.jsp">Projectiles</option><br>
<option value="index-19.jsp">Gems</option><br>
<option value="index-20.jsp">Legendary Weapon Molds</option><br>
<option value="index-21.jsp">Legendary Arm Molds</option><br>
<option value="index-22.jsp">Misc. Legendary</option><br>
<option value="index-23.jsp">Legendary Ornament Molds</option><br>
</select>
</form>
</td>
</tr>

	<tr>
		<td height="1">
			Item ID:
		</td>
		<td height="1">
			<select name="itemnumber" style="width: 100%; text-align: left;">
				<%
					for(int i=0; i<items.length; i++)
					{
						out.println("<option value=\"" + i + "\">" + items[i][0] + " - " + items[i][1] + "</option>");
					}
				%>
			</select>
		</td>
	</tr>
	<tr bgcolor="#f0f0f0">
		<td colspan="2" align="center" height="1">
			<input type="image" src="../../../include/btn_submit.jpg" style="border: 0;"></input>
		</td>
	</tr>
</table>

</form>

</body>

</html>