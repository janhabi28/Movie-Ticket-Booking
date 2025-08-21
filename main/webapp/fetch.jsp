<%@ page import="java.sql.*, java.util.*" %>
<%
    String movie = request.getParameter("movie");
    String json = "[";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/movieticketdb", "root", "janhabi2004");

        PreparedStatement ps = con.prepareStatement("SELECT DISTINCT cinema, location, showtime FROM movie WHERE name = ?");
        ps.setString(1, movie);
        ResultSet rs = ps.executeQuery();

        List<String> cinemas = new ArrayList<>();
        List<String> locations = new ArrayList<>();
        List<String> showtimes = new ArrayList<>();

        while (rs.next()) {
            String c = rs.getString("cinema");
            String l = rs.getString("location");
            String s = rs.getString("showtime");

            if (!cinemas.contains(c)) cinemas.add(c);
            if (!locations.contains(l)) locations.add(l);
            if (!showtimes.contains(s)) showtimes.add(s);
        }

        json += "{";
        json += "\"cinemas\": [" + String.join(",", cinemas.stream().map(c -> "\"" + c + "\"").toList()) + "],";
        json += "\"locations\": [" + String.join(",", locations.stream().map(l -> "\"" + l + "\"").toList()) + "],";
        json += "\"showtimes\": [" + String.join(",", showtimes.stream().map(s -> "\"" + s + "\"").toList()) + "]";
        json += "}";

        json += "]";
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        json = "[{\"error\":\"" + e.getMessage() + "\"}]";
    }

    response.setContentType("application/json");
    response.getWriter().write(json);
%>
