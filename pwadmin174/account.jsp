<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.lang.*,java.sql.*,java.util.*,java.security.*"%>
<%@page import="org.apache.commons.logging.*,org.apache.catalina.util.*,com.goldhuman.util.LocaleUtil"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>
<%!
    String pw_encode(String salt, MessageDigest alg) {
        alg.reset(); alg.update(salt.getBytes());
        return Base64.encode(alg.digest()).toString();
    }
%>
<%
    boolean allowed = session.getAttribute("ssid") != null;
    if(!allowed) out.println("<div class=\"phx-empty-state\"><i class=\"fa-solid fa-lock\"></i><p>" + T("acct.login_required") + "</p></div>");

    String msg = "", msgType = "";
    if(request.getParameter("action") != null) {
        String action = request.getParameter("action");

        if(action.compareTo("adduser") == 0) {
            String login = request.getParameter("getlogin").toLowerCase();
            String mail = request.getParameter("getmail").toLowerCase();
            String password = request.getParameter("password");
            if(login.length()>0 && password.length()>0) {
                if(login.length()<4||login.length()>10||password.length()<4||password.length()>10) {
                    msg = T("acct.msg.only_4_10"); msgType = "error";
                } else {
                    String alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_";
                    boolean check = true;
                    for(int i=0;i<login.length();i++) if(alphabet.indexOf(login.charAt(i))==-1){check=false;break;}
                    for(int i=0;i<password.length();i++) if(alphabet.indexOf(password.charAt(i))==-1){check=false;break;}
                    if(!check) { msg = T("acct.msg.forbidden_chars"); msgType = "error"; }
                    else {
                        try {
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            Connection c = DriverManager.getConnection("jdbc:mysql://"+db_host+":"+db_port+"/"+db_database,db_user,db_password);
                            Statement s = c.createStatement();
                            ResultSet rs = s.executeQuery("SELECT * FROM users WHERE name='"+login+"'");
                            int count=0; while(rs.next()) count++;
                            if(count>0) { msg = T("acct.msg.user_exists"); msgType = "error"; }
                            else {
                                password = pw_encode(login+password, MessageDigest.getInstance("MD5"));
                                s.executeQuery("CALL adduser('"+login+"','"+password+"','0','0','0','0','"+mail+"','0','0','0','0','0','0','0',NULL,'','"+password+"')");
                                msg = T("acct.msg.account_created"); msgType = "success";
                            }
                            rs.close(); s.close(); c.close();
                        } catch(Exception e) { msg = T("acct.msg.db_failed"); msgType = "error"; }
                    }
                }
            }
        }

        if(action.compareTo("passwd") == 0) {
            String login = request.getParameter("getlogin").toLowerCase();
            String pwOld = request.getParameter("password_old");
            String pwNew = request.getParameter("password_new");
            if(login.length()>0 && pwOld.length()>0 && pwNew.length()>0) {
                if(pwNew.length()<4||pwNew.length()>10) { msg = T("acct.msg.only_4_10"); msgType = "error"; }
                else {
                    String alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_";
                    boolean check = true;
                    for(int i=0;i<pwNew.length();i++) if(alphabet.indexOf(pwNew.charAt(i))==-1){check=false;break;}
                    if(!check) { msg = T("acct.msg.forbidden_chars"); msgType = "error"; }
                    else {
                        try {
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            Connection c = DriverManager.getConnection("jdbc:mysql://"+db_host+":"+db_port+"/"+db_database,db_user,db_password);
                            Statement s = c.createStatement();
                            ResultSet rs = s.executeQuery("SELECT ID,passwd,email FROM users WHERE name='"+login+"'");
                            String email="",pwStored="",idStored=""; int count=0;
                            while(rs.next()){email=rs.getString("email");idStored=rs.getString("ID");pwStored=rs.getString("passwd");count++;}
                            if(count<=0){msg=T("acct.msg.user_not_exist");msgType="error";}
                            else {
                                pwOld = pw_encode(login+pwOld, MessageDigest.getInstance("MD5"));
                                s.executeQuery("CALL adduser('"+login+"_TEMP_USER','"+pwOld+"','0','0','0','0','','0','0','0','0','0','0','0',NULL,'','"+pwOld+"')");
                                rs = s.executeQuery("SELECT passwd FROM users WHERE name='"+login+"_TEMP_USER'"); rs.next();
                                pwOld = rs.getString("passwd");
                                s.executeUpdate("DELETE FROM users WHERE name='"+login+"_TEMP_USER'");
                                if(pwOld.compareTo(pwStored)!=0){msg=T("acct.msg.old_pass_wrong");msgType="error";}
                                else {
                                    pwNew = pw_encode(login+pwNew, MessageDigest.getInstance("MD5"));
                                    s.executeUpdate("LOCK TABLE users WRITE");
                                    s.executeUpdate("DELETE FROM users WHERE name='"+login+"'");
                                    s.executeQuery("CALL adduser('"+login+"','"+pwNew+"','0','0','0','0','"+email+"','0','0','0','0','0','0','0',NULL,'','"+pwNew+"')");
                                    s.executeUpdate("UPDATE users SET ID='"+idStored+"' WHERE name='"+login+"'");
                                    s.executeUpdate("UNLOCK TABLES");
                                    msg = T("acct.msg.password_changed"); msgType = "success";
                                }
                            }
                            rs.close(); s.close(); c.close();
                        } catch(Exception e) { msg = T("acct.msg.db_failed"); msgType = "error"; }
                    }
                }
            }
        }

        if(action.compareTo("deluser") == 0 && allowed) {
            String type=request.getParameter("type"),ident=request.getParameter("ident"),character=request.getParameter("character");
            if(type.length()>0&&ident.length()>0&&character.length()>0) {
                try {
                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                    Connection c = DriverManager.getConnection("jdbc:mysql://"+db_host+":"+db_port+"/"+db_database,db_user,db_password);
                    Statement s = c.createStatement(); ResultSet rs; int count;
                    if(type.compareTo("id")==0){rs=s.executeQuery("SELECT ID FROM users WHERE ID='"+ident+"'");count=0;while(rs.next())count++;}
                    else {rs=s.executeQuery("SELECT ID FROM users WHERE name='"+ident+"'");count=0;while(rs.next()){ident=rs.getString("ID");count++;}}
                    if(count<=0){msg=T("acct.msg.user_not_exist");msgType="error";}
                    else {s.executeUpdate("DELETE FROM users WHERE ID='"+ident+"'");msg=T("acct.msg.account_deleted")+"<br>"+Tf("acct.msg.check_chars",ident,String.valueOf(15+Integer.parseInt(ident)));msgType="success";}
                    rs.close(); s.close(); c.close();
                } catch(Exception e) { msg = T("acct.msg.db_failed"); msgType = "error"; }
            }
        }

        if(action.compareTo("changegm") == 0 && allowed) {
            String type=request.getParameter("type"),ident=request.getParameter("ident"),act=request.getParameter("act");
            if(type.length()>0&&ident.length()>0&&act.length()>0) {
                try {
                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                    Connection c = DriverManager.getConnection("jdbc:mysql://"+db_host+":"+db_port+"/"+db_database,db_user,db_password);
                    Statement s = c.createStatement(); ResultSet rs; int count;
                    if(type.compareTo("id")==0){rs=s.executeQuery("SELECT ID FROM users WHERE ID='"+ident+"'");count=0;while(rs.next())count++;}
                    else {rs=s.executeQuery("SELECT ID FROM users WHERE name='"+ident+"'");count=0;while(rs.next()){ident=rs.getString("ID");count++;}}
                    if(count<=0){msg=T("acct.msg.user_not_exist");msgType="error";}
                    else {
                        rs=s.executeQuery("SELECT userid FROM auth WHERE userid='"+ident+"'");count=0;while(rs.next())count++;
                        if(count>0){if(act.compareTo("delete")==0){s.executeUpdate("DELETE FROM auth WHERE userid='"+ident+"'");msg=T("acct.msg.gm_removed");msgType="success";}else{msg=T("acct.msg.already_gm");msgType="warning";}}
                        else {if(act.compareTo("add")==0){s.executeQuery("call addGM('"+ident+"','1')");msg=T("acct.msg.gm_added");msgType="success";}else{msg=T("acct.msg.not_gm");msgType="warning";}}
                    }
                    rs.close(); s.close(); c.close();
                } catch(Exception e) { msg = T("acct.msg.db_failed"); msgType = "error"; }
            }
        }

        if(action.compareTo("addcubi") == 0 && allowed) {
            String type=request.getParameter("type"),ident=request.getParameter("ident");
            int amount=0; try{amount=Integer.parseInt(request.getParameter("amount"));}catch(Exception e){}
            if(type.length()>0&&ident.length()>0) {
                if(amount<1||amount>999999){msg=T("acct.msg.invalid_amount");msgType="error";}
                else {
                    try {
                        Class.forName("com.mysql.jdbc.Driver").newInstance();
                        Connection c = DriverManager.getConnection("jdbc:mysql://"+db_host+":"+db_port+"/"+db_database,db_user,db_password);
                        Statement s = c.createStatement(); ResultSet rs; int count;
                        if(type.compareTo("id")==0){rs=s.executeQuery("SELECT ID FROM users WHERE ID='"+ident+"'");count=0;while(rs.next())count++;}
                        else {rs=s.executeQuery("SELECT ID FROM users WHERE name='"+ident+"'");count=0;while(rs.next()){ident=rs.getString("ID");count++;}}
                        if(count<=0){msg=T("acct.msg.user_not_exist");msgType="error";}
                        else {s.executeQuery("call usecash('"+ident+"',1,0,1,0,'"+(100*amount)+"',1,@error)");msg=Tf("acct.msg.cubi_added",(double)amount)+"<br>"+T("acct.msg.cubi_note");msgType="success";}
                        rs.close(); s.close(); c.close();
                    } catch(Exception e) { msg = T("acct.msg.db_failed"); msgType = "error"; }
                }
            }
        }
    }
