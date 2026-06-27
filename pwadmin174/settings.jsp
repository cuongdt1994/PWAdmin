<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*,java.sql.*"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%!
    private String genSalt() { return BCrypt.gensalt(); }
    private static String hashPw(String p, String s) { return BCrypt.hashpw(p, s); }
    private static Connection getC(String h,String p,String d,String u,String pw) throws SQLException {
        try{Class.forName("com.mysql.jdbc.Driver");}catch(ClassNotFoundException e){throw new SQLException(e);}
        return DriverManager.getConnection("jdbc:mysql://"+h+":"+p+"/"+d,u,pw);
    }
    private static String runCmd(String cmd) {
        StringBuilder o=new StringBuilder();
        try{Process pr=Runtime.getRuntime().exec(cmd);
            BufferedReader r=new BufferedReader(new InputStreamReader(pr.getInputStream()));
            String l;while((l=r.readLine())!=null)o.append(l).append("\n");r.close();
            r=new BufferedReader(new InputStreamReader(pr.getErrorStream()));
            while((l=r.readLine())!=null)o.append("Error: ").append(l).append("\n");r.close();
            pr.waitFor();}catch(Exception e){o.append("Error: ").append(e.getMessage());}
        return o.toString();
    }
    String srvPath=null; BufferedReader srvReader=null;
%>

<div class="phx-page-header">
    <h1><i class="fa-solid fa-cog" style="color:var(--phx-primary)"></i> <%= T("nav.settings") %></h1>
    <p>Cấu hình hệ thống pwAdmin</p>
</div>

