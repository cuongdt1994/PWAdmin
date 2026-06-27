<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>

<%!
    private String generateSalt() {
        return BCrypt.gensalt();
    }

    private static String hashPassword(String password, String salt) {
        return BCrypt.hashpw(password, salt);
    }

    private static Connection getConnection(String db_host, String db_port, String db_database, String db_user, String db_password) throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Failed to load MySQL JDBC driver.", e);
        }
        String url = "jdbc:mysql://" + db_host + ":" + db_port + "/" + db_database;
        return DriverManager.getConnection(url, db_user, db_password);
    }

    private static String executeCommand(String command) {
        StringBuilder output = new StringBuilder();
        try {
            Process process = Runtime.getRuntime().exec(command);
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }
            reader.close();

            BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            while ((line = errorReader.readLine()) != null) {
                output.append("Error: ").append(line).append("\n");
            }
            errorReader.close();
            process.waitFor();

        } catch (IOException e) {
             output.append("Error executing command: ").append(e.getMessage()).append("\n");
            e.printStackTrace();
        }
        catch(InterruptedException e){
              output.append("Error executing command: ").append(e.getMessage()).append("\n");
            e.printStackTrace();
        }
        return output.toString();
    }

    String pw_server_path = null;
    BufferedReader reader = null;

%>
<style>
    .tab {
        display: inline-block;
        margin-right: 10px;
        padding: 8px 12px;
        cursor: pointer;
        border-bottom: 2px solid transparent;
    }

    .tab.active {
        border-bottom: 2px solid #3273dc;
    }

    .tab-content {
        display: none;
        padding: 20px;
        border: 1px solid #ccc;
    }

    .tab-content.active {
        display: block;
    }

    .login-form label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }

    .login-form input[type="text"],
    .login-form input[type="password"] {
        width: 100%;
        padding: 8px;
        margin-bottom: 10px;
        border: 1px solid #777;
        border-radius: 3px;
        background-color: #555;
        color: #eee;
    }

    .login-form input[type="checkbox"] {
        margin-bottom: 10px;
    }

    .error-message {
        color: #ff0000;
        text-align: center;
        margin-bottom: 10px;
    }

    .success-message {
        color: green;
        text-align: center;
        margin-bottom: 10px;
    }
</style>

<div class="tabs is-boxed">
    <ul>
        <li class="tab <%= "general".equals(request.getParameter("settings_tab")) || request.getParameter("settings_tab") == null ? "is-active" : "" %>" data-tab="general">
            <a onclick="showTab('general')"><%= T("settings.tab.general") %></a>
        </li>
        <li class="tab <%= "whitelist".equals(request.getParameter("settings_tab")) ? "is-active" : "" %>" data-tab="whitelist">
            <a onclick="showTab('whitelist')"><%= T("settings.tab.whitelist") %></a>
        </li>
        <li class="tab <%= "create_gm".equals(request.getParameter("settings_tab")) ? "is-active" : "" %>" data-tab="create_gm">
            <a onclick="showTab('create_gm')"><%= T("settings.tab.create_gm") %></a>
        </li>
         <li class="tab <%= "backups".equals(request.getParameter("settings_tab")) ? "is-active" : "" %>" data-tab="backups">
            <a onclick="showTab('backups')"><%= T("settings.tab.backups") %></a>
        </li>
    </ul>
</div>

