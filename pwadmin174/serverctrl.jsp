<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>

<%
    // =========================================================================
    //                          SERVERCTL.JSP
    //     Điều khiển Server - Start/Stop Server, Quản lý Maps, Backup
    //     Phiên bản chuẩn hóa: Java best practices, an toàn, rõ ràng
    // =========================================================================

    String message = "";
    String msgType = "";
    boolean allowed = false;

    // ---- Kiểm tra đăng nhập ----
    if (request.getSession().getAttribute("ssid") == null) {
        out.println("<div class=\"phx-empty-state\"><i class=\"fa-solid fa-lock\"></i><p>" + T("sctrl.login_required") + "</p></div>");
    } else {
        allowed = true;
    }

    // ---- XỬ LÝ HÀNH ĐỘNG ----
    if (allowed) {
        String process = request.getParameter("process");

        if (process != null) {

            // ============================
            //   DỪNG TOÀN BỘ SERVER
            // ============================
            if ("stopserver".equals(process)) {
                try {
                    // Export class config trước khi dừng
                    String exportCmd = pw_server_path + "gamedbd/./gamedbd " + pw_server_path + "gamedbd/gamesys.conf exportclsconfig";
                    File exportDir = new File(pw_server_path + "gamedbd/");
                    Process pExport = Runtime.getRuntime().exec(exportCmd, null, exportDir);
                    pExport.waitFor();
                    Thread.sleep(1000);

                    // Kill tất cả tiến trình game server
                    String[] killTargets = {"gs", "glinkd", "gdeliveryd", "gfactiond",
                                             "gacd", "gamedbd", "uniquenamed", "gauthd", "logservice"};
                    for (String target : killTargets) {
                        Runtime.getRuntime().exec("pkill -9 " + target);
                    }
                    Runtime.getRuntime().exec("sync");
                    Thread.sleep(6000);

                    message = T("sctrl.msg.server_off");
                    msgType = "success";
                } catch (Exception e) {
                    message = T("sctrl.msg.server_off_fail");
                    msgType = "error";
                }
            }

            // ============================
            //   KHỞI ĐỘNG TOÀN BỘ SERVER
            // ============================
            if ("startserver".equals(process)) {
                File mapScript = null;
                FileWriter fw = null;
                try {
                    // Bước 1: Khởi động toàn bộ server daemons
                    String startCmd = pw_server_path + "start";
                    File serverDir = new File(pw_server_path);
                    Runtime.getRuntime().exec("chmod 777 " + pw_server_path + "start");
                    Runtime.getRuntime().exec(startCmd, null, serverDir);
                    Thread.sleep(30000);

                    // Bước 2: Tự động khởi động 2 map mặc định: gs01 (Thế Giới) + is61 (Điểm Bắt Đầu)
                    mapScript = new File(pw_server_path + "iweb_map.sh");
                    fw = new FileWriter(mapScript);
                    fw.write("cd " + pw_server_path + "gamed; ./gs gs01 > /dev/null 2>&1 &\n");
                    fw.write("sleep 1\n");
                    fw.write("cd " + pw_server_path + "gamed; ./gs is61 > /dev/null 2>&1 &\n");
                    fw.write("sleep 1\n");
                    fw.close();
                    fw = null;

                    Runtime.getRuntime().exec("chmod 755 " + pw_server_path + "iweb_map.sh");
                    Runtime.getRuntime().exec("sh " + pw_server_path + "./iweb_map.sh", null, serverDir);
                    Thread.sleep(3000);

                    // Xóa script tạm
                    mapScript.delete();

                    message = T("sctrl.msg.server_starting");
                    msgType = "success";
                } catch (Exception e) {
                    message = T("sctrl.msg.server_start_fail") + " " + e.getMessage();
                    msgType = "error";
                } finally {
                    // Đảm bảo đóng FileWriter và xóa file tạm
                    if (fw != null) {
                        try { fw.close(); } catch (IOException ignored) {}
                    }
                    if (mapScript != null && mapScript.exists()) {
                        mapScript.delete();
                    }
                }
            }

            // ============================
            //   DỪNG TẤT CẢ BẢN ĐỒ
            // ============================
            if ("stopallmaps".equals(process)) {
                try {
                    int time = Integer.parseInt(request.getParameter("time"));
                    if (protocol.DeliveryDB.GMRestartServer(-1, time)) {
                        message = Tf("sctrl.msg.maps_stopping", time);
                        msgType = "success";
                    } else {
                        message = T("sctrl.msg.maps_stop_fail");
                        msgType = "error";
                    }
                } catch (Exception e) {
                    message = T("sctrl.msg.maps_stop_fail");
                    msgType = "error";
                }
            }

            // ============================
            //   DỪNG BẢN ĐỒ ĐÃ CHỌN
            // ============================
            if ("stopmap".equals(process)) {
                try {
                    String[] maps = request.getParameterValues("map");
                    if (maps != null && maps.length > 0) {
                        for (int i = 0; i < maps.length; i++) {
                            Runtime.getRuntime().exec("kill " + maps[i]);
                            Thread.sleep(1000);
                        }
                        message = T("sctrl.msg.maps_stopped");
                        msgType = "success";
                    } else {
                        message = T("sctrl.msg.maps_stop_fail2");
                        msgType = "error";
                    }
                } catch (Exception e) {
                    message = T("sctrl.msg.maps_stop_fail2");
                    msgType = "error";
                }
            }

            // ============================
            //   KHỞI ĐỘNG BẢN ĐỒ ĐÃ CHỌN
            // ============================
            if ("startmap".equals(process)) {
                File mapScript = null;
                FileWriter fw = null;
                try {
                    String[] maps = request.getParameterValues("map");
                    if (maps == null || maps.length == 0) {
                        message = T("sctrl.msg.maps_start_fail");
                        msgType = "error";
                    } else {
                        mapScript = new File(pw_server_path + "iweb_map.sh");
                        fw = new FileWriter(mapScript);
                        for (int i = 0; i < maps.length; i++) {
                            fw.write("cd " + pw_server_path + "gamed; ./gs " + maps[i] + " > /dev/null 2>&1 &\n");
                            fw.write("sleep 1\n");
                        }
                        fw.write("rm foo\nsleep 1");
                        fw.close();
                        fw = null;

                        Runtime.getRuntime().exec("chmod 755 " + pw_server_path + "iweb_map.sh");
                        Runtime.getRuntime().exec("sh " + pw_server_path + "./iweb_map.sh", null, new File(pw_server_path));
                        Thread.sleep(1000 * maps.length + 1000);

                        // Xóa script tạm
                        mapScript.delete();

                        message = T("sctrl.msg.maps_started");
                        msgType = "success";
                    }
                } catch (Exception e) {
                    message = T("sctrl.msg.maps_start_fail");
                    msgType = "error";
                } finally {
                    if (fw != null) {
                        try { fw.close(); } catch (IOException ignored) {}
                    }
                    if (mapScript != null && mapScript.exists()) {
                        mapScript.delete();
                    }
                }
            }

            // ============================
            //   SAO LƯU SERVER
            // ============================
            if ("backup".equals(process)) {
                boolean backupAllowed = true;
                BufferedReader psReader = null;
                try {
                    // Kiểm tra xem có backup nào đang chạy không
                    Process psProc = Runtime.getRuntime().exec("ps -A w");
                    psReader = new BufferedReader(new InputStreamReader(psProc.getInputStream()));
                    String line;
                    while ((line = psReader.readLine()) != null) {
                        if (line.length() > 27 && line.substring(27).contains("/./pw_backup.sh")) {
                            backupAllowed = false;
                            break;
                        }
                    }
                } catch (Exception e) {
                    // Nếu không check được, vẫn cho phép backup
                } finally {
                    if (psReader != null) {
                        try { psReader.close(); } catch (IOException ignored) {}
                    }
                }

                if (backupAllowed) {
                    File backupScript = null;
                    FileWriter fw = null;
                    try {
                        String time = new SimpleDateFormat("yyyy-MM-dd_HH-mm-ss").format(new java.util.Date());
                        backupScript = new File(pw_server_path + "pw_backup.sh");
                        fw = new FileWriter(backupScript);
                        fw.write("cd " + pw_server_path + "\n");
                        fw.write("mysqldump -u" + db_user + " -p" + db_password + " " + db_database + " --routines > " + pw_server_path + "pw_backup_" + time + ".sql\n");
                        fw.write("sleep 1\n");
                        fw.write("tar -zcf " + pw_server_path + "pw_backup_" + time + ".tar.gz " + pw_server_path + " --exclude=pw_backup*\n");
                        fw.write("sleep 1\nsync");
                        fw.close();
                        fw = null;

                        Runtime.getRuntime().exec("chmod 755 " + pw_server_path + "pw_backup.sh");
                        Runtime.getRuntime().exec("sh " + pw_server_path + "./pw_backup.sh", null, new File(pw_server_path));
                        Thread.sleep(3000);

                        backupScript.delete();

                        message = T("sctrl.msg.backup_started") + " " + pw_server_path + "pw_backup_" + time;
                        msgType = "success";
                    } catch (Exception e) {
                        message = T("sctrl.msg.backup_failed");
                        msgType = "error";
                    } finally {
                        if (fw != null) {
                            try { fw.close(); } catch (IOException ignored) {}
                        }
                        if (backupScript != null && backupScript.exists()) {
                            backupScript.delete();
                        }
                    }
                }
            }

        } // end if process != null
    } // end if allowed

    // =========================================================================
    //                          LOAD DỮ LIỆU BẢN ĐỒ
    // =========================================================================
    String[][] maps;

    // Dữ liệu map: {PID, mapId, mapName}
    // PID = "0" nghĩa là chưa chạy, số khác là PID đang chạy
    if ("pwi".equals(item_labels)) {
        maps = new String[][]{
            {"0","gs01",T("map.gs01")},{"0","is01",T("map.is01")},{"0","is02",T("map.is02")},{"0","is05",T("map.is05")},{"0","is06",T("map.is06")},
            {"0","is07",T("map.is07")},{"0","is08",T("map.is08")},{"0","is09",T("map.is09")},{"0","is10",T("map.is10")},{"0","is11",T("map.is11")},
            {"0","is12",T("map.is12")},{"0","is13",T("map.is13")},{"0","is14",T("map.is14")},{"0","is15",T("map.is15")},{"0","is16",T("map.is16")},
            {"0","is17",T("map.is17")},{"0","is18",T("map.is18")},{"0","is19",T("map.is19")},{"0","is20",T("map.is20")},{"0","is21",T("map.is21")},
            {"0","is22",T("map.is22")},{"0","is23",T("map.is23")},{"0","is24",T("map.is24")},{"0","is25",T("map.is25")},{"0","is26",T("map.is26")},
            {"0","is27",T("map.is27")},{"0","is28",T("map.is28")},{"0","is29",T("map.is29")},{"0","is31",T("map.is31")},{"0","is32",T("map.is32")},
            {"0","is33",T("map.is33")},{"0","is34",T("map.is34")},{"0","is35",T("map.is35")},{"0","is37",T("map.is37")},{"0","is38",T("map.is38")},
            {"0","is39",T("map.is39")},{"0","is40",T("map.is40")},{"0","is41",T("map.is41")},{"0","is42",T("map.is42")},{"0","is43",T("map.is43")},
            {"0","is44",T("map.is44")},{"0","is45",T("map.is45")},{"0","is46",T("map.is46")},{"0","is47",T("map.is47")},{"0","is48",T("map.is48")},
            {"0","is49",T("map.is49")},{"0","is50",T("map.is50")},{"0","is61",T("map.is61")},{"0","is62",T("map.is62")},{"0","is63",T("map.is63")},
            {"0","is66",T("map.is66")},{"0","is67",T("map.is67")},{"0","is68",T("map.is68")},{"0","is69",T("map.is69")},{"0","is70",T("map.is70")},
            {"0","is71",T("map.is71")},{"0","is72",T("map.is72")},{"0","is73",T("map.is73")},{"0","is74",T("map.is74")},{"0","is75",T("map.is75")},
            {"0","is76",T("map.is76")},{"0","is77",T("map.is77")},{"0","is78",T("map.is78")},{"0","is80",T("map.is80")},{"0","is81",T("map.is81")},
            {"0","is82",T("map.is82")},{"0","is83",T("map.is83")},{"0","is84",T("map.is84")},{"0","is85",T("map.is85")},{"0","is86",T("map.is86")},
            {"0","is87",T("map.is87")},{"0","is88",T("map.is88")},{"0","is89",T("map.is89")},{"0","is90",T("map.is90")},{"0","is91",T("map.is91")},
            {"0","is92",T("map.is92")},{"0","is93",T("map.is93")},{"0","is94",T("map.is94")},{"0","is95",T("map.is95")},{"0","is96",T("map.is96")},
            {"0","is97",T("map.is97")},{"0","is98",T("map.is98")},{"0","is99",T("map.is99")},{"0","is101",T("map.is101")},{"0","is102",T("map.is102")},
            {"0","is103",T("map.is103")},{"0","is105",T("map.is105")},{"0","is106",T("map.is106")},{"0","is107",T("map.is107")},{"0","is108",T("map.is108")},
            {"0","is109",T("map.is109")},{"0","bg01",T("map.bg01")},{"0","bg02",T("map.bg02")},{"0","bg03",T("map.bg03")},{"0","bg04",T("map.bg04")},
            {"0","bg05",T("map.bg05")},{"0","bg06",T("map.bg06")},{"0","arena01",T("map.arena01")},{"0","arena02",T("map.arena02")},
            {"0","arena03",T("map.arena03")},{"0","arena04",T("map.arena04")},{"0","rand03",T("map.rand03")},{"0","rand04",T("map.rand04")},
            {"0","rand05",T("map.rand05")}
        };
    } else {
        maps = new String[][]{
            {"0","gs01",T("map.gs01")},{"0","is01",T("map.is01")},{"0","is02",T("map.is02")},{"0","is05",T("map.is05")},{"0","is06",T("map.is06")},
            {"0","is07",T("map.is07")},{"0","is08",T("map.is08")},{"0","is09",T("map.is09")},{"0","is10",T("map.is10")},{"0","is11",T("map.is11")},
            {"0","is12",T("map.is12")},{"0","is13",T("map.is13")},{"0","is14",T("map.is14")},{"0","is15",T("map.is15")},{"0","is16",T("map.is16")},
            {"0","is17",T("map.is17")},{"0","is18",T("map.is18")},{"0","is19",T("map.is19")},{"0","is20",T("map.is20")},{"0","is21",T("map.is21")},
            {"0","is22",T("map.is22")},{"0","is23",T("map.is23")},{"0","is24",T("map.is24")},{"0","is25",T("map.is25")},{"0","is26",T("map.is26")},
            {"0","is27",T("map.is27")},{"0","is28",T("map.is28")},{"0","is29",T("map.is29")},{"0","is31",T("map.is31")},{"0","is32",T("map.is32")},
            {"0","is33",T("map.is33")},{"0","is34",T("map.is34")},{"0","is35",T("map.is35")},{"0","is37",T("map.is37")},{"0","is38",T("map.is38")},
            {"0","is39",T("map.is39")},{"0","is40",T("map.is40")},{"0","is41",T("map.is41")},{"0","is42",T("map.is42")},{"0","is43",T("map.is43")},
            {"0","is44",T("map.is44")},{"0","is45",T("map.is45")},{"0","is46",T("map.is46")},{"0","is47",T("map.is47")},{"0","is48",T("map.is48")},
            {"0","is49",T("map.is49")},{"0","is50",T("map.is50")},{"0","is61",T("map.is61")},{"0","is62",T("map.is62")},{"0","is63",T("map.is63")},
            {"0","is66",T("map.is66")},{"0","is67",T("map.is67")},{"0","is68",T("map.is68")},{"0","is69",T("map.is69")},{"0","is70",T("map.is70")},
            {"0","is71",T("map.is71")},{"0","is72",T("map.is72")},{"0","is73",T("map.is73")},{"0","is74",T("map.is74")},{"0","is75",T("map.is75")},
            {"0","is76",T("map.is76")},{"0","is77",T("map.is77")},{"0","is78",T("map.is78")},{"0","is80",T("map.is80")},{"0","is81",T("map.is81")},
            {"0","is82",T("map.is82")},{"0","is83",T("map.is83")},{"0","is84",T("map.is84")},{"0","is85",T("map.is85")},{"0","is86",T("map.is86")},
            {"0","is87",T("map.is87")},{"0","is88",T("map.is88")},{"0","is89",T("map.is89")},{"0","is90",T("map.is90")},{"0","is91",T("map.is91")},
            {"0","is92",T("map.is92")},{"0","is93",T("map.is93")},{"0","is94",T("map.is94")},{"0","is95",T("map.is95")},{"0","is96",T("map.is96")},
            {"0","is97",T("map.is97")},{"0","is98",T("map.is98")},{"0","is99",T("map.is99")},{"0","is101",T("map.is101")},{"0","is102",T("map.is102")},
            {"0","is103",T("map.is103")},{"0","is105",T("map.is105")},{"0","is106",T("map.is106")},{"0","is107",T("map.is107")},{"0","is108",T("map.is108")},
            {"0","is109",T("map.is109")},{"0","bg01",T("map.bg01")},{"0","bg02",T("map.bg02")},{"0","bg03",T("map.bg03")},{"0","bg04",T("map.bg04")},
            {"0","bg05",T("map.bg05")},{"0","bg06",T("map.bg06")},{"0","arena01",T("map.arena01")},{"0","arena02",T("map.arena02")},
            {"0","arena03",T("map.arena03")},{"0","arena04",T("map.arena04")},{"0","rand03",T("map.rand03")},{"0","rand04",T("map.rand04")},
            {"0","rand05",T("map.rand05")}
        };
    }

    // =========================================================================
    //                     QUÉT TIẾN TRÌNH ĐANG CHẠY
    // =========================================================================
    boolean server_running = false;
    int log_count = 0, auth_count = 0, unique_count = 0, gac_count = 0;
    int gfaction_count = 0, gdelivery_count = 0, glink_count = 0, gamedb_count = 0, map_count = 0;

    // ---- Đọc RAM/SWAP ----
    int memUsed = 0, memTotal = 1;
    int swpUsed = 0, swpTotal = 1;

    BufferedReader sysReader = null;
    try {
        Process pMem = Runtime.getRuntime().exec("free -m");
        sysReader = new BufferedReader(new InputStreamReader(pMem.getInputStream()));
        sysReader.readLine(); // bỏ dòng tiêu đề
        String memLine = sysReader.readLine();
        if (memLine != null) {
            String[] memParts = memLine.trim().split("\\s+");
            if (memParts.length > 2) {
                memTotal = Integer.parseInt(memParts[1]);
                memUsed = Integer.parseInt(memParts[2]);
            }
        }
        String swpLine = sysReader.readLine();
        if (swpLine != null) {
            String[] swpParts = swpLine.trim().split("\\s+");
            if (swpParts.length > 2) {
                swpTotal = Integer.parseInt(swpParts[1]);
                swpUsed = Integer.parseInt(swpParts[2]);
            }
        }
    } catch (Exception e) {
        // Giữ giá trị mặc định nếu không đọc được
    } finally {
        if (sysReader != null) {
            try { sysReader.close(); } catch (IOException ignored) {}
        }
    }

    // ---- Đọc danh sách tiến trình ----
    StringBuilder backupWarning = new StringBuilder();
    BufferedReader psReader = null;
    try {
        Process pSc = Runtime.getRuntime().exec("ps -A w");
        psReader = new BufferedReader(new InputStreamReader(pSc.getInputStream()));
        String line;
        while ((line = psReader.readLine()) != null) {
            // Bảo vệ: ps output phải đủ dài trước khi substring(27)
            if (line.length() <= 27) continue;
            String processLine = line.substring(27);

            // Phát hiện backup đang chạy
            if (processLine.contains("./pw_backup.sh")) {
                backupWarning.append("<span style=\"color:var(--phx-warning)\">")
                             .append(T("sctrl.msg.backup_running"))
                             .append("</span>");
            }

            // Đếm các daemon
            if (processLine.contains("./logservice"))    { log_count++;      server_running = true; }
            if (processLine.contains("./gauthd"))        { auth_count++;     server_running = true; }
            if (processLine.contains("./uniquenamed"))   { unique_count++;   server_running = true; }
            if (processLine.contains("./gacd"))          { gac_count++;      server_running = true; }
            if (processLine.contains("./gfactiond"))     { gfaction_count++; server_running = true; }
            if (processLine.contains("./gdeliveryd"))    { gdelivery_count++;server_running = true; }
            if (processLine.contains("./glinkd"))        { glink_count++;    }
            if (processLine.contains("./gamedbd"))       { gamedb_count++;   server_running = true; }

            // Kiểm tra map đang chạy
            for (int i = 0; i < maps.length; i++) {
                if (processLine.contains("./gs " + maps[i][1])) {
                    String[] parts = line.trim().split("\\s+");
                    maps[i][0] = (parts.length > 0) ? parts[0] : "ERROR";
                    map_count++;
                    server_running = true;
                }
            }
        }
    } catch (Exception e) {
        // Giữ giá trị mặc định nếu không quét được
    } finally {
        if (psReader != null) {
            try { psReader.close(); } catch (IOException ignored) {}
        }
    }

    // Ghép cảnh báo backup vào message
    if (backupWarning.length() > 0) {
        if (message.length() > 0) message += "<br>";
        message += backupWarning.toString();
    }

    // ---- Phân loại map: đang chạy / có sẵn ----
    List<String[]> runningMaps = new ArrayList<String[]>();
    List<String[]> availableMaps = new ArrayList<String[]>();
    for (int i = 0; i < maps.length; i++) {
        if (!"0".equals(maps[i][0]) && !"ERROR".equals(maps[i][0])) {
            runningMaps.add(maps[i]);
        } else {
            availableMaps.add(maps[i]);
        }
    }

    // ---- Kiểm tra server có đang hoạt động (để hiển thị nút Start/Stop) ----
    boolean anyDaemonRunning = (map_count > 0 || gamedb_count > 0 || glink_count > 0
        || gdelivery_count > 0 || gfaction_count > 0 || gac_count > 0
        || log_count > 0 || auth_count > 0 || unique_count > 0);
