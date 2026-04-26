<%@page import="com.rental.entity.Cars"%>
<%@page import="com.rental.entity.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Vehicle</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body style="display: flex; justify-content: center; align-items: center; min-height: 100vh;">

    <%
        // Security Check
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }
        
        // Get the car data sent by the Servlet
        Cars c = (Cars) request.getAttribute("car");
        if (c == null) { response.sendRedirect("admin_dashboard.jsp"); return; }
    %>

    <div class="form-box" style="width: 500px;">
        <h2 class="text-center">Edit Vehicle Details</h2>
        <p class="text-center" style="color: #888; margin-bottom: 20px;">Updating ID: #<%= c.getCarId() %></p>

        <form action="CarServlet" method="POST">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= c.getCarId() %>">

            <label style="color: #aaa;">Brand</label>
            <input type="text" name="brand" value="<%= c.getBrand() %>" required>

            <label style="color: #aaa;">Model</label>
            <input type="text" name="model" value="<%= c.getModel() %>" required>

            <label style="color: #aaa;">License Plate</label>
            <input type="text" name="license" value="<%= c.getLicensePlate() %>" required>

            <label style="color: #aaa;">Daily Rate (RM)</label>
            <input type="number" name="rate" step="0.01" value="<%= c.getDailyRate() %>" required>

            <label style="color: #aaa;">Image Filename</label>
            <input type="text" name="image" value="<%= c.getImageUrl() %>">

            <label style="color: #aaa;">Status</label>
            <select name="status" style="width: 100%; padding: 12px; background: #2a2a2a; border: 1px solid #444; color: white; margin-bottom: 20px;">
                <option value="AVAILABLE" <%= "AVAILABLE".equals(c.getStatus()) ? "selected" : "" %>>Available</option>
                <option value="UNAVAILABLE" <%= !"AVAILABLE".equals(c.getStatus()) ? "selected" : "" %>>Unavailable</option>
            </select>

            <button type="submit" class="btn" style="width: 100%;">Save Changes</button>
        </form>

        <div class="mt-20 text-center">
            <a href="admin_dashboard.jsp" style="color: #666;">Cancel</a>
        </div>
    </div>
</body>
</html>