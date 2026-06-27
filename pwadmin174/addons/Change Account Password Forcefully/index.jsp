<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.*" %>
<%@ page import="org.apache.catalina.util.Base64" %>
<%@ include file="../../WEB-INF/.pwadminconf.jsp" %>
<%@ include file="../../WEB-INF/lang_vi.jsp" %>
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
    boolean allowed = false;

    if (request.getSession().getAttribute("ssid") == null) {
        out.println("<div class=\"phx-notify phx-notify-error phx-mb-4\"><i class=\"fa-solid fa-circle-xmark\"></i> Đăng nhập để Quản lý Tài khoản...</div>");
    } else {
        allowed = true;
    }

    String message = "";
    StringBuilder logMessages = new StringBuilder();

    if (request.getParameter("action") != null) {
        String action = request.getParameter("action");
        logMessages.append("<p>Action: " + action + "</p>");

        if ("passwd".equals(action)) {
            String login = request.getParameter("login");
            String password_new = request.getParameter("password_new");
            logMessages.append("<p>Login: " + login + "</p>");
            logMessages.append("<p>New Password: " + password_new + "</p>");

            if (login != null && login.length() > 0 && password_new != null && password_new.length() > 0) {
                if (password_new.length() < 4 || password_new.length() > 10) {
                    message = "Only 4-10 Characters";
                    logMessages.append("<p>Password length invalid: " + password_new.length() + "</p>");
                } else {
                    String alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_";
                    boolean check = true;
                    for (char c : password_new.toCharArray()) {
                        if (alphabet.indexOf(c) == -1) {
                            check = false;
                            break;
                        }
                    }
                    logMessages.append("<p>Password Check: " + check + "</p>");

                    if (!check) {
                        message = "Forbidden Characters";
                    } else {
                        logMessages.append("<p>Starting database connection...</p>");
                        try {
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            Connection connection = DriverManager.getConnection(
                                "jdbc:mysql://" + db_host + ":" + db_port + "/" + db_database, db_user, db_password
                            );
                            logMessages.append("<p>Database connection successful.</p>");
                            String selectSQL = "SELECT ID, passwd FROM users WHERE name = ?";
                            PreparedStatement selectStatement = connection.prepareStatement(selectSQL);
                            selectStatement.setString(1, login);

                            ResultSet rs = selectStatement.executeQuery();
                            String password_stored = "";
                            String id_stored = "";
                            boolean userExists = false;

                            if (rs.next()) {
                                id_stored = rs.getString("ID");
                                password_stored = rs.getString("passwd");
                                userExists = true;
                                logMessages.append("<p>User found: " + login + "</p>");
                            } else {
                                logMessages.append("<p>User not found: " + login + "</p>");
                            }

                            if (!userExists) {
                                message = "User Doesn't Exist";
                            } else {
                                String newHashedPassword = pw_encode(login + password_new, MessageDigest.getInstance("MD5"));
                                logMessages.append("<p>New Hashed Password: " + newHashedPassword + "</p>");
                                String updateSQL = "UPDATE users SET passwd = ? WHERE name = ?";
                                PreparedStatement updateStatement = connection.prepareStatement(updateSQL);
                                updateStatement.setString(1, newHashedPassword);
                                updateStatement.setString(2, login);

                                int rowsAffected = 0;
                                try {
                                    rowsAffected = updateStatement.executeUpdate();
                                    logMessages.append("<p>Rows Affected: " + rowsAffected + "</p>");
                                } catch (SQLException e) {
                                    message = "Error changing password";
                                    e.printStackTrace();
                                    logMessages.append("<p>SQL Exception: " + e.getMessage() + "</p>");
                                } finally {
                                    updateStatement.close();
                                }

                                if (rowsAffected > 0) {
                                    message = "Password Changed";
                                    PreparedStatement verifyStatement = connection.prepareStatement("SELECT passwd FROM users WHERE name = ?");
                                    verifyStatement.setString(1, login);
                                    ResultSet verifyRS = verifyStatement.executeQuery();
                                    if (verifyRS.next()) {
                                        String dbPassword = verifyRS.getString("passwd");
                                        if (dbPassword.equals(newHashedPassword)) {
                                            logMessages.append("<p>Password change verified in database.</p>");
                                        } else {
                                            logMessages.append("<p>Password change verification failed.</p>");
                                        }
                                    }
                                    verifyRS.close();
                                    verifyStatement.close();

                                } else {
                                    message = "Error Changing Password";
                                }
                            }
                            rs.close();
                            selectStatement.close();
                            connection.close();
                            logMessages.append("<p>Connection closed.</p>");
                        } catch (Exception e) {
                            message = "Connection to MySQL Database Failed";
                            e.printStackTrace();
                            logMessages.append("<p>Exception: " + e.getMessage() + "</p>");
                        }
                    }
                }
            } else {
                 logMessages.append("<p>Login or new password empty.</p>");
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật khẩu</title>
    <link rel="stylesheet" type="text/css" href="../../include/phoenix.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        html, body {
            height: 100%;
            margin: 0;
        }
    </style>
</head>
<body style="background:var(--phx-bg); display:flex; align-items:center; justify-content:center; min-height:100vh; padding:16px;">

<div style="max-width:500px; width:100%;">
    <% if (!message.isEmpty()) { %>
        <% if (message.contains("Changed")) { %>
            <div class="phx-notify phx-notify-success phx-mb-4">
                <i class="fa-solid fa-circle-check"></i> <%= message %>
            </div>
        <% } else { %>
            <div class="phx-notify phx-notify-error phx-mb-4">
                <i class="fa-solid fa-circle-xmark"></i> <%= message %>
            </div>
        <% } %>
    <% } %>

    <div class="phx-card phx-card-glow">
        <div class="phx-card-header">
            <h2><i class="fa-solid fa-lock"></i> <%= T("changepw.title") %></h2>
        </div>
        <form action="index.jsp?page=account&action=passwd" method="post">
            <div class="phx-form-group">
                <label class="phx-label">Tên đăng nhập</label>
                <input class="phx-input" type="text" name="login" placeholder="Nhập tên đăng nhập" required>
            </div>
            <div class="phx-form-group">
                <label class="phx-label">Mật khẩu mới</label>
                <input class="phx-input" type="password" name="password_new" placeholder="Nhập mật khẩu mới" required>
            </div>
            <button class="phx-btn phx-btn-primary phx-btn-full" type="submit"><i class="fa-solid fa-key"></i> Đổi Mật khẩu</button>
        </form>
    </div>

    <div id="log-area" class="phx-card phx-mt-4" style="display:none;">
        <div class="phx-card-header">
            <h2><i class="fa-solid fa-terminal"></i> Log</h2>
        </div>
        <%= logMessages.toString() %>
    </div>
</div>

</body>
</html>
