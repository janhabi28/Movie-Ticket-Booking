<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Manage Users</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #fff8f0; /* soft cream */
            margin: 0;
            padding: 30px;
            color: #1e2a38; /* dark charcoal */
        }
        h1 {
            text-align: center;
            color: #00796b; /* rich teal */
            margin-bottom: 30px;
            font-weight: 700;
            text-shadow: 0 1px 2px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff8f0; /* soft cream */
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            padding: 14px 15px;
            border-bottom: 1px solid #ccc;
            text-align: center;
            color: #1e2a38;
        }
        th {
            background-color: #00796b; /* rich teal */
            color: #fff8f0;
            font-weight: 700;
        }
        tr:nth-child(even) {
            background-color: #f4f9ff; /* light teal-ish */
        }
        tr:hover {
            background-color: #ffebe6; /* light coral hover */
        }
        .delete-btn {
            background-color: #ff6f61; /* coral */
            color: #fff8f0;
            padding: 8px 14px;
            border-radius: 6px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 10px rgba(255, 111, 97, 0.4);
            cursor: pointer;
        }
        .delete-btn:hover {
            background-color: #e75b50; /* darker coral */
            box-shadow: 0 6px 15px rgba(231, 91, 80, 0.6);
        }
        .back-btn {
            display: inline-block;
            margin: 30px auto 0 auto;
            background-color: #00796b; /* rich teal */
            color: #fff8f0;
            padding: 12px 18px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 700;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 121, 107, 0.4);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        .back-btn:hover {
            background-color: #004d40; /* darker teal */
            box-shadow: 0 7px 20px rgba(0, 77, 64, 0.7);
        }
        @media (max-width: 700px) {
            th, td {
                padding: 10px 8px;
                font-size: 14px;
            }
            .delete-btn, .back-btn {
                padding: 8px 12px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

<h1>👥 User Management</h1>

<%
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
            "root", "janhabi2004"
        );

        String sql = "SELECT username, email, role FROM users ORDER BY username ASC";
        pst = con.prepareStatement(sql);
        rs = pst.executeQuery();
%>

<table>
    <tr>
        <th>Username</th>
        <th>Email</th>
        <th>Role</th>
        <th>Action</th>
    </tr>

<%
    while (rs.next()) {
        String username = rs.getString("username");
%>
    <tr>
        <td><%= username %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("role") %></td>
        <td>
            <a href="deleteuser.jsp?username=<%= java.net.URLEncoder.encode(username, "UTF-8") %>" 
               class="delete-btn" 
               onclick="return confirm('Are you sure you want to delete user <%= username %>?');">
               Delete
            </a>
        </td>
    </tr>
<%
    }
} catch (Exception e) {
    out.println("<p style='color:#d94c3d; text-align:center; font-weight:bold;'>Error: " + e.getMessage() + "</p>");
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (pst != null) pst.close(); } catch (Exception e) {}
    try { if (con != null) con.close(); } catch (Exception e) {}
}
%>
</table>

<div style="text-align:center;">
    <a href="admin.jsp" class="back-btn">🔙 Back to Dashboard</a>
</div>

</body>
</html>
