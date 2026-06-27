<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="org.apache.catalina.util.Base64"%>
<%@include file="WEB-INF/.pwadminconf.jsp"%>
<%@include file="WEB-INF/lang_vi.jsp"%>
<%!
    String pw_encode(String salt, MessageDigest alg) {
        alg.reset();
        alg.update(salt.getBytes());
        byte[] digest = alg.digest();
        salt = Base64.encode(digest).toString();
        return salt;
    }
%>
<%
  String logFilePath = application.getRealPath("iplog.txt");
  String lastRotatedPath = application.getRealPath("lastrotated.txt");
  String currentClientIP = request.getRemoteAddr();
  Boolean logged = (Boolean)session.getAttribute("ipLogged");
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  String timestamp = sdf.format(new Date());
  File lastRotatedFile = new File(lastRotatedPath);
  File logFile = new File(logFilePath);

  try {
    if(lastRotatedFile.exists()) {
      BufferedReader br = new BufferedReader(new FileReader(lastRotatedFile));
      String lastRotated = br.readLine();
      br.close();
      if(lastRotated != null) {
        SimpleDateFormat logDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date lastRotatedDate = logDateFormat.parse(lastRotated);
        Calendar c = Calendar.getInstance();
        c.setTime(lastRotatedDate);
        c.add(Calendar.DATE, 2);
        Date nextRotated = c.getTime();
        Date today = new Date();
        if(today.after(nextRotated)) {
          if (logFile.exists()) logFile.delete();
          FileWriter fw = new FileWriter(lastRotatedFile, false);
          BufferedWriter bw = new BufferedWriter(fw);
          bw.write(logDateFormat.format(today));
          bw.close();
        }
      }
    }
    if(logged == null || !logged) {
      FileWriter fw = new FileWriter(logFile, true);
      BufferedWriter bw = new BufferedWriter(fw);
      bw.write(timestamp + " - IP: " + currentClientIP + "\n");
      bw.close();
      session.setAttribute("ipLogged", true);
    }
  } catch(Exception e) {}

  boolean enableIPWhitelist = enable_ip_whitelist;
  String clientIP = request.getRemoteAddr();
  boolean ipAllowed = true;
  boolean isGMUser = false;
  Map<String, Boolean> gmAccess = null;

  if (enableIPWhitelist) {
    Object ipAllowedAttribute = session.getAttribute("ipAllowed");
    if (ipAllowedAttribute instanceof Boolean) ipAllowed = (Boolean) ipAllowedAttribute;
  }
  Object gmUserAttribute = session.getAttribute("gmUser");
  if (gmUserAttribute instanceof Boolean) {
    isGMUser = (Boolean) gmUserAttribute;
    Object gmAccessAttribute = session.getAttribute("gmAccess");
    if(gmAccessAttribute instanceof Map) gmAccess = (Map<String,Boolean>) gmAccessAttribute;
  }

  if (!ipAllowed && !isGMUser) {
%>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8">
<link rel="stylesheet" href="include/phoenix.css">
</head><body class="phx-denied">
<div class="phx-login-bg"><div class="phx-login-card phx-text-center">
<h1><i class="fa-solid fa-shield-halved" style="font-size:2.5rem;color:var(--phx-danger);margin-bottom:16px;display:block;"></i></h1>
<h2 style="color:var(--phx-text);margin-bottom:8px;"><%= T("denied.title") %></h2>
<p style="color:var(--phx-text-2)"><%= Tf("denied.subtitle", clientIP) %></p>
</div></div></body></html>
<%
    return;
  }

  if (request.getParameter("logout") != null && request.getParameter("logout").equals("true")) {
    session.removeAttribute("loggedIn");
    session.removeAttribute("ssid");
    session.removeAttribute("ipAllowed");
    session.removeAttribute("gmUser");
    session.removeAttribute("gmAccess");
    response.sendRedirect("index.jsp");
    return;
  }

  boolean isLoggedIn = session.getAttribute("ssid") != null;
  if (!isLoggedIn) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="include/fav.ico">
    <link rel="stylesheet" href="include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.13.3/dist/cdn.min.js"></script>
    <script src="include/phoenix.js"></script>
