<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, javax.xml.parsers.*, javax.xml.transform.*, javax.xml.transform.dom.*, javax.xml.transform.stream.*, org.w3c.dom.*, java.util.*" %>
<%@ include file="WEB-INF/.pwadminconf.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Display Role Data</title>
    <style>
        body {
            background-color: #2c2c2c;
            color: white;
            font-family: Arial, sans-serif;
        }
        table {
            width: 80%;
            margin: auto;
            border-collapse: collapse;
            background-color: #333;
            border: 1px solid #555;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #555;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #444;
            font-weight: bold;
        }
        td input[type="text"], 
        td textarea {
            width: 100%;
            padding: 5px;
            background-color: #555;
            color: white;
            border: 1px solid #777;
            border-radius: 3px;
        }
        td textarea {
            resize: vertical;
        }
        .icon-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 2px;
            justify-content: center;
            margin: 10px auto;
            width: 95%;
        } 
        .icon-grid img {
            width: 38px;
            height: 38px;
            cursor: pointer;
            border: 2px solid transparent;
        }
        .icon-grid img:hover {
            border: 2px solid #f88c8c;
        }
        .item-details {
            width: 50%;
            margin: auto;
            background-color: #444;
            padding: 20px;
            border-radius: 5px;
            display: none;
        }
        .item-details div {
            margin-top: 10px;
        }
        .item-area{
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .inv-area{ /*scrolling inv*/
            overflow-y: auto;
            margin-top: 45px; 
            height: 455px;
        }
        .bg-inv {  
            position: relative;    
            width: 317px; 
            height: 545px;
            left: 12%; 
            background-image: url('include/inv.png');
            background-size: cover;             
            background-position: center;         
            background-repeat: no-repeat;                  
        }
        .message{
            position: absolute;
            top: 0%;
            left: 12%;
            align-items: center;
            color: #00ee00;
        }
    </style>
    <script>
        function showItemDetails(itemName, detailsHtml) {
            const detailsBlock = document.getElementById('item-details');
            detailsBlock.innerHTML = `
                <h2>Item Details</h2>
                <p style="text-align: left;">Item Name : ${itemName}</p>
                <div>${detailsHtml}</div>
            `;
            detailsBlock.style.display = 'block';
        }
    </script>
</head>
<body>
    <%
        int id=0 ;
	    String xml = "";
        String debugOutput="";
        String error = ""; 
        String message="";
        String linexml="";
        StringBuilder errorResult = new StringBuilder();
        Document doc=null;
        String updatedXml="";				
        String xmlPath = "";
        String currentDir = System.getProperty("user.dir");
        String realPath = application.getRealPath("/");
        debugOutput += "<br>Debug: Tomcat run in dir = " + currentDir + "<br>Debug: Real path = " + realPath;
    %>
    <form name="content" action="index.jsp?page=rolegui" method="post" style="margin: 0px;">          
    <div style="text-align: right;"><input name="ident" type="text" value="<% out.print(id); %>"></input> <select name="type" ><option value="id">by ID</option></select> <button class="button is-info is-small">View</button></div>         
    </form>
    <br>
    <h1 class="title has-text-centered">Character Data</h1>
    <br>
    <%  
        try {
            id = Integer.parseInt(request.getParameter("ident")); // Parse the ID from the parameter
            debugOutput += "<br>Debug: Loading Character ID = " + id; // Log the loaded ID
    
            // Define the working directory
            File workingDir = new File(pw_server_path + "/gamedbd/");
            debugOutput += "<br>Debug: Working Directory = " + workingDir.getAbsolutePath(); // Log the working directory
    
            // Prepare the command to be executed
            String command = "./gamedbd ./gamesys.conf exportrole " + id;
            debugOutput += "<br>Debug: Command = " + command; // Log the command
    
            // Initialize ProcessBuilder
            ProcessBuilder processBuilder = new ProcessBuilder("/bin/bash", "-c", command);
            processBuilder.directory(workingDir); // Set the working directory for the process
    
            // Initialize result containers
            StringBuilder result = new StringBuilder();
    
            // Start the process
            Process process = processBuilder.start();
    
            // Read output and error streams
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    
            while ((linexml = reader.readLine()) != null) {
                result.append(linexml).append("\n");
            }
            while ((linexml = errorReader.readLine()) != null) {
                errorResult.append(linexml).append("\n");
                debugOutput += "<font color=\"#ee0000\"><br>Debug: Process Error Code = " + errorResult + "</font>"; // Log the exit code
            }
    
            // Close readers
            reader.close();
            errorReader.close();
    
            // Wait for process to finish
            int exitCode = process.waitFor();
            debugOutput += "<br>Debug: Process Exit Code = " + exitCode; // Log the exit code
    
            // Handle the process result
            if (exitCode != 0) {
                debugOutput += "<br>Debug: Process Error Output = " + errorResult.toString(); // Log the error output
                message = "<font color=\"#ee0000\"><b>Process exited with error</b></font>"; // Display error message
            } else {
                message = "<font color=\"#00ee00\"><b></b></font>"; // Request succeed  ,display no message
            }
            message = "<font style=\"size: 10em;\" color=\"#ee0000\"><b>" + errorResult.toString() + "</b></font>";
            xml = result.toString(); // Save the result 
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            ByteArrayInputStream input = new ByteArrayInputStream(xml.getBytes("UTF-8"));
            doc = builder.parse(input);

            
            doc.getDocumentElement().normalize();

            // Display <base>
            NodeList baseList = doc.getElementsByTagName("base");
            if (baseList.getLength() > 0) {
                Node baseNode = baseList.item(0);
                if (baseNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element baseElement = (Element) baseNode;
                    NodeList variableList = baseElement.getElementsByTagName("variable");
    %>   
    <form name="input-gui" action="index.jsp?page=rolegui&ident=<%out.print(id);%>&process=save" method="post">
                    <h2 style="text-align: center;">Base Variables</h2>
                    <table>
                        <thead>
                            <tr><th><h1 style="text-align: center;">Variable Name</h1></th><th><h1 style="text-align: center;">Value</h1></th></tr>
                        </thead>
                        <tbody>
                            <%
                                for (int i = 0; i < variableList.getLength(); i++) {
                                    Node variableNode = variableList.item(i);
                                    if (variableNode.getNodeType() == Node.ELEMENT_NODE) {
                                        Element variableElement = (Element) variableNode;
                                        String name = variableElement.getAttribute("name");
                                        String value = variableElement.getTextContent();
                                        boolean isLongText = value.length() > 50;
                            %>
                                    <tr>
                                        <td><%= name %></td>
                                        <td>
                                            <% if (isLongText) { %>
                                                <textarea id="<%= name + 1 %>" name="<%= name %>" rows="5"><%= value %></textarea>
                                            <% } else { %>
                                                <input id="<%= name + 1 %>"type="text" name="<%= name %>" value="<%= value %>">
                                            <% } %>
                                        </td>
                                    </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
    <%
                }
            }

            // Display <status>
            NodeList statusList = doc.getElementsByTagName("status");
            if (statusList.getLength() > 0) {
                Node statusNode = statusList.item(0);
                if (statusNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element statusElement = (Element) statusNode;
                    NodeList variableList = statusElement.getElementsByTagName("variable");
    %>
                    <h2 style="text-align: center;">Status Variables</h2>
                    <table>
                        <thead>
                            <tr><th><h1 style="text-align: center;">Variable Name</h1></th><th><h1 style="text-align: center;">Value</h1></th></tr>
                        </thead>
                        <tbody>
                            <%
                                for (int i = 0; i < variableList.getLength(); i++) {
                                    Node variableNode = variableList.item(i);
                                    if (variableNode.getNodeType() == Node.ELEMENT_NODE) {
                                        Element variableElement = (Element) variableNode;
                                        String name = variableElement.getAttribute("name");
                                        String value = variableElement.getTextContent();
                                        boolean isLongText = value.length() > 50;
                            %>
                                    <tr>
                                        <td><%= name %></td>
                                        <td>
                                            <% if (isLongText) { %>
                                                <textarea id="<%= name + 2 %>" name="<%= name %>" rows="5"><%= value %></textarea>
                                            <% } else { %>
                                                <input id="<%= name + 2 %>" type="text" name="<%= name %>" value="<%= value %>">
                                            <% } %>
                                        </td>
                                    </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
    <%
                }
            }

            // Display <task>
            NodeList taskList = doc.getElementsByTagName("task");
            if (taskList.getLength() > 0) {
                Node taskNode = taskList.item(0);
                if (taskNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element taskElement = (Element) taskNode;
                    NodeList variableList = taskElement.getElementsByTagName("variable");
    %>
                    <h2 style="text-align: center;">Task Variables</h2>
                    <table>
                        <thead>
                            <tr><th><h1 style="text-align: center;">Variable Name</h1></th><th><h1 style="text-align: center;">Value</h1></th></tr>
                        </thead>
                        <tbody>
                            <%
                                for (int i = 0; i < variableList.getLength(); i++) {
                                    Node variableNode = variableList.item(i);
                                    if (variableNode.getNodeType() == Node.ELEMENT_NODE) {
                                        Element variableElement = (Element) variableNode;
                                        String name = variableElement.getAttribute("name");
                                        String value = variableElement.getTextContent();
                                        boolean isLongText = value.length() > 50;
                            %>
                                    <tr>
                                        <td><%= name %></td>
                                        <td>
                                            <% if (isLongText) { %>
                                                <textarea id="<%= name + 3 %>" name="<%= name %>" rows="5"><%= value %></textarea>
                                            <% } else { %>
                                                <input id="<%= name + 3 %>" type="text" name="<%= name %>" value="<%= value %>">
                                            <% } %>
                                        </td>
                                    </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
    <%
                }
            }
            // Display basics variable <pocket>
                NodeList pocketList = doc.getElementsByTagName("pocket");
                if (pocketList.getLength() > 0) {
                    Node pocketNode = pocketList.item(0);
                    if (pocketNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element pocketElement = (Element) pocketNode;
    
                        // Display direectly under tag <pocket>
                        NodeList variableList = pocketElement.getChildNodes();
    %>
                        <h2 style="text-align: center;">Pocket Variables</h2>
                        <table>
                            <thead>
                                <tr><th><h1 style="text-align: center;">Variable Name</h1></th><th><h1 style="text-align: center;">Value</h1></th></tr>
                            </thead>
                            <tbody>
                                <%
                                    for (int i = 0; i < variableList.getLength(); i++) {
                                        Node childNode = variableList.item(i);
                                        if (childNode.getNodeType() == Node.ELEMENT_NODE && childNode.getNodeName().equals("variable")) {
                                            Element variableElement = (Element) childNode;
                                            String name = variableElement.getAttribute("name");
                                            String value = variableElement.getTextContent();
                                            boolean isLongText = value.length() > 50;
                                %>
                                        <tr>
                                            <td><%= name %></td>
                                            <td>
                                                <% if (isLongText) { %>
                                                    <textarea id="<%= name + 4 %>" name="<%= name %>" rows="5"><%= value %></textarea>
                                                <% } else { %>
                                                    <input id="<%= name + 4 %>" type="text" name="<%= name %>" value="<%= value %>">
                                                <% } %>
                                            </td>
                                        </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                <%
                        // Display <storehouse>
                            NodeList stroreList = doc.getElementsByTagName("storehouse");
                            if (stroreList.getLength() > 0) {
                                Node stroreNode = stroreList.item(0);
                                if (stroreNode.getNodeType() == Node.ELEMENT_NODE) {
                                    Element stroreElement = (Element) stroreNode;
                
                                    // Display variable <storehouse>
                                    NodeList stvariableList = stroreElement.getChildNodes();
                %>
                                    <h2 style="text-align: center;">Storehouse Variables</h2>
                                    <table>
                                        <thead>
                                            <tr><th><h1 style="text-align: center;">Variable Name</h1></th><th><h1 style="text-align: center;">Value</h1></th></tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                for (int i = 0; i < stvariableList.getLength(); i++) {
                                                    Node childNode = stvariableList.item(i);
                                                    if (childNode.getNodeType() == Node.ELEMENT_NODE && childNode.getNodeName().equals("variable")) {
                                                        Element variableElement = (Element) childNode;
                                                        String name = variableElement.getAttribute("name");
                                                        String value = variableElement.getTextContent();
                                                        boolean isLongText = value.length() > 50;
                                            %>
                                                    <tr>
                                                        <td><%= name %></td>
                                                        <td>
                                                            <% if (isLongText) { %>
                                                                <textarea id="<%= name + 6 %>" name="<%= name %>" rows="5"><%= value %></textarea>
                                                            <% } else { %>
                                                                <input id="<%= name + 6 %>" type="text" name="<%= name %>" value="<%= value %>">
                                                            <% } %>
                                                        </td>
                                                    </tr>
                                            <%
                                                    }
                                                }
                                            }
                                        }
                                            %>
                                        </tbody>
                                    </table>                        
    <%              
                    //Display <Equiptment>
                    NodeList invList = doc.getElementsByTagName("inv");
    %>
    <div class="item-area">
    <div class="bg-inv"> 
            <div class="inv-area">
                <p style="text-align: center;">Equiptment Items</p>                
                    <div class="icon-grid">
                        <%
                        if (invList.getLength() > 0) {
                            // Iterate over each <inv> element
                            for (int i = 0; i < invList.getLength(); i++) {
                                Node invNode = invList.item(i);
                                if (invNode.getNodeType() == Node.ELEMENT_NODE) {
                                    Element invElement = (Element) invNode;
                                    
                                    // Prepare HTML to display the variables for each <inv>
                                    NodeList eqvariableList = invElement.getChildNodes();
                                    StringBuilder detailsHtml = new StringBuilder();
                                    String itemId = "";                
                                                
                                    for (int j = 0; j < eqvariableList.getLength(); j++) {
                                        Node childNode = eqvariableList.item(j);
                                        if (childNode.getNodeType() == Node.ELEMENT_NODE && childNode.getNodeName().equals("variable")) {
                                            Element variableElement = (Element) childNode;
                                            String name = variableElement.getAttribute("name");
                                            String value = variableElement.getTextContent();
                
                                            // If it's the 'id' variable, store the itemId for the image lookup
                                            if (name.equals("id")) {
                                                itemId = value;
                                            }
                                            detailsHtml.append("<table style='width: 100%; margin-bottom: 10px;'>"); // Tabel dimulai
                                            detailsHtml.append("<tr><td style='width: 30%; padding-right: 10px;'><label>").append(name).append("</label></td>");
                                            detailsHtml.append("<td><input id='").append(name).append(5).append("' name='").append(name).append(5).append("'type='text' value='").append(value).append("'style='width: 100%;'></td></tr>");
                                            detailsHtml.append("</table>");
                                        }
                                    }
                
                                    // read items name
                                    String itemName = "Unknown Item"; // Default value
                                    String filePath = realPath + "include/item.txt"; // location
                                    BufferedReader br = null;
                                    try {
                                        br = new BufferedReader(new FileReader(filePath));
                                        String line;
                                        while ((line = br.readLine()) != null) {
                                            line = line.trim();
                                            if (line.matches("\\S+\\s\".*\"")) {
                                                String[] parts = line.split("\\s", 2);
                                                String text = parts[1].replaceAll("^\"|\"$", "");
                
                                                if (parts[0].equals(itemId)) {
                                                    itemName = text;
                                                    break;
                                                }
                                            }
                                        }
                                    } catch (IOException e) {
                                        itemName = "Error reading file: " + e.getMessage();
                                    } finally {
                                        if (br != null) {
                                            try {
                                                br.close();
                                            } catch (IOException e) {
                                                itemName = "Error closing file: " + e.getMessage();
                                            }
                                        }
                                    }
                
                                    // Logic to handle item image based on 'id'
                                    String imageSrc = "";
                                    String imagePath = realPath + "include/new_icons/" + itemId + ".png";
                                    File imgFile = new File(imagePath);
                                    if (imgFile.exists()) {
                                        imageSrc = "include/new_icons/" + itemId + ".png";
                                    } else {
                                        imageSrc = "include/new_icons/1.png";  // Default image
                                    }

                                    // string onclick
                                    String onclickValue = detailsHtml.toString();
                                    
                                    // get 'pos5'
                                    String pos5Regex = "id='pos5'.*?value='(\\d+)'";
                                    java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(pos5Regex);
                                    java.util.regex.Matcher matcher = pattern.matcher(onclickValue);
                                    
                                    String pos5Value = "Not Found"; // Default value 
                                    if (matcher.find()) {
                                        pos5Value = matcher.group(1); // get regex
                                    }
                
                                    // Generate the item icon and onclick action
                                    %>
                                    <img class="pos<%= pos5Value %>" src="<%= imageSrc %>" 
                                         alt="Item <%= itemId %>" 
                                         onclick="showItemDetails(`<%= itemName %>`, `<%= detailsHtml.toString() %>`)"
                                         style="width: 38px; height: 38px;">
                                    <%
                                }
                            }
                        }
                    %>
                </div> <!-- End of icon grid -->
<%
    // Dislay <pocket>
        NodeList itemsList = pocketElement.getElementsByTagName("items");
%>
                <p style="text-align: center;">Pocket Items</p>
                <div class="icon-grid">
                    <%
                        for (int i = 0; i < itemsList.getLength(); i++) {
                            Node itemNode = itemsList.item(i);
                            if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
                                Element itemElement = (Element) itemNode;
                                String itemId = "";
                                StringBuilder detailsHtml = new StringBuilder();

                                NodeList itemVariables = itemElement.getElementsByTagName("variable");
                                for (int j = 0; j < itemVariables.getLength(); j++) {
                                    Node variableNode = itemVariables.item(j);
                                    if (variableNode.getNodeType() == Node.ELEMENT_NODE) {
                                        Element variableElement = (Element) variableNode;
                                        String varName = variableElement.getAttribute("name");
                                        String varValue = variableElement.getTextContent();

                                        detailsHtml.append("<table style='width: 100%; margin-bottom: 10px;'>"); 
                                        detailsHtml.append("<tr><td style='width: 30%; padding-right: 10px;'><label>").append(varName).append("</label></td>");
                                        detailsHtml.append("<td><input id='").append(varName).append(4).append("' name='").append(varName).append(4).append("' type='text' value='").append(varValue).append("'style='width: 100%;'></td></tr>");
                                        detailsHtml.append("</table>");

                                        if (varName.equals("id")) {
                                            itemId = varValue;
                                        }
                                    }
                                }

                                if (!itemId.isEmpty()) {
                                    // file texts
                                    String filePath = realPath + "include/item.txt"; 
                                    String itemIdParam =itemId;
                                    String resultText = "Uknown Name"; 
                                
                                    BufferedReader br = null; 
                                    try {
                                        if (itemIdParam != null && !itemIdParam.trim().isEmpty()) { 
                                            br = new BufferedReader(new FileReader(filePath)); 
                                            String line;
                                
                                            while ((line = br.readLine()) != null) {
                                                
                                                line = line.trim();
                                                if (line.matches("\\S+\\s\".*\"")) { 
                                                    String[] parts = line.split("\\s", 2); 
                                                    String text = parts[1].replaceAll("^\"|\"$", ""); 
                                                    
                                                    if (parts[0].equals(itemIdParam)) { 
                                                        resultText = text;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    } catch (IOException e) {
                                        resultText = "Error reading file: " + e.getMessage();
                                    } finally {
                                        
                                        if (br != null) {
                                            try {
                                                br.close();
                                            } catch (IOException e) {
                                                resultText = "Error closing file: " + e.getMessage();
                                            }
                                        }
                                    }                                                              

                                
                                String imageSrc ="";
                                String imagePath = realPath + "include/new_icons/" + itemId + ".png";
                                File imgFile = new File(imagePath); 
                                if(imgFile.exists()){
                                    imageSrc="include/new_icons/" + itemId + ".png";
                                } else {
                                    imageSrc="include/new_icons/1.png";
                                }
                                %>
                                <img src="<%= imageSrc %>" 
                                 alt="Item <%= itemId %>" 
                                 onclick="showItemDetails(`<%= resultText %>`,`<%= detailsHtml.toString() %>`)"
                                 style="width: 38px; height: 38px;"><!-- image size -->
                                <%
                                }
                            }
                        }
                    %>
                </div>
 <%
                // Get the <storehouse> node
                NodeList storehouseList = doc.getElementsByTagName("storehouse");
%>
            
            <p style="text-align: center;">Storehouse Items</p>
            <div class="icon-grid">
                <%
                if (storehouseList.getLength() > 0) {
                    // Iterate over the <storehouse> element(s)
                    for (int i = 0; i < storehouseList.getLength(); i++) {
                        Node storehouseNode = storehouseList.item(i);
                        if (storehouseNode.getNodeType() == Node.ELEMENT_NODE) {
                            Element storehouseElement = (Element) storehouseNode;
            
                            // Iterate over child elements inside <storehouse> (items, material, generalcard, etc.)
                            NodeList itemNodes = storehouseElement.getChildNodes();
                            for (int j = 0; j < itemNodes.getLength(); j++) {
                                Node itemNode = itemNodes.item(j);
            
                                // Ensure the node is an element and NOT <variable> directly under <storehouse>
                                if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
                                    Element itemElement = (Element) itemNode;
            
                                    // Check if the tag name is relevant (like <items>, <material>, etc.)
                                    String tagName = itemElement.getTagName();
                                    if (!tagName.equals("variable")) {
                                        StringBuilder detailsHtml = new StringBuilder();
                                        String itemId = "";
                                        String itemName = "Unknown Item"; // Default item name
            
                                        // Process the <variable> elements for each item
                                        NodeList itemVariables = itemElement.getElementsByTagName("variable");
                                        for (int k = 0; k < itemVariables.getLength(); k++) {
                                            Node variableNode = itemVariables.item(k);
                                            if (variableNode.getNodeType() == Node.ELEMENT_NODE) {
                                                Element variableElement = (Element) variableNode;
                                                String name = variableElement.getAttribute("name");
                                                String value = variableElement.getTextContent();
            
                                                if (name.equals("id")) {
                                                    itemId = value;
                                                }
            
                                                // Append variable name and value in HTML table format
                                                detailsHtml.append("<table style='width: 100%; margin-bottom: 10px;'>");
                                                detailsHtml.append("<tr><td style='width: 30%; padding-right: 10px;'><label>").append(name).append("</label></td>");
                                                detailsHtml.append("<td><input id='").append(name).append(6).append("' name='").append(name).append(6).append("' type='text' value='").append(value).append("' style='width: 100%;'></td></tr>");
                                                detailsHtml.append("</table>");
                                            }
                                        }
            
                                        // Fetch the item name from the external file
                                        String filePath = realPath + "include/item.txt";
                                        BufferedReader br = null;
                                        try {
                                            br = new BufferedReader(new FileReader(filePath));
                                            String line;
                                            while ((line = br.readLine()) != null) {
                                                line = line.trim();
                                                if (line.matches("\\S+\\s\".*\"")) {
                                                    String[] parts = line.split("\\s", 2);
                                                    String text = parts[1].replaceAll("^\"|\"$", "");
                                                    if (parts[0].equals(itemId)) {
                                                        itemName = text;
                                                        break;
                                                    }
                                                }
                                            }
                                        } catch (IOException e) {
                                            itemName = "Error reading file: " + e.getMessage();
                                        } finally {
                                            if (br != null) {
                                                try {
                                                    br.close();
                                                } catch (IOException e) {
                                                    itemName = "Error closing file: " + e.getMessage();
                                                }
                                            }
                                        }
            
                                        // Generate the item image source based on 'id'
                                        String imageSrc = "";
                                        String imagePath = realPath + "include/new_icons/" + itemId + ".png";
                                        File imgFile = new File(imagePath);
                                        if (imgFile.exists()) {
                                            imageSrc = "include/new_icons/" + itemId + ".png";
                                        } else {
                                            imageSrc = "include/new_icons/1.png"; // Default image if not found
                                        }
            
                                        // Display item icon with onclick action to show details
                                        %>
                                        <div class="icon-item">
                                            <img src="<%= imageSrc %>" 
                                                 alt="Item <%= itemId %>" 
                                                 onclick="showItemDetails(`<%= itemName %>`,`<%= detailsHtml.toString() %>`)"
                                                 style="width: 38px; height: 38px;">
                                        </div>
                                        <%
                                    }
                                }
                            }
                        }
                    }
                }
                %>
            </div> <!-- End of icon grid -->
            </div> <!-- End of inv area -->           
</div><!-- End all inv grid -->
<%           
                }
            }            
            if (request.getParameter("process") != null && request.getParameter("process").compareTo("save") == 0) { 
                // Parameter mapping
                Map<String, Integer> variableIndexMap = new HashMap<String, Integer>();
                Map<String, String[]> parameterMap = request.getParameterMap();
            
                NodeList variableNodes = doc.getElementsByTagName("variable");

                // Track mapping for replacement logic
                Map<String, String> inputMapping = new HashMap<String, String>();
                for (String key : parameterMap.keySet()) {
                    if (key.matches(".*\\d+$")) { // Match names ending with digits (e.g., id5, pos5)
                        inputMapping.put(key, parameterMap.get(key)[0]);
                    }
                }
            
                // Global replacement
                for (int i = 0; i < variableNodes.getLength(); i++) {
                    Element variableElement = (Element) variableNodes.item(i);
                    String attributeName = variableElement.getAttribute("name");
            
                    if (parameterMap.containsKey(attributeName)) {
                        String[] paramValues = parameterMap.get(attributeName);
            
                        // Track current index for this parameter
                        int currentIndex = variableIndexMap.containsKey(attributeName) ? variableIndexMap.get(attributeName) : 0;
            
                        // If index is within bounds
                        if (currentIndex < paramValues.length) {
                            variableElement.setTextContent(paramValues[currentIndex]);
                            variableIndexMap.put(attributeName, currentIndex + 1);
                        }
                    }
                }
            
                // Set to track processed IDs
                Set<String> processedIds = new HashSet<String>();
                
                // Replacement based on unique ID 
                for (int i = 0; i < variableNodes.getLength(); i++) {
                    Element variableElement = (Element) variableNodes.item(i);
                    String attributeName = variableElement.getAttribute("name");
                    String parentTagName = variableElement.getParentNode().getNodeName(); // Track the parent tag name
                
                    // Check if this is the ID variable
                    if ("id".equals(attributeName)) {
                        String currentIdValue = variableElement.getTextContent();
                
                        // Skip processing if this ID was already processed
                        if (processedIds.contains(currentIdValue)) {
                            continue;
                        }
                
                        // Find matching idX in inputMapping
                        String inputKey = null;
                        for (Iterator<String> it = inputMapping.keySet().iterator(); it.hasNext();) {
                            String key = it.next();
                            if (key.startsWith("id") && inputMapping.get(key).equals(currentIdValue)) {
                                inputKey = key;
                                break;
                            }
                        }
                
                        if (inputKey != null) {
                            // Extract the group number (e.g., id5 -> 5)
                            String groupNumber = inputKey.replaceAll("\\D+", "");
                
                            // Replace variables only within the same tag
                            NodeList siblingNodes = variableElement.getParentNode().getChildNodes();
                            for (int j = 0; j < siblingNodes.getLength(); j++) {
                                if (siblingNodes.item(j).getNodeType() == Node.ELEMENT_NODE) {
                                    Element siblingVariable = (Element) siblingNodes.item(j);
                                    String siblingName = siblingVariable.getAttribute("name");
                
                                    // Skip replacing "id" and "pos"
                                    if ("id".equals(siblingName) || "pos".equals(siblingName)) {
                                        continue;
                                    }
                
                                    // Replace value if a matching input exists (e.g., count5, max_count5)
                                    String siblingKey = siblingName + groupNumber;
                                    if (inputMapping.containsKey(siblingKey)) {
                                        siblingVariable.setTextContent(inputMapping.get(siblingKey));
                                        debugOutput += "<br>Replaced " + siblingKey + " in tag <" + parentTagName + "> with value: " + inputMapping.get(siblingKey);
                                    }
                                }
                            }
                
                            // Mark this ID as processed
                            processedIds.add(currentIdValue);
                        }
                    }
                }                                

                NodeList variableNodesAfterReplace = doc.getElementsByTagName("variable");

                for (int i = variableNodesAfterReplace.getLength() - 1; i >= 0; i--) { 
                    Element variableElement = (Element) variableNodesAfterReplace.item(i);
                    String attributeName = variableElement.getAttribute("name");
                
                    // delete reserved1 to reserved10
                    if (attributeName.matches("reserved[1-9]|reserved10")) {
                        Node parent = variableElement.getParentNode();
                        parent.removeChild(variableElement);
                        debugOutput += "<br>Removed <variable name=\"" + attributeName + "\">";
                
                        // **delete whitespace**
                        NodeList children = parent.getChildNodes();
                        for (int j = children.getLength() - 1; j >= 0; j--) {
                            Node child = children.item(j);
                            if (child.getNodeType() == Node.TEXT_NODE && child.getTextContent().trim().isEmpty()) {
                                parent.removeChild(child);
                            }
                        }
                        parent.normalize();
                    }
                }                                
            
                // Convert modified XML back to string with proper settings
                TransformerFactory transformerFactory = TransformerFactory.newInstance();
                Transformer transformer = transformerFactory.newTransformer();                
                // Set properties for better formatting
                transformer.setOutputProperty(OutputKeys.INDENT, "yes");
                transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");  
                
                // Create a DOMSource from the modified XML document
                DOMSource source = new DOMSource(doc);
                StringWriter writer = new StringWriter();
                StreamResult resultOutput = new StreamResult(writer);
                
                // XML to string transformation
                transformer.transform(source, resultOutput);
                
                // Retrieve the modified XML results
                updatedXml = writer.toString();
                
                // **Additional steps to remove extra spaces/tabulations**:
                updatedXml = updatedXml.replaceAll("(?m)^[ \t]+", ""); // Menghapus spasi atau tab di awal baris
                
                // Debug output -optional
                //debugOutput += "<br>Updated XML: " + updatedXml;
                
                // Specify the path for the XML file to be saved
                xmlPath = pw_server_path + "gamedbd/temp.xml";
                
                // Create FileWriter and BufferedWriter objects to write XML files
                FileWriter fileWriter = null;
                BufferedWriter edited = null;
                try {
                    fileWriter = new FileWriter(xmlPath);
                    edited = new BufferedWriter(fileWriter);
                
                    // write to file
                    edited.write(updatedXml);
                    edited.flush(); // Pastikan semua data ditulis
                
                    debugOutput += "<font color=\"#00cc00\"><br>Debug: edited XML saved to = " + xmlPath + "</font>";
                    
                    // Path
                    workingDir = new File(pw_admin_path);
                    debugOutput += "<br>Debug: Working Directory = " + workingDir.getAbsolutePath();
                    
                    // **Command (Without Shell)**
                    String[] command2 = {workingDir.getAbsolutePath() + "/updater", pw_server_path + "gamedbd"};
                    debugOutput += "<br>Debug: Command = ";
                    
                    // command StringBuilder
                    StringBuilder commandString = new StringBuilder();
                    for (String cmdPart : command2) {
                        commandString.append(cmdPart).append(" ");
                    }
                    debugOutput += commandString.toString().trim();
                    
                    processBuilder.command(command2);
                    processBuilder.directory(workingDir);
                    
                    process = processBuilder.start();                                                                                          
                
                    reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                    errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
                
                    result.setLength(0);  
                    errorResult.setLength(0);

                    String line = null;
                    while ((line = reader.readLine()) != null) {
                        result.append(line).append("\n");
                    }
                    while ((line = errorReader.readLine()) != null) {
                        errorResult.append(line).append("\n");
                    }
                
                    // wait the process
                    exitCode = process.waitFor();
                    debugOutput += "<br>Debug: Process Exit Code = " + exitCode; 
                
                    // display shell result
                    debugOutput += "<br>Shell Output: <pre>" + result.toString() + "</pre>";
                    if (errorResult.length() > 0) {
                        debugOutput += "<br>Shell Error: <pre>" + errorResult.toString() + "</pre>";
                    }
                
                } catch (IOException e) {
                    debugOutput += "<font color=\"#ff0000\"><br>Error saving XML or executing shell command: " + e.getMessage() + "</font>";
                } catch (InterruptedException e) {
                    debugOutput += "<font color=\"#ff0000\"><br>Shell process interrupted: " + e.getMessage() + "</font>";
                } finally {
                    try {
                        if (edited != null) {
                            edited.close();
                        }
                        if (fileWriter != null) {
                            fileWriter.close();
                        }
                        debugOutput += "<font color=\"#00ee00\"><b>Request Successfull" + errorResult + "</b></font>";
                        out.println("<font class=\"message\"><b>Request Successfull" + errorResult + "</b></font>");
                    } catch (IOException e) {
                        debugOutput += "<font color=\"#ff0000\"><br>Error closing file writers: " + e.getMessage() + "</font>";
                    }
                }                                                                       
            }
                         
        } catch (Exception e) {
            if (e.getMessage() == null) {
                error += "<font color=\"#ee0000\"><b>Error: " + e.getMessage() + ", " + errorResult + "</b></font>";
            } else {
                error += "<font color=\"#00ee00\"><b>Request Successfull</b></font>";
                error += "<br><font color=\"#ee0000\"><b>" + errorResult + "</b></font>";
            }           
        }               
%>
    <div id="item-details" class="item-details"></div>
    </div>
    <center><br><br><button class="button is-info is-small">Save</button></center>  
</form>    
<%-- Debug output disabled: error and debugOutput --%>
</body>
</html>