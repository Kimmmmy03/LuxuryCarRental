<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Apply for Membership</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body style="display: flex; justify-content: center; align-items: center; height: 100vh;">
        
        <div class="form-box" style="width: 400px;">
            <h2 class="text-center">New Membership</h2>
            
            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <p style="color: var(--danger); text-align: center;"><%= error %></p>
            <% } %>

            <form action="RegisterServlet" method="POST">
                <input type="text" name="fullName" placeholder="Full Name" required>
                <input type="email" name="email" placeholder="Email Address" required>
                <input type="password" name="password" placeholder="Password" required>
                <input type="text" name="phone" placeholder="Phone Number" required>
                <input type="text" name="license" placeholder="Driver's License ID" required>
                
                <button type="submit" class="btn" style="width: 100%;">Create Account</button>
            </form>
            
            <div class="mt-20 text-center" style="font-size: 0.9rem; color: #666;">
                Already a member? <a href="login.jsp" style="color: var(--gold);">Login here</a>
            </div>
        </div>
        
    </body>
</html>