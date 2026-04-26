<%@page import="com.rental.entity.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Reserve Your Vehicle</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body style="display: flex; justify-content: center; align-items: center; min-height: 100vh;">
        
        <%
            Users user = (Users) session.getAttribute("user");
            if (user == null) { response.sendRedirect("login.jsp"); return; }
            
            String carId = request.getParameter("carId");
            String model = request.getParameter("model");
            String error = (String) request.getAttribute("error");
        %>
        
        <div class="form-box" style="width: 450px;">
            <h2 class="text-center" style="border-bottom: 1px solid #333; padding-bottom: 15px;">Reservation Details</h2>
            <p class="text-center" style="color: #888; margin-bottom: 20px;">Securing: <strong style="color: var(--gold);"><%= model %></strong></p>
            
            <% if (error != null) { %>
                <p style="color: var(--danger); text-align: center; margin-bottom: 15px;"><%= error %></p>
            <% } %>

            <form action="BookingServlet" method="POST">
                <input type="hidden" name="action" value="preview">
                <input type="hidden" name="carId" value="<%= carId %>">
                <input type="hidden" name="model" value="<%= model %>">
                
                <label style="color: #aaa;">Pick-up Date</label>
                <input type="date" name="startDate" required style="color-scheme: dark;">
                
                <label style="color: #aaa;">Return Date</label>
                <input type="date" name="endDate" required style="color-scheme: dark;">
                
                <button type="submit" class="btn" style="width: 100%; margin-top: 10px;">Check Availability & Price</button>
            </form>
            
            <div class="mt-20 text-center">
                <a href="HomeServlet" style="color: #666; font-size: 0.9em;">Cancel Reservation</a>
            </div>
        </div>
    </body>
</html>