%>

<!-- ========================================================================= -->
<!--                            GIAO DIỆN HTML                                 -->
<!-- ========================================================================= -->

<!-- Toast container -->
<div class="phx-toast-container"></div>

<!-- Notification message -->
<% if (message != null && !message.isEmpty()) { %>
    <div class="phx-notify phx-notify-<%= (msgType != null && !msgType.isEmpty()) ? msgType : "warning" %> phx-mb-4">
        <i class="fa-solid fa-<%= "success".equals(msgType) ? "circle-check" : "error".equals(msgType) ? "circle-xmark" : "circle-info" %>"></i>
        <span><%= message %></span>
    </div>
<% } %>

<!-- PAGE HEADER -->
<div class="phx-page-header">
    <h1><i class="fa-solid fa-server" style="color:var(--phx-primary)"></i> <%= T("nav.server_control") %></h1>
    <p>Perfect World Server Management</p>
</div>

<!-- RAM / SWAP CHARTS (compact) -->
<div class="phx-chart-grid phx-chart-grid-sm phx-mb-4">
    <div class="phx-chart-box phx-chart-box-sm">
        <h3><i class="fa-solid fa-memory" style="color:var(--phx-primary)"></i> <%= T("sctrl.ram_usage") %></h3>
        <div style="display:flex;align-items:center;gap:12px;">
            <canvas id="ramChart" width="120" height="120" style="max-width:120px;max-height:120px;"></canvas>
            <div style="color:var(--phx-text-2);font-size:0.7rem;">
                <div style="color:var(--phx-text);font-weight:700;font-size:1rem;"><%= memUsed %> <span style="font-size:0.7rem;color:var(--phx-text-2);">MB</span></div>
                <div style="margin-top:2px;">/ <%= memTotal %> MB</div>
            </div>
        </div>
    </div>
    <div class="phx-chart-box phx-chart-box-sm">
        <h3><i class="fa-solid fa-hard-drive" style="color:var(--phx-accent)"></i> <%= T("sctrl.swap_usage") %></h3>
        <div style="display:flex;align-items:center;gap:12px;">
            <canvas id="swapChart" width="120" height="120" style="max-width:120px;max-height:120px;"></canvas>
            <div style="color:var(--phx-text-2);font-size:0.7rem;">
                <div style="color:var(--phx-text);font-weight:700;font-size:1rem;"><%= swpUsed %> <span style="font-size:0.7rem;color:var(--phx-text-2);">MB</span></div>
                <div style="margin-top:2px;">/ <%= swpTotal %> MB</div>
            </div>
        </div>
    </div>
