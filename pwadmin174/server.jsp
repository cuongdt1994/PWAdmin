<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.lang.*,java.util.*,java.io.*"%>
<%@page import="protocol.*,com.goldhuman.auth.*,com.goldhuman.service.*,com.goldhuman.util.*"%>
<%@page import="org.apache.commons.logging.*"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>
<%
    String confFilePath = pw_server_path + "/gamed/gs.conf";
    String msg = "", msgType = "", traceLog = "";
    int exp=0,sp=0,drop=0,coins=0,taskExp=0,taskSp=0,taskCoins=0;
    boolean inWH=false;

    try {
        File f=new File(confFilePath); Scanner sc=new Scanner(f);
        while(sc.hasNextLine()){String l=sc.nextLine().trim();if(l.startsWith("[")&&l.endsWith("]")){inWH=l.equalsIgnoreCase("[WallowHeavy]");continue;}
        if(inWH){int ei=l.indexOf("=");if(ei>0){String k=l.substring(0,ei).trim(),v=l.substring(ei+1).trim();try{int iv=Integer.parseInt(v);if("exp".equals(k))exp=iv;else if("sp".equals(k))sp=iv;else if("item".equals(k))drop=iv;else if("money".equals(k))coins=iv;else if("task_exp".equals(k))taskExp=iv;else if("task_sp".equals(k))taskSp=iv;else if("task_money".equals(k))taskCoins=iv;}catch(NumberFormatException e){traceLog+="Skip: "+l+"<br>";}}}}
        sc.close();
    } catch(Exception e) { StringWriter sw=new StringWriter(); e.printStackTrace(new PrintWriter(sw)); traceLog+="<span style=\"color:var(--phx-danger)\">"+Tf("server.msg.read_error",e.getMessage())+"</span><br>"+sw.toString(); }

    if(request.getParameter("process")!=null&&"save_rates".equals(request.getParameter("process"))) {
        try {
            File cf=new File(confFilePath); File bf=new File(confFilePath+".bak");
            if(cf.exists()) java.nio.file.Files.copy(cf.toPath(),bf.toPath(),java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            String nExp=request.getParameter("exp_rate"),nSp=request.getParameter("sp_rate"),nDrop=request.getParameter("drop_rate"),nMoney=request.getParameter("coins_rate"),nTE=request.getParameter("task_exp_rate"),nTS=request.getParameter("task_sp_rate"),nTC=request.getParameter("task_coins_rate");
            boolean inWH2=false; StringBuilder fc=new StringBuilder(); Scanner sc=new Scanner(new File(confFilePath));
            while(sc.hasNextLine()){String l=sc.nextLine();if(l.trim().startsWith("[")&&l.trim().endsWith("]")){inWH2="[WallowHeavy]".equalsIgnoreCase(l.trim());fc.append(l).append("\n");continue;}
            if(inWH2){if(l.trim().startsWith("exp"))fc.append("exp = ").append(nExp).append("\n");else if(l.trim().startsWith("sp"))fc.append("sp = ").append(nSp).append("\n");else if(l.trim().startsWith("item"))fc.append("item = ").append(nDrop).append("\n");else if(l.trim().startsWith("money"))fc.append("money = ").append(nMoney).append("\n");else if(l.trim().startsWith("task_exp"))fc.append("task_exp = ").append(nTE).append("\n");else if(l.trim().startsWith("task_sp"))fc.append("task_sp = ").append(nTS).append("\n");else if(l.trim().startsWith("task_money"))fc.append("task_money = ").append(nTC).append("\n");else fc.append(l).append("\n");}else fc.append(l).append("\n");}
            sc.close(); BufferedWriter w=new BufferedWriter(new FileWriter(cf)); w.write(fc.toString()); w.close();
            msg=T("server.msg.saved"); msgType="success";
        } catch(Exception e) { StringWriter sw=new StringWriter(); e.printStackTrace(new PrintWriter(sw)); msg=Tf("server.msg.save_error",e.getMessage()); msgType="error"; traceLog+=sw.toString(); }
    }
%>

<div class="phx-page-header">
    <h1><i class="fa-solid fa-sliders" style="color:var(--phx-primary)"></i> <%= T("server.title") %></h1>
    <p>Chỉnh sửa tỉ lệ EXP, SP, Drop, Tiền</p>
</div>

<div class="phx-flex-between phx-mb-4">
    <div></div>
    <select class="phx-select" style="width:auto;" onchange="window.location.href='index.jsp?page=server&serverpage='+this.value">
        <option value="173" <%=request.getParameter("serverpage")==null||request.getParameter("serverpage").equals("173")?"selected":""%>>Version 173</option>
        <option value="155" <%=request.getParameter("serverpage")!=null&&request.getParameter("serverpage").equals("155")?"selected":""%>>Version 155</option>
    </select>
</div>

<% if(!msg.isEmpty()) { %><div class="phx-notify phx-notify-<%=msgType%> phx-mb-4"><i class="fa-solid fa-<%=msgType.equals("success")?"circle-check":"circle-xmark"%>"></i> <%=msg%></div><% } %>

<div class="phx-card phx-card-glow">
    <div class="phx-card-header"><h2><i class="fa-solid fa-gauge-high"></i> Cấu hình Tỉ lệ</h2></div>
    <form action="index.jsp?page=server&process=save_rates" method="post" onsubmit="return confirm('<%=T("server.confirm_save")%>')">
        <div class="phx-row">
            <% String[][] rates = {{"exp_rate",T("server.exp_rate"),String.valueOf(exp)},{"sp_rate",T("server.sp_rate"),String.valueOf(sp)},{"drop_rate",T("server.drop_rate"),String.valueOf(drop)},{"coins_rate",T("server.coins_rate"),String.valueOf(coins)},{"task_exp_rate",T("server.task_exp_rate"),String.valueOf(taskExp)},{"task_sp_rate",T("server.task_sp_rate"),String.valueOf(taskSp)},{"task_coins_rate",T("server.task_coins_rate"),String.valueOf(taskCoins)}};
               for(String[] r:rates) { %>
            <div class="phx-col" style="min-width:220px;">
                <div class="phx-form-group">
                    <label class="phx-label"><%=r[1]%></label>
                    <input class="phx-input" type="number" min="0" max="100" name="<%=r[0]%>" value="<%=r[2]%>">
                    <div class="phx-text-xs phx-text-3"><%=T("server.base_value")%></div>
                </div>
            </div>
            <% } %>
        </div>
        <button class="phx-btn phx-btn-primary phx-btn-lg"><i class="fa-solid fa-floppy-disk"></i> <%=T("server.btn.save")%></button>
    </form>
</div>

<% if(!traceLog.isEmpty()) { %>
<div class="phx-card phx-mt-4" x-data="{open: false}">
    <button class="phx-collapse-trigger" :class="{open: open}" @click="open=!open" style="width:100%;padding:12px 20px;">
        <i class="fa-solid fa-chevron-right"></i> <%=T("server.trace_log")%>
    </button>
    <div class="phx-collapse-content" :class="{open: open}">
        <div class="phx-code"><%=traceLog%></div>
    </div>
</div>
<% } %>