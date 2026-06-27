<%@ page import="java.util.*"%>

<%!
    String toHexString(int x)
    {
        String result = Integer.toHexString(x);
        if(result.length() == 1)
        {
            result = "0" + result;
        }

        result += "000000";

        return result;
    }
%>

<%
    String skillName;
    int skillValue;
    String skillList = "";
    int skillCount=0;

    for(Enumeration e = request.getParameterNames(); e.hasMoreElements();)
    {
        skillName = (String)e.nextElement();
        skillValue = Integer.parseInt(request.getParameter(skillName));
        if(skillValue>0 && skillCount<256 && skillValue<11 && skillName.length()==8)
        {
            skillList += skillName + "00000000" + toHexString(skillValue);
            skillCount++;
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
    <h1><i class="fa-solid fa-code" style="color:var(--phx-primary)"></i> Skill Hex XML</h1>
    <p>Generated skill hex string</p>
</div>

<div class="phx-card">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-file-code"></i> XML Output</h2>
    </div>
    <div style="margin-bottom:12px;">
        <p style="color:var(--phx-text-2);">
            <code style="color:var(--phx-text);">&lt;variable name="skills" type="Octets"&gt;</code>
        </p>
    </div>
    <textarea class="phx-input" name="skill" wrap="hard" rows="5" style="width:100%;font-family:var(--phx-font-mono);min-height:120px;"><%out.println(toHexString(skillCount)+skillList);%></textarea>
    <div style="margin-top:12px;">
        <p style="color:var(--phx-text-2);">
            <code style="color:var(--phx-text);">&lt;/variable&gt;</code>
        </p>
    </div>
</div>

<div style="text-align:center; margin-top:16px;">
    <a href="javascript: history.back()" class="phx-btn phx-btn-ghost"><i class="fa-solid fa-arrow-left"></i> Back</a>
</div>

</body>
</html>
