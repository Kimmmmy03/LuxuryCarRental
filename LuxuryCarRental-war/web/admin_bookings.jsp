<%@page import="java.util.List"%>
<%@page import="com.rental.entity.Bookings"%>
<%@page import="com.rental.entity.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Bookings</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <%
            Users user = (Users) session.getAttribute("user");
            if (user == null || !"ADMIN".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }
        %>

        <nav class="navbar">
            <div class="logo" style="color: var(--danger);">ADMIN CONSOLE</div>
            <div class="nav-links">
                <a href="admin_dashboard.jsp">Dashboard</a>
                <a href="#" style="color: var(--gold);">Bookings</a>
                <span style="color: #666; margin: 0 15px;">|</span>
                <a href="LoginServlet?logout=true" style="color: var(--text-muted);">Logout</a>
            </div>
        </nav>

        <div class="container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2>Booking Requests</h2>
                <a href="admin_dashboard.jsp" class="btn" style="background: #333; font-size: 0.8em;">&larr; Back to Fleet</a>
            </div>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Vehicle</th>
                    <th>Schedule</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                <%
                    List<Bookings> list = (List<Bookings>) request.getAttribute("bookingList");
                    if (list != null && !list.isEmpty()) {
                        for (Bookings b : list) {
                %>
                <tr>
                    <td style="color: #666;">#<%= b.getBookingId() %></td>
                    <td>
                        <div style="font-weight: bold;"><%= b.getUserId().getFullName() %></div>
                        <div style="font-size: 0.8em; color: #888;"><%= b.getUserId().getEmail() %></div>
                    </td>
                    <td style="color: var(--gold);"><%= b.getCarId().getBrand() %> <%= b.getCarId().getModel() %></td>
                    <td>
                         <div style="font-size: 0.9em;">
                             <fmt:formatDate value="<%= b.getStartDate() %>" pattern="dd/MM" /> - 
                             <fmt:formatDate value="<%= b.getEndDate() %>" pattern="dd/MM" />
                         </div>
                    </td>
                    <td>RM <%= b.getTotalCost() %></td>
                    <td>
                        <% if ("PENDING".equals(b.getBookingStatus())) { %>
                            <span style="color: orange; font-weight: bold;">● PENDING</span>
                        <% } else if ("APPROVED".equals(b.getBookingStatus())) { %>
                            <span style="color: var(--success); font-weight: bold;">● APPROVED</span>
                        <% } else if ("REJECTED".equals(b.getBookingStatus())) { %>
                            <span style="color: var(--danger); font-weight: bold;">● REJECTED</span>
                        <% } else if ("RETURNED".equals(b.getBookingStatus())) { %>
                            <span style="color: #888;">● RETURNED</span>
                        <% } else { %>
                            <span style="color: #666;">● CANCELLED</span>
                        <% } %>
                    </td>
                    <td>
                        <% if ("PENDING".equals(b.getBookingStatus())) { %>
                            <a href="AdminBookingServlet?action=approve&id=<%= b.getBookingId() %>" class="btn" style="background: var(--success); padding: 5px 10px; font-size: 0.8em;">Approve</a>
                            <a href="AdminBookingServlet?action=reject&id=<%= b.getBookingId() %>" class="btn" style="background: var(--danger); padding: 5px 10px; font-size: 0.8em;">Reject</a>
                        <% } else if ("APPROVED".equals(b.getBookingStatus())) { %>
                            <a href="AdminBookingServlet?action=return&id=<%= b.getBookingId() %>" class="btn" style="background: #007bff; padding: 5px 10px; font-size: 0.8em;">Return Car</a>
                        <% } else { %>
                            <span style="color: #444;">—</span>
                        <% } %>
                    </td>
                </tr>
                <% 
                        }
                    } else {
                %>
                <tr><td colspan="7" class="text-center">No bookings found.</td></tr>
                <% } %>
            </table>
        </div>
    </body>
</html>