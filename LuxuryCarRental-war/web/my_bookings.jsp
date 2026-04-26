<%@page import="java.util.List"%>
<%@page import="com.rental.entity.Bookings"%>
<%@page import="com.rental.entity.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>My Garage History</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <%
            Users user = (Users) session.getAttribute("user");
            if (user == null) { response.sendRedirect("login.jsp"); return; }
        %>

        <nav class="navbar">
            <div class="logo">LUXE RENTAL</div>
            <div class="nav-links">
                <a href="HomeServlet">Home</a>
                <a href="#" style="color: var(--gold);">My Bookings</a>
                <span style="color: #666; margin: 0 15px;">|</span>
                <a href="LoginServlet?logout=true" style="color: var(--danger);">Logout</a>
            </div>
        </nav>

        <div class="container">
            <h2>My Reservations</h2>
            <p style="color: #888; margin-bottom: 20px;">Manage your current and past journeys.</p>

            <table>
                <tr>
                    <th>Ref ID</th>
                    <th>Vehicle Model</th>
                    <th>Rental Period</th>
                    <th>Total Cost</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                <%
                    List<Bookings> list = (List<Bookings>) request.getAttribute("myBookings");
                    if (list != null && !list.isEmpty()) {
                        for (Bookings b : list) {
                %>
                <tr>
                    <td style="color: #666;">#<%= b.getBookingId() %></td>
                    <td style="color: var(--gold); font-weight: bold;"><%= b.getCarId().getBrand() %> <%= b.getCarId().getModel() %></td>
                    <td>
                        <fmt:formatDate value="<%= b.getStartDate() %>" pattern="dd MMM" /> - 
                        <fmt:formatDate value="<%= b.getEndDate() %>" pattern="dd MMM yyyy" />
                    </td>
                    <td>RM <%= b.getTotalCost() %></td>
                    <td>
                        <% if ("APPROVED".equals(b.getBookingStatus())) { %>
                            <span style="color: var(--success);">● CONFIRMED</span>
                        <% } else if ("CANCELLED".equals(b.getBookingStatus())) { %>
                            <span style="color: #666;">● CANCELLED</span>
                        <% } else if ("RETURNED".equals(b.getBookingStatus())) { %>
                            <span style="color: #888;">● COMPLETED</span>
                        <% } else { %>
                            <span style="color: orange;">● PENDING</span>
                        <% } %>
                    </td>
                    <td>
                        <% if (!"CANCELLED".equals(b.getBookingStatus()) && !"RETURNED".equals(b.getBookingStatus())) { %>
                            <a href="MyBookingsServlet?action=cancel&id=<%= b.getBookingId() %>" 
                               class="btn-danger"
                               style="padding: 5px 10px; border-radius: 4px; font-size: 0.8em;"
                               onclick="return confirm('Cancel this reservation?')">
                               Cancel
                            </a>
                        <% } else { %>
                            <span style="color: #444;">—</span>
                        <% } %>
                    </td> 
                </tr>
                <% 
                        }
                    } else {
                %>
                <tr><td colspan="6" class="text-center">No travel history found. <a href="HomeServlet" style="color: var(--gold);">Book a car now.</a></td></tr>
                <% } %>
            </table>
        </div>
    </body>
</html>