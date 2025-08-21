<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String movie = request.getParameter("movie");
    String cinema = request.getParameter("cinema");
    String location = request.getParameter("location");
    String showtime = request.getParameter("showtime");
    String seats = request.getParameter("seats");

    int totalSeats = (seats != null && !seats.isEmpty()) ? seats.split(",").length : 0;
    int pricePerSeat = 200;
    int totalPrice = totalSeats * pricePerSeat;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Payment | MovieNest</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #1e003c, #3b0066);
            color: #fff;
        }

        nav {
            background-color: #14002c;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(204, 0, 255, 0.2);
        }

        nav h2 {
            margin: 0;
            font-size: 24px;
            color: #ff99ff;
        }

        nav a {
            color: #ffcaff;
            text-decoration: none;
            margin-left: 20px;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        nav a:hover {
            color: #ffffff;
        }

        .container {
            max-width: 700px;
            margin: 50px auto;
            background: rgba(255, 255, 255, 0.05);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(255, 0, 255, 0.2);
            backdrop-filter: blur(6px);
        }

        h2 {
            text-align: center;
            color: #ffccff;
            margin-bottom: 30px;
        }

        .summary p {
            font-size: 17px;
            margin: 10px 0;
            color: #f1e3ff;
        }

        .summary span {
            font-weight: bold;
            color: #ff99ff;
        }

        label {
            display: block;
            margin: 20px 0 10px;
            color: #ffcaff;
            font-size: 16px;
        }

        .payment-option {
            margin-bottom: 12px;
        }

        input[type="radio"] {
            margin-right: 10px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 16px;
            background-color: #9900cc;
            border: none;
            color: white;
            font-size: 18px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(255, 102, 255, 0.3);
            transition: background 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #cc33ff;
        }
    </style>
</head>
<body>

<nav>
    <h2>🎬 MovieNest</h2>
    <div>
        <a href="user.jsp">Home</a>
        <a href="movies.jsp">Movies</a>
        <a href="bookticket.jsp">Book</a>
        <a href="logout.jsp">Logout</a>
    </div>
</nav>

<div class="container">
    <h2>💳 Payment Details</h2>

    <div class="summary">
        <p><span>Movie:</span> <%= movie %></p>
        <p><span>Cinema:</span> <%= cinema %></p>
        <p><span>Location:</span> <%= location %></p>
        <p><span>Showtime:</span> <%= showtime %></p>
        <p><span>Seats:</span> <%= seats %></p>
        <p><span>Total Price:</span> ₹<%= totalPrice %></p>
    </div>

    <form action="confirmation.jsp" method="post">
        <input type="hidden" name="movie" value="<%= movie %>">
        <input type="hidden" name="cinema" value="<%= cinema %>">
        <input type="hidden" name="location" value="<%= location %>">
        <input type="hidden" name="showtime" value="<%= showtime %>">
        <input type="hidden" name="seats" value="<%= seats %>">
        <input type="hidden" name="totalPrice" value="<%= totalPrice %>">

        <label>Select Payment Method:</label>
        <div class="payment-option">
            <input type="radio" name="paymentMethod" value="UPI" required> UPI
        </div>
        <div class="payment-option">
            <input type="radio" name="paymentMethod" value="Debit Card"> Debit Card
        </div>
        <div class="payment-option">
            <input type="radio" name="paymentMethod" value="Credit Card"> Credit Card
        </div>

        <input type="submit" value="Proceed to Pay ₹<%= totalPrice %>">
    </form>
</div>

</body>
</html>