%>

<div class="phx-page-header">
    <h1><i class="fa-solid fa-users" style="color:var(--phx-primary)"></i> <%= T("nav.accounts") %></h1>
    <p>Quản lý tài khoản người chơi</p>
</div>

<% if(!msg.isEmpty()) { %>
<div class="phx-notify phx-notify-<%= msgType %> phx-mb-4"><i class="fa-solid fa-<%= msgType.equals("success")?"circle-check":msgType.equals("error")?"circle-xmark":"triangle-exclamation" %>"></i> <%= msg %></div>
<% } %>

<div class="phx-row">
    <!-- Register -->
    <div class="phx-col">
        <div class="phx-card phx-card-glow">
            <div class="phx-card-header"><h2><i class="fa-solid fa-user-plus"></i> <%= T("acct.registration") %></h2></div>
            <form action="index.jsp?page=account&action=adduser" method="post">
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.login_label") %></label><input class="phx-input" type="text" name="getlogin" required></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.password_label") %></label><input class="phx-input" type="password" name="password" required></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.email_label") %></label><input class="phx-input" type="email" name="getmail" value="NOT_NEEDED"></div>
                <button class="phx-btn phx-btn-primary phx-btn-full"><i class="fa-solid fa-user-plus"></i> <%= T("acct.btn.register") %></button>
            </form>
        </div>
    </div>
    <!-- Change Password -->
    <div class="phx-col">
        <div class="phx-card phx-card-glow">
            <div class="phx-card-header"><h2><i class="fa-solid fa-key"></i> <%= T("acct.change_password") %></h2></div>
            <form action="index.jsp?page=account&action=passwd" method="post">
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.login_label") %></label><input class="phx-input" type="text" name="getlogin" required></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.old_password") %></label><input class="phx-input" type="password" name="password_old" required></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.new_password") %></label><input class="phx-input" type="password" name="password_new" required></div>
                <button class="phx-btn phx-btn-primary phx-btn-full"><i class="fa-solid fa-rotate"></i> <%= T("acct.btn.change_pass") %></button>
            </form>
        </div>
    </div>
