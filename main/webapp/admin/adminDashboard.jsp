<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            background-color: #fff8f0; /* soft cream */
            color: #1e2a38; /* dark charcoal */
        }
        .navbar {
            background-color: #00796b; /* rich teal */
            overflow: hidden;
            box-shadow: 0 3px 8px rgba(0, 121, 107, 0.3);
        }
        .navbar a {
            float: left;
            color: #ffe9d6; /* pale cream */
            text-align: center;
            padding: 14px 22px;
            text-decoration: none;
            font-size: 17px;
            font-weight: 600;
            transition: background-color 0.3s ease, color 0.3s ease;
            border-radius: 4px;
            margin: 6px 8px;
            display: inline-block;
        }
        .navbar a:hover, .navbar a.active {
            background-color: #ff6f61; /* coral */
            color: white;
            box-shadow: 0 0 8px rgba(255, 111, 97, 0.6);
        }
        .navbar a.logout {
            float: right;
            background-color: #ff6f61; /* coral */
            color: white;
            font-weight: 700;
            border-radius: 4px;
            margin-right: 10px;
        }
        .navbar a.logout:hover {
            background-color: #e6513b; /* deeper coral */
            box-shadow: 0 0 10px rgba(230, 81, 59, 0.8);
        }

        .container {
            padding: 30px;
            max-width: 1100px;
            margin: 0 auto;
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #00796b; /* rich teal */
            font-weight: 700;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%; 
            border-collapse: collapse; 
            background: white;
            box-shadow: 0 4px 14px rgba(0, 121, 107, 0.15);
            border-radius: 12px;
            overflow: hidden;
        }
        th, td {
            padding: 16px 20px;
            border-bottom: 1px solid #ffddd6; /* very light coral */
            text-align: left;
            vertical-align: middle;
        }
        th {
            background-color: #ff6f61; /* coral */
            color: white;
            font-weight: 700;
            user-select: none;
        }
        tr:last-child td {
            border-bottom: none;
        }
        tr:hover {
            background-color: #ffe6e1; /* soft coral highlight */
            transition: background-color 0.3s ease;
        }
        img {
            width: 80px; 
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 3px 12px rgba(255, 111, 97, 0.3);
            transition: transform 0.3s ease;
        }
        img:hover {
            transform: scale(1.05);
        }
        .count {
            font-weight: 700;
            color: #00796b; /* rich teal */
        }
    </style>
</head>
<body>

<!-- NAVIGATION -->
<div class="navbar">
    <a href="admin.jsp">🏠 Home</a>
    <a class="active" href="adminDashboard.jsp">📊 Dashboard</a>
    <a href="add_movie.jsp">🎬 Add Movie</a>
    <a href="movielistings.jsp">🎥 Movie Listings</a>
    <a href="logout.jsp" class="logout">🚪 Logout</a>
</div>

<div class="container">
    <h2>Admin Dashboard </h2>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/movieticketdb", "root", "janhabi2004");

        String query = "SELECT m.id, m.title, m.poster_url, m.category, m.status, " +
                       "(SELECT COUNT(*) FROM bookings b WHERE b.movie = m.title) AS purchase_count " +
                       "FROM movies m";

        ps = con.prepareStatement(query);
        rs = ps.executeQuery();
%>

    <table>
        <tr>
            <th>ID</th>
            <th>Poster</th>
            <th>Title</th>
            <th>Category</th>
            <th>Status</th>
            <th>Tickets Purchased</th>
        </tr>

<%
        while (rs.next()) {
%>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><img src="<%= rs.getString("poster_url") %>" alt="Poster"></td>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getString("category") %></td>
            <td><%= rs.getString("status") %></td>
            <td class="count"><%= rs.getInt("purchase_count") %></td>
        </tr>
<%
        }
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception e) {}
    }
%>

    </table>
</div>

</body>
</html>
