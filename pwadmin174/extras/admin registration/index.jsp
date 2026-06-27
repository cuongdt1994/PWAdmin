<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.security.*"%>
<%@page import="java.sql.*"%>
<%@include file="../../WEB-INF/.pwadminconf.jsp"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>

<%!
    // Function to generate a salt
    private String generateSalt() {
        return BCrypt.gensalt();
    }

    // Function to hash password with salt
    private static String hashPassword(String password, String salt) {
        return BCrypt.hashpw(password, salt);
    }

    private static Connection getConnection(String db_host, String db_port, String db_database, String db_user, String db_password) throws SQLException {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Failed to load MySQL JDBC driver.", e);
        }
        String url = "jdbc:mysql://" +  db_host  + ":" + db_port  + "/" + db_database ;
        return DriverManager.getConnection(url,db_user, db_password);
    }
%>
<style>
    body {
        background-color: #333;
        color: #eee;
    }
    .login-container {
        width: 350px;
        margin: 100px auto;
        padding: 20px;
        border: 1px solid #555;
        border-radius: 5px;
        background-color: #444;
    }
    .login-container h2 {
        text-align: center;
        margin-bottom: 20px;
    }
    .login-form label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }
    .login-form input[type="text"],
    .login-form input[type="password"] {
        width: 100%;
        padding: 8px;
        margin-bottom: 10px;
        border: 1px solid #777;
        border-radius: 3px;
        background-color: #555;
        color: #eee;
    }
    .login-form input[type="submit"] {
        display: block;
        margin: 10px auto;
		padding: 10px 15px;
		 background-color: #666;
		 color: white;
        border: none;
        border-radius: 5px;
		cursor: pointer;
    }
	.login-form input[type="submit"]:hover {
       background-color: #888;
    }
    .logout-button {
        display: block;
        margin: 10px auto;
    }
    .error-message {
        color: #ff0000;
        text-align: center;
        margin-bottom: 10px;
    }
    .return-button {
       display: block;
       margin: 10px auto;
       text-align: center;
       padding: 10px 15px;
       background-color: #666;
       color: white;
       border: none;
       border-radius: 5px;
       text-decoration: none;
       cursor: pointer;
    }
    .return-button:hover {
       background-color: #888;
    }
    #reload-image{
        width: 6%;
    }

</style>
<div class="login-container">
    <h2>Admin Registration</h2>
    <%
        String errorMessage = "";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection(db_host, db_port, db_database, db_user, db_password);

            if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("registerAdmin") != null) {
                String enteredUsername = request.getParameter("username");
                String enteredPassword = request.getParameter("password");

                // Check if username already exists
                String checkSql = "SELECT COUNT(*) FROM admin_users WHERE username = ?";
                pstmt = conn.prepareStatement(checkSql);
                pstmt.setString(1, enteredUsername);
                rs = pstmt.executeQuery();
                rs.next();
                int userCount = rs.getInt(1);

                if (userCount > 0) {
                    errorMessage = "<p class=\"error-message\">Username already exists. Please choose a different one.</p>";
                } else {
                    // Generate salt and hash the password
                    String salt = generateSalt();
                    String hashedPassword = hashPassword(enteredPassword, salt);

                    try {
                        String sql = "INSERT INTO admin_users (username, password_hash, salt) VALUES (?, ?, ?)";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, enteredUsername);
                        pstmt.setString(2, hashedPassword);
                        pstmt.setString(3, salt);
                        pstmt.executeUpdate();

                        out.println("<p style=\"text-align:center; color: lightgreen;\">Admin user created successfully! Please return to login. </p>");
                        out.println("<a href=\"login.jsp\" class=\"return-button\">Return to Login</a>");
                        return; // Prevent further form output
                    } catch (SQLException e) {
                        errorMessage = "<p class=\"error-message\">Error creating admin user: " + e.getMessage() + "</p>";
                        e.printStackTrace();
                    }
                }
            }
          if(request.getMethod().equalsIgnoreCase("GET") || errorMessage.length() > 0)
         {
    %>
            <form action="index.jsp" method="post" class="login-form">
                <% out.println(errorMessage);%>
                <input type="hidden" name="registerAdmin" value="true">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
                <input type="submit" value="Register" >
            </form>
            <a href="login.jsp" class="return-button">Cancel</a>
    <%
        }

        } catch (SQLException e) {
            errorMessage = "<p class=\"error-message\">Database error: " + e.getMessage() + "</p>";
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</div>
<script>
   //reload script no longer needed
</script>