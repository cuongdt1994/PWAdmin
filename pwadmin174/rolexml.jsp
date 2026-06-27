<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="protocol.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Arrays" %>
<%@page import="javax.xml.parsers.*"%>
<%@page import="javax.xml.transform.*" %>
<%@page import="javax.xml.transform.stream.StreamResult" %>
<%@page import="javax.xml.transform.dom.DOMSource"%>
<%@page import="org.jsoup.*"%>
<%@page import="org.jsoup.nodes.*"%>
<%@page import="org.w3c.dom.*"%>
<%@page import="org.xml.sax.InputSource" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<style>
    body, html {
        margin: 0;
        padding: 0;
        width: 100%;
        height: 100%;
        background-color: #121212;
        color: white; /* Set default text color to white */
    }
	#mainContent{
         padding: 2rem 1rem;
         width: 100%;
         height: 100%;
         
    }
     .container {
         width: 100%;
         height: 100%;
           
        }
    h1.title {
        color: white; /* Set title color to white */
    }
    .textarea-td{
         
         
        
    }
    .xml-textarea{
          width: 100%;
            min-height: 400px;
             background-color: #222222;
            color: white;
              border: 1px solid #525452;
             padding: 8px;
            box-sizing: border-box;
            font-size: 0.9rem;
            font-family: monospace;
           
    }

     .save-button-td{
            margin: 10px auto;
          
            text-align: center;
            
        }
       .save-button-td button{
           margin: 10px auto;
       }
    
    table {
        border-collapse: collapse;
        width: 100%;
        margin-bottom: 15px;
    }
	
    table, th, td {
       
        padding: 8px;
          border: 1px solid #525452;
        
       
    }
   .message-box-tr td{
        color: white;
        text-align: center;
    }
        .debug-output {
            background-color: #333333;
            color: #ffffff;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .debug-output pre {
            white-space: pre-wrap;
            color: #ffffff;
            margin: 0;
            font-size: 0.8rem;
        }
          input[type="text"]{
           background-color: #222222;
           color: white;
           border: 1px solid #525452;
           padding: 5px;
              width: 150px;
          }
         select{
           background-color: #222222;
           color: white;
           border: 1px solid #525452;
           padding: 5px;
          }
      
        
         
    
</style>

