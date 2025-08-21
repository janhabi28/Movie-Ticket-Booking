<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Get logged-in user from session
    String username = null;
    if (session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
    }

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #1a0033; /* deep purple background */
            padding: 20px;
            color: #cfa5ff; /* neon purple text */
        }
        h2 {
            color: #9c6ade; /* lighter purple */
            text-align: center;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            background-color: #2e0059; /* darker purple */
            box-shadow:
                0 0 20px #bb99ff,
                inset 0 0 15px #7f44d9;
            margin-top: 20px;
            color: #cfa5ff;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #4b267f;
            text-align: left;
        }
        th {
            background-color: #7f44d9; /* neon highlight */
            color: #fff;
            text-shadow: 0 0 5px #bb99ff;
        }
        tr:hover {
            background-color: #3f1a72;
            box-shadow: 0 0 10px #bb99ff;
        }
        p {
            text-align: center;
            font-size: 18px;
            color: #cfa5ff;
            text-shadow: 0 0 8px #bb99ff;
        }
        .back-link {
            display: inline-block;
            padding: 12px 26px;
            background: linear-gradient(45deg, #9c6ade, #cfa5ff);
            color: #1a0033;
            font-weight: 700;
            border-radius: 30px;
            text-decoration: none;
            box-shadow:
                0 0 14px #bb99ff,
                inset 0 0 12px #7f44d9;
            transition: all 0.3s ease;
            user-select: none;
            text-align: center;
        }
        .back-link:hover {
            background: linear-gradient(45deg, #cfa5ff, #9c6ade);
            box-shadow:
                0 0 18px #ddbbff,
                inset 0 0 15px #9c6ade;
            color: #330044;
        }
        .back-link-container {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>

<h2>My Bookings</h2>

<%
    if (username == null) {
%>
    <p>You must be <a href="login.jsp" style="color:#bb99ff; text-decoration: underline;">logged in</a> to view your bookings.</p>
<%
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/movieticketdb", "root", "janhabi2004");

            String sql = "SELECT * FROM bookings WHERE username = ? ORDER BY booking_time DESC";
            pst = conn.prepareStatement(sql);
            pst.setString(1, username);
            rs = pst.executeQuery();

            if (!rs.isBeforeFirst()) {
%>
                <p>No bookings found.</p>
<%
            } else {
%>
                <table>
                    <tr>
                        <th>Movie</th>
                        <th>Cinema</th>
                        <th>Location</th>
                        <th>Showtime</th>
                        <th>Seats</th>
                        <th>Total Price</th>
                        <th>Payment Method</th>
                        <th>Booked On</th>
                    </tr>
<%
                while (rs.next()) {
%>
                    <tr>
                        <td><%= rs.getString("movie") %></td>
                        <td><%= rs.getString("cinema") %></td>
                        <td><%= rs.getString("location") %></td>
                        <td><%= rs.getString("showtime") %></td>
                        <td><%= rs.getString("seats") %></td>
                        <td>₹<%= rs.getString("total_price") %></td>
                        <td><%= rs.getString("payment_method") %></td>
                        <td><%= rs.getTimestamp("booking_time") %></td>
                    </tr>
<%
                }
%>
                </table>
<%
            }
        } catch (Exception e) {
            out.println("<p style='color:#ff5555; text-align:center;'>Error fetching bookings: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (pst != null) try { pst.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
%>

<div class="back-link-container">
    <a href="index.jsp" class="back-link">Back to Home</a>
</div>

</body>
</html>
