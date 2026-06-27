<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.util.Calendar.*"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>

<%
    String message = "<br>";
    boolean allowed = false;

    if(request.getSession().getAttribute("ssid") == null)
    {
        out.println("<p align=\"right\"><font color=\"#ee0000\"><b>Login for Server control...</b></font></p>");
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
// drop_caches -> permission denied
//                FileWriter fw = new FileWriter(new File("/proc/sys/vm/drop_caches"));
//                fw.write("3");
//                fw.close();

                Thread.sleep(6000);

                message = "<font color=\"#00cc00\"><b>Server Turned Off</font>";
            }
            catch(Exception e)
            {
                message = "<font color=\"#ee0000\"><b>Turning Off Server Failed</b></font>";
            }
        }

        if(request.getParameter("process").compareTo("startserver") == 0) {
            File f = new File(pw_server_path + "iweb_starter.sh");
			try
			{
				command = pw_server_path + "server start";
				working_directory = new File(pw_server_path);
				Runtime.getRuntime().exec("chmod 777 " + pw_server_path + "server");
				Runtime.getRuntime().exec(command, null, working_directory);
				Thread.sleep(30000);

				message = "<font color=\"#00cc00\"><b>Server is Starting Up... it could take some minutes till server is fully up and //running</font>";
			}
			catch(Exception e)
			{
				f.delete();
				message = "<font color=\"#ee0000\"><b>Starting Up Server Failed </b></font>" + e.getMessage();
			}
        }

        if(request.getParameter("process").compareTo("stopallmaps") == 0)
        {
            try
            {
                int time = Integer.parseInt(request.getParameter("time"));
                if(protocol.DeliveryDB.GMRestartServer(-1, time))
                {
                    message = "<font color=\"#00cc00\"><b>All Maps will be stopped in " + time + " seconds</font>";
                }
                else
                {
                    message = "<font color=\"#ee0000\"><b>Setting Timer to stop Maps Failed</b></font>";
                }
            }
            catch(Exception e)
            {
                message = "<font color=\"#ee0000\"><b>Setting Timer to stop Maps Failed</b></font>";
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
                message = "<font color=\"#00cc00\"><b>Map(s) Stopped</b></font>";
            }
            catch(Exception e)
            {
                message = "<font color=\"#ee0000\"><b>Stopping Map(s) Failed</b></font>";
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
                //f.delete();
                message = "<font color=\"#00cc00\"><b>Map(s) Started</b></font>";
            }
            catch(Exception e)
            {
                f.delete();
                message = "<font color=\"#ee0000\"><b>Starting Map(s) Failed</b></font>";
            }
        }

        if(request.getParameter("process").compareTo("backup") == 0)
        {
            // Check if another Backup is running

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
// drop_caches -> permission denied
//                    fw.write("sync; echo 3 > /proc/sys/vm/drop_caches");
fw.write("sync");
                    fw.close();

                    command = "sh " + pw_server_path + "./pw_backup.sh";
                    working_directory = new File(pw_server_path);
                    Runtime.getRuntime().exec("chmod 755 " + pw_server_path + "pw_backup.sh");
                    Runtime.getRuntime().exec(command, null, working_directory);

                    Thread.sleep(3000);

                    f.delete();
                    message = "<font color=\"#00cc00\"><b>Backup Started -> " + pw_server_path + "pw_backup_" + time + "</b></font>";
                }
                catch(Exception e)
                {
                    f.delete();
                    message = "<font color=\"#ee0000\"><b>Backup Failed</b></font>";
                }
            }
        }
    }


    // Load

    // maps[*][0] -> process ID / pid
    // maps[*][1] -> map id
    // maps[*][2] -> map name
    String[][] maps;
    if(item_labels.compareTo("pwi") == 0)
    {
        String[][] m =
        {
            {"0", "gs01", "World"}, 
			{"0", "is01", "City of Abominations"}, 
			{"0", "is02", "Secret Passage"},
			{"0", "is05", "Firecrag Grotto"}, 
			{"0", "is06", "Den of Rabid Wolves"},
			{"0", "is07", "Cave of the Vicious"},
			{"0", "is08", "Hall of Deception"}, 
			{"0", "is09", "Gate of Delirium"}, 
			{"0", "is10", "Secret Frostcover Grounds"}, 
			{"0", "is11", "Valley of Disaster"}, 
			{"0", "is12", "Forest Ruins"}, 
			{"0", "is13", "Cave of Sadistic Glee"}, 
			{"0", "is14", "Wraithgate"}, 
			{"0", "is15", "Hallucinatory Trench"}, 
			{"0", "is16", "Eden"}, 
			{"0", "is17", "Brimstone Pit"}, 
			{"0", "is18", "Temple of the Dragon"}, 
			{"0", "is19", "Nightscream Island"}, 
			{"0", "is20", "Snake Isle"},
			{"0", "is21", "Lothranis"}, 
			{"0", "is22", "Momaganon"}, 
			{"0", "is23", "Seat of Torment"}, 
			{"0", "is24", "Abaddon"}, 
			{"0", "is25", "Warsong City"}, 
			{"0", "is26", "Palace of Nirvana"}, 
			{"0", "is27", "Lunar Glade"}, 
			{"0", "is28", "Valley of Reciprocity"}, 
			{"0", "is29", "Frostcover City"},
			{"0", "is31", "Twilight Temple"}, 
			{"0", "is32", "Cube of Fate"}, 
			{"0", "is33", "Chrono City"}, 
			{"0", "is34", "Perfect Chapel"},
			{"0", "is35", "Guild Base"},
			{"0", "is37", "Morai"},
			{"0", "is38", "Phoenix Valley"},
			{"0", "is39", "Endless Universe"},
			{"0", "is40", "Blighted Chamer"},
			{"0", "is41", "Endless Universe"},
			{"0", "is42", "Wargod Gulch"},
			{"0", "is43", "Five Emperors"},
			{"0", "is44", "Nation War 2"},
			{"0", "is45", "Nation Wa TOWER"},
			{"0", "is46", "Nation War CRYSTAL"},
			{"0", "is47", "Sunset Valley"},
			{"0", "is48", "Shutter Palace"},
			{"0", "is49", "Dragon Hidden Den"},
			{"0", "is50", "Realm of Reflection"},
			{"0", "is61", "startpoint"},
			{"0", "is62", "Origination"},
			{"0", "is63", "Primal World"},
			{"0", "is66", "Flowsilver Palace"},
			{"0", "is67", "Undercurrent Hall"},
			{"0", "is68", "Mortal Realm"},
			{"0", "is69", "LightSail Cave"},
			{"0", "is70", "Cube of Fate (2)"},
			{"0", "is71", "dragon counqest"},
			{"0", "is72", "heavenfall temple"},
			{"0", "is73", "heavenfall temple"},
			{"0", "is74", "heavenfall temple"},
			{"0", "is75", "heavenfall temple"},
			{"0", "is76", "Uncharted Paradise"},
			{"0", "is77", "Thurs Fights Cross"},
			{"0", "is78", "Western Steppes"},
			{"0", "is80", "Homestead, Beyond the Clouds"},
			{"0", "is81", "Homestead, Beyond the Clouds"},
			{"0", "is82", "Homestead, Beyond the Clouds"},
			{"0", "is83", "Homestead, Beyond the Clouds"},
			{"0", "is84", "Grape Valley, Grape Valley"},
			{"0", "is85", "Nemesis Gaunntlet, Museum"},
			{"0", "is86", "Dawnlight Halls, Palace of the Dawn (DR 1)"},
			{"0", "is87", "Mirage Lake, Mirage Lake"},
			{"0", "is88", "Rosesand Ruins, Desert Ruins"},
			{"0", "is89", "Nightmare Woods, Forest Ruins"},
			{"0", "is90", "Advisors Sanctum, Palace of the Dawn (DR 2)"},
			{"0", "is91", "Wonderland, Adventure Kingdom (Park)"},
			{"0", "is92", "The Indestructible City"},
			{"0", "is93", "Phoenix Sanctum, Hall of Fame"},
			{"0", "is94", "Town of Arrivals, Battlefield - Dusk Outpost"},
			{"0", "is95", "Icebound Underworld, Ice Hell (LA)"},
			{"0", "is96", "Doosan Station, Arena of the Gods"},
			{"0", "is97", "Alt TT Revisited, Twilight Palace"},
			{"0", "is98", "Spring Pass, Peach Abode (Mentoring)"},
			{"0", "is99", "Abode of Dreams"},
			{"0", "is101", "White Wolf Pass"},
			{"0", "is102", "Imperial Battle"},
			{"0", "is103", "Northern Lands"},
			{"0", "is105", "Altar of the Virgin"},
			{"0", "is106", "Imperial Battle"},
			{"0", "is107", "Northern Lands"},
			{"0", "is108", "Full Moon Pavilion"},
			{"0", "is109", "Abode of Changes"},
			{"0", "bg01", "Territory War T-3 PvP"}, 
			{"0", "bg02", "Territory War T-3 PvE"}, 
			{"0", "bg03", "Territory War T-2 PvP"}, 
			{"0", "bg04", "Territory War T-2 PvE"}, 
			{"0", "bg05", "Territory War T-1 PvP"}, 
			{"0", "bg06", "Territory War T-1 PvE"},
			{"0", "arena01", "Etherblade Arena"},
			{"0", "arena02", "Lost Arena"},
			{"0", "arena03", "Plume Arena"},
			{"0", "arena04", "Archosaur Arenas"},
			{"0", "rand03", "Quicksand Maze (Sandstorm Mirage)"},
			{"0", "rand04", "Quicksand Maze (Mirage of the wandering sands)"},
			{"0", "rand05", "Tomb of Whispers"}            
        };
        maps = m;
    }
    else
    {
        String[][] m =
        {
            {"0", "gs01", "World"}, 
			{"0", "is01", "City of Abominations"}, 
			{"0", "is02", "Secret Passage"},
			{"0", "is05", "Firecrag Grotto"}, 
			{"0", "is06", "Den of Rabid Wolves"},
			{"0", "is07", "Cave of the Vicious"},
			{"0", "is08", "Hall of Deception"}, 
			{"0", "is09", "Gate of Delirium"}, 
			{"0", "is10", "Secret Frostcover Grounds"}, 
			{"0", "is11", "Valley of Disaster"}, 
			{"0", "is12", "Forest Ruins"}, 
			{"0", "is13", "Cave of Sadistic Glee"}, 
			{"0", "is14", "Wraithgate"}, 
			{"0", "is15", "Hallucinatory Trench"}, 
			{"0", "is16", "Eden"}, 
			{"0", "is17", "Brimstone Pit"}, 
			{"0", "is18", "Temple of the Dragon"}, 
			{"0", "is19", "Nightscream Island"}, 
			{"0", "is20", "Snake Isle"},
			{"0", "is21", "Lothranis"}, 
			{"0", "is22", "Momaganon"}, 
			{"0", "is23", "Seat of Torment"}, 
			{"0", "is24", "Abaddon"}, 
			{"0", "is25", "Warsong City"}, 
			{"0", "is26", "Palace of Nirvana"}, 
			{"0", "is27", "Lunar Glade"}, 
			{"0", "is28", "Valley of Reciprocity"}, 
			{"0", "is29", "Frostcover City"},
			{"0", "is31", "Twilight Temple"}, 
			{"0", "is32", "Cube of Fate"}, 
			{"0", "is33", "Chrono City"}, 
			{"0", "is34", "Perfect Chapel"},
			{"0", "is35", "Guild Base"},
			{"0", "is37", "Morai"},
			{"0", "is38", "Phoenix Valley"},
			{"0", "is39", "Endless Universe"},
			{"0", "is40", "Blighted Chamer"},
			{"0", "is41", "Endless Universe"},
			{"0", "is42", "Wargod Gulch"},
			{"0", "is43", "Five Emperors"},
			{"0", "is44", "Nation War 2"},
			{"0", "is45", "Nation Wa TOWER"},
			{"0", "is46", "Nation War CRYSTAL"},
			{"0", "is47", "Sunset Valley"},
			{"0", "is48", "Shutter Palace"},
			{"0", "is49", "Dragon Hidden Den"},
			{"0", "is50", "Realm of Reflection"},
			{"0", "is61", "startpoint"},
			{"0", "is62", "Origination"},
			{"0", "is63", "Primal World"},
			{"0", "is66", "Flowsilver Palace"},
			{"0", "is67", "Undercurrent Hall"},
			{"0", "is68", "Mortal Realm"},
			{"0", "is69", "LightSail Cave"},
			{"0", "is70", "Cube of Fate (2)"},
			{"0", "is71", "dragon counqest"},
			{"0", "is72", "heavenfall temple"},
			{"0", "is73", "heavenfall temple"},
			{"0", "is74", "heavenfall temple"},
			{"0", "is75", "heavenfall temple"},
			{"0", "is76", "Uncharted Paradise"},
			{"0", "is77", "Thurs Fights Cross"},
			{"0", "is78", "Western Steppes"},
			{"0", "is80", "Homestead, Beyond the Clouds"},
			{"0", "is81", "Homestead, Beyond the Clouds"},
			{"0", "is82", "Homestead, Beyond the Clouds"},
			{"0", "is83", "Homestead, Beyond the Clouds"},
			{"0", "is84", "Grape Valley, Grape Valley"},
			{"0", "is85", "Nemesis Gaunntlet, Museum"},
			{"0", "is86", "Dawnlight Halls, Palace of the Dawn (DR 1)"},
			{"0", "is87", "Mirage Lake, Mirage Lake"},
			{"0", "is88", "Rosesand Ruins, Desert Ruins"},
			{"0", "is89", "Nightmare Woods, Forest Ruins"},
			{"0", "is90", "Advisors Sanctum, Palace of the Dawn (DR 2)"},
			{"0", "is91", "Wonderland, Adventure Kingdom (Park)"},
			{"0", "is92", "The Indestructible City"},
			{"0", "is93", "Phoenix Sanctum, Hall of Fame"},
			{"0", "is94", "Town of Arrivals, Battlefield - Dusk Outpost"},
			{"0", "is95", "Icebound Underworld, Ice Hell (LA)"},
			{"0", "is96", "Doosan Station, Arena of the Gods"},
			{"0", "is97", "Alt TT Revisited, Twilight Palace"},
			{"0", "is98", "Spring Pass, Peach Abode (Mentoring)"},
			{"0", "is99", "Abode of Dreams"},
			{"0", "is101", "White Wolf Pass"},
			{"0", "is102", "Imperial Battle"},
			{"0", "is103", "Northern Lands"},
			{"0", "is105", "Altar of the Virgin"},
			{"0", "is106", "Imperial Battle"},
			{"0", "is107", "Northern Lands"},
			{"0", "is108", "Full Moon Pavilion"},
			{"0", "is109", "Abode of Changes"},
			{"0", "bg01", "Territory War T-3 PvP"}, 
			{"0", "bg02", "Territory War T-3 PvE"}, 
			{"0", "bg03", "Territory War T-2 PvP"}, 
			{"0", "bg04", "Territory War T-2 PvE"}, 
			{"0", "bg05", "Territory War T-1 PvP"}, 
			{"0", "bg06", "Territory War T-1 PvE"},
			{"0", "arena01", "Etherblade Arena"},
			{"0", "arena02", "Lost Arena"},
			{"0", "arena03", "Plume Arena"},
			{"0", "arena04", "Archosaur Arenas"},
			{"0", "rand03", "Quicksand Maze (Sandstorm Mirage)"},
			{"0", "rand04", "Quicksand Maze (Mirage of the wandering sands)"},
			{"0", "rand05", "Tomb of Whispers"}             
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
    //input.readLine();
    swp = input.readLine().split("\\s+");
    input.close();

    p = Runtime.getRuntime().exec("ps -A w");
    input = new BufferedReader(new InputStreamReader(p.getInputStream()));
    while((line = input.readLine()) != null)
    {
        process = line.substring(27);

        if(process.indexOf("./pw_backup.sh") != -1)
        {
            message += "<br><font color=\"#ee0000\"><b>A Server Backup is Running please wait until Backup is finished!<br>Click <a href=\"index.jsp?page=serverctrl\"><font color=\"#0000cc\">here</font></a> from Time to Time until this Message disappears...</b></font>";
        }

        if(process.indexOf("./logservice") != -1)
        {
            log_count++;
            server_running = true;
        }
        if(process.indexOf("./authd") != -1) // Changed check to authd
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
                    maps[i][0] = "ERROR"; // Set an error value, if needed
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
        <h2 class="title is-4 has-text-light is-centered">Memory & Daemon</h2>
        <div class="columns is-centered">
            <!-- RAM Usage Chart -->
            <div class="column is-narrow has-text-centered">
                <canvas id="ramChart" width="300" height="300"></canvas>
                <p class="has-text-light mt-2">RAM Usage</p>
            </div>
            <!-- Swap Usage Chart -->
            <div class="column is-narrow has-text-centered">
                <canvas id="swapChart" width="300" height="300"></canvas>
                <p class="has-text-light mt-2">Swap Usage</p>
            </div>
        
        </div>

        <div class="container">
            
                <h3 class="title is-size-6 is-centered has-text-centered"> Game Services Status</h3>
                <div class="columns is-multiline">
                    <!-- Logservice Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= log_count > 0 ? "background-color: #1f2226; color: #000; " : "background-color: #ff7675; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= log_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info">Logservice</h3>
                        </div>
                    </div>
            
                    <!-- Auth Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= auth_count > 0 ? "background-color: #1f2226; color: #000; " : "background-color: #ff7675; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= auth_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info">Auth Daemon</h3>
                        </div>
                    </div>
            
                    <!-- Unique Name Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= unique_count > 0 ? "background-color: #1f2226; color: #000; " : "background-color: #ff7675; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= unique_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info">Unique Name Daemon</h3>
                        </div>
                    </div>
            
                    <!-- Game Anti-Cheat Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= gac_count > 0 ? "background-color: #1f2226; color: #000; " : "background-color: #ff7675; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= gac_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info">Game Anti-Cheat Daemon</h3>
                        </div>
                    </div>
            
                    <!-- Faction Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= gfaction_count > 0 ? "background-color: #1f2226; color: #000; " : "background-color: #ff7675; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= gfaction_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info">Faction Daemon</h3>
                        </div>
                    </div>
            
                    <!-- Game Delivery Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= gdelivery_count > 0 ? "background-color: #1f2226; color: #000; " : "background-color: #ff7675; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= gdelivery_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info">Game Delivery Daemon</h3>
                        </div>
                    </div>
            
                    <!-- Game Link Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= glink_count > 0 ? "background-color: #1f2226; color: #000; " : "background-color: #ff7675; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= glink_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info">Game Link Daemon</h3>
                        </div>
                    </div>
            
                    <!-- Game Database Daemon Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= gamedb_count > 0 ? "background-color: #1f2226; color: #000; " : "background-color: #ff7675; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= gamedb_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info">Game Database Daemon</h3>
                        </div>
                    </div>
            
                    <!-- Map Service Card -->
                    <div class="column is-one-third">
                        <div class="box has-text-centered" style='<%= map_count > 0 ? "background-color: #1f2226; color: #000; " : "background-color: #ff7675; color: #000; " %>'>
                            <span class="icon" style="float: left; margin-right: 10px;">
                                <i class="fas fa-circle" style='color: <%= map_count > 0 ? "#00ff00" : "#ff0000" %>'></i>
                            </span>
                            <h3 class="title is-size-6 has-text-weight-normal has-text-info">Map Service</h3>
                        </div>
                    </div>
                </div>
           
            
            
    </div>

    <div class="box">
        <h2 class="title is-4 has-text-light is-centered">Server Start</h2>
            <div class="buttons is-centered"><% if (map_count > 0 || gamedb_count > 0 || glink_count > 0 || gdelivery_count > 0 || 
                gfaction_count > 0 || gac_count > 0 || log_count > 0 || auth_count > 0 || unique_count > 0 ) {%>
                <form action="index.jsp?page=serverctrl&process=stopserver" method="post">
                    <button class="button is-danger">Stop Server</button>
                </form>
                <% } else { %>
                <form action="index.jsp?page=serverctrl&process=startserver" method="post">
                    <button class="button is-success">Start Server</button>
                </form>
                <% } %>
            </div>
        <p class="has-text-centered"><%= message %></p>
    </div>
       


    <div class="box ">
        <h2 class="title is-4 has-text-light">Maps</h2>
        <form action="index.jsp?page=serverctrl&process=stopallmaps" method="post">
            <div class="field">
                <label class="label has-text-light">Delay (seconds):</label>
                <div class="control">
                    <input class="input " type="number" name="time" value="300">
                </div>
            </div>
            <button class="button is-danger is-fullwidth">Stop All Maps</button>
        </form>
    
        <div class="columns is-gapless mt-5">
            <div class="column">
                <h3 class="subtitle is-size-6 has-text-weight-normal has-text-light">Online Maps : <%= map_count %></h3> 
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
                    <button class="button is-danger ">Stop Selected Maps</button>
                </form>
            </div>
            <div class="column">
                <h3 class="subtitle is-size-6 has-text-weight-normal has-text-light">Available Maps</h3>
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
                    <button class="button is-success ">Start Selected Maps</button>
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