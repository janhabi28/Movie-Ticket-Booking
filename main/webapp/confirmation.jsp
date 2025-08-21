<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>

<%
    String username = (String) session.getAttribute("username");

    if (username == null || username.trim().isEmpty()) {
        response.sendRedirect("login.jsp?error=Please+login+first");
        return;
    }

    String movie = request.getParameter("movie");
    String cinema = request.getParameter("cinema");
    String location = request.getParameter("location");
    String showtime = request.getParameter("showtime");
    String seats = request.getParameter("seats");
    String totalPrice = request.getParameter("totalPrice");
    String paymentMethod = request.getParameter("paymentMethod");

    boolean inserted = false;
    String errorMessage = "";

    String bookedMovie = "", bookedCinema = "", bookedLocation = "", bookedShowtime = "";
    String bookedSeats = "", bookedPrice = "", bookedPaymentMethod = "";

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
            "root", "janhabi2004"
        );

        String insertSQL = "INSERT INTO bookings (username, movie, cinema, location, showtime, seats, total_price, payment_method) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pst = conn.prepareStatement(insertSQL);
        pst.setString(1, username);
        pst.setString(2, movie);
        pst.setString(3, cinema);
        pst.setString(4, location);
        pst.setString(5, showtime);
        pst.setString(6, seats);
        pst.setString(7, totalPrice);
        pst.setString(8, paymentMethod);

        int rows = pst.executeUpdate();
        inserted = rows > 0;
        pst.close();

        if (inserted) {
            String fetchSQL = "SELECT * FROM bookings WHERE username = ? ORDER BY id DESC LIMIT 1";
            pst = conn.prepareStatement(fetchSQL);
            pst.setString(1, username);
            rs = pst.executeQuery();

            if (rs.next()) {
                bookedMovie = rs.getString("movie");
                bookedCinema = rs.getString("cinema");
                bookedLocation = rs.getString("location");
                bookedShowtime = rs.getString("showtime");
                bookedSeats = rs.getString("seats");
                bookedPrice = rs.getString("total_price");
                bookedPaymentMethod = rs.getString("payment_method");
            }
        }

    } catch (Exception e) {
        errorMessage = "Database Error: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pst != null) pst.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Booking Confirmation | MovieNest</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #2a005f, #4b0082);
            margin: 0;
            padding: 0;
            color: #f0eaff;
        }

        .box {
            max-width: 650px;
            margin: 60px auto;
            background: rgba(255, 255, 255, 0.05);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(255, 0, 255, 0.3);
            backdrop-filter: blur(8px);
        }

        h2 {
            text-align: center;
            color: #cc99ff;
            margin-bottom: 30px;
        }

        p {
            font-size: 17px;
            margin: 12px 0;
            color: #f8e9ff;
        }

        strong {
            color: #ffccff;
        }

        .error {
            color: #ff4d6d;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
        }

        .button {
            display: inline-block;
            margin-top: 25px;
            padding: 12px 22px;
            background: #9900cc;
            color: white;
            text-decoration: none;
            font-weight: bold;
            border-radius: 8px;
            transition: background 0.3s;
        }

        .button:hover {
            background: #cc33ff;
        }

        .center {
            text-align: center;
        }
    </style>
</head>
<body>

<div class="box">
    <%
        if (inserted) {
    %>
        <h2>🎉 Booking Confirmed!</h2>
        <p><strong>Movie:</strong> <%= bookedMovie %></p>
        <p><strong>Cinema:</strong> <%= bookedCinema %></p>
        <p><strong>Location:</strong> <%= bookedLocation %></p>
        <p><strong>Showtime:</strong> <%= bookedShowtime %></p>
        <p><strong>Seats:</strong> <%= bookedSeats %></p>
        <p><strong>Total Paid:</strong> ₹<%= bookedPrice %></p>
        <p><strong>Payment Method:</strong> <%= bookedPaymentMethod %></p>
        <div class="center">
            <a href="mybookings.jsp" class="button">📄 View My Bookings</a>
        </div>
    <%
        } else {
    %>
        <p class="error"><%= errorMessage %></p>
        <div class="center">
            <a href="index.jsp" class="button">🔙 Go Back</a>
        </div>
    <%
        }
    %>
</div>

</body>
</html>


