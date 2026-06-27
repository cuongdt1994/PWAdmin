<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Run gsfix.sh</title>
</head>
<body>
    <h1>Run gsfix.sh Script</h1>

    <label for="gsPath">Enter GS Path on Server:</label>
    <input type="text" id="gsPath" placeholder="/path/to/your/game/server" style="width: 300px;">
    <br><br>
    <button id="runButton" onclick="runScript()">Run Script</button>

    <script>
        function runScript() {
            var button = document.getElementById("runButton");
            var gsPath = document.getElementById("gsPath").value;

            if (!gsPath) {
                alert("Please enter a GS path on the server.");
                return;
            }

            button.disabled = true;
            button.textContent = "Downloading and Running...";

            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4) {
                    if (this.status == 200) {
                        alert(this.responseText);
                       button.disabled = false;
                       button.textContent = "Run Script";
                    } else {
                        alert("Error running script: " + this.status);
                        button.disabled = false;
                        button.textContent = "Run Script";
                    }
                }
            };
            xhttp.open("GET", "run_gsfix.jsp?gsPath=" + encodeURIComponent(gsPath), true);
            xhttp.send();
        }
    </script>
</body>
</html>