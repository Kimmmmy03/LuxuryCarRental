package com.rental.web;

import com.rental.entity.Bookings;
import com.rental.entity.Cars;
import com.rental.entity.Users;
import com.rental.session.BookingBeanLocal;
import com.rental.session.CarBeanLocal;
import java.io.IOException;
import java.math.BigDecimal; // IMPORT ADDED
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BookingServlet", urlPatterns = {"/BookingServlet"})
public class BookingServlet extends HttpServlet {

    @EJB
    private CarBeanLocal carBean;
    
    @EJB
    private BookingBeanLocal bookingBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("booking_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            // SCENARIO 1: PREVIEW (Calculate Cost)
            if ("preview".equals(action)) {
                String carIdStr = request.getParameter("carId");
                String startStr = request.getParameter("startDate");
                String endStr = request.getParameter("endDate");

                Date start = sdf.parse(startStr);
                Date end = sdf.parse(endStr);
                int carId = Integer.parseInt(carIdStr);

                if (start.after(end)) {
                    request.setAttribute("error", "Return date must be after pickup date.");
                    request.getRequestDispatcher("booking_form.jsp").forward(request, response);
                    return;
                }
                
                // Calculate Days
                long diff = end.getTime() - start.getTime();
                long days = TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
                if (days < 1) days = 1; 

                // --- BIG DECIMAL MATH ---
                Cars c = carBean.findCarById(carId);
                
                // Convert 'days' to BigDecimal and multiply
                BigDecimal daysBD = new BigDecimal(days);
                BigDecimal totalBD = c.getDailyRate().multiply(daysBD);
                
                // Convert back to double for display if needed, or keep as BigDecimal
                double total = totalBD.doubleValue(); 

                request.setAttribute("start", start);
                request.setAttribute("end", end);
                request.setAttribute("days", days);
                request.setAttribute("total", total); // Sending as double is fine for display
                request.setAttribute("car", c);
                
                request.getRequestDispatcher("booking_preview.jsp").forward(request, response);
            } 
            
            // SCENARIO 2: CONFIRM (Save to DB)
            else if ("confirm".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("carId"));
                Date start = sdf.parse(request.getParameter("startDate"));
                Date end = sdf.parse(request.getParameter("endDate"));
                
                // --- READ TOTAL AS DOUBLE OR BIGDECIMAL ---
                // Since we sent it as a simple number string, we can parse it as Double
                // and then convert to BigDecimal for the database
                double totalVal = Double.parseDouble(request.getParameter("totalPrice"));
                BigDecimal totalCost = BigDecimal.valueOf(totalVal);

                Bookings b = new Bookings();
                b.setUserId(user);
                b.setCarId(new Cars(carId));
                b.setStartDate(start);
                b.setEndDate(end);
                b.setTotalCost(totalCost); // Expects BigDecimal
                b.setBookingStatus("PENDING");
                b.setCreatedAt(new Date());

                bookingBean.createBooking(b);

                response.sendRedirect("MyBookingsServlet");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("booking_form.jsp").forward(request, response);
        }
    }
}