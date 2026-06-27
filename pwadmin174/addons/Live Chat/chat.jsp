<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="protocol.*"%>
<%@page import="org.apache.axis.encoding.Base64"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>

<%
    //------------------------------------
    //----------- SETTINGS ---------------
    int show_lines = 20;
    boolean show_colors = true;
    boolean show_smiley_picture = true;
    boolean show_whisper = true;
    boolean show_faction = true;
    boolean show_rooms = true;
    boolean show_common = true;
    boolean show_world = true;
    boolean show_squad = true;
    boolean show_trade = true;
    boolean show_horn = true;
    //------------------------------------
%>

<%
    boolean allowed = false;
    if(request.getSession().getAttribute("ssid") != null) {
        allowed = true;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="refresh" content="5">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="../../include/fav.ico">
    <link rel="stylesheet" type="text/css" href="../../include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body style="background:transparent; margin:0; padding:8px;">

<div class="phx-table-wrap">
    <table class="phx-table">
<%
if(allowed)
{
    Vector<String> lines = new Vector<String>();
    String line;
    String time;
    String sender;
    String recipient;
    String message;
    String debug;
    String color;

    BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(pw_server_path + "/logs/world2.chat")));

    while((line = br.readLine()) != null) {
        lines.add(line);
    }
    br.close();

    int i = lines.size()-1;
    while(i>lines.size()-show_lines && i>=0)
    {
        line = lines.get(i);
        color = "#aaaaaa";
        time = line.substring(0, 19);
        line = line.substring(line.indexOf(": chat :")+9);
        sender = "*****";
        recipient = "*****";
        message = new String("*****");
        byte[] temp = Base64.decode(line.substring(line.indexOf("msg=")+4));

        // Whisper
        if(show_whisper && line.startsWith("Whisper")) {
            message = new String(temp, "UTF-16LE");
            sender = line.substring(line.indexOf("src=")+4);
            sender = "Player(" + sender.substring(0, sender.indexOf(" ")) + ")";
            recipient = line.substring(line.indexOf("dst=")+4);
            recipient = "Player(" + recipient.substring(0, recipient.indexOf(" ")) + ")";
            color = "#ff00dd";
        }
        // Faction
        if(show_faction && line.startsWith("Guild")) {
            message = new String(temp, "UTF-16LE");
            sender = line.substring(line.indexOf("src=")+4);
            sender = "Player(" + sender.substring(0, sender.indexOf(" ")) + ")";
            recipient = line.substring(line.indexOf("fid=")+4);
            recipient = "Faction(" + recipient.substring(0, recipient.indexOf(" ")) + ")";
            color = "#00fffc";
        }
        // Chatroom
        if(show_rooms && line.startsWith("Group")) {
            message = new String(temp, "UTF-16LE");
            sender = line.substring(line.indexOf("src=")+4);
            sender = "Player(" + sender.substring(0, sender.indexOf(" ")) + ")";
            recipient = line.substring(line.indexOf("room=")+5);
            recipient = "Room(" + recipient.substring(0, recipient.indexOf(" ")) + ")";
            color = "#888888";
        }
        if(line.startsWith("Chat")) {
            if(show_common && line.indexOf("chl=0") != -1) {
                message = new String(temp, "UTF-16LE");
                sender = line.substring(line.indexOf("src=")+4);
                sender = "Player(" + sender.substring(0, sender.indexOf(" ")) + ")";
                recipient = "Common";
                color = "#ffffff";
            }
            if(show_world && line.indexOf("chl=1") != -1) {
                message = new String(temp, "UTF-16LE");
                sender = line.substring(line.indexOf("src=")+4);
                sender = "Player(" + sender.substring(0, sender.indexOf(" ")) + ")";
                recipient = "World";
                color = "#ffee00";
            }
            if(show_squad && line.indexOf("chl=2") != -1) {
                message = new String(temp, "UTF-16LE");
                sender = line.substring(line.indexOf("src=")+4);
                sender = "Player(" + sender.substring(0, sender.indexOf(" ")) + ")";
                recipient = "Squad";
                color = "#00ff00";
            }
            if(show_trade && line.indexOf("chl=7") != -1) {
                message = new String(temp, "UTF-16LE");
                sender = line.substring(line.indexOf("src=")+4);
                sender = "Player(" + sender.substring(0, sender.indexOf(" ")) + ")";
                recipient = "Trade";
                color = "#ff8800";
            }
            if(line.indexOf("chl=9") != -1) {
                message = new String(temp, "UTF-16LE");
                sender = line.substring(line.indexOf("src=")+4);
                sender = "Player(" + sender.substring(0, sender.indexOf(" ")) + ")";
                recipient = "System";
                color = "#ff2200";
            }
            if(show_horn && line.indexOf("chl=12") != -1) {
                message = new String(temp, "UTF-16LE");
                sender = line.substring(line.indexOf("src=")+4);
                sender = "Player(" + sender.substring(0, sender.indexOf(" ")) + ")";
                recipient = "Horn";
                color = "#ff9b3e";
            }
        }

        if(show_smiley_picture) {
            message = message.replaceAll(".<\\d+>...<\\d+.\\d+>", "<img src=\"smiley.gif\" align=\"absmiddle\"></img>");
        }

        if(!show_colors) { color = "#ffffff"; }

        out.print("<tr>");
        out.print("<td style=\"width:40px;\">giờ:</td>");
        out.print("<td><b>" + time + "</b></td>");
        out.print("<td style=\"width:40px;\">từ:</td>");
        out.print("<td><b><span style=\"color:" + color + ";\">" + sender + "</span></b></td>");
        out.print("<td style=\"width:30px;\">đến:</td>");
        out.print("<td><b><span style=\"color:" + color + ";\">" + recipient + "</span></b></td>");
        out.print("<td style=\"width:40px;\">tin:</td>");
        out.print("<td><b><span style=\"color:" + color + ";\">" + message + "</span></b></td>");
        out.println("</tr>");
        i--;
    }
}
%>
    </table>
</div>

</body>
</html>
