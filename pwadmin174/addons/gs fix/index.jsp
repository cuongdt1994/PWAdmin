<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@include file="../../WEB-INF/lang_vi.jsp"%>

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
    <h1><i class="fa-solid fa-wrench" style="color:var(--phx-primary)"></i> <%= T("gsfix.title") %></h1>
    <p><%= T("gsfix.subtitle") %></p>
</div>

<div class="phx-card">
    <div class="phx-form-group">
        <label class="phx-label" for="gsPath">Nhập đường dẫn GS trên Server:</label>
        <input class="phx-input" type="text" id="gsPath" placeholder="/path/to/your/game/server">
    </div>
    <button class="phx-btn phx-btn-primary" id="runButton" onclick="runScript()"><i class="fa-solid fa-play"></i> <%= T("gsfix.run_btn") %></button>
</div>

<script>
    function runScript() {
        var button = document.getElementById("runButton");
        var gsPath = document.getElementById("gsPath").value;

        if (!gsPath) {
            alert("Vui lòng nhập đường dẫn GS trên server.");
            return;
        }

        button.disabled = true;
        button.textContent = "Đang tải và chạy...";

        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4) {
                if (this.status == 200) {
                    alert(this.responseText);
                   button.disabled = false;
                   button.textContent = "<%= T("gsfix.run_btn") %>";
                } else {
                    alert("Lỗi khi chạy script: " + this.status);
                    button.disabled = false;
                    button.textContent = "<%= T("gsfix.run_btn") %>";
                }
            }
        };
        xhttp.open("GET", "run_gsfix.jsp?gsPath=" + encodeURIComponent(gsPath), true);
        xhttp.send();
    }
</script>

</body>
</html>