</div>

<!-- DAEMON STATUS -->
<div class="phx-card phx-mb-4">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-microchip"></i> <%= T("sctrl.game_services") %></h2>
        <span class="phx-badge <%= server_running ? "phx-badge-success" : "phx-badge-danger" %>">
            <span class="phx-status-dot <%= server_running ? "online pulse" : "offline" %>"></span>
            <%= server_running ? "Online" : "Offline" %>
        </span>
    </div>
    <div class="phx-daemon-grid">
        <%
            String[][] daemons = {
                {"logservice",  T("sctrl.logservice"),  String.valueOf(log_count)},
                {"gauthd",      T("sctrl.auth_daemon"),  String.valueOf(auth_count)},
                {"uniquenamed", T("sctrl.unique_name"),  String.valueOf(unique_count)},
                {"gacd",        T("sctrl.anti_cheat"),   String.valueOf(gac_count)},
                {"gfactiond",   T("sctrl.faction"),      String.valueOf(gfaction_count)},
                {"gdeliveryd",  T("sctrl.delivery"),     String.valueOf(gdelivery_count)},
                {"glinkd",      T("sctrl.link"),         String.valueOf(glink_count)},
                {"gamedbd",     T("sctrl.database"),     String.valueOf(gamedb_count)},
                {"gs",          T("sctrl.map_service"),  String.valueOf(map_count)}
            };
            for (String[] d : daemons) {
                boolean on = Integer.parseInt(d[2]) > 0;
        %>
        <div class="phx-daemon-card <%= on ? "online" : "offline" %>">
            <div class="phx-daemon-icon">
                <i class="fa-solid <%= on ? "fa-check" : "fa-xmark" %>"></i>
            </div>
            <div class="phx-daemon-info">
                <div class="name"><%= d[1] %></div>
                <div class="status"><%= on ? "Đang chạy" : "Đã dừng" %></div>
            </div>
            <span class="phx-status-dot <%= on ? "online pulse" : "offline" %>"></span>
        </div>
        <% } %>
    </div>
