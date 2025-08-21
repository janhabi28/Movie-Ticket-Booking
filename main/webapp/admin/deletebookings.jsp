<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<%
    String idStr = request.getParameter("id");
    if (idStr != null) {
        int id = Integer.parseInt(idStr);

        Connection con = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/movieticketdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
                "root", "janhabi2004"
            );

            String sql = "DELETE FROM bookings WHERE id = ?";
            pst = con.prepareStatement(sql);
            pst.setInt(1, id);

            int deleted = pst.executeUpdate();

            if(deleted > 0){
                response.sendRedirect("viewbookings.jsp?msg=deleted");
            } else {
                out.println("<p style='color:red; text-align:center;'>Error: Booking not found or already deleted.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red; text-align:center;'>Error deleting booking: " + e.getMessage() + "</p>");
        } finally {
            try { if (pst != null) pst.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    } else {
        out.println("<p style='color:red; text-align:center;'>No booking ID provided.</p>");
    }
%>
