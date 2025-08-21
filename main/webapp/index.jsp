<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>MovieNest - Home</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #1e003c, #3b0066);
            color: #fff;
        }

        .navbar {
            background: rgba(0, 0, 60, 0.9);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 30px;
            box-shadow: 0 4px 10px rgba(255, 0, 255, 0.4);
        }

        .navbar-left, .navbar-right {
            display: flex;
            align-items: center;
        }

        .navbar .logo {
            font-size: 24px;
            font-weight: bold;
            margin-right: 30px;
            color: #ff33cc;
            text-shadow: 1px 1px 3px #8800ff;
        }

        .navbar a {
            color: #ddd;
            text-decoration: none;
            margin-right: 20px;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .navbar a:hover {
            color: #ffffff;
            text-shadow: 0 0 8px #ff00ff;
        }

        .navbar .btn {
            background: linear-gradient(to right, #6a00f4, #d000ff);
            color: white;
            padding: 6px 14px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(204, 51, 255, 0.6);
            transition: transform 0.2s ease, box-shadow 0.3s ease;
        }

        .navbar .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 51, 204, 0.8);
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
        }

        h2 {
            text-align: center;
            font-size: 32px;
            margin-bottom: 30px;
            color: #ff99ff;
            text-shadow: 1px 1px 4px #9900ff;
        }

        .movie-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 24px;
            justify-content: center;
        }

        .movie-card {
            background: rgba(255, 255, 255, 0.06);
            border-radius: 12px;
            width: 240px;
            backdrop-filter: blur(8px);
            box-shadow: 0 0 20px rgba(255, 0, 255, 0.15);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .movie-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 0 25px #cc33ff;
        }

        .movie-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-bottom: 3px solid #cc33ff;
        }

        .info {
            padding: 15px;
            text-align: center;
        }

        .info h4 {
            margin: 10px 0 8px;
            font-size: 18px;
            color: #ffccff;
            text-shadow: 1px 1px 2px #ff00cc;
        }

        .info p {
            font-size: 14px;
            color: #ddddff;
        }

        .book-btn {
            background: linear-gradient(to right, #3f00ff, #cc00ff);
            border: none;
            color: #fff;
            padding: 10px 18px;
            font-size: 14px;
            border-radius: 6px;
            margin-top: 10px;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(204, 51, 255, 0.5);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .book-btn:hover {
            background: linear-gradient(to right, #ff00cc, #8800ff);
            box-shadow: 0 6px 20px rgba(255, 102, 204, 0.8);
        }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <div class="navbar-left">
        <div class="logo">🎥 MovieNest</div>
        <a href="index.jsp">🏠 Home</a>
        <a href="movies.jsp">🎬 Movies</a>
        <a href="services.jsp">🛎️ Services</a>
    </div>
    <div class="navbar-right">
        <a href="login.jsp" class="btn">Login</a>
        <a href="register.jsp" class="btn">Register</a>
    </div>
</div>

<!-- Main Content -->
<div class="container">
    <h2>🎞️ Now Showing</h2>

    <div class="movie-grid">
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

                String sql = "SELECT id, title, description, poster_url, category FROM movies WHERE status = 'now_showing'";
                ps = con.prepareStatement(sql);
                rs = ps.executeQuery();

                while (rs.next()) {
                    int movieId = rs.getInt("id");
                    String title = rs.getString("title");
                    String desc = rs.getString("description");
                    String poster = rs.getString("poster_url");
                    String category = rs.getString("category");
        %>
                <div class="movie-card">
                    <img src="<%= poster %>" alt="<%= title %>" onerror="this.onerror=null; this.src='images/default.jpg';">
                    <div class="info">
                        <h4><%= title %></h4>
                        <p><em><%= category %></em></p>
                        <p><%= desc %></p>
                        <form action="bookticket.jsp" method="get">
                            <input type="hidden" name="movieId" value="<%= movieId %>">
                            <button class="book-btn" type="submit">🎟️ Book Now</button>
                        </form>
                    </div>
                </div>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (con != null) try { con.close(); } catch (Exception e) {}
            }
        %>
    </div>
</div>

</body>
</html>

