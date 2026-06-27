<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>index</title>
    <style>
        body {
            background-image: url('set.png');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center center;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .overlay {
            background-color: rgba(0, 0, 0, 0.7); /* Transparent dark overlay */
            padding: 25px;
            border-radius: 15px;
            box-shadow: 5px 5px 15px rgba(0, 0, 0, 0.3);
            max-width: 80%;
            text-align: center;
        }
        .text-content {
          font-size: 1.3em;
          font-weight: bold;
          text-shadow: 1px 1px 2px #ddd; /* Lighter shadow for dark background */
          line-height: 1.4;
            color: white; /* Set text color to white for better visibility */
        }
    </style>
</head>
<body>
    <div class="overlay">
        <div class="text-content">
            Remix Version 4<br>
            This version by Crucifix, Creez, Krona and corzca based on pwAdmin by DaMadBoy,Sora1984, Bola.
        </div>
    </div>
</body>
</html>