</div>

<% if(allowed) { %>
<div class="phx-row">
    <!-- Delete Account -->
    <div class="phx-col">
        <div class="phx-card">
            <div class="phx-card-header"><h2><i class="fa-solid fa-trash-can"></i> <%= T("acct.delete_account") %></h2></div>
            <form action="index.jsp?page=account&action=deluser" method="post">
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.type_label") %></label>
                    <select class="phx-select" name="type"><option value="id"><%= T("acct.type_by_id") %></option><option value="login"><%= T("acct.type_by_login") %></option></select></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.identifier") %></label><input class="phx-input" type="text" name="ident" required></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.characters_label") %></label>
                    <select class="phx-select" name="character"><option value="keep"><%= T("acct.characters_keep") %></option></select></div>
                <button class="phx-btn phx-btn-danger phx-btn-full"><i class="fa-solid fa-trash"></i> <%= T("acct.btn.delete") %></button>
            </form>
        </div>
    </div>
    <!-- GM Management -->
    <div class="phx-col">
        <div class="phx-card">
            <div class="phx-card-header"><h2><i class="fa-solid fa-crown"></i> <%= T("acct.gm_management") %></h2></div>
            <form action="index.jsp?page=account&action=changegm" method="post">
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.type_label") %></label>
                    <select class="phx-select" name="type"><option value="id"><%= T("acct.type_by_id") %></option><option value="login"><%= T("acct.type_by_login") %></option></select></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.identifier") %></label><input class="phx-input" type="text" name="ident" required></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.action_label") %></label>
                    <select class="phx-select" name="act"><option value="add"><%= T("acct.grant_gm") %></option><option value="delete"><%= T("acct.deny_gm") %></option></select></div>
                <button class="phx-btn phx-btn-primary phx-btn-full"><%= T("acct.btn.submit") %></button>
            </form>
        </div>
    </div>
    <!-- Cubi Transfer -->
    <div class="phx-col">
        <div class="phx-card">
            <div class="phx-card-header"><h2><i class="fa-solid fa-coins"></i> <%= T("acct.cubi_transfer") %></h2></div>
            <form action="index.jsp?page=account&action=addcubi" method="post">
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.type_label") %></label>
                    <select class="phx-select" name="type"><option value="id"><%= T("acct.type_by_id") %></option><option value="login"><%= T("acct.type_by_login") %></option></select></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.identifier") %></label><input class="phx-input" type="text" name="ident" required></div>
                <div class="phx-form-group"><label class="phx-label"><%= T("acct.amount_label") %></label><input class="phx-input" type="number" name="amount" required></div>
                <button class="phx-btn phx-btn-primary phx-btn-full"><i class="fa-solid fa-paper-plane"></i> <%= T("acct.btn.transfer") %></button>
            </form>
        </div>
    </div>
