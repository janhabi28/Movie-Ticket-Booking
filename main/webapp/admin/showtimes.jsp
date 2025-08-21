<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    String jdbcUser = "root";
    String jdbcPass = "janhabi2004";

    String message = "";
    String error = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String movieId = request.getParameter("movie_id");
        String cinemaId = request.getParameter("cinema_id");
        String showtime = request.getParameter("showtime");
        String screenId = request.getParameter("screen_id");

        if (movieId != null && cinemaId != null && showtime != null && screenId != null &&
            !movieId.isEmpty() && !cinemaId.isEmpty() && !showtime.isEmpty() && !screenId.isEmpty()) {

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPass)) {
                    String sqlInsert = "INSERT INTO shows (movie_id, cinema_id, showtime, screen_id) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement pst = con.prepareStatement(sqlInsert)) {
                        pst.setInt(1, Integer.parseInt(movieId));
                        pst.setInt(2, Integer.parseInt(cinemaId));
                        pst.setString(3, showtime);
                        pst.setInt(4, Integer.parseInt(screenId));
                        int rows = pst.executeUpdate();
                        message = rows > 0 ? "Showtime added successfully!" : "Failed to add showtime.";
                    }
                }
            } catch (Exception e) {
                error = "Error: " + e.getMessage();
            }
        } else {
            error = "Please fill in all fields.";
        }
    }

    String action = request.getParameter("action");
    String deleteId = request.getParameter("id");

    if ("delete".equals(action) && deleteId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPass)) {
                String sqlDelete = "DELETE FROM shows WHERE id = ?";
                try (PreparedStatement pst = con.prepareStatement(sqlDelete)) {
                    pst.setInt(1, Integer.parseInt(deleteId));
                    int deleted = pst.executeUpdate();
                    message = deleted > 0 ? "Showtime deleted." : "Failed to delete showtime.";
                }
            }
        } catch (Exception e) {
            error = "Error deleting showtime: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Manage Showtimes</title>
    <style>
        /* Dark theme background and font */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #1a1a2e;
            color: #e0e0e0;
            padding: 30px;
            margin: 0;
        }
        h1 {
            text-align: center;
            color: #00b894; /* teal accent */
            font-weight: 700;
            margin-bottom: 40px;
            text-shadow: 0 0 8px #00b894a1;
        }
        .message {
            color: #55efc4; /* light teal */
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .error {
            color: #d63031; /* coral red */
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
        }
        form {
            background-color: #16213e;
            max-width: 600px;
            margin: 0 auto 40px auto;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 184, 148, 0.3);
        }
        label {
            display: block;
            margin: 15px 0 6px;
            font-weight: 700;
            color: #81ecec; /* light cyan */
        }
        input[type="text"],
        input[type="datetime-local"] {
            width: 100%;
            padding: 12px 14px;
            border-radius: 6px;
            border: 1px solid #00cec9;
            background-color: #0f3460;
            color: #dfe6e9;
            font-size: 15px;
            transition: border-color 0.3s ease;
        }
        input[type="text"]:focus,
        input[type="datetime-local"]:focus {
            outline: none;
            border-color: #00b894;
            box-shadow: 0 0 8px #00b894aa;
        }
        button {
            margin-top: 20px;
            background-color: #00b894;
            color: #1a1a2e;
            font-weight: 700;
            font-size: 17px;
            border: none;
            border-radius: 8px;
            padding: 12px 0;
            width: 100%;
            cursor: pointer;
            box-shadow: 0 6px 14px rgba(0, 184, 148, 0.7);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        button:hover {
            background-color: #019875;
            box-shadow: 0 8px 20px rgba(0, 152, 117, 0.8);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #16213e;
            box-shadow: 0 8px 25px rgba(0, 184, 148, 0.2);
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            padding: 14px 20px;
            text-align: center;
            border-bottom: 1px solid #0f3460;
            font-weight: 600;
        }
        th {
            background-color: #00b894;
            color: #1a1a2e;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }
        tr:nth-child(even) {
            background-color: #0f3460;
        }
        tr:hover {
            background-color: #00b894;
            color: #1a1a2e;
            transition: background-color 0.3s ease;
        }
        a.delete-link {
            color: #d63031;
            font-weight: 700;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        a.delete-link:hover {
            color: #ff7675;
            text-decoration: underline;
        }
        .back-btn {
            display: block;
            width: 180px;
            margin: 40px auto 0;
            background: #00b894;
            color: #1a1a2e;
            padding: 12px 0;
            text-align: center;
            text-decoration: none;
            font-weight: 700;
            border-radius: 8px;
            box-shadow: 0 6px 18px rgba(0, 184, 148, 0.6);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        .back-btn:hover {
            background-color: #019875;
            box-shadow: 0 8px 22px rgba(0, 152, 117, 0.9);
        }
        @media (max-width: 700px) {
            form, table {
                padding: 15px;
                font-size: 14px;
            }
            button, .back-btn {
                width: 100%;
                font-size: 15px;
            }
        }
    </style>
</head>
<body>

<h1>🎬 Manage Showtimes</h1>

<% if (!message.isEmpty()) { %><p class="message"><%= message %></p><% } %>
<% if (!error.isEmpty()) { %><p class="error"><%= error %></p><% } %>

<form method="post" action="showtimes.jsp">
    <label for="movie_id">Movie ID</label>
    <input type="text" id="movie_id" name="movie_id" required />

    <label for="cinema_id">Cinema ID</label>
    <input type="text" id="cinema_id" name="cinema_id" required />

    <label for="showtime">Showtime</label>
    <input type="datetime-local" id="showtime" name="showtime" required />

    <label for="screen_id">Screen ID</label>
    <input type="text" id="screen_id" name="screen_id" required />

    <button type="submit">Add Showtime</button>
</form>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPass);
             PreparedStatement pst = con.prepareStatement("SELECT * FROM shows ORDER BY showtime ASC");
             ResultSet rs = pst.executeQuery()) {
%>
<table>
    <tr>
        <th>ID</th>
        <th>Movie ID</th>
        <th>Cinema ID</th>
        <th>Showtime</th>
        <th>Screen ID</th>
        <th>Action</th>
    </tr>
    <% while (rs.next()) { %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getInt("movie_id") %></td>
        <td><%= rs.getInt("cinema_id") %></td>
        <td><%= rs.getString("showtime") %></td>
        <td><%= rs.getInt("screen_id") %></td>
        <td>
            <a class="delete-link" href="showtimes.jsp?action=delete&id=<%= rs.getInt("id") %>" 
               onclick="return confirm('Are you sure you want to delete this showtime?');">Delete</a>
        </td>
    </tr>
    <% } %>
</table>
<% 
        }
    } catch (Exception e) {
        out.println("<p class='error'>Failed to fetch showtimes: " + e.getMessage() + "</p>");
    }
%>

<a href="admin.jsp" class="back-btn">🔙 Back to Dashboard</a>

</body>
</html>