</div>

<!-- SERVER START/STOP -->
<div class="phx-card phx-mb-4">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-power-off"></i> <%= T("sctrl.server_start") %></h2>
    </div>
    <div class="phx-btn-group phx-flex-center">
        <% if (anyDaemonRunning) { %>
            <form action="index.jsp?page=serverctrl&process=stopserver" method="post" onsubmit="return phxConfirm('Bạn có chắc muốn DỪNG Server? Tất cả người chơi sẽ bị ngắt kết nối.')" style="margin:0;">
                <button class="phx-btn phx-btn-danger phx-btn-lg">
                    <i class="fa-solid fa-stop"></i> <%= T("sctrl.stop_server_btn") %>
                </button>
            </form>
        <% } else { %>
            <form action="index.jsp?page=serverctrl&process=startserver" method="post" style="margin:0;">
                <button class="phx-btn phx-btn-success phx-btn-lg">
                    <i class="fa-solid fa-play"></i> <%= T("sctrl.start_server_btn") %>
                </button>
            </form>
        <% } %>
    </div>
</div>

<!-- MAPS -->
<div class="phx-card phx-mb-4">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-map"></i> <%= T("sctrl.maps") %></h2>
        <div class="phx-btn-group">
            <form action="index.jsp?page=serverctrl&process=stopallmaps" method="post" style="margin:0;" onsubmit="return phxConfirm('Bạn có chắc muốn DỪNG TẤT CẢ bản đồ?')">
                <input type="hidden" name="time" value="300">
                <button class="phx-btn phx-btn-danger phx-btn-sm">
                    <i class="fa-solid fa-stop-circle"></i> <%= T("sctrl.stop_all_maps") %>
                </button>
            </form>
        </div>
    </div>

    <div class="phx-row">
        <!-- RUNNING MAPS -->
        <div class="phx-col">
            <div class="phx-flex-between phx-mb-2">
                <h3 style="font-size:var(--phx-font-size-sm);color:var(--phx-text);font-weight:600;">
                    <span class="phx-status-dot online pulse" style="margin-right:6px;"></span>
                    <%= Tf("sctrl.online_maps", map_count) %>
                </h3>
            </div>
            <form action="index.jsp?page=serverctrl&process=stopmap" method="post">
                <div class="phx-map-running">
                    <% if (runningMaps.isEmpty()) { %>
                        <div class="phx-empty-state" style="padding:24px;">
                            <i class="fa-solid fa-map-location-dot"></i>
                            <p>Không có bản đồ nào đang chạy</p>
                        </div>
                    <% } else {
                        for (String[] rm : runningMaps) { %>
                        <div class="phx-map-running-item">
                            <span class="phx-map-id" style="background:var(--phx-success-dim);color:var(--phx-success);min-width:52px;text-align:center;font-family:var(--phx-font-mono);font-size:0.7rem;font-weight:700;padding:3px 8px;border-radius:4px;"><%= rm[1] %></span>
                            <span style="flex:1;font-size:var(--phx-font-size-sm);color:var(--phx-text);"><%= rm[2] %></span>
                            <span class="phx-pid">PID:<%= rm[0] %></span>
                            <input type="checkbox" name="map" value="<%= rm[0] %>" style="accent-color:var(--phx-danger);">
                        </div>
                    <% }} %>
                </div>
                <% if (!runningMaps.isEmpty()) { %>
                    <button class="phx-btn phx-btn-danger phx-btn-sm phx-mt-2" style="width:100%;">
                        <i class="fa-solid fa-stop"></i> <%= T("sctrl.stop_selected") %>
                    </button>
                <% } %>
            </form>
        </div>

        <!-- AVAILABLE MAPS (Searchable Grid) -->
        <div class="phx-col">
            <h3 style="font-size:var(--phx-font-size-sm);color:var(--phx-text);font-weight:600;margin-bottom:8px;">
                <i class="fa-solid fa-map-pin" style="color:var(--phx-primary)"></i> <%= T("sctrl.available_maps") %>
            </h3>
            <%
                // Build JSON for Alpine.js map manager
                // CRITICAL: Use single-quote HTML attribute to avoid conflict with JSON double-quotes
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < availableMaps.size(); i++) {
                    if (i > 0) json.append(",");
                    // Proper JSON escape: backslash FIRST, then quote, then control chars, then single-quote
                    String safeName = availableMaps.get(i)[2]
                        .replace("\\", "\\\\")
                        .replace("\"", "\\\"")
                        .replace("'", "\\u0027")
                        .replace("\n", "\\n")
                        .replace("\r", "\\r")
                        .replace("\t", "\\t");
                    json.append("{\"id\":\"")
                        .append(availableMaps.get(i)[1])
                        .append("\",\"name\":\"")
                        .append(safeName)
                        .append("\"}");
                }
                json.append("]");
                String mapJson = json.toString();
            %>
            <div x-data='phxMapManager(<%= mapJson %>)'>
                <!-- Search -->
                <div class="phx-search phx-mb-2">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input class="phx-input" type="text" x-model="search" placeholder="Tìm kiếm bản đồ...">
                </div>
                <!-- Quick actions -->
                <div class="phx-map-actions">
                    <button type="button" class="phx-btn phx-btn-ghost phx-btn-sm" @click="selectAll()">
                        <i class="fa-solid fa-check-double"></i> Chọn tất
                    </button>
                    <button type="button" class="phx-btn phx-btn-ghost phx-btn-sm" @click="deselectAll()">
                        <i class="fa-solid fa-xmark"></i> Bỏ chọn
                    </button>
                    <span class="phx-map-count">Đã chọn: <strong x-text="selectedCount" style="color:var(--phx-primary)">0</strong></span>
                </div>
                <!-- Map grid -->
                <div class="phx-map-grid">
                    <template x-for="map in filteredMaps" :key="map.id">
                        <div class="phx-map-card"
                             :class="{selected: isSelected(map)}"
                             @click="toggleMap(map)"
                             :title="map.id + ' - ' + map.name">
                            <span class="phx-map-id" x-text="map.id"></span>
                            <span class="phx-map-name" x-text="map.name"></span>
                            <span class="phx-map-check">
                                <i class="fa-solid fa-check" x-show="isSelected(map)"></i>
                            </span>
                        </div>
                    </template>
                    <!-- Fallback when no maps match search -->
                    <div class="phx-empty-state" style="padding:20px;grid-column:1/-1;" x-show="filteredMaps.length === 0">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <p>Không tìm thấy bản đồ nào khớp với "<span x-text="search"></span>"</p>
                    </div>
                </div>
                <!-- Start form -->
                <form action="index.jsp?page=serverctrl&process=startmap" method="post" class="phx-mt-2">
                    <template x-for="id in selected" :key="id">
                        <input type="hidden" name="map" :value="id">
                    </template>
                    <button type="submit" class="phx-btn phx-btn-success phx-btn-sm" style="width:100%;" :disabled="selectedCount === 0">
                        <i class="fa-solid fa-play"></i> <%= T("sctrl.start_selected") %>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js + Biểu đồ -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
