<%@page import="java.util.List"%>
<%@page import="com.rental.entity.Cars"%>
<%@page import="com.rental.entity.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Luxury Car Rental</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <%
            Users user = (Users) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <nav class="navbar">
            <div class="logo">LUXE RENTAL</div>
            <div class="nav-links">
                <a href="#">Home</a>
                <a href="MyBookingsServlet">My Bookings</a>
                <span style="color: #666; margin: 0 15px;">|</span>
                <span style="font-size: 0.9em;">Welcome, <%= user.getFullName()%></span>
                <a href="LoginServlet?logout=true" style="color: var(--danger);">Logout</a>
            </div>
        </nav>

        <header style="
        /* This URL is a high-quality dark luxury car image */
        background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.8)), url('https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
        height: 70vh; /* Made it slightly taller for drama */
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        text-align: center;
        margin-bottom: 50px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.5); /* Adds a shadow below the banner */
    ">
        <h1 style="font-size: 3.5rem; margin-bottom: 10px; color: var(--gold); text-shadow: 2px 2px 4px rgba(0,0,0,0.8);">
            Experience the Extraordinary
        </h1>
        <p style="font-size: 1.2rem; color: #ddd; max-width: 600px; text-shadow: 1px 1px 2px rgba(0,0,0,0.8);">
            Drive the world's most exclusive vehicles. Premium service, unforgettable journeys.
        </p>
        <a href="#fleet" class="btn" style="margin-top: 30px; background: transparent; border: 2px solid var(--gold); color: var(--gold);">
            View Fleet
        </a>
    </header>

        <div class="container" id="fleet">
            <h2 class="text-center">Our Exclusive Fleet</h2>

            <div class="car-grid">
                <%
                    List<Cars> cars = (List<Cars>) request.getAttribute("featuredCars");
                    if (cars != null && !cars.isEmpty()) {
                        for (Cars c : cars) {
                %>
                <div class="car-card">
                    <img src="<%= (c.getImageUrl() != null && c.getImageUrl().startsWith("http")) ? c.getImageUrl() : "images/" + ((c.getImageUrl() != null && !c.getImageUrl().isEmpty()) ? c.getImageUrl() : "default_car.jpg")%>" 
                         alt="<%= c.getBrand()%>"
                         style="width: 100%; height: 200px; object-fit: cover; border-bottom: 1px solid #333;">

                    <div class="car-info">
                        <h3><%= c.getBrand()%> <%= c.getModel()%></h3>
                        <div class="price-tag">RM <%= c.getDailyRate()%> <span style="font-size:0.6em; color:#888;">/ DAY</span></div>

                        <% if ("AVAILABLE".equals(c.getStatus())) {%>
                        <a href="booking_form.jsp?carId=<%= c.getCarId()%>&model=<%= c.getModel()%>" class="btn" style="width:100%;">Book Now</a>
                        <% } else { %>
                        <button disabled style="background: #333; color: #555; width:100%; border:none; padding:10px;">Unavailable</button>
                        <% } %>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <p class="text-center">No vehicles available at the moment.</p>
                <% }%>
            </div>
        </div>

        <footer style="text-align: center; padding: 40px; color: #555; font-size: 0.8rem;">
            &copy; 2026 Luxe Rental Malaysia. All rights reserved.
        </footer>
    </body>
</html>