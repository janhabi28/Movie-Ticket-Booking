<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Movie Listings</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0; 
            padding: 0;
            background-color: #fff8f0; /* soft cream */
            color: #1e2a38; /* dark charcoal */
        }

        /* Navigation Bar */
        .navbar {
            background-color: #00796b; /* rich teal */
            overflow: hidden;
            box-shadow: 0 3px 8px rgba(0, 121, 107, 0.3);
            padding: 12px 30px;
            display: flex;
            align-items: center;
            font-weight: 600;
        }
        .navbar a {
            color: #fff8f0; /* pale cream */
            text-align: center;
            padding: 14px 20px;
            text-decoration: none;
            font-size: 17px;
            border-radius: 5px;
            margin-right: 12px;
            transition: background-color 0.3s ease;
        }
        .navbar a:hover {
            background-color: #ff6f61; /* coral hover */
            color: #fff8f0;
        }
        .navbar a.active {
            background-color: #ff6f61; /* coral active */
            color: #fff8f0;
            box-shadow: 0 0 10px rgba(255, 111, 97, 0.6);
        }
        .navbar a.logout {
            margin-left: auto;
            background-color: #ff6f61; /* coral */
            box-shadow: 0 0 8px rgba(255, 111, 97, 0.7);
        }
        .navbar a.logout:hover {
            background-color: #00796b; /* teal on hover */
            color: #fff8f0;
            box-shadow: none;
        }

        /* Main Content */
        .container {
            padding: 30px;
        }
        h2 {
            text-align: center;
            color: #00796b; /* rich teal */
            font-weight: 700;
            margin-bottom: 25px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }

        table {
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 20px;
            background-color: #fff8f0; /* soft cream */
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            padding: 14px; 
            text-align: left; 
            border-bottom: 1px solid #ccc;
            color: #1e2a38;
        }
        th {
            background-color: #00796b; /* rich teal */
            color: #fff8f0;
            font-weight: 700;
        }
        tr:hover {
            background-color: #ffebe6; /* very light coral on hover */
        }
        img {
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .delete-btn {
            background-color: #ff6f61; /* coral */
            color: #fff8f0;
            border: none; 
            padding: 8px 14px; 
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 10px rgba(255, 111, 97, 0.4);
        }
        .delete-btn:hover {
            background-color: #e75b50; /* darker coral */
            box-shadow: 0 6px 15px rgba(231, 91, 80, 0.6);
        }

        .message {
            text-align: center; 
            font-weight: bold; 
            margin-top: 20px;
            color: #2a7a60; /* dark teal green */
        }
        .message.error {
            color: #d94c3d; /* darker coral red */
        }
    </style>
</head>
<body>

<!-- NAVIGATION BAR -->
<div class="navbar">
    <a href="admin.jsp">🏠</a>
    <a href="adminDashboard.jsp">📊 Dashboard</a>
    <a href="add_movie.jsp">🎬 Add Movie</a>
    <a class="active" href="movieListings.jsp">🎥 Movie Listings</a>
    <a href="logout.jsp" class="logout">🚪 Logout</a>
</div>

<div class="container">
<h2>Movie Listings</h2>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String message = "";
    boolean isError = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/movieticketdb", "root", "janhabi2004");

        // Handle delete if form submitted
        String deleteId = request.getParameter("deleteId");
        if (deleteId != null && !deleteId.isEmpty()) {
            ps = con.prepareStatement("DELETE FROM movies WHERE id = ?");
            ps.setInt(1, Integer.parseInt(deleteId));
            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "✅ Movie deleted successfully.";
            } else {
                message = "❌ Movie not found.";
                isError = true;
            }
        }

        // Fetch all movies
        String query = "SELECT * FROM movies";
        ps = con.prepareStatement(query);
        rs = ps.executeQuery();
%>

<% if (!message.isEmpty()) { %>
    <div class="message <%= isError ? "error" : "" %>"><%= message %></div>
<% } %>

<table>
    <tr>
        <th>ID</th>
        <th>Poster</th>
        <th>Title</th>
        <th>Description</th>
        <th>Category</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><img src="<%= rs.getString("poster_url") %>" alt="Poster" width="80" height="100"></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("description") %></td>
        <td><%= rs.getString("category") %></td>
        <td><%= rs.getString("status") %></td>
        <td>
            <form method="post" onsubmit="return confirm('Are you sure you want to delete this movie?');">
                <input type="hidden" name="deleteId" value="<%= rs.getInt("id") %>">
                <button type="submit" class="delete-btn">Delete</button>
            </form>
        </td>
    </tr>
<%
    }
%>

</table>

<%
    } catch (Exception e) {
        out.println("<div class='message error'>❌ Error: " + e.getMessage() + "</div>");
    } finally {
        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception e) {}
    }
%>
</div>

</body>
</html>
