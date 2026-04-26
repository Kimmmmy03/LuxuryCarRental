package com.rental.web;

import com.rental.entity.Bookings;
import com.rental.entity.Users;
import com.rental.session.BookingBeanLocal;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminBookingServlet", urlPatterns = {"/AdminBookingServlet"})
public class AdminBookingServlet extends HttpServlet {

    @EJB
    private BookingBeanLocal bookingBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Security Check (Admins Only)
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Handle Actions (Approve, Reject, Return)
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        if (action != null && idStr != null) {
            int id = Integer.parseInt(idStr);
            
            if ("approve".equals(action)) {
                bookingBean.updateBookingStatus(id, "APPROVED");
            } else if ("reject".equals(action)) {
                bookingBean.updateBookingStatus(id, "REJECTED");
            } else if ("return".equals(action)) {
                bookingBean.updateBookingStatus(id, "RETURNED");
            }
            
            // Refresh to show changes
            response.sendRedirect("AdminBookingServlet");
            return;
        }

        // 3. Load All Bookings & Show Page
        List<Bookings> allBookings = bookingBean.getAllBookings();
        request.setAttribute("bookingList", allBookings);
        request.getRequestDispatcher("admin_bookings.jsp").forward(request, response);
    }
}