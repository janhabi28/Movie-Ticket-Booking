<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String movie = request.getParameter("movie");
    String showtime = request.getParameter("showtime");
    String seats = request.getParameter("seats"); // comma-separated
    int seatCount = 0;
    if (seats != null && !seats.isEmpty()) {
        seatCount = seats.split(",").length;
    }
    int seatPrice = 200;
    int totalPrice = seatCount * seatPrice;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Summary | MovieNest</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #1e003c, #3b0066);
            margin: 0;
            padding: 40px 20px;
            color: #fff;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background: rgba(255, 255, 255, 0.05);
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(204, 0, 255, 0.2);
            backdrop-filter: blur(6px);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #ff99ff;
            text-shadow: 1px 1px 2px #cc00ff;
        }

        p {
            font-size: 18px;
            margin: 15px 0;
            color: #f1e3ff;
        }

        strong {
            color: #ffcaff;
        }

        form {
            margin-top: 30px;
            text-align: center;
        }

        input[type="submit"] {
            background-color: #9900cc;
            color: white;
            border: none;
            padding: 14px 32px;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(255, 102, 255, 0.3);
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #cc33ff;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>🎟️ Booking Summary</h2>
    <p><strong>Movie Name:</strong> <%= movie %></p>
    <p><strong>Show Time:</strong> <%= showtime %></p>
    <p><strong>Seats Selected:</strong> <%= (seats != null && !seats.isEmpty()) ? seats : "None" %></p>
    <p><strong>Total Price:</strong> ₹<%= totalPrice %></p>

    <form action="payment.jsp" method="post">
        <input type="hidden" name="movieName" value="<%= movie %>">
        <input type="hidden" name="showTime" value="<%= showtime %>">
        <input type="hidden" name="seatNumber" value="<%= seats %>">
        <input type="hidden" name="totalPrice" value="<%= totalPrice %>">

        <input type="submit" value="💳 Proceed to Payment">
    </form>
</div>

</body>
</html>

