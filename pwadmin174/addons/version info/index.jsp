<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<body style="background:transparent; padding:16px; display:flex; align-items:center; justify-content:center; min-height:100vh;">

<div class="phx-card phx-card-glow" style="max-width:500px; text-align:center;">
    <div class="phx-page-header">
        <h1><i class="fa-solid fa-circle-info" style="color:var(--phx-primary)"></i> <%= T("version.title") %></h1>
    </div>
    <p style="font-size:1.1rem; line-height:1.6; color:var(--phx-text);">
        <%= T("version.text") %>
    </p>
</div>

</body>
</html>
