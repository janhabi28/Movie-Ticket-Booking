<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>MovieNest - Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #1e003c, #3b0066);
            color: #ffffff;
        }

        nav {
            background-color: #000033;
            box-shadow: 0 4px 12px rgba(255, 0, 255, 0.2);
        }

        nav ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        nav ul li {
            display: inline-block;
        }

        nav ul li a {
            display: block;
            padding: 16px 22px;
            color: #ffccff;
            text-decoration: none;
            font-weight: 600;
            transition: background 0.3s ease, color 0.3s ease;
        }

        nav ul li a:hover {
            background-color: #4a0072;
            color: white;
        }

        nav ul li.right {
            margin-left: auto;
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
        }

        h2, h3 {
            text-align: center;
            margin: 25px 0 15px;
            color: #ff99ff;
            text-shadow: 1px 1px 4px #8800ff;
        }

        .movies-section {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .movie-card {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            width: 230px;
            box-shadow: 0 0 14px rgba(255, 0, 255, 0.15);
            overflow: hidden;
            text-align: center;
            backdrop-filter: blur(8px);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .movie-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 0 20px #cc33ff;
        }

        .movie-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-bottom: 3px solid #cc33ff;
        }

        .info {
            padding: 12px;
        }

        .info h4 {
            margin: 10px 0 6px;
            color: #ffccff;
            font-size: 18px;
            text-shadow: 1px 1px 2px #ff00cc;
        }

        .info p {
            font-size: 14px;
            color: #ddddff;
            min-height: 40px;
        }

        .book-btn {
            background: linear-gradient(to right, #3f00ff, #cc00ff);
            color: white;
            padding: 8px 14px;
            margin: 10px;
            border: none;
            font-size: 14px;
            font-weight: bold;
            border-radius: 6px;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(204, 51, 255, 0.4);
            text-decoration: none;
            display: inline-block;
            transition: background 0.3s ease, box-shadow 0.3s ease;
        }

        .book-btn:hover {
            background: linear-gradient(to right, #ff00cc, #8800ff);
            box-shadow: 0 6px 20px rgba(255, 102, 204, 0.8);
        }
    </style>
</head>
<body>

<!-- Navigation -->
<nav>
    <ul>
        <li><a href="user.jsp">🏠 Home</a></li>
        <li><a href="services.jsp">🛎️ Services</a></li>
        <li><a href="movies.jsp">🎞️ Movies</a></li>
        <li class="right"><a href="logout.jsp">🚪 Logout (<%= username %>)</a></li>
    </ul>
</nav>

<!-- Main Container -->
<div class="container">
    <h2>Welcome, <%= username %>!</h2>

    <!-- NOW SHOWING -->
    <h3>🎬 Now Showing</h3>
    <div class="movies-section">
    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&serverTimezone=UTC",
                "root", "janhabi2004"
            );

            String sqlNow = "SELECT id, title, description, poster_url FROM movies WHERE status='now_showing'";
            PreparedStatement psNow = con.prepareStatement(sqlNow);
            ResultSet rsNow = psNow.executeQuery();
            while (rsNow.next()) {
    %>
        <div class="movie-card">
            <img src="<%= rsNow.getString("poster_url") %>" alt="<%= rsNow.getString("title") %>" onerror="this.onerror=null; this.src='images/default.jpg';">
            <div class="info">
                <h4><%= rsNow.getString("title") %></h4>
                <p><%= rsNow.getString("description") %></p>
            </div>
            <a href="bookticket.jsp?movieId=<%= rsNow.getInt("id") %>" class="book-btn">🎟️ Book</a>
        </div>
    <%
            }
            rsNow.close();
            psNow.close();

            // UPCOMING SECTION
            out.println("</div><h3>🚀 Upcoming Movies</h3><div class='movies-section'>");

            String sqlUp = "SELECT id, title, description, poster_url FROM movies WHERE status='upcoming'";
            PreparedStatement psUp = con.prepareStatement(sqlUp);
            ResultSet rsUp = psUp.executeQuery();
            while (rsUp.next()) {
    %>
        <div class="movie-card">
            <img src="<%= rsUp.getString("poster_url") %>" alt="<%= rsUp.getString("title") %>" onerror="this.onerror=null; this.src='images/default.jpg';">
            <div class="info">
                <h4><%= rsUp.getString("title") %></h4>
                <p><%= rsUp.getString("description") %></p>
            </div>
        </div>
    <%
            }
            rsUp.close();
            psUp.close();
            con.close();
        } catch (Exception e) {
            out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
        }
    %>
    </div>
</div>

</body>
</html>