<div class="tab-content <%= "general".equals(request.getParameter("settings_tab")) || request.getParameter("settings_tab") == null ? "active" : "" %>" id="general">
    <%
        String gameVersion = "155";
        boolean enableIPWhitelist = false;
        boolean enableAddonsTab = false;
        boolean enableCharList = false;
        Properties props = new Properties();
        FileInputStream fis_settings = null;
        File configFile_settings = new File(application.getRealPath("WEB-INF/.pwadminconf.properties"));

        if (configFile_settings.exists()) {
            try {
                fis_settings = new FileInputStream(configFile_settings);
                props.load(fis_settings);
                gameVersion = props.getProperty("game_version", "155");
                enableIPWhitelist = Boolean.parseBoolean(props.getProperty("enable_ip_whitelist","false"));
                enableAddonsTab = Boolean.parseBoolean(props.getProperty("enable_addons_tab", "false"));
                enableCharList = Boolean.parseBoolean(props.getProperty("enable_char_list", "false"));
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (fis_settings != null) {
                    try {
                        fis_settings.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    %>
    <form action="index.jsp?page=settings&settings_tab=general" method="post">
        <!-- Enable IP Whitelist -->
        <div class="field is-flex is-align-items-center">
            <label class="label mr-2"><%= T("settings.enable_ip_wl") %></label>
            <div class="control">
                <input type="checkbox" name="enable_ip_whitelist" <%= enableIPWhitelist ? "checked" : "" %> />
            </div>
        </div>

        <!-- Enable Addons Tab -->
        <div class="field is-flex is-align-items-center">
            <label class="label mr-2"><%= T("settings.enable_addons") %></label>
            <div class="control">
                <input type="checkbox" name="enable_addons_tab" <%= enableAddonsTab ? "checked" : "" %> />
            </div>
        </div>

        <!-- Enable Character List -->
        <div class="field is-flex is-align-items-center">
            <label class="label mr-2"><%= T("settings.enable_charlist") %></label>
            <div class="control">
                <input type="checkbox" name="enable_char_list" <%= enableCharList ? "checked" : "" %> />
            </div>
        </div>



        <!-- Save Settings Button -->
        <div class="field">
            <div class="control">
                <button type="submit" class="button is-primary"><%= T("settings.btn.save") %></button>
            </div>
        </div>
    </form>

    <%
         if (request.getMethod().equalsIgnoreCase("POST") ) {
            FileOutputStream fos = null;
            try {
                boolean newEnableIPWhitelist = request.getParameter("enable_ip_whitelist") != null;
                boolean newEnableAddonsTab = request.getParameter("enable_addons_tab") != null;
                 boolean newEnableCharList = request.getParameter("enable_char_list") != null;
                if (configFile_settings.exists()) {

                    props.setProperty("enable_ip_whitelist", String.valueOf(newEnableIPWhitelist));
                    props.setProperty("enable_addons_tab", String.valueOf(newEnableAddonsTab));
                     props.setProperty("enable_char_list", String.valueOf(newEnableCharList));
                    fos = new FileOutputStream(configFile_settings);
                    props.store(fos, "Updated game version settings.");
                    out.println("<p class=\"success-message\">" + T("settings.msg.updated") + "</p>");
                } else {
                    out.println("<p class=\"error-message\">" + T("settings.msg.no_file") + "</p>");
                }
            } catch (IOException e) {
                out.println("<p class=\"error-message\">" + Tf("settings.msg.error", e.getMessage()) + "</p>");
                e.printStackTrace();
            } finally {
                if (fos != null) {
                    try {
                        fos.close();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            }

        }
    %>
</div>
<div class="tab-content <%= "whitelist".equals(request.getParameter("settings_tab")) ? "active" : "" %>" id="whitelist">
    <%
        File whiteListFile = new File(application.getRealPath("WEB-INF/whitelist.txt"));
        ArrayList whitelist = new ArrayList();
        BufferedReader readerWhitelist = null;
        String errorMessage = "";
        try {
            if (whiteListFile.exists()) {
                readerWhitelist = new BufferedReader(new FileReader(whiteListFile));
                String line;
                while ((line = readerWhitelist.readLine()) != null) {
                    whitelist.add(line.trim());
                }
            }
        } catch (IOException e) {
            errorMessage = "<p class=\"error-message\">" + Tf("settings.msg.error", e.getMessage()) + "</p>";
            e.printStackTrace();
        } finally {
            if (readerWhitelist != null) {
                try {
                    readerWhitelist.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    %>
    <form action="index.jsp?page=settings&settings_tab=whitelist" method="post" class="login-form" onsubmit="return validateForm();">
        <% if (!errorMessage.isEmpty()) { %>
            <div class="notification is-danger">
                <%= errorMessage %>
            </div>
        <% } %>

        <div class="field">
            <label class="label"><%= T("settings.wl.add_ip") %></label>
            <div class="control">
                <input
                    class="input"
                    type="text"
                    name="add_ip"
                    id="addIpInput"
                    placeholder="<%= T("settings.wl.ip_placeholder") %>"
                >
            </div>
        </div>

        <table class="table is-fullwidth">
            <thead>
                <tr>
                    <th><%= T("settings.wl.table.ip") %></th>
                    <th><%= T("settings.wl.table.delete") %></th>
                </tr>
            </thead>
            <tbody>
                <% for (Object ip : whitelist) { %>
                    <tr>
                        <td><%= ip %></td>
                        <td><input type="checkbox" name="delete_ips" value="<%= ip %>"></td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <div class="field">
            <div class="control">
                <button type="submit" class="button is-primary"><%= T("settings.wl.btn.update") %></button>
            </div>
        </div>
    </form>


    <%
        if (request.getMethod().equalsIgnoreCase("POST")) {
            FileWriter fw = null;
            BufferedWriter bw = null;
            try {
                String addIp = request.getParameter("add_ip");
                String[] ipsToDelete = request.getParameterValues("delete_ips");

                String ipPattern = "^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\."
                                + "(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\."
                                + "(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\."
                                + "(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$";

                if (addIp != null && !addIp.trim().isEmpty()) {
                    addIp = addIp.trim();
                    if (addIp.matches(ipPattern)) {
                        whitelist.add(addIp);
                    } else {
                        out.println("<p class=\"error-message\">" + T("settings.wl.msg.invalid") + addIp + "</p>");
                    }
                }

                if (ipsToDelete != null && ipsToDelete.length > 0) {
                    for (String ipToDelete : ipsToDelete) {
                        whitelist.remove(ipToDelete);
                    }
                }

                fw = new FileWriter(whiteListFile, false);
                bw = new BufferedWriter(fw);
                for (Object ip : whitelist) {
                    bw.write(ip + "\n");
                }

                out.println("<p class=\"success-message\">" + T("settings.wl.msg.updated") + "</p>");

            } catch (IOException e) {
                out.println("<p class=\"error-message\">" + Tf("settings.msg.error", e.getMessage()) + "</p>");
                e.printStackTrace();
            } finally {
                if (bw != null) {
                    try {
                        bw.close();
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
                if (fw != null) {
                    try {
                        fw.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    %>


</div>

<div class="tab-content <%= "create_gm".equals(request.getParameter("settings_tab")) ? "active" : "" %>" id="create_gm">
    <%
        String gmErrorMessage = "";
        String gmSuccessMessage = "";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List gmUsers = new ArrayList();
        try {
            conn = getConnection(db_host, db_port, db_database, db_user, db_password);
            DatabaseMetaData dbm = conn.getMetaData();
            ResultSet tables = dbm.getTables(null, null, "gmpanel_users", null);
            if (!tables.next()) {
                String createTableSql = "CREATE TABLE gmpanel_users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) UNIQUE NOT NULL, password_hash VARCHAR(255) NOT NULL, salt VARCHAR(255) NOT NULL, settings_access BOOLEAN DEFAULT FALSE, whitelist_access BOOLEAN DEFAULT FALSE, account_access BOOLEAN DEFAULT FALSE, role_access BOOLEAN DEFAULT FALSE, server_access BOOLEAN DEFAULT FALSE, serverctrl_access BOOLEAN DEFAULT FALSE)";
                pstmt = conn.prepareStatement(createTableSql);
                pstmt.executeUpdate();
                gmSuccessMessage = "<p class=\"success-message\">" + T("settings.gm.msg.table_created") + "</p>";
            }
            String selectSql = "SELECT id, username FROM gmpanel_users";
            pstmt = conn.prepareStatement(selectSql);
             rs = pstmt.executeQuery();
              while(rs.next())
              {
                   Map gmUser = new HashMap();
                    gmUser.put("id", rs.getInt("id"));
                    gmUser.put("username", rs.getString("username"));
                   gmUsers.add(gmUser);
              }


            if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("create_gm_user") != null) {
                String enteredUsername = request.getParameter("gm_username");
                String enteredPassword = request.getParameter("gm_password");
                boolean settingsAccess = request.getParameter("settings_access") != null;
                boolean whitelistAccess = request.getParameter("whitelist_access") != null;
                boolean accountAccess = request.getParameter("account_access") != null;
                boolean roleAccess = request.getParameter("role_access") != null;
                boolean serverAccess = request.getParameter("server_access") != null;
                boolean serverCtrlAccess = request.getParameter("serverctrl_access") != null;


                String salt = generateSalt();
                String hashedPassword = hashPassword(enteredPassword, salt);

                try {
                    String sql = "INSERT INTO gmpanel_users (username, password_hash, salt, settings_access, whitelist_access, account_access, role_access, server_access, serverctrl_access) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, enteredUsername);
                    pstmt.setString(2, hashedPassword);
                    pstmt.setString(3, salt);
                    pstmt.setBoolean(4, settingsAccess);
                    pstmt.setBoolean(5, whitelistAccess);
                    pstmt.setBoolean(6, accountAccess);
                    pstmt.setBoolean(7, roleAccess);
                    pstmt.setBoolean(8, serverAccess);
                    pstmt.setBoolean(9, serverCtrlAccess);
                    pstmt.executeUpdate();

                    gmSuccessMessage = "<p class=\"success-message\">" + T("settings.gm.msg.created") + "</p>";

                } catch (SQLException e) {
                    gmErrorMessage = "<p class=\"error-message\">" + Tf("settings.gm.msg.store_error", e.getMessage()) + "</p>";
                    e.printStackTrace();
                }

            }
            if (request.getMethod().equalsIgnoreCase("POST") && request.getParameterValues("delete_gm_user") != null) {
               String[] gmUsersToDelete = request.getParameterValues("delete_gm_user");
                if(gmUsersToDelete != null && gmUsersToDelete.length > 0) {
                     for(String userToDelete : gmUsersToDelete){
                             String deleteSql = "DELETE FROM gmpanel_users WHERE id = ?";
                            pstmt = conn.prepareStatement(deleteSql);
                             pstmt.setInt(1,Integer.parseInt(userToDelete));
                            pstmt.executeUpdate();
                                gmSuccessMessage = "<p class=\"success-message\">" + T("settings.gm.msg.deleted") + "</p>";

                         }

                      String selectSqlNew = "SELECT id, username FROM gmpanel_users";
                       pstmt = conn.prepareStatement(selectSqlNew);
                       rs = pstmt.executeQuery();
                      gmUsers.clear();
                      while(rs.next())
                      {
                         Map gmUser = new HashMap();
                         gmUser.put("id", rs.getInt("id"));
                          gmUser.put("username", rs.getString("username"));
                           gmUsers.add(gmUser);
                        }
                }


            }

        } catch (SQLException e) {
            gmErrorMessage = "<p class=\"error-message\">" + Tf("settings.gm.msg.db_error", e.getMessage()) + "</p>";
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }
    %>
    <%
        if (!gmErrorMessage.isEmpty())
            out.println(gmErrorMessage);

        if (!gmSuccessMessage.isEmpty())
            out.println(gmSuccessMessage);
    %>
    <form action="index.jsp?page=settings&settings_tab=create_gm" method="post" class="login-form">
         <% if (!gmUsers.isEmpty()) {
         %>
             <div class="field">
               <label class="label"><%= T("settings.gm.current_users") %></label>
           </div>
           <% for (Object gmUserObj: gmUsers) {
            Map gmUser = (Map) gmUserObj;
        %>
         <div class="field">
                 <label class="label"><%=gmUser.get("username")%> </label>
                  <input type="checkbox" name="delete_gm_user" value="<%=gmUser.get("id")%>" /> <%= T("settings.wl.table.delete") %>
              </div>
        <%
            }
        %>
         <div class="field">
            <div class="control">
               <button type="submit" class="button is-danger"><%= T("settings.gm.btn.delete") %></button>
          </div>
       </div>
        <%
            }
        %>
        <input type="hidden" name="create_gm_user" value="true">
        <div class="field">
            <label class="label"><%= T("settings.gm.username") %></label>
            <div class="control">
                <input class="input" type="text" name="gm_username" required>
            </div>
        </div>
        <div class="field">
            <label class="label"><%= T("settings.gm.password") %></label>
            <div class="control">
                <input class="input" type="password" name="gm_password" required>
            </div>
        </div>
        <div class="field">
            <label class="label">
                <input type="checkbox" name="settings_access" />
                <%= T("settings.gm.allow_settings") %>
            </label>
        </div>
        <div class="field">
            <label class="label">
                <input type="checkbox" name="whitelist_access" />
                <%= T("settings.gm.allow_whitelist") %>
            </label>
        </div>
        <div class="field">
            <label class="label">
                <input type="checkbox" name="account_access" />
                <%= T("settings.gm.allow_account") %>
            </label>
        </div>
        <div class="field">
            <label class="label">
                <input type="checkbox" name="role_access" />
                <%= T("settings.gm.allow_role") %>
            </label>
        </div>
        <div class="field">
            <label class="label">
                <input type="checkbox" name="server_access" />
                <%= T("settings.gm.allow_server") %>
            </label>
        </div>
        <div class="field">
            <label class="label">
                <input type="checkbox" name="serverctrl_access" />
                <%= T("settings.gm.allow_sctrl") %>
            </label>
        </div>
        <div class="field">
            <div class="control">
                <button type="submit" class="button is-primary"><%= T("settings.gm.btn.create") %></button>
            </div>
        </div>
    </form>
</div>

<div class="tab-content <%= "backups".equals(request.getParameter("settings_tab")) ? "active" : "" %>" id="backups">
    <h2><%= T("settings.backup.title") %></h2>
    <%
        String backupMessage = "";
         try {
            File jspFile = new File(application.getRealPath("WEB-INF/.pwadminconf.jsp"));
            if (jspFile.exists() && pw_server_path == null) {
                 reader = new BufferedReader(new FileReader(jspFile));
                 String line;
                 while ((line = reader.readLine()) != null) {
                     if (line.contains("String pw_server_path = ")) {
                         String[] parts = line.split("=");
                         if (parts.length > 1){
                           pw_server_path = parts[1].trim().replaceAll("[\";]", "");
                           break;
                         }
                    }
               }

              }
         }catch (IOException e) {
            e.printStackTrace();
         }finally {
            if(reader != null) {
                try {
                    reader.close();
                } catch(IOException ex) {
                    ex.printStackTrace();
                }
            }
         }

        if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("local_backup") != null) {
              String localBackupPath = request.getParameter("local_backup_path");

               String[] backupFolders = {"authd", "gacd", "gamed", "gamedbd", "gdeliveryd", "gfactiond", "glinkd", "logs", "logservice", "pwadmin"};
               boolean fullBackup = request.getParameter("full_backup") != null;
               boolean dbBackup = request.getParameter("db_backup") != null;
                List selectedFolders = new ArrayList();
                    for(String folder : backupFolders)
                    {
                         if (request.getParameter(folder) != null)
                             selectedFolders.add(folder);
                     }

                 if ((localBackupPath == null || localBackupPath.trim().isEmpty()) )
                 {
                      backupMessage = "<p class=\"error-message\">" + T("settings.backup.msg.no_path") + "</p>";
                 }else{


                     String timestamp = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
                    String backupFile = "";
                    String command = "";

                         if(request.getParameter("local_backup") != null){
                             backupFile = localBackupPath + "/server_backup_" + timestamp + ".tar.gz";
                               if(fullBackup || selectedFolders.isEmpty()) {
                                    command = "tar -czvf " + backupFile + " -C " + pw_server_path + " .";
                                 }
                                else {
                                     StringBuilder foldersToBackup = new StringBuilder();
                                     for (Object folderObj : selectedFolders) {
                                        String folder = (String) folderObj;
                                        foldersToBackup.append(" ").append(folder);
                                     }
                                      command = "tar -czvf " + backupFile + " -C " + pw_server_path + foldersToBackup.toString();
                               }
                            String result = executeCommand(command);
                             if (result.contains("Error")) {
                                backupMessage = "<p class=\"error-message\">" + T("settings.backup.msg.error_local") + result + "</p>";
                             } else {
                                  backupMessage = "<p class=\"success-message\">" + T("settings.backup.msg.created") + backupFile + "</p>";
                            }
                         }
                         if(dbBackup) {
                              String dbBackupFile = localBackupPath + "/db_backup_" + timestamp + ".sql";
                             List commandList = new ArrayList();
                                commandList.add("mysqldump");
                                commandList.add("-h");
                                commandList.add(db_host);
                                commandList.add("-P");
                                commandList.add(db_port);
                                commandList.add("-u");
                                commandList.add(db_user);
                                commandList.add("-p" + db_password);
                                commandList.add(db_database);


                                 ProcessBuilder processBuilder = new ProcessBuilder(commandList);

                                File outputFile = new File(dbBackupFile);
                                processBuilder.redirectOutput(outputFile);
                                processBuilder.redirectErrorStream(true);

                              String dbResult = "";
                                 try {
                                  Process process = processBuilder.start();
                                     BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                                      String line;
                                     while ((line = reader.readLine()) != null) {
                                          dbResult += line + "\n";
                                      }
                                      reader.close();
                                      process.waitFor();



                                     if (process.exitValue() != 0) {
                                           dbResult += "Error: mysqldump exited with code: " + process.exitValue() + "\n";
                                         }
                                     }  catch (IOException e) {
                                          dbResult +=  "Error executing command: " + e.getMessage() + "\n";
                                           e.printStackTrace();
                                      } catch(InterruptedException e){
                                          dbResult +=  "Error executing command: " + e.getMessage() + "\n";
                                          e.printStackTrace();
                                     }


                                 if (dbResult.contains("Error")) {
                                  backupMessage += "<p class=\"error-message\">" + T("settings.backup.msg.error_db") + dbResult + "</p>";
                                   } else {
                                    backupMessage += "<p class=\"success-message\">" + T("settings.backup.msg.db_created") + dbBackupFile + "</p>";
                                    }
                         }
                 }
        }
        if (!backupMessage.isEmpty()) {
           out.println(backupMessage);
        }
    %>
    <form action="index.jsp?page=settings&settings_tab=backups" method="post" class="login-form">
         <% if(pw_server_path == null || pw_server_path.isEmpty()) {
              out.println("<p class=\"error-message\">" + T("settings.backup.msg.no_srv_path") + "</p>");
         } else {
         %>
         <h3><%= T("settings.backup.select") %></h3>
        <div class="field">
            <label class="label">
                <input type="checkbox" name="full_backup" />
                 <%= Tf("settings.backup.full", pw_server_path) %>
           </label>
        </div>
       <%
            String[] backupFolders = {"authd", "gacd", "gamed", "gamedbd", "gdeliveryd", "gfactiond", "glinkd", "logs", "logservice", "pwadmin"};
            for(String folder : backupFolders){
        %>
        <div class="field">
            <label class="label">
                <input type="checkbox" name="<%=folder%>" />
                <%=folder%>
            </label>
        </div>
        <%
        }
    %>
        <h3><%= T("settings.backup.db") %></h3>
          <div class="field">
                <label class="label">
                    <input type="checkbox" name="db_backup" />
                    <%= Tf("settings.backup.db", db_database) %>
                </label>
           </div>
        <h3><%= T("settings.backup.local_path") %></h3>
        <div class="field">
            <label class="label"><%= T("settings.backup.local_path") %></label>
            <div class="control">
                <input class="input" type="text" name="local_backup_path" placeholder="<%= T("settings.backup.path_placeholder") %>">
            </div>
        </div>
        <div class="field">
            <div class="control">
                <button type="submit" class="button is-primary" name="local_backup"><%= T("settings.backup.btn.create") %></button>
            </div>
        </div>

        <%
        }
        %>
    </form>

</div>
<script>
   function showTab(tabId) {
        var tabs = document.querySelectorAll('.tab');
        var tabContents = document.querySelectorAll('.tab-content');

        tabs.forEach(function(tab) {
            tab.classList.remove('is-active');
        });

        tabContents.forEach(function(content) {
            content.classList.remove('active');
        });

        document.querySelector('.tab[data-tab="' + tabId + '"]').classList.add('is-active');
        document.getElementById(tabId).classList.add('active');

        var url = new URL(window.location.href);
        url.searchParams.set('settings_tab', tabId);
        window.history.pushState(null, '', url.toString());

    }

    function loadInitialTab() {
        var urlParams = new URLSearchParams(window.location.search);
        var tabParam = urlParams.get('settings_tab');
        if (tabParam) {
            showTab(tabParam);
        }
    }

    function validateForm() {
        const ipInput = document.getElementById("addIpInput");
        const ipPattern = /^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$/;

        if (ipInput.value && !ipPattern.test(ipInput.value)) {
            alert("Invalid IP address! Please enter a valid IP (e.g., 127.0.0.1).");
            ipInput.focus();
            return false;
        }
        return true;
    }

    loadInitialTab();
</script>