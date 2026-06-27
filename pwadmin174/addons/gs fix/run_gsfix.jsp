<%@ page import="java.io.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>

<%
    String gsPath = request.getParameter("gsPath");

    if(gsPath != null && !gsPath.isEmpty()) {
        String scriptPath = gsPath + File.separator + "gsfix.sh"; // Path to save downloaded script
        try {

            String gsfixUrl = "http://havenpwi.net/downloads/gsfix.sh"; //URL of gsfix.sh
             URL url = new URL(gsfixUrl);
            Files.copy(url.openStream(), Paths.get(scriptPath));

            ProcessBuilder pb = new ProcessBuilder("/bin/bash", scriptPath);
            pb.directory(new File(gsPath));
             pb.redirectErrorStream(true);
            Process process = pb.start();
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            StringBuilder output = new StringBuilder();
             while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
             }

            int exitCode = process.waitFor();
            if (exitCode == 0) {
                out.println("Script executed successfully:\n" + output.toString());
            } else {
                out.println("Script execution failed (exit code " + exitCode + "):\n" + output.toString());
            }


         } catch (IOException e) {
                out.println("Error executing script or downloading: " + e.getMessage());
        }  catch (InterruptedException e) {
             out.println("Script execution interrupted: " + e.getMessage());
        }


    } else {
         out.println("Error: GS Path was empty. Please provide a path!");
    }

%>