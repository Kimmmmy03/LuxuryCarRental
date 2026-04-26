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

@WebServlet(name = "MyBookingsServlet", urlPatterns = {"/MyBookingsServlet"})
public class MyBookingsServlet extends HttpServlet {

    @EJB
    private BookingBeanLocal bookingBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Handle "Cancel" action if clicked
        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            bookingBean.cancelBooking(id);

            // Refresh the page to show the new status
            response.sendRedirect("MyBookingsServlet");
            return;
        }

        // Load the list
        List<Bookings> myList = bookingBean.getBookingsByUser(user.getUserId());
        request.setAttribute("myBookings", myList);

        request.getRequestDispatcher("my_bookings.jsp").forward(request, response);
    }
}
