<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Invalidate the current session to log out the user
    if (session != null) {
        session.invalidate();
    }
    // Redirect to home page after logout
    response.sendRedirect("index.jsp");
%>
