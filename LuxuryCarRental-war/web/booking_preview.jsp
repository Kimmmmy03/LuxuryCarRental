<%@page import="com.rental.entity.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Confirm Reservation</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body style="display: flex; justify-content: center; align-items: center; min-height: 100vh;">

        <%
            Users user = (Users) session.getAttribute("user");
            if (user == null) { response.sendRedirect("login.jsp"); return; }
        %>

        <div class="form-box" style="width: 500px; border-top: 3px solid var(--gold);">
            <h2 class="text-center">Booking Summary</h2>
            <p class="text-center" style="color: #888; margin-bottom: 30px;">Please review your itinerary details.</p>

            <div style="background: #222; padding: 20px; border-radius: 4px; margin-bottom: 20px;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <span style="color: #aaa;">Vehicle</span>
                    <strong style="color: white;"><%= request.getParameter("model") %></strong>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <span style="color: #aaa;">Dates</span>
                    <span style="color: white; font-size: 0.9em;">
                        <fmt:formatDate value="${start}" pattern="dd MMM" /> - <fmt:formatDate value="${end}" pattern="dd MMM yyyy" />
                    </span>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <span style="color: #aaa;">Duration</span>
                    <span style="color: white;"><%= request.getAttribute("days") %> Days</span>
                </div>
                <hr style="border-color: #444; margin: 15px 0;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="color: var(--gold); font-size: 1.1em;">Total Amount</span>
                    <strong style="color: var(--gold); font-size: 1.5em;">RM ${total}</strong>
                </div>
            </div>

            <form action="BookingServlet" method="POST">
                <input type="hidden" name="action" value="confirm">
                <input type="hidden" name="carId" value="<%= request.getParameter("carId") %>">
                <input type="hidden" name="startDate" value="<fmt:formatDate value="${start}" pattern="yyyy-MM-dd" />">
                <input type="hidden" name="endDate" value="<fmt:formatDate value="${end}" pattern="yyyy-MM-dd" />">
                <input type="hidden" name="totalPrice" value="${total}">

                <button type="submit" class="btn" style="width: 100%;">Confirm & Pay</button>
            </form>

            <div class="mt-20 text-center">
                <a href="javascript:history.back()" style="color: #666; font-size: 0.9em;">Modify Dates</a>
            </div>
        </div>
    </body>
</html>