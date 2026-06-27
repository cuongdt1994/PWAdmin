<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, javax.xml.parsers.*, javax.xml.transform.*, javax.xml.transform.dom.*, javax.xml.transform.stream.*, org.w3c.dom.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ include file="WEB-INF/.pwadminconf.jsp" %>
<%!
    // Helper function to escape HTML for display in <pre> tags
    private String escapeHtml(String text) {
        if (text == null) return "";
        // Basic escaping, sufficient for viewing most content
        return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Display Role Data</title>
    <style>
        /* Styles remain unchanged */
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
        /* Style for the debug output box */
        .debug-output {
            background-color: #1e1e1e;
            border: 1px solid #777;
            padding: 15px;
            margin-top: 25px;
            font-family: monospace;
            font-size: 0.9em;
            line-height: 1.4;
            white-space: pre-wrap; /* Allows wrapping long lines */
            word-wrap: break-word; /* Breaks long words/lines */
            color: #ccc;
            max-height: 400px; /* Limit height */
            overflow-y: auto; /* Add scroll if needed */
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
        // --- START SCRIPTLET ---

        // ******************************************
        // ***** SET DEBUG FLAG HERE (true/false) *****
        // ******************************************
        boolean debug = false; // Set to false to disable debugging output and logging

        int id=0 ;
        String xml = "";
        // Use StringBuilder for better performance with frequent appends
        StringBuilder debugOutputBuilder = new StringBuilder();
        String error = "";
        String message="";
        String linexml="";
        StringBuilder errorResult = new StringBuilder();
        Document doc=null;
        String updatedXml="";
        String xmlPath = "";
        String logFilePath = null; // For text log
        PrintWriter logWriter = null; // For text log
        SimpleDateFormat sdf = null; // Declare here for broader scope

        if (debug) {
            // Add timestamp to debug start
            sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS Z");
            debugOutputBuilder.append("--- Request Start: ").append(sdf.format(new Date())).append(" ---<br>");

            // Determine log file path (in webapp root)
            try {
                String webappRoot = application.getRealPath("/");
                if (webappRoot != null) {
                    logFilePath = new File(webappRoot, "rolegui_debug.log").getAbsolutePath();
                    debugOutputBuilder.append("Debug: Log file path calculated: ").append(logFilePath).append("<br>");
                } else {
                    debugOutputBuilder.append("Warning: Could not determine webapp root path. File logging disabled.<br>");
                }
            } catch (Exception pathEx) {
                debugOutputBuilder.append("<font color='#ffcc00'>Warning: Error getting webapp root path: ").append(pathEx.getMessage()).append(". File logging disabled.</font><br>");
            }


            String currentDir = System.getProperty("user.dir");
            String realPath = application.getRealPath("/");
            debugOutputBuilder.append("Debug: Tomcat run in dir = ").append(currentDir).append("<br>Debug: Real path = ").append(realPath).append("<br>");
        }
        // Store realPath outside the debug block as it's needed later
        String realPath = application.getRealPath("/");
    %>
    <form name="content" action="index.jsp?page=rolegui" method="post" style="margin: 0px;">
    <div style="text-align: right;"><input name="ident" type="text" value="<% out.print(id); %>"></input> <select name="type" ><option value="id">by ID</option></select> <button class="button is-info is-small">View</button></div>
    </form>
    <br>
    <h1 class="title has-text-centered">Character Data</h1>
    <br>
    <%
        try {
            String identParam = request.getParameter("ident");
            if (identParam != null && !identParam.trim().isEmpty()) {
                try {
                    id = Integer.parseInt(identParam); // Parse the ID from the parameter
                } catch (NumberFormatException nfe) {
                    error += "<font color=\"#ee0000\"><b>Error: Invalid ID parameter provided. Not a number.</b></font><br>";
                    if (debug) debugOutputBuilder.append("<font color='#ffcc00'>Warning: Invalid ID '").append(escapeHtml(identParam)).append("'. Using default ID 0.</font><br>");
                    id = 0; // Default or handle as error
                }
            } else {
                if (debug) debugOutputBuilder.append("Debug: No ID parameter provided. Using default ID 0.<br>");
                id = 0; // Default if no param
            }

            if (debug) debugOutputBuilder.append("Debug: Loading Character ID = ").append(id).append("<br>");

            // Proceed only if ID is valid (or handle the 0 case appropriately)
            if (id > 0) { // Assuming 0 is not a valid character ID to load

                // Define the working directory
                File workingDir = new File(pw_server_path + "/gamedbd/");
                if (debug) debugOutputBuilder.append("Debug: Working Directory = ").append(workingDir.getAbsolutePath()).append("<br>");

                // Prepare the command to be executed
                String command = "./gamedbd ./gamesys.conf exportrole " + id;
                if (debug) debugOutputBuilder.append("Debug: Command = ").append(command).append("<br>");

                // Initialize ProcessBuilder
                ProcessBuilder processBuilder = new ProcessBuilder("/bin/bash", "-c", command);
                processBuilder.directory(workingDir); // Set the working directory for the process

                if (debug) debugOutputBuilder.append("[DEBUG] Starting process: ").append(command).append("<br>");

                // Start the process
                Process process = processBuilder.start();

                // --- Read output and error streams with pre-processing ---
                StringBuilder result = new StringBuilder(); // For stdout XML
                boolean foundXmlStart = false; // Flag to track if <?xml is found

                // Use platform default encoding initially for reader, might need changing if gamedbd outputs differently
                BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                if (debug) debugOutputBuilder.append("[DEBUG] Reading process stdout line by line...<br>");
                while ((linexml = reader.readLine()) != null) {
                    if (!foundXmlStart) { // Only check for start if we haven't found it yet
                        // Trim leading/trailing whitespace from the line before checking
                        String trimmedLine = linexml.trim();
                        if (trimmedLine.startsWith("<?xml")) {
                            foundXmlStart = true;
                            if (debug) debugOutputBuilder.append("[DEBUG] Found '&lt;?xml' start marker. Starting XML capture.<br>");
                            result.append(linexml).append("\n"); // Append the starting line
                        } else {
                            // Discard lines before <?xml but log them if debugging
                            if (debug) debugOutputBuilder.append("<font color='#ffcc00'>[DEBUG] Discarding pre-XML line: ").append(escapeHtml(linexml)).append("</font><br>");
                        }
                    } else {
                        // Once <?xml is found, append all subsequent lines
                        result.append(linexml).append("\n");
                    }
                }
                if (debug && !foundXmlStart) {
                    debugOutputBuilder.append("<font color='#ffcc00'>[WARNING] XML start marker '&lt;?xml' was *not* found in process output.</font><br>");
                }
                if (debug) debugOutputBuilder.append("[DEBUG] Finished reading process stdout.<br>");

                // Read stderr as before
                BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
                while ((linexml = errorReader.readLine()) != null) {
                    errorResult.append(linexml).append("\n");
                }
                if (debug) debugOutputBuilder.append("[DEBUG] Finished reading process stderr.<br>");

                // Close readers
                reader.close();
                errorReader.close();

                // Wait for process to finish
                int exitCode = process.waitFor();
                if (debug) debugOutputBuilder.append("Debug: Process Exit Code = ").append(exitCode).append("<br>");

                // Log stderr content if any
                if (debug && errorResult.length() > 0) {
                    debugOutputBuilder.append("<font color=\"#ffcc00\">Debug: Process stderr output: <pre>").append(escapeHtml(errorResult.toString())).append("</pre></font><br>");
                }

                xml = result.toString(); // Save the potentially corrected result

                // --- Log Raw XML Output (Now should be cleaner) ---
                if (debug) {
                    String escapedXml = escapeHtml(xml);
                    debugOutputBuilder.append("<hr><b>[DEBUG] Raw XML Output AFTER Pre-processing Attempt (").append(xml.length()).append(" bytes):</b><pre>")
                                    .append(xml.isEmpty() ? "[EMPTY]" : escapedXml)
                                    .append("</pre><hr>");
                }
                // --- End Log Raw XML Output ---


                // Handle the process result
                if (exitCode != 0) {
                    if (debug) debugOutputBuilder.append("<font color=\"#ee0000\">Debug: Process exited with error code ").append(exitCode).append(".</font><br>");
                    // Display error message based on stderr or generic message
                    message = "<font color=\"#ee0000\"><b>Process exited with error (Code: " + exitCode + ")</b></font>";
                    if (errorResult.length() > 0) {
                         message += "<br><font color=\"#ee0000\"><b>" + escapeHtml(errorResult.toString()) + "</b></font>";
                    }
                } else {
                    message = "<font color=\"#00ee00\"><b></b></font>"; // Request succeed ,display no message
                    // If there was stderr output even on success, maybe log it as a warning message?
                    if (errorResult.length() > 0) {
                        message = "<font style=\"size: 10em;\" color=\"#ffcc00\"><b>Warning (stderr output): " + escapeHtml(errorResult.toString()) + "</b></font>";
                    }
                }


                 // --- XML Parsing ---
                DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                DocumentBuilder builder = factory.newDocumentBuilder();

                // Try parsing the XML (use the pre-processed 'xml' variable)
                if (!xml.trim().isEmpty()) { // Only parse if XML is not empty
                    try {
                        // Use "UTF-8" string for older Java compatibility
                        ByteArrayInputStream input = new ByteArrayInputStream(xml.getBytes("UTF-8"));
                        // Alternatively, try GBK if UTF-8 fails often: xml.getBytes("GBK")
                        doc = builder.parse(input);
                        if (debug) debugOutputBuilder.append("<b>[DEBUG] XML Parsing check:</b> Document object is CREATED<br>");
                    } catch (Exception parseEx) {
                        if (debug) debugOutputBuilder.append("<font color='#ffcc00'><b>[DEBUG] XML Parsing check:</b> Document object is NULL. Parser Error: ").append(escapeHtml(parseEx.getMessage())).append("</font><br>");
                        error += "<font color=\"#ee0000\"><b>Error: Failed to parse XML data from gamedbd.</b></font><br>";
                        doc = null; // Ensure doc is null if parsing failed
                    }
                } else {
                    if (debug) debugOutputBuilder.append("<b>[DEBUG] XML Parsing check:</b> Skipped parsing, XML output was empty.<br>");
                    doc = null;
                }


                if (doc != null) { // Check if parsing was successful before proceeding
                    doc.getDocumentElement().normalize();

                    // --- Log Element Counts ---
                    if (debug) {
                        StringBuilder counts = new StringBuilder("[DEBUG] Found elements: ");
                        NodeList baseList = doc.getElementsByTagName("base");
                        counts.append("&lt;base&gt; = ").append(baseList.getLength());
                        NodeList statusList = doc.getElementsByTagName("status");
                        counts.append(", &lt;status&gt; = ").append(statusList.getLength());
                        NodeList taskList = doc.getElementsByTagName("task");
                        counts.append(", &lt;task&gt; = ").append(taskList.getLength());
                        NodeList pocketList = doc.getElementsByTagName("pocket");
                        counts.append(", &lt;pocket&gt; = ").append(pocketList.getLength());
                        NodeList storehouseList = doc.getElementsByTagName("storehouse");
                        counts.append(", &lt;storehouse&gt; = ").append(storehouseList.getLength());
                        NodeList invList = doc.getElementsByTagName("inv");
                        counts.append(", &lt;inv&gt; = ").append(invList.getLength());
                        debugOutputBuilder.append(counts.toString()).append("<br>");
                    }
                    // --- End Log Element Counts ---

                    // Get all the lists needed later
                    NodeList baseList = doc.getElementsByTagName("base");
                    NodeList statusList = doc.getElementsByTagName("status");
                    NodeList taskList = doc.getElementsByTagName("task");
                    NodeList pocketList = doc.getElementsByTagName("pocket");
                    NodeList storehouseList = doc.getElementsByTagName("storehouse");
                    NodeList invList = doc.getElementsByTagName("inv");

                    // Display <base>
                    if (baseList.getLength() > 0) {
                        if (debug) debugOutputBuilder.append("[DEBUG] Processing <base> section...<br>"); // Added
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
                    } // End <base> processing

                    // Display <status>
                    if (statusList.getLength() > 0) {
                        if (debug) debugOutputBuilder.append("[DEBUG] Processing <status> section...<br>"); // Added
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
                    } // End <status> processing

                    // Display <task>
                    if (taskList.getLength() > 0) {
                        if (debug) debugOutputBuilder.append("[DEBUG] Processing <task> section...<br>"); // Added
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
                    } // End <task> processing

                    // Display <pocket> and its contents
                    if (pocketList.getLength() > 0) {
                         if (debug) debugOutputBuilder.append("[DEBUG] Processing <pocket> section...<br>"); // Added
                         Node pocketNode = pocketList.item(0);
                         if (pocketNode.getNodeType() == Node.ELEMENT_NODE) {
                            Element pocketElement = (Element) pocketNode;

                             // Display variables directly under <pocket>
                            NodeList pocketDirectVars = pocketElement.getChildNodes();
                            // Create a temporary list to hold only the <variable> elements
                             // Use explicit type for older Java compatibility
                             List<Element> pocketVarElements = new ArrayList<Element>();
                              for (int i = 0; i < pocketDirectVars.getLength(); i++) {
                                 Node childNode = pocketDirectVars.item(i);
                                 if (childNode.getNodeType() == Node.ELEMENT_NODE && childNode.getNodeName().equals("variable")) {
                                     pocketVarElements.add((Element) childNode);
                                 }
                             }

                             if (!pocketVarElements.isEmpty()) {
                                 if (debug) debugOutputBuilder.append("[DEBUG] Processing direct variables under <pocket> ("+pocketVarElements.size()+")...<br>"); // Added
                        %>
                                        <h2 style="text-align: center;">Pocket Variables</h2>
                                        <table>
                                            <thead>
                                                <tr><th><h1 style="text-align: center;">Variable Name</h1></th><th><h1 style="text-align: center;">Value</h1></th></tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    for (Element variableElement : pocketVarElements) {
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
                                                %>
                                            </tbody>
                                        </table>
                        <%
                             } // End direct pocket variables display

                             // Display <storehouse> within <pocket> (if structure allows)
                             // Note: Original code checks for storehouse *outside* pocket, adapting slightly
                            if (storehouseList.getLength() > 0) {
                                 if (debug) debugOutputBuilder.append("[DEBUG] Processing <storehouse> section...<br>"); // Added
                                 Node stroreNode = storehouseList.item(0); // Assuming only one
                                 if (stroreNode.getNodeType() == Node.ELEMENT_NODE) {
                                    Element stroreElement = (Element) stroreNode;

                                     // Display variables directly under <storehouse>
                                    NodeList stvariableList = stroreElement.getChildNodes();
                                     // Use explicit type for older Java compatibility
                                     List<Element> storeVarElements = new ArrayList<Element>();
                                      for (int i = 0; i < stvariableList.getLength(); i++) {
                                         Node childNode = stvariableList.item(i);
                                         if (childNode.getNodeType() == Node.ELEMENT_NODE && childNode.getNodeName().equals("variable")) {
                                             storeVarElements.add((Element) childNode);
                                         }
                                     }

                                     if (!storeVarElements.isEmpty()) {
                                          if (debug) debugOutputBuilder.append("[DEBUG] Processing direct variables under <storehouse> ("+storeVarElements.size()+")...<br>"); // Added
                            %>
                                                <h2 style="text-align: center;">Storehouse Variables</h2>
                                                <table>
                                                    <thead>
                                                        <tr><th><h1 style="text-align: center;">Variable Name</h1></th><th><h1 style="text-align: center;">Value</h1></th></tr>
                                                    </thead>
                                                    <tbody>
                                                    <%
                                                        for (Element variableElement : storeVarElements) {
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
                                                    %>
                                                    </tbody>
                                                </table>
                            <%
                                     } // End direct storehouse variables
                                 } // End if storeNode is element
                             } // End <storehouse> processing


                             // Display Items (Pocket/Equip/Storehouse) - Needs refactoring based on actual XML structure
                             // Assuming <inv> = Equipment, <pocket><items> = Pocket, <storehouse><items/material/...> = Store
                            %>
                                <div class="item-area">
                                    <div class="bg-inv">
                                        <div class="inv-area">
                            <%

                            // Display <inv> (Equipment) Items
                            if (invList.getLength() > 0) {
                                if (debug) debugOutputBuilder.append("[DEBUG] Processing <inv> (Equipment) items...<br>"); // Added
                            %>
                                            <p style="text-align: center;">Equipment Items</p>
                                            <div class="icon-grid">
                            <%
                                // Iterate over each <inv> element
                                for (int i = 0; i < invList.getLength(); i++) {
                                    Node invNode = invList.item(i);
                                    if (invNode.getNodeType() == Node.ELEMENT_NODE) {
                                        Element invElement = (Element) invNode;

                                        NodeList eqvariableList = invElement.getElementsByTagName("variable"); // Use getElementsByTagName for robustness
                                        StringBuilder detailsHtml = new StringBuilder();
                                        String itemId = "";
                                        String itemName = "Unknown Item"; // Default value

                                        for (int j = 0; j < eqvariableList.getLength(); j++) {
                                            Node childNode = eqvariableList.item(j);
                                            if (childNode.getNodeType() == Node.ELEMENT_NODE) { // Check it's an element node
                                                Element variableElement = (Element) childNode;
                                                String name = variableElement.getAttribute("name");
                                                String value = variableElement.getTextContent();

                                                if (name.equals("id")) {
                                                    itemId = value;
                                                    if (debug) debugOutputBuilder.append("[DEBUG] Processing <inv> item ID: ").append(itemId).append("<br>"); // Added
                                                }
                                                detailsHtml.append("<table style='width: 100%; margin-bottom: 10px;'>"); // Tabel dimulai
                                                detailsHtml.append("<tr><td style='width: 30%; padding-right: 10px;'><label>").append(escapeHtml(name)).append("</label></td>");
                                                detailsHtml.append("<td><input id='").append(escapeHtml(name)).append(5).append("' name='").append(escapeHtml(name)).append(5).append("'type='text' value='").append(escapeHtml(value)).append("'style='width: 100%;'></td></tr>");
                                                detailsHtml.append("</table>");
                                            }
                                        }

                                        // read items name
                                        if (!itemId.isEmpty()) {
                                            String filePath = realPath + "include/item.txt"; // location
                                            if (debug) debugOutputBuilder.append("[DEBUG] Reading item name for equip ID ").append(itemId).append(" from ").append(filePath).append("<br>"); // Added
                                            BufferedReader br = null;
                                            try {
                                                // Specify encoding if item.txt might not be platform default
                                                br = new BufferedReader(new InputStreamReader(new FileInputStream(filePath), "GBK")); // Example: using GBK if needed
                                                // If unsure, use default: br = new BufferedReader(new FileReader(filePath));
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
                                                 if (debug) debugOutputBuilder.append("[DEBUG] Found item name: ").append(escapeHtml(itemName)).append("<br>"); // Added
                                            } catch (IOException e) {
                                                itemName = "Error reading file: " + e.getMessage();
                                                 if (debug) debugOutputBuilder.append("<font color='#ffcc00'>[ERROR] Failed reading item.txt: ").append(e.getMessage()).append("</font><br>"); // Added
                                            } finally {
                                                if (br != null) { try { br.close(); } catch (IOException e) {} }
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

                                        // string onclick (Escape HTML/JS properly) - Simplified escaping here
                                        String onclickDetails = detailsHtml.toString().replace("`", "\\`").replace("'", "\\'"); // Basic escaping

                                        // get 'pos5' (Assuming pos is a variable within the item's variables)
                                        // Let's find the 'pos' variable directly instead of regex on HTML
                                        String posValue = "Unknown";
                                        for (int j = 0; j < eqvariableList.getLength(); j++) {
                                             Node childNode = eqvariableList.item(j);
                                             if (childNode.getNodeType() == Node.ELEMENT_NODE) {
                                                 Element variableElement = (Element) childNode;
                                                 if ("pos".equals(variableElement.getAttribute("name"))) {
                                                     posValue = variableElement.getTextContent();
                                                     break;
                                                 }
                                             }
                                         }

                                        %>
                                        <img class="pos<%= escapeHtml(posValue) %>" src="<%= imageSrc %>"
                                             alt="Item <%= escapeHtml(itemId) %>"
                                             title="Equip: <%= escapeHtml(itemName) %> (ID: <%= escapeHtml(itemId) %>, Pos: <%= escapeHtml(posValue) %>)"
                                             onclick="showItemDetails(`<%= escapeHtml(itemName) %>`, `<%= onclickDetails %>`)"
                                             style="width: 38px; height: 38px;">
                                        <%
                                    } // end if invNode is element
                                } // end for loop invList
                            %>
                                            </div> <%
                            } // End <inv> processing

                            // Display <pocket><items>
                            NodeList pocketItemsList = pocketElement.getElementsByTagName("items");
                            if (pocketItemsList.getLength() > 0) {
                                if (debug) debugOutputBuilder.append("[DEBUG] Processing <pocket><items>...("+pocketItemsList.getLength()+" items)<br>"); // Added
                            %>
                                            <p style="text-align: center;">Pocket Items</p>
                                            <div class="icon-grid">
                            <%
                                for (int i = 0; i < pocketItemsList.getLength(); i++) {
                                    Node itemNode = pocketItemsList.item(i);
                                    if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
                                        Element itemElement = (Element) itemNode;
                                        String itemId = "";
                                        StringBuilder detailsHtml = new StringBuilder();
                                        String itemName = "Unknown Item";

                                        NodeList itemVariables = itemElement.getElementsByTagName("variable");
                                        for (int j = 0; j < itemVariables.getLength(); j++) {
                                            Node variableNode = itemVariables.item(j);
                                            if (variableNode.getNodeType() == Node.ELEMENT_NODE) {
                                                Element variableElement = (Element) variableNode;
                                                String varName = variableElement.getAttribute("name");
                                                String varValue = variableElement.getTextContent();

                                                detailsHtml.append("<table style='width: 100%; margin-bottom: 10px;'>");
                                                detailsHtml.append("<tr><td style='width: 30%; padding-right: 10px;'><label>").append(escapeHtml(varName)).append("</label></td>");
                                                detailsHtml.append("<td><input id='").append(escapeHtml(varName)).append(4).append("' name='").append(escapeHtml(varName)).append(4).append("' type='text' value='").append(escapeHtml(varValue)).append("'style='width: 100%;'></td></tr>");
                                                detailsHtml.append("</table>");

                                                if (varName.equals("id")) {
                                                    itemId = varValue;
                                                     if (debug) debugOutputBuilder.append("[DEBUG] Processing <pocket><items> item ID: ").append(itemId).append("<br>"); // Added
                                                }
                                            }
                                        }

                                        if (!itemId.isEmpty()) {
                                            // Fetch item name
                                            String filePath = realPath + "include/item.txt";
                                            if (debug) debugOutputBuilder.append("[DEBUG] Reading item name for pocket ID ").append(itemId).append(" from ").append(filePath).append("<br>"); // Added
                                            BufferedReader br = null;
                                            try {
                                                // Specify encoding if item.txt might not be platform default
                                                br = new BufferedReader(new InputStreamReader(new FileInputStream(filePath), "GBK")); // Example: using GBK if needed
                                                // If unsure, use default: br = new BufferedReader(new FileReader(filePath));
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
                                                if (debug) debugOutputBuilder.append("[DEBUG] Found item name: ").append(escapeHtml(itemName)).append("<br>"); // Added
                                            } catch (IOException e) {
                                                itemName = "Error reading file: " + e.getMessage();
                                                if (debug) debugOutputBuilder.append("<font color='#ffcc00'>[ERROR] Failed reading item.txt: ").append(e.getMessage()).append("</font><br>"); // Added
                                            } finally {
                                                if (br != null) { try { br.close(); } catch (IOException e) {} }
                                            }

                                             // Fetch item icon
                                            String imageSrc ="";
                                            String imagePath = realPath + "include/new_icons/" + itemId + ".png";
                                            File imgFile = new File(imagePath);
                                            if(imgFile.exists()){
                                                imageSrc="include/new_icons/" + itemId + ".png";
                                            } else {
                                                imageSrc="include/new_icons/1.png";
                                            }
                                             String onclickDetails = detailsHtml.toString().replace("`", "\\`").replace("'", "\\'"); // Basic escaping

                                             // Get pos value
                                             String posValue = "Unknown";
                                             for (int j = 0; j < itemVariables.getLength(); j++) {
                                                 Node variableNode = itemVariables.item(j);
                                                 if (variableNode.getNodeType() == Node.ELEMENT_NODE) {
                                                     Element variableElement = (Element) variableNode;
                                                     if ("pos".equals(variableElement.getAttribute("name"))) {
                                                         posValue = variableElement.getTextContent();
                                                         break;
                                                     }
                                                 }
                                             }
                                            %>
                                            <img src="<%= imageSrc %>"
                                                alt="Item <%= escapeHtml(itemId) %>"
                                                title="Pocket: <%= escapeHtml(itemName) %> (ID: <%= escapeHtml(itemId) %>, Pos: <%= escapeHtml(posValue) %>)"
                                                onclick="showItemDetails(`<%= escapeHtml(itemName) %>`,`<%= onclickDetails %>`)"
                                                style="width: 38px; height: 38px;"><%
                                        } // end if !itemId.isEmpty()
                                    } // end if itemNode is element
                                } // end for loop pocketItemsList
                            %>
                                            </div> <%
                            } // End pocket <items> processing


                            // Display <storehouse> items (materials, cards etc)
                            if (storehouseList.getLength() > 0) {
                                 if (debug) debugOutputBuilder.append("[DEBUG] Processing <storehouse> items...<br>"); // Added
                                 Node storehouseNode = storehouseList.item(0); // Assuming only one <storehouse> tag
                                 if (storehouseNode.getNodeType() == Node.ELEMENT_NODE) {
                                    Element storehouseElement = (Element) storehouseNode;
                            %>
                                            <p style="text-align: center;">Storehouse Items</p>
                                            <div class="icon-grid">
                            <%
                                    // Iterate over child elements inside <storehouse> (items, material, generalcard, etc.)
                                    NodeList storeItemNodes = storehouseElement.getChildNodes();
                                    for (int j = 0; j < storeItemNodes.getLength(); j++) {
                                        Node itemNode = storeItemNodes.item(j);

                                        // Ensure the node is an element and NOT <variable> directly under <storehouse>
                                        if (itemNode.getNodeType() == Node.ELEMENT_NODE) {
                                            Element itemElement = (Element) itemNode;
                                            String tagName = itemElement.getTagName();

                                            if (!tagName.equals("variable")) { // Process tags like <items>, <material> etc.
                                                 if (debug) debugOutputBuilder.append("[DEBUG] Processing <storehouse><").append(tagName).append("> item...<br>"); // Added
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
                                                             if (debug) debugOutputBuilder.append("[DEBUG] Processing <storehouse><").append(tagName).append("> item ID: ").append(itemId).append("<br>"); // Added
                                                        }

                                                        // Append variable name and value in HTML table format
                                                        detailsHtml.append("<table style='width: 100%; margin-bottom: 10px;'>");
                                                        detailsHtml.append("<tr><td style='width: 30%; padding-right: 10px;'><label>").append(escapeHtml(name)).append("</label></td>");
                                                        detailsHtml.append("<td><input id='").append(escapeHtml(name)).append(6).append("' name='").append(escapeHtml(name)).append(6).append("' type='text' value='").append(escapeHtml(value)).append("' style='width: 100%;'></td></tr>");
                                                        detailsHtml.append("</table>");
                                                    }
                                                }

                                                if (!itemId.isEmpty()){
                                                     // Fetch the item name from the external file
                                                    String filePath = realPath + "include/item.txt";
                                                    if (debug) debugOutputBuilder.append("[DEBUG] Reading item name for store ID ").append(itemId).append(" from ").append(filePath).append("<br>"); // Added
                                                    BufferedReader br = null;
                                                    try {
                                                        // Specify encoding if item.txt might not be platform default
                                                        br = new BufferedReader(new InputStreamReader(new FileInputStream(filePath), "GBK")); // Example: using GBK if needed
                                                        // If unsure, use default: br = new BufferedReader(new FileReader(filePath));
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
                                                         if (debug) debugOutputBuilder.append("[DEBUG] Found item name: ").append(escapeHtml(itemName)).append("<br>"); // Added
                                                    } catch (IOException e) {
                                                        itemName = "Error reading file: " + e.getMessage();
                                                         if (debug) debugOutputBuilder.append("<font color='#ffcc00'>[ERROR] Failed reading item.txt: ").append(e.getMessage()).append("</font><br>"); // Added
                                                    } finally {
                                                        if (br != null) { try { br.close(); } catch (IOException e) {} }
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
                                                     String onclickDetails = detailsHtml.toString().replace("`", "\\`").replace("'", "\\'"); // Basic escaping

                                                     // Get pos value
                                                     String posValue = "Unknown";
                                                     for (int k = 0; k < itemVariables.getLength(); k++) {
                                                         Node variableNode = itemVariables.item(k);
                                                         if (variableNode.getNodeType() == Node.ELEMENT_NODE) {
                                                             Element variableElement = (Element) variableNode;
                                                             if ("pos".equals(variableElement.getAttribute("name"))) {
                                                                 posValue = variableElement.getTextContent();
                                                                 break;
                                                             }
                                                         }
                                                     }

                                                     // Display item icon with onclick action to show details
                                                    %>
                                                    <div class="icon-item">
                                                        <img src="<%= imageSrc %>"
                                                             alt="Item <%= escapeHtml(itemId) %>"
                                                             title="Store: <%= escapeHtml(itemName) %> (ID: <%= escapeHtml(itemId) %>, Pos: <%= escapeHtml(posValue) %>)"
                                                             onclick="showItemDetails(`<%= escapeHtml(itemName) %>`,`<%= onclickDetails %>`)"
                                                             style="width: 38px; height: 38px;">
                                                    </div>
                                                    <%
                                                } // end if !itemId.isEmpty()
                                            } // end if !tagName.equals("variable")
                                        } // end if itemNode is element
                                    } // end for storeItemNodes
                            %>
                                            </div> <%
                                } // end if storehouseNode is element
                            } // End <storehouse> items processing

                            %>
                                        </div> </div></div> <%
                         } // end if pocketNode is element
                    } // End <pocket> processing


                } // End of if (doc != null)

                 // --- Save processing logic ---
                 if (request.getParameter("process") != null && request.getParameter("process").compareTo("save") == 0) {
                      if (debug) debugOutputBuilder.append("<br><hr><b>[DEBUG] Starting Save Process...</b><br>"); // Added
                      if (doc != null) { // Only proceed if doc was parsed correctly
                         // Parameter mapping
                         Map<String, Integer> variableIndexMap = new HashMap<String, Integer>();
                         Map<String, String[]> parameterMap = request.getParameterMap();
                         if (debug) debugOutputBuilder.append("[DEBUG] Received ").append(parameterMap.size()).append(" parameters for saving.<br>"); // Added

                         NodeList variableNodes = doc.getElementsByTagName("variable");

                         // Track mapping for replacement logic
                         Map<String, String> inputMapping = new HashMap<String, String>();
                         for (String key : parameterMap.keySet()) {
                             if (key.matches(".*\\d+$")) { // Match names ending with digits (e.g., id5, pos5)
                                 inputMapping.put(key, parameterMap.get(key)[0]);
                             }
                         }

                         // Global replacement (for variables directly under <base>, <status>, <task>, etc.)
                         if (debug) debugOutputBuilder.append("[DEBUG] Starting global variable replacement...<br>"); // Added
                         for (int i = 0; i < variableNodes.getLength(); i++) {
                             Element variableElement = (Element) variableNodes.item(i);
                             String attributeName = variableElement.getAttribute("name");

                             // Check if the parent is one of the main sections (base, status, task, pocket, storehouse)
                             String parentTagName = variableElement.getParentNode().getNodeName();
                             if ("base".equals(parentTagName) || "status".equals(parentTagName) || "task".equals(parentTagName) ||
                                 ("pocket".equals(parentTagName) && !variableElement.getParentNode().getParentNode().getNodeName().equals("items")) || // direct child of pocket
                                 ("storehouse".equals(parentTagName) && !variableElement.getParentNode().getParentNode().getNodeName().equals("items")) ) { // direct child of storehouse

                                 if (parameterMap.containsKey(attributeName)) {
                                     String[] paramValues = parameterMap.get(attributeName);

                                     // Track current index for this parameter (assuming non-repeating names in global context)
                                     int currentIndex = variableIndexMap.containsKey(attributeName) ? variableIndexMap.get(attributeName) : 0;

                                     if (currentIndex < paramValues.length) {
                                         String newValue = paramValues[currentIndex];
                                         if (debug) debugOutputBuilder.append("[DEBUG] Global Replace: Setting &lt;").append(parentTagName).append("&gt;&lt;variable name=\"").append(attributeName).append("\"&gt; to '").append(escapeHtml(newValue)).append("'&lt;br&gt;");
                                         variableElement.setTextContent(newValue);
                                         variableIndexMap.put(attributeName, currentIndex + 1);
                                     }
                                 }
                             }
                         }

                         // Set to track processed IDs within items/inv/storehouse subsections
                         Set<String> processedItemIds = new HashSet<String>();

                         // Replacement based on unique item ID within inv, pocket items, storehouse items
                         if (debug) debugOutputBuilder.append("[DEBUG] Starting ID-based variable replacement for items...<br>"); // Added
                         for (int i = 0; i < variableNodes.getLength(); i++) {
                             Element variableElement = (Element) variableNodes.item(i);
                             String attributeName = variableElement.getAttribute("name");
                             String parentTagName = variableElement.getParentNode().getNodeName(); // e.g., inv, items, material

                             // Check if inside a relevant item tag (inv, items, material, generalcard etc.)
                             if (!"base".equals(parentTagName) && !"status".equals(parentTagName) && !"task".equals(parentTagName) &&
                                 !"pocket".equals(parentTagName) && !"storehouse".equals(parentTagName) ) { // If it's inside an item structure

                                 if ("id".equals(attributeName)) {
                                     String currentItemIdValue = variableElement.getTextContent();

                                     // Create a unique key combining parent and ID to avoid collisions if same ID exists in pocket and store etc.
                                     String uniqueItemKey = parentTagName + "_" + currentItemIdValue;

                                     if (processedItemIds.contains(uniqueItemKey)) {
                                         continue; // Skip if this specific item (ID within this parent type) was already processed
                                     }

                                     // Find matching idX in inputMapping (e.g., id4, id5, id6)
                                     String inputKey = null;
                                     String groupNumber = null;
                                     for (Map.Entry<String, String> entry : inputMapping.entrySet()) {
                                         String key = entry.getKey();
                                         if (key.startsWith("id") && entry.getValue().equals(currentItemIdValue)) {
                                             // Check if the group number matches the expected suffix for this item type
                                             String currentGroupNumber = key.replaceAll("\\D+", "");
                                             boolean match = false;
                                             if(parentTagName.equals("inv") && key.endsWith("5")) match = true; // Equip uses suffix 5
                                             else if(parentTagName.equals("items") && key.endsWith("4")) match = true; // Pocket items use suffix 4
                                             else if(!parentTagName.equals("variable") && key.endsWith("6")) match = true; // Storehouse items use suffix 6

                                             if (match) {
                                                 inputKey = key;
                                                 groupNumber = currentGroupNumber;
                                                 break;
                                             }
                                         }
                                     }

                                     if (inputKey != null) {
                                          if (debug) debugOutputBuilder.append("[DEBUG] Found match for item ID ").append(currentItemIdValue).append(" in &lt;").append(parentTagName).append("&gt; using input key ").append(inputKey).append("&lt;br&gt;");
                                          // Replace sibling variables within the same item tag
                                         NodeList siblingNodes = variableElement.getParentNode().getChildNodes();
                                         for (int j = 0; j < siblingNodes.getLength(); j++) {
                                             if (siblingNodes.item(j).getNodeType() == Node.ELEMENT_NODE) {
                                                 Element siblingVariable = (Element) siblingNodes.item(j);
                                                 String siblingName = siblingVariable.getAttribute("name");

                                                 // Construct the expected input key (e.g., count4, max_count5, proctype6)
                                                 String siblingKey = siblingName + groupNumber;
                                                 if (inputMapping.containsKey(siblingKey)) {
                                                     String newValue = inputMapping.get(siblingKey);
                                                     // Don't replace id or pos directly here, handle them if needed via specific logic
                                                     if (!"id".equals(siblingName) && !"pos".equals(siblingName)) {
                                                          if (debug) debugOutputBuilder.append("[DEBUG] ID-Based Replace: Setting &lt;").append(parentTagName).append("&gt;&lt;variable name=\"").append(siblingName).append("\"&gt; (ID: ").append(currentItemIdValue).append(") to '").append(escapeHtml(newValue)).append("'&lt;br&gt;");
                                                          siblingVariable.setTextContent(newValue);
                                                     }
                                                 }
                                             }
                                         }
                                         processedItemIds.add(uniqueItemKey); // Mark this item as processed
                                     }
                                 }
                             }
                         }

                         // Remove reserved variables
                         if (debug) debugOutputBuilder.append("[DEBUG] Starting removal of reserved variables...<br>"); // Added
                         NodeList variableNodesAfterReplace = doc.getElementsByTagName("variable");
                         for (int i = variableNodesAfterReplace.getLength() - 1; i >= 0; i--) {
                             Element resVariableElement = (Element) variableNodesAfterReplace.item(i);
                             String resAttributeName = resVariableElement.getAttribute("name");

                             if (resAttributeName.matches("reserved[1-9]|reserved10")) {
                                 Node parent = resVariableElement.getParentNode();
                                 parent.removeChild(resVariableElement);
                                 if (debug) debugOutputBuilder.append("[DEBUG] Removed &lt;variable name=\"").append(resAttributeName).append("\"&gt; from &lt;").append(parent.getNodeName()).append("&gt;&lt;br&gt;"); // Added parent info

                                 // remove whitespace text nodes left behind
                                 NodeList children = parent.getChildNodes();
                                 for (int j = children.getLength() - 1; j >= 0; j--) {
                                     Node child = children.item(j);
                                     if (child.getNodeType() == Node.TEXT_NODE && child.getTextContent().trim().isEmpty()) {
                                         parent.removeChild(child);
                                     }
                                 }
                             }
                         }

                         // Convert modified XML back to string with proper settings
                         TransformerFactory transformerFactory = TransformerFactory.newInstance();
                         Transformer transformer = transformerFactory.newTransformer();
                         transformer.setOutputProperty(OutputKeys.INDENT, "yes");
                         // Specify UTF-8 encoding for the output XML declaration
                         transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
                         // Ensure XML declaration is included
                         transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
                         transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");

                         DOMSource source = new DOMSource(doc);
                         StringWriter writer = new StringWriter();
                         StreamResult resultOutput = new StreamResult(writer);
                         transformer.transform(source, resultOutput);
                         updatedXml = writer.toString();

                         // Optional: Remove extra spaces/tabulations if needed (might affect formatting)
                         // updatedXml = updatedXml.replaceAll("(?m)^[ \t]+", "");

                         // Debug output - log the updated XML (can be very long!)
                         if (debug) {
                             // debugOutputBuilder.append("<br><b>[DEBUG] Updated XML for Saving:</b><pre>").append(escapeHtml(updatedXml)).append("</pre><br>");
                            debugOutputBuilder.append("<br><b>[DEBUG] Updated XML generated (length: ").append(updatedXml.length()).append(" bytes). Ready to save.</b><br>");
                         }

                         // Specify the path for the XML file to be saved
                         xmlPath = pw_server_path + "gamedbd/temp.xml";
                         if (debug) debugOutputBuilder.append("[DEBUG] Preparing to save updated XML to ").append(xmlPath).append("<br>"); // Added

                         // Create FileWriter and BufferedWriter objects to write XML files
                         FileWriter fileWriter = null;
                         BufferedWriter edited = null;
                         try {
                             // Use specific encoding ("UTF-8") when writing the file for consistency
                             fileWriter = new FileWriter(xmlPath); // Overwrite existing temp.xml
                             edited = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(xmlPath), "UTF-8"));
                             edited.write(updatedXml);
                             edited.flush();
                             if (debug) debugOutputBuilder.append("<font color=\"#00cc00\">[DEBUG] Edited XML successfully saved to = ").append(xmlPath).append("</font><br>");

                             // Now run the updater script
                             if (debug) debugOutputBuilder.append("[DEBUG] Preparing to run updater command...<br>"); // Added
                             File updaterWorkingDir = new File(pw_admin_path); // As defined in original code for updater
                             if (debug) debugOutputBuilder.append("[DEBUG] Updater Working Directory = ").append(updaterWorkingDir.getAbsolutePath()).append("<br>"); // Added

                             String updaterCommand = updaterWorkingDir.getAbsolutePath() + "/updater";
                             String targetDirArg = pw_server_path + "gamedbd"; // Argument for the updater script
                             String[] command2 = {updaterCommand, targetDirArg};

                             if (debug) {
                                 StringBuilder commandString = new StringBuilder();
                                 for (String cmdPart : command2) {
                                     commandString.append(cmdPart).append(" ");
                                 }
                                  debugOutputBuilder.append("[DEBUG] Updater Command = ").append(commandString.toString().trim()).append("<br>"); // Added
                             }

                             ProcessBuilder processBuilder2 = new ProcessBuilder(command2); // Use direct command array
                             processBuilder2.directory(updaterWorkingDir); // Set working dir for the updater itself

                             Process process2 = processBuilder2.start();

                             StringBuilder result2 = new StringBuilder();
                             StringBuilder errorResult2 = new StringBuilder();
                             BufferedReader reader2 = new BufferedReader(new InputStreamReader(process2.getInputStream()));
                             BufferedReader errorReader2 = new BufferedReader(new InputStreamReader(process2.getErrorStream()));

                             String line2 = null;
                             while ((line2 = reader2.readLine()) != null) {
                                 result2.append(line2).append("\n");
                             }
                             while ((line2 = errorReader2.readLine()) != null) {
                                 errorResult2.append(line2).append("\n");
                             }
                             reader2.close();
                             errorReader2.close();

                             int exitCode2 = process2.waitFor();
                             if (debug) debugOutputBuilder.append("[DEBUG] Updater Process Exit Code = ").append(exitCode2).append("<br>");

                             if (debug) debugOutputBuilder.append("[DEBUG] Updater Shell Output: <pre>").append(escapeHtml(result2.toString())).append("</pre><br>");
                             if (debug && errorResult2.length() > 0) {
                                 debugOutputBuilder.append("<font color='#ffcc00'>[DEBUG] Updater Shell Error: <pre>").append(escapeHtml(errorResult2.toString())).append("</pre></font><br>");
                             }

                             if (exitCode2 == 0) {
                                 if (debug) debugOutputBuilder.append("<font color=\"#00ee00\"><b>Request Successfull (Save & Update OK)</b></font><br>");
                                 out.println("<font class=\"message\"><b>Request Successfull</b></font>"); // Show success message on page
                             } else {
                                 if (debug) debugOutputBuilder.append("<font color=\"#ee0000\"><b>Error: Updater process failed (Code: ").append(exitCode2).append(")</b></font><br>");
                                  out.println("<font class=\"message\" style='color:#ee0000;'><b>Updater Failed!</b></font>");
                             }

                         } catch (IOException e) {
                              if (debug) debugOutputBuilder.append("<font color=\"#ff0000\"><br>Error saving XML or executing shell command: ").append(e.getMessage()).append("</font><br>");
                         } catch (InterruptedException e) {
                              if (debug) debugOutputBuilder.append("<font color=\"#ff0000\"><br>Shell process interrupted: ").append(e.getMessage()).append("</font><br>");
                         } finally {
                             try {
                                 if (edited != null) edited.close();
                                 if (fileWriter != null) fileWriter.close(); // Still close fileWriter if bufferedReader failed
                             } catch (IOException e) {
                                  if (debug) debugOutputBuilder.append("<font color=\"#ff0000\"><br>Error closing file writers: ").append(e.getMessage()).append("</font><br>");
                             }
                         }
                     } else { // End if(doc != null) for save block
                          if (debug) debugOutputBuilder.append("<font color=\"#ff0000\"><b>Error: Cannot save data because initial XML parsing failed or was empty.</b></font><br>");
                          error += "<font color=\"#ee0000\"><b>Save failed: Could not read initial character data.</b></font><br>";
                     }
                 } // End save process block ("process=save")

            } // End if (id > 0)
            else {
                 if (debug) debugOutputBuilder.append("Info: No character data loaded as ID was 0 or invalid.<br>");
            }

        } catch (Exception e) {
            // Catch errors during initial data loading or general processing
            error += "<font color=\"#ee0000\"><b>Error: " + escapeHtml(e.getMessage()) + "</b></font>";
            // Log detailed error to debug output if debugging is enabled
            if (debug) {
                StringWriter sw = new StringWriter();
                e.printStackTrace(new PrintWriter(sw));
                debugOutputBuilder.append("<font color=\"#ff0000\"><b>[FATAL ERROR] Exception occurred: ").append(escapeHtml(e.toString()))
                                .append("</b><br><pre>").append(escapeHtml(sw.toString())).append("</pre></font><br>");
            }
        } finally {
            // --- Write Debug Output to File (Only if debug is enabled) ---
            if (debug && logFilePath != null) {
                debugOutputBuilder.append("<br>--- Request End: ").append(sdf.format(new Date())).append(" ---");
                try {
                    // Open in append mode (true)
                    logWriter = new PrintWriter(new BufferedWriter(new FileWriter(logFilePath, true)));
                    // Write the web debug output (strip HTML tags for cleaner log file)
                    String logContent = debugOutputBuilder.toString().replaceAll("<br>", "\n").replaceAll("<[^>]*>", ""); // Basic tag stripping
                    logWriter.println(logContent);
                    logWriter.println("--------------------------------------------------------------"); // Separator
                    logWriter.flush();
                } catch (IOException logEx) {
                    // If file logging fails, add note to web output (still check debug flag)
                     debugOutputBuilder.append("<font color='#ffcc00'><br><b>Warning: Failed to write to log file '")
                                     .append(logFilePath).append("': ").append(logEx.getMessage()).append("</b></font>");
                } finally {
                    if (logWriter != null) {
                        logWriter.close();
                    }
                }
            }
             // --- End Write Debug Output to File ---
        }
        // --- END SCRIPTLET ---
    %>
    <div id="item-details" class="item-details"></div>

    <%-- Display form only if data was loaded --%>
    <% if (doc != null) { %>
        <center><br><br><button class="button is-info is-small">Save</button></center>
    </form> <%-- Closing the form started before the tables --%>
    <% } %>

    <%-- Display error messages accumulated --%>
    <% if (!error.isEmpty()) { %>
        <div style="color: #ee0000; text-align: center; margin-top: 15px;"><%= error %></div>
    <% } %>
     <% if (!message.isEmpty()) { %>
        <div style="text-align: center; margin-top: 15px;"><%= message %></div>
     <% } %>


    <%-- The debug output box (Only display if debug is enabled) --%>
    <% if (debug) { %>
        <div class="box mt-5 debug-output"><%= debugOutputBuilder.toString() %></div>
    <% } %>

</body>
</html>