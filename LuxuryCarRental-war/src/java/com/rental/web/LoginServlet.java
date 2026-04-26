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
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @EJB
    private UserBeanLocal userBean;

    // 1. doGet handles LOGOUT and basic page visits
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String logout = request.getParameter("logout");
        
        // If user clicked "Logout"
        if ("true".equals(logout)) {
            HttpSession session = request.getSession(false); // Get session if it exists
            if (session != null) {
                session.invalidate(); // DESTROY the session
            }
            response.sendRedirect("login.jsp"); // Go back to login screen
            return;
        }

        // If user is already logged in, redirect them to the right place
        // (This prevents them from seeing the login screen again)
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            Users user = (Users) session.getAttribute("user");
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("HomeServlet");
            }
        } else {
            // If not logged in, just show the login page
            response.sendRedirect("login.jsp");
        }
    }

    // 2. doPost handles the LOGIN FORM submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        Users user = userBean.login(email, password);
        
        if (user != null) {
            // Login Success: Save user to Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Redirect based on Role
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("HomeServlet");
            }
        } else {
            // Login Failed
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
