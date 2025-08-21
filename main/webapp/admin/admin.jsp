<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Page</title>
    <!-- Font Awesome CDN for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            margin: 0; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #fff8f0; /* soft cream */
            color: #1e2a38; /* dark charcoal */
        }
        .navbar {
            background-color: #00796b; /* rich teal */
            color: #fff8f0; /* pale cream */
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 30px;
            box-shadow: 0 3px 8px rgba(0, 121, 107, 0.3);
        }
        .nav-left, .nav-right {
            display: flex;
            align-items: center;
        }
        .nav-left a, .nav-right span {
            color: #fff8f0; /* pale cream */
            text-decoration: none;
            margin-right: 25px;
            font-size: 16px;
            display: flex;
            align-items: center;
            cursor: pointer;
            font-weight: 600;
            transition: color 0.3s ease;
            border-radius: 4px;
            padding: 6px 10px;
        }
        .nav-left a:last-child {
            margin-right: 0;
        }
        .nav-left a:hover {
            background-color: #ff6f61; /* coral background on hover */
            color: #fff8f0;
            box-shadow: 0 0 8px rgba(255, 111, 97, 0.6);
        }
        .nav-left i, .nav-right i {
            margin-right: 8px;
            font-size: 18px;
        }
        .admin-name {
            font-weight: 700;
            font-size: 16px;
            display: flex;
            align-items: center;
        }
        .admin-name i {
            margin-right: 6px;
            color: #ff6f61; /* coral icon */
        }
        .content {
            padding: 40px 30px;
            text-align: center;
        }
        .content h1 {
            color: #00796b; /* rich teal heading */
            margin-bottom: 20px;
            font-weight: 700;
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }

        /* Button container */
        .button-container {
            margin-top: 30px;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
        }

        /* Buttons with soft cream background, coral border and teal text */
        .admin-button {
            background-color: #fff8f0; /* soft cream */
            color: #00796b; /* rich teal text */
            border: 3px solid #ff6f61; /* coral border */
            padding: 20px 40px;
            font-size: 20px;
            font-weight: 700;
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(255, 111, 97, 0.3);
        }
        .admin-button i {
            margin-right: 14px;
            font-size: 24px;
            color: #ff6f61; /* coral icons */
            transition: color 0.3s ease;
        }
        .admin-button:hover {
            background: linear-gradient(135deg, #ff6f61, #00796b); /* coral to teal gradient */
            color: #fff8f0; /* pale cream text */
            box-shadow: 0 8px 20px rgba(0, 121, 107, 0.7);
            transform: translateY(-4px);
        }
        .admin-button:hover i {
            color: #fff8f0; /* pale cream icons on hover */
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="nav-left">
        <a href="adminDashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="add_movie.jsp"><i class="fas fa-plus-circle"></i> Add Movie</a>
        <a href="movielistings.jsp"><i class="fas fa-film"></i> Movie Listings</a>
    </div>
    <div class="nav-right">
        <span class="admin-name"><i class="fas fa-user-shield"></i> AdminUser</span>
    </div>
</nav>

<div class="content">
    <h1>Welcome, AdminUser!</h1>

    <div class="button-container">
        <a href="viewbookings.jsp" class="admin-button"><i class="fas fa-ticket-alt"></i> View Bookings</a>
        <a href="manageusers.jsp" class="admin-button"><i class="fas fa-users-cog"></i> Manage Users</a>
        <a href="showtimes.jsp" class="admin-button"><i class="fas fa-clock"></i> Showtimes</a>
        <a href="managepromotions.jsp" class="admin-button"><i class="fas fa-percent"></i> Promotions</a>
        <a href="statistics.jsp" class="admin-button"><i class="fas fa-chart-bar"></i> View Stats</a>
    </div>
</div>

</body>
</html>


