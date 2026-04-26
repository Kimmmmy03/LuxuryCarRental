<%@page import="java.util.List"%>
<%@page import="com.rental.entity.Cars"%>
<%@page import="com.rental.entity.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Command Center</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            /* Specific Admin Styles */
            .admin-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                border-bottom: 1px solid #333;
                padding-bottom: 20px;
            }
            .stat-card {
                background: #1a1a1a;
                padding: 20px;
                border: 1px solid #333;
                flex: 1;
                margin-right: 20px;
                text-align: center;
            }
            .action-bar {
                margin-bottom: 20px;
                display: flex;
                gap: 10px;
            }
        </style>
    </head>
    <body>
        <%
            Users user = (Users) session.getAttribute("user");
            if (user == null || !"ADMIN".equals(user.getRole())) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <nav class="navbar">
            <div class="logo" style="color: var(--danger);">ADMIN CONSOLE</div>
            <div class="nav-links">
                <span style="font-size: 0.9em; margin-right: 20px;">Administrator: <%= user.getFullName()%></span>
                <a href="LoginServlet?logout=true" style="color: var(--text-muted);">Logout</a>
            </div>
        </nav>

        <div class="container">

            <div class="action-bar">
                <a href="AdminBookingServlet" class="btn" style="border: 1px solid #555;">📂 Manage All Bookings</a>
                <a href="CarServlet" class="btn">↻ Refresh Fleet Data</a>
            </div>

            <div style="display: flex; gap: 30px; align-items: flex-start;">

                <div class="form-box" style="flex: 1; padding: 30px;">
                    <h3>Add New Asset</h3>
                    <%
                        String errorMsg = (String) request.getAttribute("errorMessage");
                        if (errorMsg != null && !errorMsg.isEmpty()) {
                    %>
                    <div style="background-color: #3e1e1e; color: #ff6b6b; padding: 10px; border: 1px solid #ff6b6b; margin-bottom: 15px; border-radius: 4px; font-size: 0.9rem;">
                        ⚠️ <%= errorMsg%>
                    </div>
                    <%
                        }
                    %>
                    <form action="CarServlet" method="POST">
                        <input type="text" name="brand" placeholder="Brand (e.g. Porsche)" required>
                        <input type="text" name="model" placeholder="Model (e.g. 911 GT3)" required>
                        <input type="text" name="license" placeholder="License Plate" required>
                        <input type="number" name="rate" placeholder="Daily Rate (RM)" step="0.01" required>
                        <input type="text" name="image" placeholder="Image Filename (e.g. car1.jpg)">
                        <button type="submit" class="btn" style="width: 100%;">Add to Fleet</button>
                    </form>
                </div>

                <div style="flex: 2;">
                    <h3>Current Fleet Inventory</h3>
                    <table>
                        <tr>
                            <th>ID</th>
                            <th>Vehicle</th>
                            <th>License</th>
                            <th>Rate</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                        <%
                            List<Cars> cars = (List<Cars>) request.getAttribute("carList");
                            if (cars != null) {
                                for (Cars c : cars) {
                        %>
                        <tr>
                            <td><%= c.getCarId()%></td>
                            <td style="color: var(--gold);"><%= c.getBrand()%> <%= c.getModel()%></td>
                            <td><%= c.getLicensePlate()%></td>
                            <td>RM <%= c.getDailyRate()%></td>
                            <td>
                                <% if ("AVAILABLE".equals(c.getStatus())) { %>
                                <span style="color: var(--success); font-size: 0.8em;">● AVAILABLE</span>
                                <% } else { %>
                                <span style="color: var(--danger); font-size: 0.8em;">● UNAVAILABLE</span>
                                <% }%>
                            </td>
                            <td>
                                <a href="CarServlet?action=edit&id=<%= c.getCarId()%>" 
                                   class="btn" 
                                   style="background: #999; padding: 5px 15px; font-size: 0.8rem; margin-right: 5px;">
                                    Edit
                                </a>

                                   
                                <a href="CarServlet?action=delete&id=<%= c.getCarId()%>" 
                                   onclick="return confirm('Remove this vehicle permanently?')"
                                   style="color: var(--danger); font-size: 0.8rem;">Remove</a>
                            </td>
                        </tr>
                        <%      }
                        } else {
                        %>
                        <tr><td colspan="6" class="text-center">No data. Click "Refresh Fleet Data".</td></tr>
                        <% }%>
                    </table>
                </div>
            </div>
        </div>

    </body>
</html>