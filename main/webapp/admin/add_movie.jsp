<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Movie</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #121622;
            color: #d1d9e6;
            padding: 40px;
            margin: 0;
        }
        .container {
            background: #1f2937;
            padding: 30px;
            max-width: 600px;
            margin: auto;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(16, 185, 129, 0.6);
        }
        h2 {
            text-align: center;
            color: #10b981; /* teal green */
            margin-bottom: 30px;
            font-weight: 700;
            text-shadow: 0 0 6px #10b981aa;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #a0aec0;
        }
        input, textarea, select {
            width: 100%;
            padding: 12px 15px;
            font-size: 15px;
            border-radius: 8px;
            border: 1px solid #374151;
            background-color: #2d3748;
            color: #e2e8f0;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            resize: vertical;
        }
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #10b981;
            box-shadow: 0 0 8px #10b981aa;
            background-color: #324155;
        }
        input[type="submit"] {
            background-color: #10b981;
            color: #121622;
            font-weight: 700;
            font-size: 16px;
            border: none;
            padding: 14px 0;
            border-radius: 10px;
            cursor: pointer;
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.7);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        input[type="submit"]:hover {
            background-color: #34d399;
            box-shadow: 0 8px 25px rgba(52, 211, 153, 0.9);
            color: #121622;
        }
        .message {
            margin-top: 25px;
            font-weight: 700;
            text-align: center;
            font-size: 16px;
        }
        .message.success {
            color: #34d399;
            text-shadow: 0 0 6px #34d399bb;
        }
        .message.error {
            color: #f87171;
            text-shadow: 0 0 6px #f8717188;
        }
        /* Responsive */
        @media (max-width: 650px) {
            body {
                padding: 20px;
            }
            .container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Add New Movie</h2>

    <form method="post">
        <div class="form-group">
            <label>Title:</label>
            <input type="text" name="title" required>
        </div>
        <div class="form-group">
            <label>Description:</label>
            <textarea name="description" rows="4" required></textarea>
        </div>
        <div class="form-group">
            <label>Poster URL (path or full URL):</label>
            <input type="text" name="poster_url" required>
        </div>
        <div class="form-group">
            <label>Category:</label>
            <input type="text" name="category" required>
        </div>
        <div class="form-group">
            <label>Status:</label>
            <select name="status" required>
                <option value="now_showing">Now Showing</option>
                <option value="upcoming">Upcoming</option>
            </select>
        </div>
        <input type="submit" value="Add Movie">
    </form>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String posterUrl = request.getParameter("poster_url");
        String category = request.getParameter("category");
        String status = request.getParameter("status");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/movieticketdb", "root", "janhabi2004");

            String sql = "INSERT INTO movies (title, description, poster_url, category, status) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, posterUrl);
            ps.setString(4, category);
            ps.setString(5, status);

            int rows = ps.executeUpdate();
            if (rows > 0) {
%>
                <div class="message success">✅ Movie added successfully!</div>
<%
            } else {
%>
                <div class="message error">❌ Failed to add movie.</div>
<%
            }
        } catch (Exception e) {
%>
            <div class="message error">❌ Error: <%= e.getMessage() %></div>
<%
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception e) {}
        }
    }
%>

</div>
</body>
</html>
