<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<%
    String username = request.getParameter("username");

    if (username == null || username.trim().isEmpty()) {
        out.println("<p style='color:red; text-align:center;'>Invalid user.</p>");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
            "root", "janhabi2004"
        );

        String sql = "DELETE FROM users WHERE username = ?";
        pst = con.prepareStatement(sql);
        pst.setString(1, username);

        int rowsAffected = pst.executeUpdate();

        if (rowsAffected > 0) {
            // Success: redirect to manage users page
            response.sendRedirect("manageusers.jsp?msg=User+deleted+successfully");
        } else {
            out.println("<p style='color:red; text-align:center;'>User not found or could not be deleted.</p>");
        }

    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (pst != null) pst.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>
