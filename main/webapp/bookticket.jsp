<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Book Ticket | MovieNest</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #1e003c, #3b0066);
            margin: 0;
            padding: 0;
            color: #fff;
        }

        nav {
            background-color: #000033;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(255, 0, 255, 0.2);
        }

        nav h2 {
            margin: 0;
            font-size: 24px;
            color: #ff66cc;
            text-shadow: 1px 1px 2px #9900cc;
        }

        nav .links a {
            color: #ffccff;
            text-decoration: none;
            margin-left: 20px;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        nav .links a:hover {
            color: white;
            text-shadow: 0 0 6px #ff33cc;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            background-color: rgba(255, 255, 255, 0.05);
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(255, 51, 204, 0.2);
            backdrop-filter: blur(6px);
        }

        h3 {
            text-align: center;
            margin-bottom: 30px;
            color: #ff99ff;
            text-shadow: 1px 1px 2px #cc00ff;
        }

        label {
            display: block;
            margin: 15px 0 5px;
            font-weight: bold;
            color: #ffccff;
        }

        select, input[type="text"] {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: none;
            background-color: #2a0055;
            color: white;
            box-shadow: inset 0 0 5px rgba(204, 102, 255, 0.5);
        }

        select:focus, input:focus {
            outline: none;
            box-shadow: 0 0 8px #cc33ff;
        }

        .seating {
            display: grid;
            grid-template-columns: repeat(10, 1fr);
            gap: 10px;
            margin-top: 25px;
        }

        .seat {
            padding: 12px 0;
            text-align: center;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .seat.available {
            background-color: #33cc99;
            color: white;
        }

        .seat.occupied {
            background-color: #ff4444;
            color: white;
            cursor: not-allowed;
        }

        .seat.selected {
            background-color: #ffcc00;
            color: black;
        }

        #summary {
            margin-top: 25px;
            font-size: 16px;
            color: #f1e3ff;
        }

        #summary span {
            font-weight: bold;
            color: #ffffff;
        }

        input[type="submit"] {
            margin-top: 30px;
            background-color: #9900cc;
            color: white;
            padding: 14px;
            border: none;
            width: 100%;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(255, 102, 255, 0.3);
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #cc33ff;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav>
    <h2>MovieNest</h2>
    <div class="links">
        <a href="user.jsp">🏠 Home</a>
        <a href="bookticket.jsp">🎟️ Book</a>
        <a href="movies.jsp">🎬 Movies</a>
        <a href="login.jsp">🔐 Login</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
</nav>

<div class="container">
    <h3>🎫 Book Your Ticket</h3>
    <form action="payment.jsp" method="post" onsubmit="return validateForm();">
        <label for="movie">Now Showing:</label>
        <select id="movie" name="movie" required>
            <option value="">--Select Movie--</option>
            <option value="Oppenheimer">Oppenheimer</option>
            <option value="Deadpool 3">Deadpool 3</option>
            <option value="Avatar 3">Avatar 3</option>
        </select>

        <label for="cinema">Select Cinema:</label>
        <select id="cinema" name="cinema" required>
            <option value="">--Select Cinema--</option>
            <option value="PVR">PVR</option>
            <option value="INOX">INOX</option>
        </select>

        <label for="location">Location:</label>
        <select id="location" name="location" required>
            <option value="">--Select Location--</option>
            <option value="Bhubaneswar">Bhubaneswar</option>
            <option value="Cuttack">Cuttack</option>
            <option value="Mumbai">Mumbai</option>
        </select>

        <label for="showtime">Select Timings:</label>
        <select id="showtime" name="showtime" required>
            <option value="">--Select Time--</option>
            <option value="12:00 PM">12:00 PM</option>
            <option value="3:00 PM">3:00 PM</option>
            <option value="6:00 PM">6:00 PM</option>
            <option value="9:00 PM">9:00 PM</option>
        </select>

        <label>Choose Your Seats:</label>
        <div class="seating" id="seating">
            <%-- Seats A1–D10 with some marked occupied --%>
            <%
                char[] rows = {'A', 'B', 'C', 'D'};
                for (char row : rows) {
                    for (int i = 1; i <= 10; i++) {
                        String seat = row + String.valueOf(i);
                        boolean isOccupied = (i % 5 == 0); // simulate occupied
            %>
                <div class="seat <%= isOccupied ? "occupied" : "available" %>" data-seat="<%= seat %>"><%= seat %></div>
            <%
                    }
                }
            %>
        </div>

        <input type="hidden" id="selectedSeats" name="seats" value="">

        <div id="summary">
            🎟️ Tickets Selected: <span id="ticketCount">0</span><br>
            💰 Total Price: ₹<span id="totalPrice">0</span>
        </div>

        <input type="submit" value="Confirm Booking">
    </form>
</div>

<script>
    const seats = document.querySelectorAll(".seat.available");
    const selectedSeatsInput = document.getElementById("selectedSeats");
    const ticketCount = document.getElementById("ticketCount");
    const totalPrice = document.getElementById("totalPrice");
    const seatPrice = 200;

    let selected = [];

    seats.forEach(seat => {
        seat.addEventListener("click", () => {
            const seatNum = seat.dataset.seat;

            if (seat.classList.contains("selected")) {
                seat.classList.remove("selected");
                selected = selected.filter(s => s !== seatNum);
            } else {
                seat.classList.add("selected");
                selected.push(seatNum);
            }

            selectedSeatsInput.value = selected.join(",");
            ticketCount.textContent = selected.length;
            totalPrice.textContent = selected.length * seatPrice;
        });
    });

    function validateForm() {
        if (selected.length === 0) {
            alert("Please select at least one seat to continue.");
            return false;
        }
        return true;
    }
</script>

</body>
</html>
