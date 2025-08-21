<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>All Movies | MovieNest</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #1e003c, #3b0066);
            margin: 0;
            padding: 0;
            color: #fff;
        }

        .navbar {
            background-color: #000033;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 30px;
            box-shadow: 0 4px 12px rgba(255, 0, 255, 0.2);
        }

        .navbar .left-links {
            display: flex;
            align-items: center;
        }

        .navbar .logo {
            font-size: 22px;
            font-weight: bold;
            margin-right: 30px;
            color: #ff66cc;
            text-shadow: 1px 1px 2px #660099;
        }

        .navbar a {
            color: #ffccff;
            text-decoration: none;
            margin-right: 20px;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .navbar a:hover {
            color: #ffffff;
            text-shadow: 0 0 8px #ff33cc;
        }

        .auth-buttons a {
            background: #cc33ff;
            padding: 6px 12px;
            border-radius: 5px;
            margin-left: 10px;
            font-size: 14px;
            color: white;
            box-shadow: 0 3px 8px rgba(204, 51, 255, 0.4);
            transition: background 0.3s ease;
        }

        .auth-buttons a:hover {
            background: #ff66cc;
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #ff99ff;
            text-shadow: 1px 1px 3px #9900cc;
        }

        .filter-form {
            text-align: center;
            margin-bottom: 30px;
        }

        .filter-form select,
        .filter-form button {
            padding: 8px 14px;
            font-size: 14px;
            margin: 4px;
            border: none;
            border-radius: 4px;
        }

        .filter-form select {
            background-color: #330066;
            color: #fff;
        }

        .filter-form button {
            background-color: #cc33ff;
            color: #fff;
            cursor: pointer;
        }

        .filter-form button:hover {
            background-color: #ff66cc;
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
            width: 220px;
            box-shadow: 0 0 12px rgba(255, 51, 204, 0.2);
            overflow: hidden;
            text-align: center;
            padding-bottom: 10px;
            backdrop-filter: blur(6px);
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
            padding: 10px;
            color: #ffffffcc;
        }

        .info h4 {
            margin: 10px 0 5px;
            color: #ffccff;
            font-size: 17px;
            text-shadow: 1px 1px 2px #cc00ff;
        }

        .info p {
            font-size: 14px;
            min-height: 40px;
        }

        .book-btn {
            background-color: #330099;
            border: none;
            color: #ff99ff;
            padding: 7px 12px;
            margin-top: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(102, 51, 153, 0.7);
            transition: background-color 0.3s ease;
        }

        .book-btn:hover {
            background-color: #cc33ff;
            color: white;
            box-shadow: 0 6px 18px rgba(255, 102, 204, 0.8);
        }

        .back {
            text-align: center;
            margin-top: 30px;
        }

        .back a {
            text-decoration: none;
            color: #ff99ff;
            font-weight: bold;
        }

        .back a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <div class="left-links">
        <div class="logo">MovieNest</div>
        <a href="index.jsp">🏠Home</a>
        <a href="movies.jsp">🎬Movies</a>
        <a href="services.jsp">🛎️Services</a>
    </div>
    <div class="auth-buttons">
        <a href="login.jsp">🔐 Login</a>
        <a href="register.jsp">📝 Register</a>
    </div>
</div>

<!-- Main Container -->
<div class="container">
    <h2>Browse All Movies</h2>

    <!-- Filter -->
    <div class="filter-form">
        <form method="get" action="movies.jsp">
            <label for="status">Filter by Status:</label>
            <select name="status" id="status">
                <option value="">All</option>
                <option value="now_showing" <%= "now_showing".equals(request.getParameter("status")) ? "selected" : "" %>>Now Showing</option>
                <option value="upcoming" <%= "upcoming".equals(request.getParameter("status")) ? "selected" : "" %>>Upcoming</option>
            </select>
            <button type="submit">Apply Filter</button>
        </form>
    </div>

    <!-- Movie Cards -->
    <div class="movies-section">
        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&serverTimezone=UTC",
                    "root", "janhabi2004"
                );

                String selectedStatus = request.getParameter("status");
                String sql;
                if (selectedStatus != null && !selectedStatus.isEmpty()) {
                    sql = "SELECT id, title, description, poster_url, category, status FROM movies WHERE status = ?";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, selectedStatus);
                } else {
                    sql = "SELECT id, title, description, poster_url, category, status FROM movies";
                    ps = con.prepareStatement(sql);
                }

                rs = ps.executeQuery();
                boolean found = false;
                while (rs.next()) {
                    found = true;
                    int movieId = rs.getInt("id");
                    String title = rs.getString("title");
                    String desc = rs.getString("description");
                    String img = rs.getString("poster_url");
                    String category = rs.getString("category");
                    String status = rs.getString("status");
        %>
                    <div class="movie-card">
                        <img src="<%= img %>" alt="<%= title %>" onerror="this.onerror=null; this.src='images/default.jpg';">
                        <div class="info">
                            <h4><%= title %></h4>
                            <p><em><%= category %></em></p>
                            <p><%= desc %></p>
                            <% if ("now_showing".equalsIgnoreCase(status)) { %>
                                <form action="bookticket.jsp" method="get">
                                    <input type="hidden" name="movieId" value="<%= movieId %>">
                                    <button class="book-btn" type="submit">🎟️ Book Now</button>
                                </form>
                            <% } %>
                        </div>
                    </div>
        <%
                }
                if (!found) {
                    out.println("<p style='text-align:center; color:#ddd;'>No movies found for selected status.</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch(Exception e) {}
                if (ps != null) try { ps.close(); } catch(Exception e) {}
                if (con != null) try { con.close(); } catch(Exception e) {}
            }
        %>
    </div>

    <!-- Back Link -->
    <div class="back">
        <a href="index.jsp">← Back to Home</a>
    </div>
</div>

</body>
</html>