<%
	String message = "<br>";
	boolean allowed = false;
    String debugOutput = ""; // For accumulating debugging info
	//Check Login session
	if(request.getSession().getAttribute("ssid") == null)
	{
		out.println("<p align=\"right\" class=\"has-text-right has-text-danger\"><b>Login for Character administration...</b></p>");
	}
	else
	{
		allowed = true;
	}

				int id=0 ;
				String rolelist = "";
        
        String xml = "";
            if(allowed){ //IF1
             if (request.getParameter("process") != null && request.getParameter("process").compareTo("save") == 0) { // Check if the "ident" parameter is provided
             // save data
             try {
                 String filePath = "";
                 xml = request.getParameter("xml");
                 id = Integer.parseInt(request.getParameter("ident")); // Parse the ID from the parameter
                 debugOutput += "<br>Debug: Loading Character ID = " + id; // Log the loaded ID
             
                 // **XML Modification** - Delete reserved1 to reserved10
                 DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                 DocumentBuilder builder = factory.newDocumentBuilder();
                 InputSource is = new InputSource(new StringReader(xml));
                 
                 //debugOutput += "<br>Debug: Parsing XML = " + xml; // Log the XML being parsed
                 
                 Document doc = builder.parse(is);  // Parsing XML
                 
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
                 transformer.setOutputProperty(OutputKeys.INDENT, "yes");
                 transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");  // Menggunakan 4 spasi sesuai permintaan Anda
             
                 DOMSource source = new DOMSource(doc);
                 StringWriter writer = new StringWriter();
                 StreamResult resultOutput = new StreamResult(writer);
                 transformer.transform(source, resultOutput);
             
                 // Retrieve the modified XML results
                 String updatedXml = writer.toString();
             
                 // Delete space 
                 updatedXml = updatedXml.replaceAll("(?m)^[ \t]+", "");
             
                 // Xml Path
                 filePath = pw_server_path + "gamedbd/temp.xml"; 
             
                 // Create object FileWriter dan BufferedWriter
                 FileWriter fileWriter = new FileWriter(filePath);
                 BufferedWriter edited = new BufferedWriter(fileWriter);
             
                 // Write modified xml to file
                 edited.write(updatedXml);
                 //debugOutput += "<font color=\"#00cc00\"><br>Debug: edited XML saved to = " + filePath + "</font>";
             
                 // close process
                 edited.close();
             
                 // Path
                 File workingDir = new File(pw_admin_path);
                 debugOutput += "<br>Debug: Working Directory = " + workingDir.getAbsolutePath();
             
                 // command
                 String command = "./updater "+ pw_server_path +"gamedbd";								
                 debugOutput += "<br>Debug: Command = " + command; // Log the command
         
                 // Initialize ProcessBuilder
                 ProcessBuilder processBuilder = new ProcessBuilder("/bin/bash", "-c", command);
                 processBuilder.directory(workingDir); // Set the working directory for the process
         
                 // Initialize result containers
                 StringBuilder result = new StringBuilder();
                 StringBuilder errorResult = new StringBuilder();
         
                 // Start the process
                 Process process = processBuilder.start();
         
                 // Read output and error streams
                 BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                 BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
         
                 String line;
                 while ((line = reader.readLine()) != null) {
                     result.append(line).append("\n");
                 }
                 while ((line = errorReader.readLine()) != null) {
                     errorResult.append(line).append("\n");
                     xml=errorResult.toString();
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
                     message = "<font color=\"#00ee00\"><b>Xml imported successfully</b></font>"; // Request succeed  ,display no message
                 }                                 
                 xml = result.toString(); // Save the result
             
             } catch (NumberFormatException e) {
                 debugOutput += "<font color=\"#ee0000\"><br>Debug: Invalid ID.</font>";
                 message = "<font color=\"#ee0000\"><b>Invalid ID</b></font>";
             } catch (IOException e) {
                 debugOutput += "<font color=\"#ee0000\"><br>Debug: IOException occurred = " + e.getMessage() + "</font>";
                 message = "<font color=\"#ee0000\"><b>Process execution failed</b></font>";
             } catch (InterruptedException e) {
                 debugOutput += "<br>Debug: Process was interrupted = " + e.getMessage();
                 message = "<font color=\"#ee0000\"><b>Process was interrupted</b></font>";
             } catch (Exception e) {
                debugOutput += "<font color=\"#ee0000\"><br>Debug: Unexpected error occurred = " + e.getMessage() + "</font>";
                debugOutput += "<br>Stacktrace: " + Arrays.toString(e.getStackTrace());  // Log stacktrace
                message = "<font color=\"#ee0000\"><b>An unexpected error occurred.</b></font>";
             }                                    
            } else {
                // read data
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
                    StringBuilder errorResult = new StringBuilder();
            
                    // Start the process
                    Process process = processBuilder.start();
            
                    // Read output and error streams
                    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                    BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            
                    String line;
                    while ((line = reader.readLine()) != null) {
                        result.append(line).append("\n");
                    }
                    while ((line = errorReader.readLine()) != null) {
                        errorResult.append(line).append("\n");
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
            
                } catch (NumberFormatException e) { // Catch invalid ID format
                    debugOutput += "<br>Debug: Invalid ID."; // Log invalid ID format
                    message = "<font color=\"#ee0000\"><b>Invalid ID</b></font>"; // Display error message
                } catch (IOException e) { // Handle IO exceptions
                    debugOutput += "<br>Debug: IOException occurred = " + e.getMessage(); // Log IO exception details
                    message = "<font color=\"#ee0000\"><b>Process execution failed</b></font>"; // Display failure message
                } catch (InterruptedException e) { // Handle InterruptedException
                    debugOutput += "<br>Debug: Process was interrupted = " + e.getMessage(); // Log interrupted exception details
                    message = "<font color=\"#ee0000\"><b>Process was interrupted</b></font>"; // Display interruption message
                }	
		
			}
		
		  } else {
				debugOutput += "<br>Debug: ID not found."; // Log the missing parameter
				message = "<font color=\"#ee0000\"><b>Id Not found</b></font>"; // Display missing parameter message
			} //END IF1
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Character XML</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma/css/bulma.min.css">
    <link rel="stylesheet" href="include/custom.css">
</head>

<body >
<div id="mainContent" class="container">		
    <form name="content" action="index.jsp?page=rolexml" method="post" style="margin: 0px;">          
        <div style="text-align: right;"><input name="ident" type="text" value="<% out.print(id); %>"></input> <select name="type" ><option value="id">by ID</option></select> <button class="button is-info is-small">View</button></div>         
    </form>
<br>
<h1 class="title has-text-centered">Character XML</h1>
<br>    
<table width="800" style="table-layout: fixed; width: 100%;" cellpadding="0" cellspacing="0" border="0">	
	<tr>
		<th height="1" align="left" valign="middle" style="padding: 5px;">
			<font color="white" size="+1"><b>
			<%
				out.print("Character ID: " + id);
			%>
			</b></font>
		</th>
	</tr>

	<tr class="message-box-tr" >
		<td colspan="3" align="center" >
			<%= message %>
		</td>
	</tr>
	
	<form name="update" action="index.jsp?page=rolexml&ident=<%out.print(id);%>&process=save" method="post" style="margin: 0px;">

	<tr>
		<td colspan="3" align="left" valign="top" class="textarea-td">
			<textarea name="xml" rows="24" class="xml-textarea"><%out.print(StringEscapeUtils.escapeHtml(xml));%></textarea>
		</td>
	</tr>
	<%
		if(allowed)
		{
			out.println("<tr>");
				out.println("<td colspan=\"3\" align=\"center\" class=\"save-button-td\"><button class=\"button is-info is-small\">Save XML</button></td>");
			out.println("</tr>");
		}
	%>
	</form>
	</tr>
</table>
<!--<div class="box mt-5 debug-output"><%=debugOutput%></div>-->
</div>
</body>
</html>