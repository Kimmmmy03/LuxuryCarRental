package com.rental.web;

import com.rental.entity.Users;
import com.rental.session.UserBeanLocal;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @EJB
    private UserBeanLocal userBean;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Get Form Data
            String name = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String license = request.getParameter("license");

            // 2. Create User Entity
            Users newUser = new Users();
            newUser.setFullName(name);
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setPhoneNumber(phone);
            newUser.setDriverLicenseNumber(license);
            newUser.setRole("CUSTOMER");

            // 3. Save to DB
            userBean.registerUser(newUser);

            // 4. Success -> Send to Login with a message
            response.sendRedirect("login.jsp?registered=true");
            
        } catch (Exception e) {
            // Duplicate email or other error
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}