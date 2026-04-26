<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login - Luxe Rental</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body style="display: flex; justify-content: center; align-items: center; height: 100vh;">
        
        <div class="form-box">
            <h2 class="text-center">Member Access</h2>
            
            <% if ("true".equals(request.getParameter("registered"))) { %>
                <p style="color: var(--success); text-align: center; margin-bottom: 15px;">Account created successfully!</p>
            <% } %>
            
            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <p style="color: var(--danger); text-align: center; margin-bottom: 15px;"><%= error %></p>
            <% } %>

            <form action="LoginServlet" method="POST">
                <label style="color: #888;">Email Address</label>
                <input type="email" name="email" required placeholder="example@gmail.com">

                <label style="color: #888;">Password</label>
                <input type="password" name="password" required placeholder="••••••••">

                <button type="submit" class="btn" style="width: 100%;">Secure Login</button>
            </form>
            
            <div class="mt-20 text-center" style="font-size: 0.9rem; color: #666;">
                Not a member yet? <a href="register.jsp" style="color: var(--gold);">Apply for Membership</a>
            </div>
        </div>
        
    </body>
</html>