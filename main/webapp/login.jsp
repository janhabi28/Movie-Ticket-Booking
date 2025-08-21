<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login | MovieNest</title>
    <style>
        /* General Styling */
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #1b1b3a, #472b62);
            margin: 0;
            padding: 0;
            color: #ffffff;
        }

        /* Navbar */
        .navbar {
            background-color: #12122e;
            display: flex;
            align-items: center;
            padding: 12px 30px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.5);
        }

        .navbar .left-section {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-grow: 1;
        }

        .navbar .logo {
            font-size: 26px;
            font-weight: bold;
            color: #fdfdfd;
            text-shadow: 1px 1px 4px #ee00ff;
        }

        .navbar a {
            color: #ddd;
            text-decoration: none;
            padding: 8px 14px;
            border-radius: 6px;
            transition: background-color 0.3s, color 0.3s;
        }

        .navbar a:hover {
            background-color: #2b2b5f;
            color: #ff55cc;
        }

        /* Login Box */
        .login-container {
            max-width: 420px;
            margin: 80px auto;
            background: rgba(255, 255, 255, 0.05);
            padding: 35px 30px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(10px);
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #ffffff;
        }

        label {
            display: block;
            margin-top: 18px;
            font-weight: 600;
            color: #ddd;
        }

        input[type="text"],
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
        input[type="password"]:focus {
            outline: none;
            border: 2px solid #8847ff;
        }

        .role-options {
            margin-top: 10px;
            display: flex;
            gap: 12px;
        }

        .role-options label {
            font-weight: normal;
            display: flex;
            align-items: center;
            gap: 6px;
            color: #ccc;
        }

        input[type="submit"] {
            background: linear-gradient(to right, #6a00f4, #d000ff);
            color: white;
            padding: 14px;
            border: none;
            width: 100%;
            margin-top: 25px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 16px;
            cursor: pointer;
            transition: box-shadow 0.3s ease, transform 0.2s ease;
        }

        input[type="submit"]:hover {
            box-shadow: 0 0 12px #bb00ff;
            transform: translateY(-2px);
        }

        .message {
            color: #ff6b6b;
            text-align: center;
            margin-top: 20px;
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

<!-- Navbar -->
<div class="navbar">
    <div class="left-section">
        <div class="logo">MovieNest</div>
        <a href="movies.jsp">🎞️ Movies</a>
        <a href="services.jsp">🛎️ Services</a>
    </div>
</div>

<%
    String loginMessage = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username != null && password != null && role != null &&
            !username.isEmpty() && !password.isEmpty() && !role.isEmpty()) {

            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                String dbUser = "root";
                String dbPass = "janhabi2004";

                con = DriverManager.getConnection(url, dbUser, dbPass);
                String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND role = ?";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, role);

                rs = ps.executeQuery();

                if (rs.next()) {
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);

                    if ("admin".equalsIgnoreCase(role)) {
                        response.sendRedirect("admin/admin.jsp");
                    } else {
                        response.sendRedirect("user.jsp");
                    }
                    return;
                } else {
                    loginMessage = "Invalid username, password, or role.";
                }
            } catch (Exception e) {
                loginMessage = "Database error: " + e.getMessage();
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        } else {
            loginMessage = "Please fill in all fields.";
        }
    }
%>

<!-- Login Form -->
<div class="login-container">
    <h2>Login</h2>

    <form method="post">
        <label>Username:</label>
        <input type="text" name="username" required>

        <label>Password:</label>
        <input type="password" name="password" required>

        <label></label>
        <div class="role-options">
            <label><input type="radio" name="role" value="user" required> User</label>
            <label><input type="radio" name="role" value="admin" required> Admin</label>
        </div>

        <input type="submit" value="Login">
    </form>

    <div class="message"><%= loginMessage %></div>

    <div class="back">
        <a href="index.jsp">← Back to Home</a>
    </div>
</div>

</body>
</html>
