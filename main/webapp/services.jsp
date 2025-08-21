<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>All Movies</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f9f9f9; margin: 0; padding: 0; }

        /* Navbar */
        .navbar {
            background-color: #000;
            color: white;
            display: flex;
            align-items: center;
            padding: 12px 30px;
        }

        .navbar .logo {
            font-size: 22px;
            font-weight: bold;
            margin-right: 30px;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            margin-right: 20px;
            font-weight: 600;
            transition: color 0.3s;
        }

        .navbar a:hover {
            color: #ccc;
        }

        /* Container and Movie Cards */
        .container { max-width: 1000px; margin: 40px auto 20px auto; padding: 0 20px; }
        h2 { color: #444; text-align: center; margin-bottom: 30px; }
        .movies-section {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }
        .movie-card {
            background: white;
            border-radius: 8px;
            width: 220px;
            box-shadow: 0 0 8px #ccc;
            overflow: hidden;
            text-align: center;
            padding-bottom: 10px;
        }
        .movie-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }
        .info {
            padding: 10px;
        }
        .info h4 { margin: 10px 0 5px; color: #222; }
        .info p { font-size: 14px; color: #555; }

        .back {
            text-align: center;
            margin-top: 30px;
        }
        .back a {
            text-decoration: none;
            color: #007bff;
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
    <div class="logo">MovieNest</div>
     <a href="index.jsp">🏠Home</a>
    <a href="movies.jsp">🎞️Movies</a>
    <a href="services.jsp">🛎️Services</a>
</div>

<div class="container">
    <h2>All Movies</h2>
    <div class="movies-section">
        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                String dbUser = "root";
                String dbPass = "janhabi2004";

                con = DriverManager.getConnection(url, dbUser, dbPass);
                String sql = "SELECT title, description, image, category FROM movies";
                ps = con.prepareStatement(sql);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String title = rs.getString("title");
                    String desc = rs.getString("description");
                    String img = rs.getString("image");
                    String category = rs.getString("category");
        %>
                    <div class="movie-card">
                        <img src="images/<%= img %>" alt="<%= title %>">
                        <div class="info">
                            <h4><%= title %></h4>
                            <p><em><%= category %></em></p>
                            <p><%= desc %></p>
                        </div>
                    </div>
        <%
                }
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error loading movies: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch(Exception e) {}
                if (ps != null) try { ps.close(); } catch(Exception e) {}
                if (con != null) try { con.close(); } catch(Exception e) {}
            }
        %>
    </div>
    <div class="back">
        <a href="index.jsp">← Back to Home</a>
    </div>
</div>

</body>
</html>
