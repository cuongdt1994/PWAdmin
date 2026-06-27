<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.lang.*,java.util.*,protocol.*"%>
<%@page import="com.goldhuman.auth.*,com.goldhuman.service.*,com.goldhuman.util.*"%>
<%@page import="org.apache.commons.logging.*"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>
<%
    boolean allowed = session.getAttribute("ssid") != null;
    if(!allowed) out.println("<div class=\"phx-empty-state\"><i class=\"fa-solid fa-lock\"></i><p>" + T("server.login_required") + "</p></div>");
%>

<div class="phx-page-header">
    <h1><i class="fa-solid fa-sliders" style="color:var(--phx-primary)"></i> <%= T("server.title") %> (v155)</h1>
</div>

<div class="phx-flex-between phx-mb-4">
    <div></div>
    <select class="phx-select" style="width:auto;" onchange="window.location.href='index.jsp?page=server&serverpage='+this.value">
        <option value="173" <%= request.getParameter("serverpage")==null||request.getParameter("serverpage").equals("173")?"selected":"" %>>Version 173</option>
        <option value="155" <%= request.getParameter("serverpage")!=null&&request.getParameter("serverpage").equals("155")?"selected":"" %>>Version 155</option>
    </select>
</div>

<%
    if(allowed) {
%>
<!-- Server Info Card -->
<div class="phx-card phx-mb-4">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-circle-info"></i> Thông tin Server</h2>
        <span class="phx-badge phx-badge-info"><%= pw_server_name %></span>
    </div>
    <div class="phx-row">
        <div class="phx-col"><span class="phx-text-2 phx-text-sm">Name:</span> <strong><%= pw_server_name %></strong></div>
        <div class="phx-col"><span class="phx-text-2 phx-text-sm">EXP:</span> <strong style="color:var(--phx-success);"><%= pw_server_exp %>x</strong></div>
        <div class="phx-col"><span class="phx-text-2 phx-text-sm">SP:</span> <strong style="color:var(--phx-primary);"><%= pw_server_sp %>x</strong></div>
        <div class="phx-col"><span class="phx-text-2 phx-text-sm">Drop:</span> <strong style="color:var(--phx-accent);"><%= pw_server_drop %>x</strong></div>
        <div class="phx-col"><span class="phx-text-2 phx-text-sm">Coins:</span> <strong style="color:var(--phx-warning);"><%= pw_server_coins %>x</strong></div>
    </div>
    <div class="phx-text-sm phx-text-3 phx-mt-2"><%= pw_server_description %></div>
</div>

<div class="phx-card">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-bolt"></i> Double EXP/SP</h2>
    </div>
    <form action="index.jsp?page=server&serverpage=155&process=doubleexp" method="post">
        <div class="phx-form-group">
            <label class="phx-label">Chọn tỉ lệ EXP</label>
            <select class="phx-select" name="expselect" onchange="this.form.submit()">
                <option value="0">Bình thường (1x)</option>
                <option value="2">Gấp đôi (2x)</option>
                <option value="3">3 lần (3x)</option>
                <option value="5">5 lần (5x)</option>
                <option value="10">10 lần (10x)</option>
            </select>
        </div>
    </form>
</div>
<% } %>