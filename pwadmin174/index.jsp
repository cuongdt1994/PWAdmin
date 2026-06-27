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
    String pw_encode(String salt, MessageDigest alg)
    {
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
    StringWriter sw = new StringWriter();
    PrintWriter pw = new PrintWriter(sw);
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
                 if (logFile.exists()) {
                   logFile.delete();
                }
                FileWriter fw = new FileWriter(lastRotatedFile, false);
                 BufferedWriter bw = new BufferedWriter(fw);
                  bw.write(logDateFormat.format(today));
                   bw.close();
               }
           } else
           {
            FileWriter fw = new FileWriter(lastRotatedFile, false);
             BufferedWriter bw = new BufferedWriter(fw);
              bw.write(sdf.format(new Date()).substring(0,10));
               bw.close();
           }
         } else {
          FileWriter fw = new FileWriter(lastRotatedFile, false);
             BufferedWriter bw = new BufferedWriter(fw);
              bw.write(sdf.format(new Date()).substring(0,10));
               bw.close();
         }
     } catch(Exception e) {

     }

        try {
           if(logged == null || !logged) {
               FileWriter fw = new FileWriter(logFile, true);
            BufferedWriter bw = new BufferedWriter(fw);
             bw.write(timestamp + " - IP: " + currentClientIP + "\n");
            bw.close();
              session.setAttribute("ipLogged", true);
           }
        } catch (IOException e) {

        }

%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <link rel="shortcut icon" href="include/fav.ico">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma/css/bulma.min.css">
    <%
        String theme = "dark";
    %>
  <link rel="stylesheet" href="include/custom.css">
</head>

