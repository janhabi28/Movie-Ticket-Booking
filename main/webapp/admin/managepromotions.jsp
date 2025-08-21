<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&serverTimezone=UTC";
    String jdbcUser = "root";
    String jdbcPass = "janhabi2004";

    String message = "";
    String error = "";

    // Handle form submission for adding promotion
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String promoCode = request.getParameter("promo_code");
        String description = request.getParameter("description");
        String discountPercent = request.getParameter("discount_percent");
        String validUntil = request.getParameter("valid_until");

        if (promoCode != null && description != null && discountPercent != null && validUntil != null &&
            !promoCode.isEmpty() && !description.isEmpty() && !discountPercent.isEmpty() && !validUntil.isEmpty()) {
            try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPass)) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String insertSQL = "INSERT INTO promotions (promo_code, description, discount_percent, valid_until) VALUES (?, ?, ?, ?)";
                try (PreparedStatement pst = con.prepareStatement(insertSQL)) {
                    pst.setString(1, promoCode);
                    pst.setString(2, description);
                    pst.setDouble(3, Double.parseDouble(discountPercent));
                    pst.setDate(4, Date.valueOf(validUntil));
                    int rows = pst.executeUpdate();
                    message = rows > 0 ? "Promotion added successfully!" : "Failed to add promotion.";
                }
            } catch (Exception e) {
                error = "Error: " + e.getMessage();
            }
        } else {
            error = "Please fill in all fields.";
        }
    }

    // Handle delete promotion
    String action = request.getParameter("action");
    String deleteId = request.getParameter("id");

    if ("delete".equals(action) && deleteId != null) {
        try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPass)) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String deleteSQL = "DELETE FROM promotions WHERE id = ?";
            try (PreparedStatement pst = con.prepareStatement(deleteSQL)) {
                pst.setInt(1, Integer.parseInt(deleteId));
                int deleted = pst.executeUpdate();
                message = deleted > 0 ? "Promotion deleted." : "Failed to delete promotion.";
            }
        } catch (Exception e) {
            error = "Error deleting promotion: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Promotions</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #121212;
            color: #eee;
            padding: 30px;
            margin: 0;
        }
        h1 {
            text-align: center;
            color: #ff6f00; /* bold orange */
            text-shadow: 0 0 8px #ff6f0080;
            margin-bottom: 40px;
            font-weight: 700;
        }
        form {
            background: #1e1e1e;
            max-width: 600px;
            margin: 0 auto 40px;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(255, 111, 0, 0.4);
        }
        label {
            display: block;
            margin: 15px 0 8px;
            font-weight: 600;
            color: #ffa726;
        }
        input[type="text"],
        input[type="number"],
        input[type="date"] {
            width: 100%;
            padding: 12px 14px;
            border-radius: 8px;
            border: 1px solid #ff6f00;
            background-color: #2c2c2c;
            color: #fff;
            font-size: 15px;
            transition: border-color 0.3s ease;
        }
        input[type="text"]:focus,
        input[type="number"]:focus,
        input[type="date"]:focus {
            outline: none;
            border-color: #ffa726;
            box-shadow: 0 0 10px #ffa726aa;
        }
        button {
            margin-top: 20px;
            background-color: #ff6f00;
            color: #121212;
            font-weight: 700;
            font-size: 17px;
            border: none;
            border-radius: 10px;
            padding: 14px 0;
            width: 100%;
            cursor: pointer;
            box-shadow: 0 6px 18px rgba(255, 111, 0, 0.8);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        button:hover {
            background-color: #ffa726;
            box-shadow: 0 8px 22px rgba(255, 167, 38, 1);
        }
        .message {
            color: #80cbc4;
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .error {
            color: #ef5350;
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
        }
        table {
            width: 100%;
            margin-top: 30px;
            background: #1e1e1e;
            border-collapse: collapse;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(255, 111, 0, 0.3);
        }
        th, td {
            padding: 14px 20px;
            border-bottom: 1px solid #2c2c2c;
            text-align: center;
            font-weight: 600;
        }
        th {
            background-color: #ff6f00;
            color: #121212;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }
        tr:nth-child(even) {
            background-color: #2c2c2c;
        }
        tr:hover {
            background-color: #ffa726;
            color: #121212;
            transition: background-color 0.3s ease;
        }
        a.delete-link {
            color: #ef5350;
            font-weight: 700;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        a.delete-link:hover {
            color: #ff8a80;
            text-decoration: underline;
        }
        .back-btn {
            display: block;
            width: 200px;
            margin: 40px auto 0;
            background: #ff6f00;
            color: #121212;
            padding: 14px 0;
            text-align: center;
            text-decoration: none;
            font-weight: 700;
            border-radius: 10px;
            box-shadow: 0 6px 18px rgba(255, 111, 0, 0.8);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        .back-btn:hover {
            background-color: #ffa726;
            box-shadow: 0 8px 22px rgba(255, 167, 38, 1);
        }
        @media (max-width: 700px) {
            form, table {
                padding: 15px;
                font-size: 14px;
            }
            button, .back-btn {
                width: 100%;
                font-size: 16px;
            }
        }
    </style>
</head>
<body>

<h1>🎫 Manage Promotions & Discounts</h1>

<% if (!message.isEmpty()) { %><p class="message"><%= message %></p><% } %>
<% if (!error.isEmpty()) { %><p class="error"><%= error %></p><% } %>

<form method="post" action="managepromotions.jsp">
    <label for="promo_code">Promotion Code</label>
    <input type="text" id="promo_code" name="promo_code" required />

    <label for="description">Description</label>
    <input type="text" id="description" name="description" required />

    <label for="discount_percent">Discount Percent (%)</label>
    <input type="number" id="discount_percent" name="discount_percent" min="0" max="100" step="0.01" required />

    <label for="valid_until">Valid Until</label>
    <input type="date" id="valid_until" name="valid_until" required />

    <button type="submit">Add Promotion</button>
</form>

<%
    try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPass)) {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String sql = "SELECT * FROM promotions ORDER BY valid_until ASC";
        try (PreparedStatement pst = con.prepareStatement(sql); ResultSet rs = pst.executeQuery()) {
%>
<table>
    <tr>
        <th>ID</th>
        <th>Promo Code</th>
        <th>Description</th>
        <th>Discount (%)</th>
        <th>Valid Until</th>
        <th>Action</th>
    </tr>
    <% while (rs.next()) { %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("promo_code") %></td>
        <td><%= rs.getString("description") %></td>
        <td><%= rs.getDouble("discount_percent") %></td>
        <td><%= rs.getDate("valid_until") %></td>
        <td><a class="delete-link" href="managepromotions.jsp?action=delete&id=<%= rs.getInt("id") %>" 
               onclick="return confirm('Are you sure you want to delete this promotion?');">Delete</a></td>
    </tr>
    <% } %>
</table>
<%
        }
    } catch (Exception e) {
        out.println("<p class='error'>Failed to fetch promotions: " + e.getMessage() + "</p>");
    }
%>

<a href="admin.jsp" class="back-btn">🔙 Back to Dashboard</a>

</body>
</html>