</head>
<body x-data="phxSidebar()" :class="{'phx-sidebar-open': open}">

    <!-- Mobile overlay -->
    <div class="phx-sidebar-overlay" :class="{show: open}" @click="close()"></div>

    <!-- Mobile topbar -->
    <div class="phx-topbar">
        <button class="phx-hamburger" @click="toggle()">
            <i class="fa-solid fa-bars"></i>
        </button>
        <span class="phx-logo">PWADMIN</span>
    </div>

    <div class="phx-layout">

        <!-- SIDEBAR -->
        <aside class="phx-sidebar" :class="{open: open}">
            <div class="phx-sidebar-brand">
                <div class="phx-logo">PWADMIN</div>
                <div class="phx-version">Version 1.7.4</div>
            </div>

            <nav class="phx-sidebar-nav">
                <div class="phx-nav-section"><%= T("nav.server_control") %></div>
                <%
                  Map<String, String[]> navItems = new LinkedHashMap<String, String[]>();
                  navItems.put("serverctrl", new String[]{"fa-server", T("nav.server_control")});

                  if(isGMUser && gmAccess != null) {
                    if(gmAccess.get("account") != null && gmAccess.get("account"))
                      navItems.put("account", new String[]{"fa-users", T("nav.accounts")});
                    if(gmAccess.get("role") != null && gmAccess.get("role"))
                      navItems.put("role", new String[]{"fa-user", T("nav.characters")});
                    if(gmAccess.get("server") != null && gmAccess.get("server"))
                      navItems.put("server", new String[]{"fa-sliders", T("nav.server_config")});
                    if(gmAccess.get("settings") != null && gmAccess.get("settings"))
                      navItems.put("settings", new String[]{"fa-cog", T("nav.settings")});
                  } else {
                    navItems.put("account", new String[]{"fa-users", T("nav.accounts")});
                    navItems.put("role", new String[]{"fa-user", T("nav.characters")});
                    navItems.put("server", new String[]{"fa-sliders", T("nav.server_config")});
                    navItems.put("settings", new String[]{"fa-cog", T("nav.settings")});
                  }

                  String currentPage = request.getParameter("page");
                  if(currentPage == null) currentPage = "serverctrl";

                  for (Map.Entry<String, String[]> item : navItems.entrySet()) {
                    String pageKey = item.getKey();
                    String[] data = item.getValue();
                    boolean active = currentPage.equals(pageKey);
                %>
                    <a href="index.jsp?page=<%= pageKey %>" class="phx-nav-item <%= active ? "active" : "" %>" @click="close()">
                        <i class="fa-solid <%= data[0] %>"></i>
                        <span><%= data[1] %></span>
                    </a>
                <% } %>

                <% if (enable_addons_tab) { %>
                <div class="phx-nav-section"><%= T("nav.addons") %></div>
                <%
                  File addonsDir = new File(request.getRealPath("addons"));
                  String[] addonFolders = addonsDir.list(new FilenameFilter() {
                    public boolean accept(File dir, String name) { return new File(dir, name).isDirectory(); }
                  });
                  if (addonFolders != null && addonFolders.length > 0) {
                    java.util.Arrays.sort(addonFolders);
                    for (String folder : addonFolders) {
                      String folderUrl = java.net.URLEncoder.encode(folder, "UTF-8").replace("+", "%20");
                      String folderHtml = StringEscapeUtils.escapeHtml(folder);
                %>
                    <a href="index.jsp?page=addons&plugin=<%= folderUrl %>" class="phx-nav-item" @click="close()">
                        <i class="fa-solid fa-puzzle-piece"></i>
                        <span><%= folderHtml %></span>
                    </a>
                <%    }
                  }
                %>
                <% } %>
            </nav>

            <div class="phx-sidebar-footer">
                <a href="index.jsp?logout=true" class="phx-logout-btn">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    <span><%= T("nav.logout") %></span>
                </a>
            </div>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="phx-main">
            <%
              String pageParam = request.getParameter("page");
              if (pageParam == null) pageParam = "serverctrl";

              if (isGMUser && gmAccess != null) {
                boolean hasAccess = false;
                if (gmAccess.get(pageParam) != null) hasAccess = gmAccess.get(pageParam);
                if (!hasAccess) {
                  pageParam = "serverctrl";
                  out.print("<div class=\"phx-notify phx-notify-warning\"><i class=\"fa-solid fa-triangle-exclamation\"></i>" + T("nav.access_denied") + "</div>");
                }
              }

              String includePath = null;
              String serverSubPage = request.getParameter("serverpage");

              if ("settings".equals(pageParam)) includePath = "settings.jsp";
              else if ("account".equals(pageParam)) includePath = "account.jsp";
              else if ("role".equals(pageParam)) includePath = "role.jsp";
              else if ("rolegui".equals(pageParam)) includePath = "rolegui.jsp";
              else if ("rolexml".equals(pageParam)) includePath = "rolexml.jsp";
              else if ("server".equals(pageParam)) {
                includePath = "155".equals(serverSubPage) ? "server2.jsp" : "server.jsp";
              }
              else if ("serverctrl".equals(pageParam)) includePath = "serverctrl.jsp";
              else if ("addons".equals(pageParam)) {
                String plugin = request.getParameter("plugin");
                if (plugin != null) {
                  File pluginDir = new File(request.getRealPath("addons"), plugin);
                  boolean validPlugin = plugin.matches("[A-Za-z0-9._ -]+") && !plugin.startsWith(".") && pluginDir.isDirectory();
                  if (validPlugin) {
                    String pluginUrl = java.net.URLEncoder.encode(plugin, "UTF-8").replace("+", "%20");
                    out.print("<iframe src=\"addons/" + pluginUrl + "/\" style=\"width:100%;height:calc(100vh - 80px);border:1px solid var(--phx-border);border-radius:var(--phx-radius);background:var(--phx-surface);\"></iframe>");
                  } else {
                    out.print("<div class=\"phx-notify phx-notify-warning\"><i class=\"fa-solid fa-triangle-exclamation\"></i>Invalid addon plugin.</div>");
                  }
                } else {
                  out.print("<div class=\"phx-empty-state\"><i class=\"fa-solid fa-puzzle-piece\"></i><p>" + T("nav.no_addons") + "</p></div>");
                }
                includePath = null;
              }

              if (includePath != null) {
            %>
                <jsp:include page="<%= includePath %>" />
            <% } %>
        </main>
    </div>
</body>
</html>