<body>
    <%
        boolean enableIPWhitelist = enable_ip_whitelist;
        String clientIP = request.getRemoteAddr();
        boolean ipAllowed = true;
        boolean isGMUser = false;
        Map<String, Boolean> gmAccess = null;
        if (enableIPWhitelist) {
            Object ipAllowedAttribute = session.getAttribute("ipAllowed");
            if (ipAllowedAttribute instanceof Boolean) {
                ipAllowed = (Boolean) ipAllowedAttribute;
            }
        }
        Object gmUserAttribute = session.getAttribute("gmUser");
         if (gmUserAttribute instanceof Boolean) {
              isGMUser = (Boolean) gmUserAttribute;
               Object gmAccessAttribute = session.getAttribute("gmAccess");
                if(gmAccessAttribute instanceof Map)
                     gmAccess = (Map<String,Boolean>) gmAccessAttribute;
          }



        if (!ipAllowed && !isGMUser) {
    %>
    <section class="hero is-danger is-fullheight">
        <div class="hero-body">
            <div class="container has-text-centered">
                <h1 class="title"><%= T("denied.title") %></h1>
                <h2 class="subtitle"><%= Tf("denied.subtitle", clientIP) %></h2>
            </div>
        </div>
    </section>
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

    <nav class="navbar" role="navigation" aria-label="main navigation">
        <div class="navbar-brand">
            <a class="navbar-item" href="index.jsp?page=serverctrl">
                <strong><%= T("app.brand") %></strong>
            </a>
        </div>

        <div class="navbar-menu">
            <div class="navbar-start">
                <%
                    Map<String, String> navbarItems = new LinkedHashMap<String, String>();
                    if(isGMUser)
                    {
                      if (gmAccess != null) {
                         if(gmAccess.get("settings") != null && gmAccess.get("settings"))
                               navbarItems.put("settings", T("nav.settings"));
                         if(gmAccess.get("account") != null && gmAccess.get("account"))
                                navbarItems.put("account", T("nav.accounts"));
                         if(gmAccess.get("role") != null && gmAccess.get("role"))
                                navbarItems.put("role", T("nav.characters"));
                         if(gmAccess.get("server") != null && gmAccess.get("server"))
                                navbarItems.put("server", T("nav.server_config"));
                         if(gmAccess.get("serverctrl") != null && gmAccess.get("serverctrl"))
                                navbarItems.put("serverctrl", T("nav.server_control"));
                      }

                    }else {
                        navbarItems.put("settings", T("nav.settings"));
                        navbarItems.put("account", T("nav.accounts"));
                        navbarItems.put("role", T("nav.characters"));
                        navbarItems.put("server", T("nav.server_config"));
                        navbarItems.put("serverctrl", T("nav.server_control"));
                    }

                    for (Map.Entry<String, String> item : navbarItems.entrySet()) {
                        String key = item.getKey();
                        String value = item.getValue();
                        boolean isActive = key.equals(request.getParameter("page"));
                %>
                    <a href="index.jsp?page=<%= key %>" class="navbar-item <%= isActive ? "is-active" : "" %>">
                        <%= value %>
                    </a>
                <% } %>

               <% if (enable_addons_tab) { %>
                <div class="navbar-item has-dropdown is-hoverable">
                    <a class="navbar-link"
                        <% if (!isLoggedIn) { %>style="pointer-events:none;opacity:0.7;"<% } %>>
                        <%= T("nav.addons") %>
                    </a>

                    <div class="navbar-dropdown">
                        <%
                            File addonsDir = new File(request.getRealPath("addons"));

                            String[] addonFolders = addonsDir.list(new FilenameFilter() {
                                public boolean accept(File dir, String name) {
                                    return new File(dir, name).isDirectory();
                                }
                            });

                            if (addonFolders != null && addonFolders.length > 0) {
                                java.util.Arrays.sort(addonFolders);

                                for (String addonFolder : addonFolders) {
                        %>
                            <a href="index.jsp?page=addons&plugin=<%= addonFolder %>" class="navbar-item">
                                <b>?</b> <%= addonFolder %>
                            </a>
                        <%
                                }
                            } else {
                        %>
                            <div class="navbar-item"><%= T("nav.no_addons") %></div>
                        <%
                            }
                        %>
                        <hr class="navbar-divider">
                        <a href="http://pwadmin.codeplex.com/Thread/List.aspx" target="_blank" class="navbar-item">
                            <%= T("nav.search_plugins") %>
                        </a>
                    </div>
                </div>
               <% } %>
            </div>

            <div class="navbar-end">
                <% if (isLoggedIn) { %>
                <div class="navbar-item">
                    <a href="index.jsp?logout=true" class="button is-danger"><%= T("nav.logout") %></a>
                </div>
                <% } %>
            </div>
        </div>
    </nav>

    <section class="section">
        <div class="container">
            <%
                if (isLoggedIn) {
                    String pageParam = request.getParameter("page");
                    if (pageParam == null) {
                        pageParam = "serverctrl";
                    }

                     if (isGMUser && gmAccess != null) {
                          boolean hasAccess = false;
                           if (pageParam != null) {
                                  if (gmAccess.get(pageParam) != null)
                                     hasAccess = gmAccess.get(pageParam);
                              }

                           if(!hasAccess)
                              {
                                  pageParam = "serverctrl";
                                   out.print("<p style=\"color:red\">" + T("nav.access_denied") + "</p>");

                              }

                     }

                     String includePath = null;
                     String serverSubPage = request.getParameter("serverpage");


                    if ("settings".equals(pageParam)) {
                        includePath = "settings.jsp";
                    } else if ("account".equals(pageParam)) {
                        includePath = "account.jsp";
                    } else if ("role".equals(pageParam)) {
                        includePath = "role.jsp";
                    } else if ("rolegui".equals(pageParam)) {
                         includePath = "rolegui.jsp";
                    } else if ("rolexml".equals(pageParam)) {
                        includePath = "rolexml.jsp";
                    } else if ("server".equals(pageParam)) {
                         if ("155".equals(serverSubPage)) {
                               includePath = "server2.jsp";
                            } else {
                                includePath = "server.jsp";
                            }
                    } else if ("serverctrl".equals(pageParam)) {
                        includePath = "serverctrl.jsp";
                    } else if ("addons".equals(pageParam)) {
                        if (request.getParameter("plugin") != null) {
                            out.print("<iframe src=\"addons/" + request.getParameter("plugin") + "/\" width=\"100%\" height=\"600px\" frameborder=\"0\"></iframe>");
                        } else {
                            out.print("<p>" + T("nav.no_addons") + "</p>");
                        }
                        includePath = null;
                    } else {

                        out.print("<p>" + T("nav.no_addons") + "</p>");
                    }

                    if (includePath != null) {
            %>
                        <jsp:include page="<%= includePath %>" />
            <%
                    }
                }
            %>
        </div>
    </section>
</body>

</html>