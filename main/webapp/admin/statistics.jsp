<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&serverTimezone=UTC";
    String jdbcUser = "root";
    String jdbcPass = "janhabi2004";

    // Updated SQL: aggregate total bookings per movie, no month grouping
    String sql = "SELECT movie, COUNT(*) AS bookings_count " +
                 "FROM bookings " +
                 "GROUP BY movie " +
                 "ORDER BY movie;";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Booking Growth Stats</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #fff8f0; /* soft cream */
            margin: 0;
            padding: 30px;
            color: #2c3e50; /* dark slate */
        }
        h1 {
            color: #00796b; /* rich teal */
            text-align: center;
            font-weight: 700;
            margin-bottom: 40px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #ffffff;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            padding: 15px 20px;
            border-bottom: 1px solid #ddd;
            text-align: center;
            color: #34495e; /* slate */
            font-weight: 600;
        }
        th {
            background-color: #00796b; /* rich teal */
            color: #fff8f0;
            font-weight: 700;
            letter-spacing: 1px;
        }
        tr:nth-child(even) {
            background-color: #e3f2f1; /* light teal */
        }
        tr:hover {
            background-color: #ffebe6; /* soft coral hover */
            transition: background-color 0.3s ease;
        }
        .back-btn {
            display: block;
            width: 220px;
            margin: 40px auto 0 auto;
            background-color: #00796b;
            color: #fff8f0;
            padding: 12px 0;
            text-align: center;
            text-decoration: none;
            font-weight: 700;
            border-radius: 8px;
            box-shadow: 0 6px 18px rgba(0, 121, 107, 0.4);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        .back-btn:hover {
            background-color: #004d40;
            box-shadow: 0 8px 24px rgba(0, 77, 64, 0.7);
        }
        @media (max-width: 700px) {
            th, td {
                padding: 12px 8px;
                font-size: 14px;
            }
            .back-btn {
                width: 180px;
                padding: 10px 0;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

<h1>📊 Movie Booking Totals</h1>

<table>
    <tr>
        <th>Movie Title</th>
        <th># of Bookings</th>
    </tr>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPass);
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("movie") %></td>
        <td><%= rs.getInt("bookings_count") %></td>
    </tr>
<%
            }
        }
    } catch (Exception e) {
%>
    <tr>
        <td colspan="2" style="color:#d94c3d; font-weight:bold;">Error loading stats: <%= e.getMessage() %></td>
    </tr>
<%
    }
%>
</table>

<a href="admin.jsp" class="back-btn">🔙 Back to Dashboard</a>

</body>
</html>
