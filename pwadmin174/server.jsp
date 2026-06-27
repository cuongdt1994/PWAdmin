<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="protocol.*"%>
<%@page import="com.goldhuman.auth.*"%>
<%@page import="com.goldhuman.service.*"%>
<%@page import="com.goldhuman.util.*"%>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>

<%
    String confFilePath = pw_server_path + "/gamed/gs.conf";
    String message = "";
    String traceLog = "";
    String baseValueString = "Base Value is: 0";
    int version = 173;
    // Rates
    int exp_rate = 0;
    int sp_rate = 0;
    int drop_rate = 0;
    int coins_rate = 0;
    int task_exp_rate = 0;
    int task_sp_rate = 0;
    int task_coins_rate = 0;
    boolean inWallowHeavy = false;

    // Load rates from the configuration file
    try {
        traceLog += "Starting load process.<br>";
        File file = new File(confFilePath);
        traceLog += "File object created: " + file.getAbsolutePath() + "<br>";

        Scanner scanner = new Scanner(file);
        traceLog += "Scanner created.<br>";

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine().trim();

            if (line.startsWith("[") && line.endsWith("]")) {
                inWallowHeavy = line.equalsIgnoreCase("[WallowHeavy]");
                continue;
            }


            if (inWallowHeavy) {
                int equalIndex = line.indexOf("=");
                if (equalIndex > 0) {
                    String key = line.substring(0, equalIndex).trim();
                    String value = line.substring(equalIndex + 1).trim();

                    try {
                        int intValue = Integer.parseInt(value);

                        if ("exp".equals(key)) {
                            exp_rate = intValue;
                        } else if ("sp".equals(key)) {
                            sp_rate = intValue;
                        } else if ("item".equals(key)) {
                            drop_rate = intValue;
                        } else if ("money".equals(key)) {
                            coins_rate = intValue;
                        } else if ("task_exp".equals(key)) {
                            task_exp_rate = intValue;
                        } else if ("task_sp".equals(key)) {
                            task_sp_rate = intValue;
                        } else if ("task_money".equals(key)) {
                            task_coins_rate = intValue;
                        }
                    } catch (NumberFormatException e) {
                        traceLog += "Skipping invalid number format in line: " + line + "<br>";
                    }
                }
            }
        }
        scanner.close();
        traceLog += "File scanned.<br>";
    } catch (Exception e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        traceLog += "<font color=\"#ee0000\"><b>" + Tf("server.msg.read_error", e.getMessage()) + "</b></font><br>";
        traceLog += "<font color=\"#ee0000\"><b>Trace Log: " + sw.toString() + "</b></font><br>";
    }

    // Handle form submission
    if (request.getParameter("process") != null) {
        if ("save_rates".equals(request.getParameter("process"))) {


            // Backup gs.conf
              try {
                File confFile = new File(confFilePath);
                File backupFile = new File(confFilePath + ".bak");

                  if(confFile.exists()) {
                      traceLog += "gs.conf exists, attempting to backup.<br>";
                      java.nio.file.Files.copy(confFile.toPath(), backupFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                      traceLog += "gs.conf backed up to " + backupFile.getAbsolutePath() + ".<br>";
                  } else {
                      traceLog += "gs.conf file does not exist, unable to backup.<br>";
                  }
            } catch (Exception e) {
                traceLog += "<font color=\"#ee0000\"><b>Error backing up gs.conf: " + e.getMessage() + "</b></font><br>";
            }


            String newExp = request.getParameter("exp_rate");
            String newDrop = request.getParameter("drop_rate");
            String newMoney = request.getParameter("coins_rate");
            String newSp = request.getParameter("sp_rate");
            String newTaskExp = request.getParameter("task_exp_rate");
            String newTaskSp = request.getParameter("task_sp_rate");
            String newTaskCoins = request.getParameter("task_coins_rate");

            boolean inWallowHeavyWrite = false;
            StringBuilder fileContent = new StringBuilder();

            try {
                traceLog += "Starting save process.<br>";
                File file = new File(confFilePath);
                traceLog += "File object created: " + file.getAbsolutePath() + "<br>";

                Scanner scanner = new Scanner(file);
                traceLog += "StringBuilder created.<br>";

                while (scanner.hasNextLine()) {
                    String line = scanner.nextLine().trim();

                    if (line.startsWith("[") && line.endsWith("]")) {
                        inWallowHeavyWrite = "[WallowHeavy]".equalsIgnoreCase(line);
                        fileContent.append(line).append("\n");
                        continue;
                    }

                    if (inWallowHeavyWrite) {
                        if (line.startsWith("exp")) {
                            fileContent.append("exp = ").append(newExp).append("\n");
                        } else if (line.startsWith("sp")) {
                            fileContent.append("sp = ").append(newSp).append("\n");
                        } else if (line.startsWith("item")) {
                            fileContent.append("item = ").append(newDrop).append("\n");
                        } else if (line.startsWith("money")) {
                            fileContent.append("money = ").append(newMoney).append("\n");
                        } else if (line.startsWith("task_exp")) {
                            fileContent.append("task_exp = ").append(newTaskExp).append("\n");
                        } else if (line.startsWith("task_sp")) {
                            fileContent.append("task_sp = ").append(newTaskSp).append("\n");
                        } else if (line.startsWith("task_money")) {
                            fileContent.append("task_money = ").append(newTaskCoins).append("\n");
                        } else {
                            fileContent.append(line).append("\n");
                        }
                    } else {
                        fileContent.append(line).append("\n");
                    }
                }
                scanner.close();
                traceLog += "File scanned and modifications prepared.<br>";

                BufferedWriter writer = new BufferedWriter(new FileWriter(file));
                traceLog += "BufferedWriter created.<br>";
                writer.write(fileContent.toString());
                writer.close();
                traceLog += "File written.<br>";

                message = "<font color=\"#00cc00\"><b>" + T("server.msg.saved") + "</b></font><br>";
                traceLog += "Save process complete.<br>";
            } catch (Exception e) {
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                e.printStackTrace(pw);
                traceLog += "<font color=\"#ee0000\"><b>" + Tf("server.msg.save_error", e.getMessage()) + "</b></font><br>";
                traceLog += "<font color=\"#ee0000\"><b>Trace Log: " + sw.toString() + "</b></font><br>";
                message = "<font color=\"#ee0000\"><b>" + Tf("server.msg.save_error", e.getMessage()) + "</b></font><br>";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title><%= T("server.title") %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma/css/bulma.min.css">
    <link rel="stylesheet" href="include/custom.css">
     <script>
        function confirmSave() {
            return confirm("<%= T("server.confirm_save") %>");

        }
    </script>
</head>

<body>
    <section class="section">
        <div class="container">

        <!-- Page Selector -->
        <div class="field">
            <div class="control">
              <div class="select">
                <select onchange="
                    var selectedValue = this.value;
                    window.location.href = 'index.jsp?page=server&serverpage=' + selectedValue;
                ">
                  <option value="173" <% if(request.getParameter("serverpage") == null ||request.getParameter("serverpage").equals("173") ) out.print("selected"); %>>173</option>
                  <option value="155" <% if(request.getParameter("serverpage") != null && request.getParameter("serverpage").equals("155")) out.print("selected"); %>>155</option>
                </select>
              </div>
            </div>
          </div>

            <h1 class="title has-text-centered"><%= T("server.title") %></h1>

            <% if (!message.isEmpty()) { %>
                <div class="notification <% out.print(message.contains("Error") ? "is-danger" : "is-success"); %>">
                    <%= message %>
                </div>
            <% } %>

            <!-- Form for server rates -->
            <form action="index.jsp?page=server&process=save_rates" method="post" onsubmit="return confirmSave()">
                <div class="box server-rate-editor-box">

                    <!-- EXP Rate Input -->
                    <div class="field">
                        <label class="label"><%= T("server.exp_rate") %></label>
                        <div class="control">
                            <input class="input server-rate-input" type="number" min="0" max="100" name="exp_rate" value="<%= exp_rate %>">
                        </div>
                        <p class="help server-rate-help"><%= T("server.base_value") %></p>
                    </div>

                    <!-- SP Rate Input -->
                    <div class="field">
                        <label class="label"><%= T("server.sp_rate") %></label>
                        <div class="control">
                            <input class="input server-rate-input" type="number" min="0" max="100" name="sp_rate" value="<%= sp_rate %>">
                        </div>
                        <p class="help server-rate-help"><%= T("server.base_value") %></p>
                    </div>

                    <!-- Item Drop Rate Input -->
                    <div class="field">
                        <label class="label"><%= T("server.drop_rate") %></label>
                        <div class="control">
                            <input class="input server-rate-input" type="number" min="0" max="100" name="drop_rate" value="<%= drop_rate %>">
                        </div>
                        <p class="help server-rate-help"><%= T("server.base_value") %></p>
                    </div>

                    <!-- (Silver) Coins Rate Input -->
                    <div class="field">
                        <label class="label"><%= T("server.coins_rate") %></label>
                        <div class="control">
                            <input class="input server-rate-input" type="number" min="0" max="100" name="coins_rate" value="<%= coins_rate %>">
                        </div>
                        <p class="help server-rate-help"><%= T("server.base_value") %></p>
                    </div>

                    <!-- Task EXP Input-->
                    <div class="field">
                        <label class="label"><%= T("server.task_exp_rate") %></label>
                        <div class="control">
                            <input class="input server-rate-input" type="number" min="0" max="100" name="task_exp_rate" value="<%= task_exp_rate %>">
                        </div>
                        <p class="help server-rate-help"><%= T("server.base_value") %></p>
                    </div>

                    <!-- Task SP Input-->
                    <div class="field">
                        <label class="label"><%= T("server.task_sp_rate") %></label>
                        <div class="control">
                            <input class="input server-rate-input" type="number" min="0" max="100" name="task_sp_rate" value="<%= task_sp_rate %>">
                        </div>
                        <p class="help server-rate-help"><%= T("server.base_value") %></p>
                    </div>

                    <!-- Task Coins Input-->
                    <div class="field">
                        <label class="label"><%= T("server.task_coins_rate") %></label>
                        <div class="control">
                            <input class="input server-rate-input" type="number" min="0" max="100" name="task_coins_rate" value="<%= task_coins_rate %>">
                        </div>
                        <p class="help server-rate-help"><%= T("server.base_value") %></p>
                    </div>

                    <div class="field is-grouped is-grouped-centered">
                        <div class="control">
                            <button type="submit" class="button is-link server-rate-save-button"><%= T("server.btn.save") %></button>

                        </div>
                    </div>
                </div>
            </form>
            <br>
            <!-- Trace Log -->
            <% if (!traceLog.isEmpty()) { %>
            <div class="trace-log-area">
                <h3><%= T("server.trace_log") %></h3>
                <%= traceLog %>
                </div>
            <% } %>
        </div>
    </section>
</body>

</html>