<%@ page import="java.sql.*" %>
<%@ page import="java.security.*" %>
<%@ page import="org.apache.catalina.util.Base64" %>
<%@ include file="../../WEB-INF/.pwadminconf.jsp" %>
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
        out.println("<p class='has-text-right has-text-danger'><b>Login for Account administration...</b></p>");
    } else {
        allowed = true;
    }

    String message = "";
    StringBuilder logMessages = new StringBuilder(); // Initialize logMessages here
    
	if (request.getParameter("action") != null) {
        String action = request.getParameter("action");
        logMessages.append("<p>Action: " + action + "</p>"); // Log the action
    
		if ("passwd".equals(action)) {
            String login = request.getParameter("login");
            String password_new = request.getParameter("password_new");
            logMessages.append("<p>Login: " + login + "</p>"); // Log the login
            logMessages.append("<p>New Password: " + password_new + "</p>");// Log the password
    
			if (login != null && login.length() > 0 && password_new != null && password_new.length() > 0) {
                if (password_new.length() < 4 || password_new.length() > 10) {
					message = "<font color=\"ee0000\">Only 4-10 Characters</font>";
                    logMessages.append("<p>Password length invalid: " + password_new.length() + "</p>");// Log password length
				} else {
                    String alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_";
                    boolean check = true;
                    for (char c : password_new.toCharArray()) {
                        if (alphabet.indexOf(c) == -1) {
                            check = false;
                            break;
                        }
                    }
                    logMessages.append("<p>Password Check: " + check + "</p>"); // Log the password check

                    if (!check) {
                        message = "<font color=\"ee0000\">Forbidden Characters</font>";
                    } else {
                        logMessages.append("<p>Starting database connection...</p>"); //Log start of database connection
                        try {
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            Connection connection = DriverManager.getConnection(
                                "jdbc:mysql://" + db_host + ":" + db_port + "/" + db_database, db_user, db_password
                            );
                            logMessages.append("<p>Database connection successful.</p>"); //Log start of database connection
                            // 1. Prepare the SELECT statement with a placeholder for the login
                            String selectSQL = "SELECT ID, passwd FROM users WHERE name = ?";
                            PreparedStatement selectStatement = connection.prepareStatement(selectSQL);
                            selectStatement.setString(1, login); // set the login parameter

                            ResultSet rs = selectStatement.executeQuery();
                            String password_stored = "";
                            String id_stored = "";
                            boolean userExists = false;

                            if (rs.next()) {
                                id_stored = rs.getString("ID");
                                password_stored = rs.getString("passwd");
                                userExists = true;
                                logMessages.append("<p>User found: " + login + "</p>"); //Log that a user was found
                            } else {
                                logMessages.append("<p>User not found: " + login + "</p>"); //Log that a user was not found
                            }

                            if (!userExists) {
                                message = "<font color=\"ee0000\">User Doesn't Exist</font>";
                            } else {
                                String newHashedPassword = pw_encode(login + password_new, MessageDigest.getInstance("MD5"));
                                logMessages.append("<p>New Hashed Password: " + newHashedPassword + "</p>"); //Log the new hashed password
                                // 2. Prepare the UPDATE statement
                                String updateSQL = "UPDATE users SET passwd = ? WHERE name = ?";
                                PreparedStatement updateStatement = connection.prepareStatement(updateSQL);
                                updateStatement.setString(1, newHashedPassword);
                                updateStatement.setString(2, login);

                                // Execute the SQL Statements
                                int rowsAffected = 0;
                                try {
                                    rowsAffected = updateStatement.executeUpdate();
                                    logMessages.append("<p>Rows Affected: " + rowsAffected + "</p>"); //Log number of rows affected
                                } catch (SQLException e) {
                                    message = "<font color=\"#ee0000\"><b>Error changing password</b></font>";
                                    e.printStackTrace();
                                    logMessages.append("<p>SQL Exception: " + e.getMessage() + "</p>"); //Log the SQL exception
                                } finally {
                                    updateStatement.close();
                                }

                                if (rowsAffected > 0) {
                                    message = "<font color=\"00cc00\">Password Changed</font>";
                                    // Query the database to verify the password change
                                    PreparedStatement verifyStatement = connection.prepareStatement("SELECT passwd FROM users WHERE name = ?");
                                    verifyStatement.setString(1, login);
                                    ResultSet verifyRS = verifyStatement.executeQuery();
                                    if (verifyRS.next()) {
                                        String dbPassword = verifyRS.getString("passwd");
                                        if (dbPassword.equals(newHashedPassword)) {
                                            logMessages.append("<p>Password change verified in database.</p>");
                                        } else {
                                            logMessages.append("<p>Password change verification failed: Hash in DB does not match the hashed password</p>");
                                        }
                                    }
                                    verifyRS.close();
                                    verifyStatement.close();

                                } else {
                                    message = "<font color=\"#ee0000\"><b>Error Changing Password</b></font>";
                                }
                            }
                            rs.close();
                            selectStatement.close();
                            connection.close();
                            logMessages.append("<p>Connection closed.</p>"); //Log the end of the connection
                        } catch (Exception e) {
                            message = "<font color=\"#ee0000\"><b>Connection to MySQL Database Failed</b></font>";
                            e.printStackTrace();
                            logMessages.append("<p>Exception: " + e.getMessage() + "</p>");//Log any exceptions
                        }
                    }
                }
            } else {
                 logMessages.append("<p>Login or new password empty.</p>"); //Log if login or password is empty
            }
        }
	}
%>

<!DOCTYPE html>
<html lang="en" class="has-background-dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <style>
        html, body {
            height: 100%; /* Set height of html and body to 100% */
            margin: 0; /* Remove any default margin */
        }

        .section {
           height: 100%; /* set section height */
           display: flex;
           align-items: center;
        }
    </style>
</head>
<body class="has-background-dark">
    <section class="section">
        <div class="container">
            <% if (message != null && !message.isEmpty()) { %>
            <div class="notification <%= message.contains("00cc00") ? "is-success" : "is-danger" %>">
                <%= message.replaceAll("<font color=\"#ee0000\">", "").replaceAll("<font color=\"00cc00\">", "").replaceAll("</font>", "") %>
            </div>
            <% } %>

            <div class="columns is-centered">
                <div class="column is-half">
                    <div class="card has-background-grey-darker">
                        <header class="card-header">
                            <p class="card-header-title has-text-light">
                                Change Account Password
                            </p>
                        </header>
                        <div class="card-content">
                            <form action="index.jsp?page=account&action=passwd" method="post">
                                <div class="field">
                                    <label class="label has-text-light">Login Name</label>
                                    <div class="control">
                                        <input class="input is-dark" type="text" name="login" placeholder="Enter your login name" required>
                                    </div>
                                </div>
                                <div class="field">
                                    <label class="label has-text-light">New Password</label>
                                    <div class="control">
                                        <input class="input is-dark" type="password" name="password_new" placeholder="Enter new password" required>
                                    </div>
                                </div>
                                <div class="field has-text-centered">
                                    <button class="button is-primary is-fullwidth" type="submit">Change Password</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div id="log-area" class="box has-background-grey-darker" style="display:none">
                        <h2 class="title is-4 has-text-light">Log</h2>
                        <%= logMessages.toString() %>
                    </div>
                </div>
            </div>
        </div>
    </section>
</body>
</html>