<div class="phx-card" x-data="{tab: '<%= request.getParameter("settings_tab") != null ? request.getParameter("settings_tab") : "general" %>'}">
    <div class="phx-tabs">
        <button class="phx-tab" :class="{active:tab==='general'}" @click="tab='general'"><i class="fa-solid fa-sliders"></i> <%= T("settings.tab.general") %></button>
        <button class="phx-tab" :class="{active:tab==='whitelist'}" @click="tab='whitelist'"><i class="fa-solid fa-shield-halved"></i> <%= T("settings.tab.whitelist") %></button>
        <button class="phx-tab" :class="{active:tab==='create_gm'}" @click="tab='create_gm'"><i class="fa-solid fa-user-gear"></i> <%= T("settings.tab.create_gm") %></button>
        <button class="phx-tab" :class="{active:tab==='backups'}" @click="tab='backups'"><i class="fa-solid fa-box-archive"></i> <%= T("settings.tab.backups") %></button>
    </div>

    <%-- ==================== GENERAL TAB ==================== --%>
    <div x-show="tab==='general'" x-transition>
        <%
            Properties props=new Properties();
            FileInputStream fisG=null;
            File cf=new File(application.getRealPath("WEB-INF/.pwadminconf.properties"));
            boolean eipw=false, eat=false, ecl=false;
            if(cf.exists()){
                try{fisG=new FileInputStream(cf);props.load(fisG);
                    eipw=Boolean.parseBoolean(props.getProperty("enable_ip_whitelist","false"));
                    eat=Boolean.parseBoolean(props.getProperty("enable_addons_tab","false"));
                    ecl=Boolean.parseBoolean(props.getProperty("enable_char_list","false"));
                }catch(Exception e){}finally{if(fisG!=null)try{fisG.close();}catch(Exception e){}}
            }
            // ONLY process POST for general tab
            String tabParam = request.getParameter("settings_tab");
            if("POST".equalsIgnoreCase(request.getMethod()) && (tabParam==null||"general".equals(tabParam))){
                FileOutputStream fos=null;
                try{
                    props.setProperty("enable_ip_whitelist",String.valueOf(request.getParameter("enable_ip_whitelist")!=null));
                    props.setProperty("enable_addons_tab",String.valueOf(request.getParameter("enable_addons_tab")!=null));
                    props.setProperty("enable_char_list",String.valueOf(request.getParameter("enable_char_list")!=null));
                    fos=new FileOutputStream(cf);props.store(fos,"Updated");
                    out.print("<div class=\"phx-notify phx-notify-success phx-mb-2\"><i class=\"fa-solid fa-circle-check\"></i> "+T("settings.msg.updated")+"</div>");
                }catch(Exception e){
                    out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> "+Tf("settings.msg.error",e.getMessage())+"</div>");
                }finally{if(fos!=null)try{fos.close();}catch(Exception e){}}
            }
        %>
        <form action="index.jsp?page=settings&settings_tab=general" method="post">
            <div class="phx-form-group">
                <label class="phx-toggle-wrap">
                    <span class="phx-toggle"><input type="checkbox" name="enable_ip_whitelist" <%=eipw?"checked":""%>><span class="phx-toggle-track"></span></span>
                    <span class="phx-toggle-label"><%=T("settings.enable_ip_wl")%></span>
                </label>
            </div>
            <div class="phx-form-group">
                <label class="phx-toggle-wrap">
                    <span class="phx-toggle"><input type="checkbox" name="enable_addons_tab" <%=eat?"checked":""%>><span class="phx-toggle-track"></span></span>
                    <span class="phx-toggle-label"><%=T("settings.enable_addons")%></span>
                </label>
            </div>
            <div class="phx-form-group">
                <label class="phx-toggle-wrap">
                    <span class="phx-toggle"><input type="checkbox" name="enable_char_list" <%=ecl?"checked":""%>><span class="phx-toggle-track"></span></span>
                    <span class="phx-toggle-label"><%=T("settings.enable_charlist")%></span>
                </label>
            </div>
            <button class="phx-btn phx-btn-primary"><i class="fa-solid fa-floppy-disk"></i> <%=T("settings.btn.save")%></button>
        </form>
    </div>

    <%-- ==================== WHITELIST TAB ==================== --%>
    <div x-show="tab==='whitelist'" x-transition>
        <%
            File wlf=new File(application.getRealPath("WEB-INF/whitelist.txt"));
            ArrayList<String> wl=new ArrayList<String>();
            try{if(wlf.exists()){BufferedReader br=new BufferedReader(new FileReader(wlf));String l;while((l=br.readLine())!=null)wl.add(l.trim());br.close();}}catch(Exception e){}
            // ONLY process POST for whitelist tab
            if("POST".equalsIgnoreCase(request.getMethod()) && "whitelist".equals(tabParam)){
                try{
                    String add=request.getParameter("add_ip");
                    String[] del=request.getParameterValues("delete_ips");
                    if(add!=null&&!add.trim().isEmpty()){
                        add=add.trim();
                        if(add.matches("^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$"))
                            wl.add(add);
                        else out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> "+T("settings.wl.msg.invalid")+add+"</div>");
                    }
                    if(del!=null)for(String d:del)wl.remove(d);
                    BufferedWriter bw=new BufferedWriter(new FileWriter(wlf,false));
                    for(String ip:wl)bw.write(ip+"\n");bw.close();
                    out.print("<div class=\"phx-notify phx-notify-success\"><i class=\"fa-solid fa-circle-check\"></i> "+T("settings.wl.msg.updated")+"</div>");
                }catch(Exception e){
                    out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> "+Tf("settings.msg.error",e.getMessage())+"</div>");
                }
            }
        %>
        <form action="index.jsp?page=settings&settings_tab=whitelist" method="post" onsubmit="var ip=document.getElementById('addIpInput').value;if(ip&&!/^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$/.test(ip)){alert(\"IP khong hop le!\");return false;}return true;">
            <div class="phx-form-group">
                <label class="phx-label"><%=T("settings.wl.add_ip")%></label>
                <input class="phx-input" type="text" name="add_ip" id="addIpInput" placeholder="<%=T("settings.wl.ip_placeholder")%>">
            </div>
            <div class="phx-table-wrap" style="max-height:300px;">
                <table class="phx-table">
                    <thead><tr><th><%=T("settings.wl.table.ip")%></th><th style="width:60px;"><%=T("settings.wl.table.delete")%></th></tr></thead>
                    <tbody><%for(String ip:wl){%><tr><td style="font-family:var(--phx-font-mono);"><%=ip%></td><td style="text-align:center;"><input type="checkbox" name="delete_ips" value="<%=ip%>"></td></tr><%}%></tbody>
                </table>
            </div>
            <button class="phx-btn phx-btn-primary phx-mt-4"><i class="fa-solid fa-floppy-disk"></i> <%=T("settings.wl.btn.update")%></button>
        </form>
    </div>

    <%-- ==================== GM ACCOUNTS TAB ==================== --%>
    <div x-show="tab==='create_gm'" x-transition>
        <%
            Connection conn=null; PreparedStatement pstmt=null; ResultSet rs=null;
            List<Map<String,Object> > gmUsers=new ArrayList<Map<String,Object> >();
            try{
                conn=getC(db_host,db_port,db_database,db_user,db_password);
                DatabaseMetaData dbm=conn.getMetaData();
                ResultSet tables=dbm.getTables(null,null,"gmpanel_users",null);
                if(!tables.next()){
                    pstmt=conn.prepareStatement("CREATE TABLE gmpanel_users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) UNIQUE NOT NULL, password_hash VARCHAR(255) NOT NULL, salt VARCHAR(255) NOT NULL, settings_access BOOLEAN DEFAULT FALSE, whitelist_access BOOLEAN DEFAULT FALSE, account_access BOOLEAN DEFAULT FALSE, role_access BOOLEAN DEFAULT FALSE, server_access BOOLEAN DEFAULT FALSE, serverctrl_access BOOLEAN DEFAULT FALSE)");
                    pstmt.executeUpdate();
                    out.print("<div class=\"phx-notify phx-notify-success\"><i class=\"fa-solid fa-circle-check\"></i> "+T("settings.gm.msg.table_created")+"</div>");
                }
                // ONLY process POST for GM tab
                if("POST".equalsIgnoreCase(request.getMethod()) && "create_gm".equals(tabParam)){
                    if(request.getParameter("create_gm_user")!=null){
                        String un=request.getParameter("gm_username");
                        String pw=request.getParameter("gm_password");
                        String salt=genSalt();
                        String hash=hashPw(pw,salt);
                        pstmt=conn.prepareStatement("INSERT INTO gmpanel_users (username,password_hash,salt,settings_access,whitelist_access,account_access,role_access,server_access,serverctrl_access) VALUES (?,?,?,?,?,?,?,?,?)");
                        pstmt.setString(1,un);pstmt.setString(2,hash);pstmt.setString(3,salt);
                        pstmt.setBoolean(4,request.getParameter("settings_access")!=null);
                        pstmt.setBoolean(5,request.getParameter("whitelist_access")!=null);
                        pstmt.setBoolean(6,request.getParameter("account_access")!=null);
                        pstmt.setBoolean(7,request.getParameter("role_access")!=null);
                        pstmt.setBoolean(8,request.getParameter("server_access")!=null);
                        pstmt.setBoolean(9,request.getParameter("serverctrl_access")!=null);
                        pstmt.executeUpdate();
                        out.print("<div class=\"phx-notify phx-notify-success\"><i class=\"fa-solid fa-circle-check\"></i> "+T("settings.gm.msg.created")+"</div>");
                    }
                    if(request.getParameterValues("delete_gm_user")!=null){
                        for(String uid:request.getParameterValues("delete_gm_user")){
                            pstmt=conn.prepareStatement("DELETE FROM gmpanel_users WHERE id=?");
                            pstmt.setInt(1,Integer.parseInt(uid));pstmt.executeUpdate();
                        }
                        out.print("<div class=\"phx-notify phx-notify-success\"><i class=\"fa-solid fa-circle-check\"></i> "+T("settings.gm.msg.deleted")+"</div>");
                    }
                }
                pstmt=conn.prepareStatement("SELECT id,username FROM gmpanel_users");rs=pstmt.executeQuery();
                while(rs.next()){Map<String,Object> u=new HashMap<String,Object>();u.put("id",rs.getInt("id"));u.put("username",rs.getString("username"));gmUsers.add(u);}
            }catch(Exception e){
                out.print("<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> "+Tf("settings.gm.msg.db_error",e.getMessage())+"</div>");
            }finally{
                try{if(rs!=null)rs.close();}catch(Exception e){}
                try{if(pstmt!=null)pstmt.close();}catch(Exception e){}
                try{if(conn!=null)conn.close();}catch(Exception e){}
            }
        %>
        <% if(!gmUsers.isEmpty()){ %>
            <form action="index.jsp?page=settings&settings_tab=create_gm" method="post" class="phx-mb-4">
                <div class="phx-row">
                    <% for(Map<String,Object> u:gmUsers){ %>
                    <div class="phx-col" style="min-width:200px;">
                        <label class="phx-toggle-wrap">
                            <input type="checkbox" name="delete_gm_user" value="<%=u.get("id")%>">
                            <span class="phx-toggle-label"><%=u.get("username")%></span>
                        </label>
                    </div>
                    <% } %>
                </div>
                <button class="phx-btn phx-btn-danger phx-btn-sm"><i class="fa-solid fa-trash"></i> <%=T("settings.gm.btn.delete")%></button>
            </form>
        <% } %>
        <form action="index.jsp?page=settings&settings_tab=create_gm" method="post">
            <input type="hidden" name="create_gm_user" value="true">
            <div class="phx-row">
                <div class="phx-col"><div class="phx-form-group"><label class="phx-label"><%=T("settings.gm.username")%></label><input class="phx-input" type="text" name="gm_username" required></div></div>
                <div class="phx-col"><div class="phx-form-group"><label class="phx-label"><%=T("settings.gm.password")%></label><input class="phx-input" type="password" name="gm_password" required></div></div>
            </div>
            <div class="phx-row">
                <% String[][] perms={{"settings_access",T("settings.gm.allow_settings")},{"whitelist_access",T("settings.gm.allow_whitelist")},{"account_access",T("settings.gm.allow_account")},{"role_access",T("settings.gm.allow_role")},{"server_access",T("settings.gm.allow_server")},{"serverctrl_access",T("settings.gm.allow_sctrl")}};
                   for(String[] pm:perms){ %>
                <div class="phx-col" style="min-width:200px;"><label class="phx-toggle-wrap"><span class="phx-toggle"><input type="checkbox" name="<%=pm[0]%>"><span class="phx-toggle-track"></span></span><span class="phx-toggle-label"><%=pm[1]%></span></label></div>
                <% } %>
            </div>
            <button class="phx-btn phx-btn-primary phx-mt-4"><i class="fa-solid fa-user-plus"></i> <%=T("settings.gm.btn.create")%></button>
        </form>
    </div>

    <%-- ==================== BACKUPS TAB ==================== --%>
    <div x-show="tab==='backups'" x-transition>
        <%
            String bkMsg="";
            try{File jspFile=new File(application.getRealPath("WEB-INF/.pwadminconf.jsp"));
                if(jspFile.exists()){srvReader=new BufferedReader(new FileReader(jspFile));String l;
                    while((l=srvReader.readLine())!=null){if(l.contains("String pw_server_path =")){String[] p=l.split("=");if(p.length>1)srvPath=p[1].trim().replaceAll("[\";]","");break;}}}
            }catch(Exception e){}finally{if(srvReader!=null)try{srvReader.close();}catch(Exception e){}}
            // ONLY process POST for backups tab
            if("POST".equalsIgnoreCase(request.getMethod()) && "backups".equals(tabParam) && request.getParameter("local_backup")!=null){
                String lpath=request.getParameter("local_backup_path");
                boolean full=request.getParameter("full_backup")!=null;
                boolean dbBk=request.getParameter("db_backup")!=null;
                if(lpath==null||lpath.trim().isEmpty()){
                    bkMsg="<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> "+T("settings.backup.msg.no_path")+"</div>";
                }else{
                    String ts = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
                    // Local file backup
                    String bf=lpath+"/server_backup_"+ts+".tar.gz";
                    String cmd;
                    if(full){
                        cmd="tar -czvf "+bf+" -C "+srvPath+" .";
                    }else{
                        StringBuilder fb=new StringBuilder();
                        String[] bfs={"authd","gacd","gamed","gamedbd","gdeliveryd","gfactiond","glinkd","logs","logservice","pwadmin"};
                        for(String f:bfs)if(request.getParameter(f)!=null)fb.append(" ").append(f);
                        cmd="tar -czvf "+bf+" -C "+srvPath+fb.toString();
                    }
                    String r=runCmd(cmd);
                    bkMsg=r.contains("Error")?
                        "<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> "+T("settings.backup.msg.error_local")+r+"</div>":
                        "<div class=\"phx-notify phx-notify-success\"><i class=\"fa-solid fa-circle-check\"></i> "+T("settings.backup.msg.created")+bf+"</div>";
                    // DB backup
                    if(dbBk){
                        String dbf=lpath+"/db_backup_"+ts+".sql";
                        try{
                            ProcessBuilder pb=new ProcessBuilder("mysqldump","-h",db_host,"-P",db_port,"-u",db_user,"-p"+db_password,db_database);
                            pb.redirectOutput(new File(dbf));pb.redirectErrorStream(true);
                            Process pr=pb.start();pr.waitFor();
                            bkMsg+="<div class=\"phx-notify phx-notify-success\"><i class=\"fa-solid fa-circle-check\"></i> "+T("settings.backup.msg.db_created")+dbf+"</div>";
                        }catch(Exception e){
                            bkMsg+="<div class=\"phx-notify phx-notify-error\"><i class=\"fa-solid fa-circle-xmark\"></i> "+T("settings.backup.msg.error_db")+e.getMessage()+"</div>";
                        }
                    }
                }
            }
            if(!bkMsg.isEmpty())out.print(bkMsg);
        %>
        <% if(srvPath==null||srvPath.isEmpty()){ %>
            <div class="phx-notify phx-notify-error"><i class="fa-solid fa-circle-xmark"></i> <%=T("settings.backup.msg.no_srv_path")%></div>
        <% }else{ %>
        <form action="index.jsp?page=settings&settings_tab=backups" method="post">
            <div class="phx-row">
                <div class="phx-col">
                    <h3 style="font-size:var(--phx-font-size-sm);font-weight:600;color:var(--phx-text);margin-bottom:8px;"><%=T("settings.backup.select")%></h3>
                    <label class="phx-toggle-wrap phx-mb-2"><span class="phx-toggle"><input type="checkbox" name="full_backup"><span class="phx-toggle-track"></span></span><span class="phx-toggle-label"><%=Tf("settings.backup.full",srvPath)%></span></label>
                    <% String[] bfs2={"authd","gacd","gamed","gamedbd","gdeliveryd","gfactiond","glinkd","logs","logservice","pwadmin"};
                       for(String f:bfs2){ %>
                    <label class="phx-toggle-wrap phx-mb-2"><span class="phx-toggle"><input type="checkbox" name="<%=f%>"><span class="phx-toggle-track"></span></span><span class="phx-toggle-label"><%=f%></span></label>
                    <% } %>
                    <label class="phx-toggle-wrap phx-mb-2"><span class="phx-toggle"><input type="checkbox" name="db_backup"><span class="phx-toggle-track"></span></span><span class="phx-toggle-label"><%=Tf("settings.backup.db",db_database)%></span></label>
                </div>
                <div class="phx-col">
                    <div class="phx-form-group"><label class="phx-label"><%=T("settings.backup.local_path")%></label><input class="phx-input" type="text" name="local_backup_path" placeholder="<%=T("settings.backup.path_placeholder")%>"></div>
                    <button class="phx-btn phx-btn-primary" name="local_backup"><i class="fa-solid fa-box-archive"></i> <%=T("settings.backup.btn.create")%></button>
                </div>
            </div>
        </form>
        <% } %>
    </div>
</div>