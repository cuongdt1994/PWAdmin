<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.util.Calendar.*"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>

<%
    String message = "<br>";
    boolean allowed = false;

    if(request.getSession().getAttribute("ssid") == null)
    {
        out.println("<p align=\"right\"><font color=\"#ee0000\"><b>" + T("sctrl.login_required") + "</b></font></p>");
    }
    else
    {
        allowed = true;
    }

    // Apply changes
    if(request.getParameter("process") != null && allowed)
    {
        Process p;
        String command;
        File working_directory;

        if(request.getParameter("process").compareTo("stopserver") == 0)
        {
            try
            {
                command = pw_server_path + "gamedbd/./gamedbd " + pw_server_path + "gamedbd/gamesys.conf exportclsconfig";
                working_directory = new File(pw_server_path + "gamedbd/");
                p = Runtime.getRuntime().exec(command, null, working_directory);
                p.waitFor();
                Thread.sleep(1000);

                Runtime.getRuntime().exec("pkill -9 gs");
                Runtime.getRuntime().exec("pkill -9 glinkd");
                Runtime.getRuntime().exec("pkill -9 gdeliveryd");
                Runtime.getRuntime().exec("pkill -9 gfactiond");
                Runtime.getRuntime().exec("pkill -9 gacd");
                Runtime.getRuntime().exec("pkill -9 gamedbd");
                Runtime.getRuntime().exec("pkill -9 uniquenamed");
                Runtime.getRuntime().exec("pkill -9 authd");
                Runtime.getRuntime().exec("pkill -9 logservice");
                Runtime.getRuntime().exec("sync");

                Thread.sleep(6000);

                message = "<font color=\"#00cc00\"><b>" + T("sctrl.msg.server_off") + "</font>";
            }
            catch(Exception e)
            {
                message = "<font color=\"#ee0000\"><b>" + T("sctrl.msg.server_off_fail") + "</b></font>";
            }
        }

        if(request.getParameter("process").compareTo("startserver") == 0) {
            File f = new File(pw_server_path + "iweb_starter.sh");
            try
            {
                command = pw_server_path + "start";
                working_directory = new File(pw_server_path);
                Runtime.getRuntime().exec("chmod 777 " + pw_server_path + "server");
                Runtime.getRuntime().exec(command, null, working_directory);
                Thread.sleep(30000);

                // === FIX: Tự động khởi động map gs01 (Thế Giới) sau khi start server ===
                // Trước đây server start không tự động chạy map gs01, dẫn đến server
                // khởi động không hoàn chỉnh và thiếu bản đồ thế giới chính.
                try {
                    File mapScript = new File(pw_server_path + "iweb_map_gs01.sh");
                    FileWriter fw2 = new FileWriter(mapScript);
                    fw2.write("cd " + pw_server_path + "gamed; ./gs gs01 > /dev/null 2>&1 &\n");
                    fw2.write("sleep 2\n");
                    fw2.write("rm -f " + pw_server_path + "iweb_map_gs01.sh\n");
                    fw2.close();

                    Runtime.getRuntime().exec("chmod 755 " + pw_server_path + "iweb_map_gs01.sh");
                    Runtime.getRuntime().exec("sh " + pw_server_path + "iweb_map_gs01.sh", null, new File(pw_server_path));
                    message += "<br><font color=\"#00cc00\"><b>" + T("sctrl.msg.gs01_starting") + "</font>";
                } catch(Exception mapEx) {
                    message += "<br><font color=\"#ffaa00\"><b>Lưu ý: Không thể tự động khởi động gs01: " + mapEx.getMessage() + "</b></font>";
                }

                message = "<font color=\"#00cc00\"><b>" + T("sctrl.msg.server_starting") + "</font>";
            }
            catch(Exception e)
            {
                f.delete();
                message = "<font color=\"#ee0000\"><b>" + T("sctrl.msg.server_start_fail") + "</b></font>" + e.getMessage();
            }
        }

        if(request.getParameter("process").compareTo("stopallmaps") == 0)
        {
            try
            {
                int time = Integer.parseInt(request.getParameter("time"));
                if(protocol.DeliveryDB.GMRestartServer(-1, time))
                {
                    message = "<font color=\"#00cc00\"><b>" + Tf("sctrl.msg.maps_stopping", time) + "</font>";
                }
                else
                {
                    message = "<font color=\"#ee0000\"><b>" + T("sctrl.msg.maps_stop_fail") + "</b></font>";
                }
            }
            catch(Exception e)
            {
                message = "<font color=\"#ee0000\"><b>" + T("sctrl.msg.maps_stop_fail") + "</b></font>";
            }
        }

        if(request.getParameter("process").compareTo("stopmap") == 0)
        {
            try
            {
                String[] maps = request.getParameterValues("map");
                for(int i=0; i<maps.length; i++)
                {
                    Runtime.getRuntime().exec("kill " +  maps[i]);
                    Thread.sleep(1000);
                }
                message = "<font color=\"#00cc00\"><b>" + T("sctrl.msg.maps_stopped") + "</b></font>";
            }
            catch(Exception e)
            {
                message = "<font color=\"#ee0000\"><b>" + T("sctrl.msg.maps_stop_fail2") + "</b></font>";
            }
        }

        if(request.getParameter("process").compareTo("startmap") == 0)
        {
            File f = new File(pw_server_path + "iweb_map.sh");
            try
            {
                String[] maps = request.getParameterValues("map");
                FileWriter fw = new FileWriter(f);
                for(int i = 0; i < maps.length; i++)
                {
                    fw.write("cd " + pw_server_path + "gamed; ./gs " + maps[i] + " > /dev/null 2>&1 &\n");
                    fw.write("sleep 1\n");
                }
                fw.write("rm foo\n");
                fw.write("sleep 1");
                fw.close();

                command = "sh " + pw_server_path + "./iweb_map.sh";
                working_directory = new File(pw_server_path);
                Runtime.getRuntime().exec("chmod 755 " + pw_server_path + "iweb_map.sh");
                Runtime.getRuntime().exec(command, null, working_directory);
                Thread.sleep(1000*maps.length+1);
                message = "<font color=\"#00cc00\"><b>" + T("sctrl.msg.maps_started") + "</b></font>";
            }
            catch(Exception e)
            {
                f.delete();
                message = "<font color=\"#ee0000\"><b>" + T("sctrl.msg.maps_start_fail") + "</b></font>";
            }
        }

        if(request.getParameter("process").compareTo("backup") == 0)
        {
            String line;
            boolean backup_allowed = true;
            p = Runtime.getRuntime().exec("ps -A w");
            BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
            while((line = input.readLine()) != null)
            {
                if(line.substring(27).indexOf("/./pw_backup.sh") != -1)
                {
                    backup_allowed = false;
                }
            }
            input.close();

            if(backup_allowed)
            {
                File f = new File(pw_server_path + "pw_backup.sh");
                try
                {
                    String time = (new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss")).format(new java.util.Date());
                    FileWriter fw = new FileWriter(f);
                    fw.write("cd " + pw_server_path + "\n");
                    fw.write("mysqldump -u" + db_user + " -p" + db_password + " " + db_database + " --routines > " + pw_server_path + "pw_backup_" + time + ".sql\n");
                    fw.write("sleep 1\n");
                    fw.write("tar -zcf " + pw_server_path + "pw_backup_" + time + ".tar.gz " + pw_server_path + " --exclude=pw_backup*\n");
                    fw.write("sleep 1\n");
                    fw.write("sync");
                    fw.close();

                    command = "sh " + pw_server_path + "./pw_backup.sh";
                    working_directory = new File(pw_server_path);
                    Runtime.getRuntime().exec("chmod 755 " + pw_server_path + "pw_backup.sh");
                    Runtime.getRuntime().exec(command, null, working_directory);

                    Thread.sleep(3000);

                    f.delete();
                    message = "<font color=\"#00cc00\"><b>" + T("sctrl.msg.backup_started") + " " + pw_server_path + "pw_backup_" + time + "</b></font>";
                }
                catch(Exception e)
                {
                    f.delete();
                    message = "<font color=\"#ee0000\"><b>" + T("sctrl.msg.backup_failed") + "</b></font>";
                }
            }
        }
    }


    // Load

    // Helper function: get map name in Vietnamese, fallback to English
    // maps[*][0] -> process ID / pid
    // maps[*][1] -> map id
    // maps[*][2] -> map name
    String[][] maps;
    if(item_labels.compareTo("pwi") == 0)
    {
        String[][] m =
        {
            {"0", "gs01", T("map.gs01")},
            {"0", "is01", T("map.is01")},
            {"0", "is02", T("map.is02")},
            {"0", "is05", T("map.is05")},
            {"0", "is06", T("map.is06")},
            {"0", "is07", T("map.is07")},
            {"0", "is08", T("map.is08")},
            {"0", "is09", T("map.is09")},
            {"0", "is10", T("map.is10")},
            {"0", "is11", T("map.is11")},
            {"0", "is12", T("map.is12")},
            {"0", "is13", T("map.is13")},
            {"0", "is14", T("map.is14")},
            {"0", "is15", T("map.is15")},
            {"0", "is16", T("map.is16")},
            {"0", "is17", T("map.is17")},
            {"0", "is18", T("map.is18")},
            {"0", "is19", T("map.is19")},
            {"0", "is20", T("map.is20")},
            {"0", "is21", T("map.is21")},
            {"0", "is22", T("map.is22")},
            {"0", "is23", T("map.is23")},
            {"0", "is24", T("map.is24")},
            {"0", "is25", T("map.is25")},
            {"0", "is26", T("map.is26")},
            {"0", "is27", T("map.is27")},
            {"0", "is28", T("map.is28")},
            {"0", "is29", T("map.is29")},
            {"0", "is31", T("map.is31")},
            {"0", "is32", T("map.is32")},
            {"0", "is33", T("map.is33")},
            {"0", "is34", T("map.is34")},
            {"0", "is35", T("map.is35")},
            {"0", "is37", T("map.is37")},
            {"0", "is38", T("map.is38")},
            {"0", "is39", T("map.is39")},
            {"0", "is40", T("map.is40")},
            {"0", "is41", T("map.is41")},
            {"0", "is42", T("map.is42")},
            {"0", "is43", T("map.is43")},
            {"0", "is44", T("map.is44")},
            {"0", "is45", T("map.is45")},
            {"0", "is46", T("map.is46")},
            {"0", "is47", T("map.is47")},
            {"0", "is48", T("map.is48")},
            {"0", "is49", T("map.is49")},
            {"0", "is50", T("map.is50")},
            {"0", "is61", T("map.is61")},
            {"0", "is62", T("map.is62")},
            {"0", "is63", T("map.is63")},
            {"0", "is66", T("map.is66")},
            {"0", "is67", T("map.is67")},
            {"0", "is68", T("map.is68")},
            {"0", "is69", T("map.is69")},
            {"0", "is70", T("map.is70")},
            {"0", "is71", T("map.is71")},
            {"0", "is72", T("map.is72")},
            {"0", "is73", T("map.is73")},
            {"0", "is74", T("map.is74")},
            {"0", "is75", T("map.is75")},
            {"0", "is76", T("map.is76")},
            {"0", "is77", T("map.is77")},
            {"0", "is78", T("map.is78")},
            {"0", "is80", T("map.is80")},
            {"0", "is81", T("map.is81")},
            {"0", "is82", T("map.is82")},
            {"0", "is83", T("map.is83")},
            {"0", "is84", T("map.is84")},
            {"0", "is85", T("map.is85")},
            {"0", "is86", T("map.is86")},
            {"0", "is87", T("map.is87")},
            {"0", "is88", T("map.is88")},
            {"0", "is89", T("map.is89")},
            {"0", "is90", T("map.is90")},
            {"0", "is91", T("map.is91")},
            {"0", "is92", T("map.is92")},
            {"0", "is93", T("map.is93")},
            {"0", "is94", T("map.is94")},
            {"0", "is95", T("map.is95")},
            {"0", "is96", T("map.is96")},
            {"0", "is97", T("map.is97")},
            {"0", "is98", T("map.is98")},
            {"0", "is99", T("map.is99")},
            {"0", "is101", T("map.is101")},
            {"0", "is102", T("map.is102")},
            {"0", "is103", T("map.is103")},
            {"0", "is105", T("map.is105")},
            {"0", "is106", T("map.is106")},
            {"0", "is107", T("map.is107")},
            {"0", "is108", T("map.is108")},
            {"0", "is109", T("map.is109")},
            {"0", "bg01", T("map.bg01")},
            {"0", "bg02", T("map.bg02")},
            {"0", "bg03", T("map.bg03")},
            {"0", "bg04", T("map.bg04")},
            {"0", "bg05", T("map.bg05")},
            {"0", "bg06", T("map.bg06")},
            {"0", "arena01", T("map.arena01")},
            {"0", "arena02", T("map.arena02")},
            {"0", "arena03", T("map.arena03")},
            {"0", "arena04", T("map.arena04")},
            {"0", "rand03", T("map.rand03")},
            {"0", "rand04", T("map.rand04")},
            {"0", "rand05", T("map.rand05")}
        };
        maps = m;
    }
    else
    {
        String[][] m =
        {
            {"0", "gs01", T("map.gs01")},
            {"0", "is01", T("map.is01")},
            {"0", "is02", T("map.is02")},
            {"0", "is05", T("map.is05")},
            {"0", "is06", T("map.is06")},
            {"0", "is07", T("map.is07")},
            {"0", "is08", T("map.is08")},
            {"0", "is09", T("map.is09")},
            {"0", "is10", T("map.is10")},
            {"0", "is11", T("map.is11")},
            {"0", "is12", T("map.is12")},
            {"0", "is13", T("map.is13")},
            {"0", "is14", T("map.is14")},
            {"0", "is15", T("map.is15")},
            {"0", "is16", T("map.is16")},
            {"0", "is17", T("map.is17")},
            {"0", "is18", T("map.is18")},
            {"0", "is19", T("map.is19")},
            {"0", "is20", T("map.is20")},
            {"0", "is21", T("map.is21")},
            {"0", "is22", T("map.is22")},
            {"0", "is23", T("map.is23")},
            {"0", "is24", T("map.is24")},
            {"0", "is25", T("map.is25")},
            {"0", "is26", T("map.is26")},
            {"0", "is27", T("map.is27")},
            {"0", "is28", T("map.is28")},
            {"0", "is29", T("map.is29")},
            {"0", "is31", T("map.is31")},
            {"0", "is32", T("map.is32")},
            {"0", "is33", T("map.is33")},
            {"0", "is34", T("map.is34")},
            {"0", "is35", T("map.is35")},
            {"0", "is37", T("map.is37")},
            {"0", "is38", T("map.is38")},
            {"0", "is39", T("map.is39")},
            {"0", "is40", T("map.is40")},
            {"0", "is41", T("map.is41")},
            {"0", "is42", T("map.is42")},
            {"0", "is43", T("map.is43")},
            {"0", "is44", T("map.is44")},
            {"0", "is45", T("map.is45")},
            {"0", "is46", T("map.is46")},
            {"0", "is47", T("map.is47")},
            {"0", "is48", T("map.is48")},
            {"0", "is49", T("map.is49")},
            {"0", "is50", T("map.is50")},
            {"0", "is61", T("map.is61")},
            {"0", "is62", T("map.is62")},
            {"0", "is63", T("map.is63")},
            {"0", "is66", T("map.is66")},
            {"0", "is67", T("map.is67")},
            {"0", "is68", T("map.is68")},
            {"0", "is69", T("map.is69")},
            {"0", "is70", T("map.is70")},
            {"0", "is71", T("map.is71")},
            {"0", "is72", T("map.is72")},
            {"0", "is73", T("map.is73")},
            {"0", "is74", T("map.is74")},
            {"0", "is75", T("map.is75")},
            {"0", "is76", T("map.is76")},
            {"0", "is77", T("map.is77")},
            {"0", "is78", T("map.is78")},
            {"0", "is80", T("map.is80")},
            {"0", "is81", T("map.is81")},
            {"0", "is82", T("map.is82")},
            {"0", "is83", T("map.is83")},
            {"0", "is84", T("map.is84")},
            {"0", "is85", T("map.is85")},
            {"0", "is86", T("map.is86")},
            {"0", "is87", T("map.is87")},
            {"0", "is88", T("map.is88")},
            {"0", "is89", T("map.is89")},
            {"0", "is90", T("map.is90")},
            {"0", "is91", T("map.is91")},
            {"0", "is92", T("map.is92")},
            {"0", "is93", T("map.is93")},
            {"0", "is94", T("map.is94")},
            {"0", "is95", T("map.is95")},
            {"0", "is96", T("map.is96")},
            {"0", "is97", T("map.is97")},
            {"0", "is98", T("map.is98")},
            {"0", "is99", T("map.is99")},
            {"0", "is101", T("map.is101")},
            {"0", "is102", T("map.is102")},
            {"0", "is103", T("map.is103")},
            {"0", "is105", T("map.is105")},
            {"0", "is106", T("map.is106")},
            {"0", "is107", T("map.is107")},
            {"0", "is108", T("map.is108")},
            {"0", "is109", T("map.is109")},
            {"0", "bg01", T("map.bg01")},
            {"0", "bg02", T("map.bg02")},
            {"0", "bg03", T("map.bg03")},
            {"0", "bg04", T("map.bg04")},
            {"0", "bg05", T("map.bg05")},
            {"0", "bg06", T("map.bg06")},
            {"0", "arena01", T("map.arena01")},
            {"0", "arena02", T("map.arena02")},
            {"0", "arena03", T("map.arena03")},
            {"0", "arena04", T("map.arena04")},
            {"0", "rand03", T("map.rand03")},
            {"0", "rand04", T("map.rand04")},
            {"0", "rand05", T("map.rand05")}
        };
        maps = m;
    }

    boolean server_running = false;
    boolean backup_running = false;
    int log_count = 0;
    int auth_count = 0;
    int unique_count = 0;
    int gac_count = 0;
    int gfaction_count = 0;
    int gdelivery_count = 0;
    int glink_count = 0;
    int gamedb_count = 0;
    int map_count = 0;
    String[] mem;
    String[] swp;
    String line;
    String process;
    Process p;
    BufferedReader input;

    p = Runtime.getRuntime().exec("free -m");
    input = new BufferedReader(new InputStreamReader(p.getInputStream()));
    input.readLine();
    mem = input.readLine().split("\\s+");
    swp = input.readLine().split("\\s+");
    input.close();

    p = Runtime.getRuntime().exec("ps -A w");
    input = new BufferedReader(new InputStreamReader(p.getInputStream()));
    while((line = input.readLine()) != null)
    {
        process = line.substring(27);

        if(process.indexOf("./pw_backup.sh") != -1)
        {
            message += "<br><font color=\"#ee0000\"><b>" + T("sctrl.msg.backup_running") + "</b></font>";
        }

        if(process.indexOf("./logservice") != -1)
        {
            log_count++;
            server_running = true;
        }
        if(process.indexOf("./gauthd") != -1)
        {
            auth_count++;
            server_running = true;
        }
        if(process.indexOf("./uniquenamed") != -1)
        {
            unique_count++;
            server_running = true;
        }
        if(process.indexOf("./gacd") != -1)
        {
            gac_count++;
            server_running = true;
        }
        if(process.indexOf("./gfactiond") != -1)
        {
            gfaction_count++;
            server_running = true;
        }
        if(process.indexOf("./gdeliveryd") != -1)
        {
            gdelivery_count++;
            server_running = true;
        }
        if(process.indexOf("./glinkd") != -1)
        {
            glink_count++;
        }
        if(process.indexOf("./gamedbd") != -1)
        {
            gamedb_count++;
            server_running = true;
        }

        // Check running maps
        for(int i=0; i<maps.length; i++)
        {
            if (process.indexOf("./gs " + maps[i][1]) != -1)
            {
                // set the process id
                String[] parts = line.trim().split("\\s+");
                if (parts.length > 0) {
                   maps[i][0] = parts[0];
                } else {
                    System.err.println("Unexpected format, split failed on line: " + line);
                    maps[i][0] = "ERROR";
                }

                map_count++;
                server_running = true;
            }
        }
    }
    input.close();
%>

<div class="container">

    <div class="box">
        <h2 class="title is-4 has-text-light is-centered"><%= T("sctrl.memory_daemon") %></h2>
        <div class="columns is-centered">
            <!-- RAM Usage Chart -->
            <div class="column is-narrow has-text-centered">
                <canvas id="ramChart" width="300" height="300"></canvas>
                <p class="has-text-light mt-2"><%= T("sctrl.ram_usage") %></p>
            </div>
            <!-- Swap Usage Chart -->
            <div class="column is-narrow has-text-centered">
                <canvas id="swapChart" width="300" height="300"></canvas>
                <p class="has-text-light mt-2"><%= T("sctrl.swap_usage") %></p>
            </div>

        </div>

        <div class="container">

                <h3 class="title is-size-6 is-centered has-text-centered"><%= T("sctrl.game_services") %></h3>
                <div class="columns is-multiline">
                    <!-- Logservice Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= log_count > 0 ? "background-color: green; color: #000; " : "background-color: red; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= log_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info"><%= T("sctrl.logservice") %></h3>
                        </div>
                    </div>

                    <!-- Auth Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= auth_count > 0 ? "background-color: green; color: #000; " : "background-color: red; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= auth_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info"><%= T("sctrl.auth_daemon") %></h3>
                        </div>
                    </div>

                    <!-- Unique Name Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= unique_count > 0 ? "background-color: green; color: #000; " : "background-color: red; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= unique_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info"><%= T("sctrl.unique_name") %></h3>
                        </div>
                    </div>

                    <!-- Game Anti-Cheat Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= gac_count > 0 ? "background-color: green; color: #000; " : "background-color: red; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= gac_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info"><%= T("sctrl.anti_cheat") %></h3>
                        </div>
                    </div>

                    <!-- Faction Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= gfaction_count > 0 ? "background-color: green; color: #000; " : "background-color: red; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= gfaction_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info"><%= T("sctrl.faction") %></h3>
                        </div>
                    </div>

                    <!-- Game Delivery Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= gdelivery_count > 0 ? "background-color: green; color: #000; " : "background-color: red; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= gdelivery_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info"><%= T("sctrl.delivery") %></h3>
                        </div>
                    </div>

                    <!-- Game Link Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= glink_count > 0 ? "background-color: green; color: #000; " : "background-color: red; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= glink_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info"><%= T("sctrl.link") %></h3>
                        </div>
                    </div>

                    <!-- Game Database Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= gamedb_count > 0 ? "background-color: green; color: #000; " : "background-color: red; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= gamedb_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info"><%= T("sctrl.database") %></h3>
                        </div>
                    </div>

                    <!-- Map Service Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= map_count > 0 ? "background-color: green; color: #000; " : "background-color: red; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= map_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info"><%= T("sctrl.map_service") %></h3>
                        </div>
                    </div>
                </div>



    </div>

    <div class="box">
        <h2 class="title is-4 has-text-light is-centered"><%= T("sctrl.server_start") %></h2>
            <div class="buttons is-centered"><% if (map_count > 0 || gamedb_count > 0 || glink_count > 0 || gdelivery_count > 0 ||
                gfaction_count > 0 || gac_count > 0 || log_count > 0 || auth_count > 0 || unique_count > 0 ) {%>
                <form action="index.jsp?page=serverctrl&process=stopserver" method="post">
                    <button class="button is-danger"><%= T("sctrl.stop_server_btn") %></button>
                </form>
                <% } else { %>
                <form action="index.jsp?page=serverctrl&process=startserver" method="post">
                    <button class="button is-success"><%= T("sctrl.start_server_btn") %></button>
                </form>
                <% } %>
            </div>
        <p class="has-text-centered"><%= message %></p>
    </div>



    <div class="box ">
        <h2 class="title is-4 has-text-light"><%= T("sctrl.maps") %></h2>
        <form action="index.jsp?page=serverctrl&process=stopallmaps" method="post">
            <div class="field">
                <label class="label has-text-light"><%= T("sctrl.delay_seconds") %></label>
                <div class="control">
                    <input class="input " type="number" name="time" value="300">
                </div>
            </div>
            <button class="button is-danger is-fullwidth"><%= T("sctrl.stop_all_maps") %></button>
        </form>

        <div class="columns is-gapless mt-5">
            <div class="column">
                <h3 class="subtitle is-size-6 has-text-weight-normal has-text-light"><%= Tf("sctrl.online_maps", map_count) %></h3>
                <form action="index.jsp?page=serverctrl&process=stopmap" method="post">
                    <div class="field">
                        <div class="control">
                            <div class="select is-multiple is-fullwidth">
                                <select name="map" size="11" multiple class="has-background has-text-light">
                                    <% for (int i = 0; i < maps.length; i++) {
                                        if (!maps[i][0].equals("0") && !maps[i][0].equals("ERROR")) {
                                            out.println("<option value=\"" + maps[i][0] + "\">" + maps[i][1] + " : " + maps[i][2] + "</option>");
                                        }
                                    } %>
                                </select>
                            </div>
                        </div>
                    </div>
                    <button class="button is-danger "><%= T("sctrl.stop_selected") %></button>
                </form>
            </div>
            <div class="column">
                <h3 class="subtitle is-size-6 has-text-weight-normal has-text-light"><%= T("sctrl.available_maps") %></h3>
                <form action="index.jsp?page=serverctrl&process=startmap" method="post">
                    <div class="field">
                        <div class="control">
                            <div class="select is-multiple is-fullwidth">
                                <select name="map" size="11" multiple class="has-background has-text-light">
                                    <% for (int i = 0; i < maps.length; i++) {
                                        if (maps[i][0].equals("0")) {
                                            out.println("<option value=\"" + maps[i][1] + "\">" + maps[i][1] + " : " + maps[i][2] + "</option>");
                                        }
                                    } %>
                                </select>
                            </div>
                        </div>
                    </div>
                    <button class="button is-success "><%= T("sctrl.start_selected") %></button>
                </form>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // RAM Usage Data
    const ramData = {
        labels: ["Used", "Free"],
        datasets: [{
            data: [<%= mem[2] %>, <%= mem[3] %>],
            backgroundColor: ["#ff7675", "#1f2226"],
        }]
    };

    // Swap Usage Data
    const swapData = {
        labels: ["Used", "Free"],
        datasets: [{
            data: [<%= swp[2] %>, <%= swp[3] %>],
            backgroundColor: ["#74b9ff", "#ffeaa7"],
        }]
    };

    // RAM Chart
    const ramChartCtx = document.getElementById("ramChart").getContext("2d");
    new Chart(ramChartCtx, {
        type: "doughnut",
        data: ramData,
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: true,
                    position: "bottom",
                    labels: {
                        color: "#ffffff"
                    }
                }
            }
        }
    });

    // Swap Chart
    const swapChartCtx = document.getElementById("swapChart").getContext("2d");
    new Chart(swapChartCtx, {
        type: "doughnut",
        data: swapData,
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: true,
                    position: "bottom",
                    labels: {
                        color: "#ffffff"
                    }
                }
            }
        }
    });
</script>