(function() {
    var chartDefaults = {
        type: 'doughnut',
        options: {
            responsive: true,
            maintainAspectRatio: true,
            cutout: '68%',
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#1a2332',
                    titleColor: '#f1f5f9',
                    bodyColor: '#94a3b8',
                    borderColor: '#263148',
                    borderWidth: 1
                }
            }
        }
    };

    var ramTotal = <%= memTotal %>;
    var ramUsed = <%= memUsed %>;
    var ramFree = Math.max(0, ramTotal - ramUsed);

    new Chart(document.getElementById('ramChart'), {
        type: chartDefaults.type,
        options: chartDefaults.options,
        data: {
            labels: ['Đã dùng', 'Còn trống'],
            datasets: [{
                data: [ramUsed, ramFree],
                backgroundColor: ['#ef4444', '#1a2332'],
                borderColor: ['#ef4444', '#263148'],
                borderWidth: 2,
                hoverBorderColor: ['#f87171', '#334155']
            }]
        }
    });

    var swpTotal = <%= swpTotal %>;
    var swpUsed = <%= swpUsed %>;
    var swpFree = Math.max(0, swpTotal - swpUsed);

    new Chart(document.getElementById('swapChart'), {
        type: chartDefaults.type,
        options: chartDefaults.options,
        data: {
            labels: ['Đã dùng', 'Còn trống'],
            datasets: [{
                data: [swpUsed, swpFree],
                backgroundColor: ['#f59e0b', '#1a2332'],
                borderColor: ['#f59e0b', '#263148'],
                borderWidth: 2,
                hoverBorderColor: ['#fbbf24', '#334155']
            }]
        }
    });
})();
</script>
