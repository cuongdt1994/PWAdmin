<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="protocol.*,java.io.*,java.text.*,java.util.*,org.apache.commons.lang.StringEscapeUtils"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>
<%
    String message="",debugOutput=""; boolean allowed=session.getAttribute("ssid")!=null;
    if(!allowed){out.println("<div class=\"phx-empty-state\"><i class=\"fa-solid fa-lock\"></i><p>"+T("role.login_required")+"</p></div>");}

    String rolelist="";
    File workingDir=new File(pw_server_path+"/gamedbd/");
    ProcessBuilder pb=new ProcessBuilder("/bin/bash","-c","./gamedbd ./gamesys.conf listrole");
    pb.directory(workingDir);
    StringBuilder result=new StringBuilder(),errorResult=new StringBuilder();
    try{
        Process process=pb.start();
        BufferedReader reader=new BufferedReader(new InputStreamReader(process.getInputStream()));
        BufferedReader errReader=new BufferedReader(new InputStreamReader(process.getErrorStream()));
        String l; while((l=reader.readLine())!=null)result.append(l).append("\n");
        while((l=errReader.readLine())!=null){errorResult.append(l).append("\n");debugOutput+="<span style=\"color:var(--phx-danger)\">Error: "+errorResult+"</span><br>";}
        reader.close();errReader.close();
        int ec=process.waitFor();
    }catch(Exception e){message=T("role.msg.error");}
    message="<span style=\"color:var(--phx-danger);font-size:0.75rem;\">"+errorResult.toString()+"</span>";
    rolelist=result.toString();
%>

<div class="phx-page-header">
    <h1><i class="fa-solid fa-user" style="color:var(--phx-primary)"></i> <%= T("role.title") %></h1>
    <p>Danh sách nhân vật trên server</p>
</div>

<% if(!message.isEmpty()&&!errorResult.toString().isEmpty()) { %>
<div class="phx-notify phx-notify-warning phx-mb-4"><i class="fa-solid fa-triangle-exclamation"></i> <%=message%></div>
<% } %>

<div class="phx-card">
    <div class="phx-card-header">
        <h2><i class="fa-solid fa-list-ul"></i> <%=T("role.title")%></h2>
    </div>
    <%
        String[] rows=rolelist.split("\n");
        List<String> filtered=new ArrayList<String>();
        for(String r:rows){String[] cols=r.split(",");try{if(Integer.parseInt(cols[0])>1000)filtered.add(r);}catch(NumberFormatException e){}}
        rows=filtered.toArray(new String[0]);
        int rpp=10,p=1;String pp=request.getParameter("p");
        if(pp!=null)try{p=Integer.parseInt(pp);}catch(NumberFormatException e){p=1;}
        int tp=(int)Math.ceil((double)rows.length/rpp);if(p>tp)p=tp;
    %>
    <div class="phx-table-wrap" style="max-height:500px;">
        <table class="phx-table">
            <thead><tr><th><%=T("role.table.id")%></th><th><%=T("role.table.name")%></th><th><%=T("role.table.class")%></th><th><%=T("role.table.level")%></th><th><%=T("role.table.action")%></th></tr></thead>
            <tbody>
            <% if(rows.length==0){ %>
                <tr><td colspan="5" class="phx-empty"><%=T("role.no_players")%></td></tr>
            <% } else {
                int si=(p-1)*rpp,ei=Math.min(si+rpp,rows.length);
                for(int i=si;i<ei;i++){
                    String[] cols=rows[i].split(",");
                    if(cols.length<15){%><tr><td colspan="5" class="phx-text-3"><%=T("role.invalid_data")%></td></tr><%continue;}
                    String occ;
                    switch(Integer.parseInt(cols[4])){case 0:occ=T("class.0");break;case 1:occ=T("class.1");break;case 2:occ=T("class.2");break;case 3:occ=T("class.3");break;case 4:occ=T("class.4");break;case 5:occ=T("class.5");break;case 6:occ=T("class.6");break;case 7:occ=T("class.7");break;case 8:occ=T("class.8");break;case 9:occ=T("class.9");break;case 10:occ=T("class.10");break;case 11:occ=T("class.11");break;case 14:occ=T("class.14");break;default:occ=T("class.unknown");}
            %>
                <tr>
                    <td style="font-family:var(--phx-font-mono);font-size:0.75rem;color:var(--phx-text-2);"><%=cols[0]%></td>
                    <td style="font-weight:600;"><%=cols[2].replace("\"","")%></td>
                    <td><%=occ%></td>
                    <td><span class="phx-badge phx-badge-info"><%=cols[13]%></span></td>
                    <td>
                        <div class="phx-btn-group">
                            <a href="index.jsp?page=rolexml&ident=<%=cols[0]%>"><button class="phx-btn phx-btn-ghost phx-btn-sm"><i class="fa-solid fa-code"></i> <%=T("role.btn.view_xml")%></button></a>
                            <a href="index.jsp?page=rolegui&ident=<%=cols[0]%>"><button class="phx-btn phx-btn-primary phx-btn-sm"><i class="fa-solid fa-eye"></i> <%=T("role.btn.view_gui")%></button></a>
                        </div>
                    </td>
                </tr>
            <% }} %>
            </tbody>
        </table>
    </div>

    <% if(rows.length>0) { %>
    <div class="phx-pagination">
        <button class="phx-page-btn" <%=p<=1?"disabled":""%> onclick="window.location.href='index.jsp?page=role&p=<%=p-1%>'">
            <i class="fa-solid fa-chevron-left"></i> <%=T("role.pagination.prev")%>
        </button>
        <% for(int pl=1;pl<=tp;pl++) { %>
        <button class="phx-page-btn <%=pl==p?"active":""%>" onclick="window.location.href='index.jsp?page=role&p=<%=pl%>'"><%=pl%></button>
        <% } %>
        <button class="phx-page-btn" <%=p>=tp?"disabled":""%> onclick="window.location.href='index.jsp?page=role&p=<%=p+1%>'">
            <%=T("role.pagination.next")%> <i class="fa-solid fa-chevron-right"></i>
        </button>
    </div>
    <% } %>
</div>