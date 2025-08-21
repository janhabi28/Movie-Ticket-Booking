
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration | MovieNest</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #1b1b3a, #472b62);
            margin: 0;
            padding: 0;
            color: #ffffff;
        }

        .container {
            width: 460px;
            margin: 70px auto;
            background: rgba(255, 255, 255, 0.05);
            padding: 35px 30px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(12px);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #ffffff;
        }

        label {
            display: block;
            margin-top: 16px;
            font-weight: 600;
            color: #ccc;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-top: 6px;
            border: none;
            border-radius: 8px;
            background-color: #2e2e4d;
            color: #ffffff;
            box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border: 2px solid #8847ff;
        }

        .role-options {
            display: flex;
            gap: 25px;
            margin-top: 10px;
            padding-left: 5px;
        }

        .role-options label {
            font-weight: normal;
            color: #ddd;
            display: flex;
            align-items: center;
        }

        input[type="submit"] {
            background: linear-gradient(to right, #6a00f4, #d000ff);
            color: white;
            padding: 14px;
            border: none;
            width: 100%;
            margin-top: 30px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
            transition: box-shadow 0.3s ease, transform 0.2s ease;
        }

        input[type="submit"]:hover {
            box-shadow: 0 0 14px #bb00ff;
            transform: translateY(-2px);
        }

        .message {
            margin-top: 20px;
            color: #00ff99;
            text-align: center;
        }

        .back {
            text-align: center;
            margin-top: 25px;
        }

        .back a {
            color: #9ecbff;
            text-decoration: none;
        }

        .back a:hover {
            text-decoration: underline;
            color: #ffffff;
        }
    </style>
</head>
<body>

<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username != null && email != null && password != null && role != null &&
            !username.isEmpty() && !email.isEmpty() && !password.isEmpty() && !role.isEmpty()) {

            Connection con = null;
            PreparedStatement ps = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                String dbUser = "root";
                String dbPass = "janhabi2004";

                con = DriverManager.getConnection(url, dbUser, dbPass);
                String sql = "INSERT INTO users(username, email, password, role) VALUES (?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password); // 🔒 In real apps, hash passwords!
                ps.setString(4, role);

                int row = ps.executeUpdate();
                if (row > 0) {
                    message = "✅ Registration successful! You can now login.";
                }
            } catch (SQLException e) {
                if (e.getErrorCode() == 1062) {
                    message = "⚠️ Username already taken!";
                } else {
                    message = "❌ Database error: " + e.getMessage();
                }
            } finally {
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        } else {
            message = "⚠️ Please fill all fields.";
        }
    }
%>

<div class="container">
    <h2>Register</h2>
    <form method="post">
        <label>Username:</label>
        <input type="text" name="username" required>

        <label>Email:</label>
        <input type="email" name="email" required>

        <label>Password:</label>
        <input type="password" name="password" required>

        <label>Role:</label>
        <div class="role-options">
            <label><input type="radio" name="role" value="user" required> User</label>
            <label><input type="radio" name="role" value="admin" required> Admin</label>
        </div>

        <input type="submit" value="Register">
    </form>

    <div class="message"><%= message %></div>

    <div class="back">
        <a href="index.jsp">← Back to Home</a>
    </div>
</div>

</body>
</html>