</div>

<!-- Account List -->
<div class="phx-card phx-mt-4">
    <div class="phx-card-header"><h2><i class="fa-solid fa-list"></i> <%= T("acct.browse_accounts") %></h2></div>
    <div class="phx-table-wrap" style="max-height:400px;">
        <table class="phx-table">
            <thead><tr><th><%= T("acct.table.id") %></th><th><%= T("acct.table.name") %></th><th><%= T("acct.table.creation") %></th></tr></thead>
            <tbody>
                <%
                try {
                    Class.forName("com.mysql.jdbc.Driver").newInstance();
                    Connection c = DriverManager.getConnection("jdbc:mysql://"+db_host+":"+db_port+"/"+db_database,db_user,db_password);
                    Statement s = c.createStatement();
                    ResultSet rs = s.executeQuery("SELECT DISTINCT userid FROM auth");
                    ArrayList<Integer> gm = new ArrayList<Integer>();
                    while(rs.next()) gm.add(rs.getInt("userid"));
                    rs = s.executeQuery("SELECT ID,name,creatime FROM users");
                    while(rs.next()) {
                        boolean isGm = gm.contains(rs.getInt("ID"));
                        out.print("<tr"+(isGm?" class=\"phx-row-gm\"":"")+"><td style=\"font-family:var(--phx-font-mono);font-size:0.75rem;\">"+rs.getString("ID")+"</td><td>"+rs.getString("name")+(isGm?" <span class=\"phx-badge phx-badge-info\" style=\"font-size:0.65rem;\">GM</span>":"")+"</td><td class=\"phx-text-2\">"+rs.getString("creatime").substring(0,16)+"</td></tr>");
                    }
                    rs.close(); s.close(); c.close();
                } catch(Exception e) {
                    out.print("<tr><td colspan=\"3\" class=\"phx-text-danger phx-text-center\">"+T("acct.msg.db_failed")+"</td></tr>");
                }
                %>
            </tbody>
        </table>
    </div>
</div>
<% } %>