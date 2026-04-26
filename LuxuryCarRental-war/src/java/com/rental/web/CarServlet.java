package com.rental.web;

import com.rental.entity.Cars;
import com.rental.entity.Users;
import com.rental.session.CarBeanLocal;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CarServlet", urlPatterns = {"/CarServlet"})
public class CarServlet extends HttpServlet {

    @EJB
    private CarBeanLocal carBean;

    // doGet handles: Listing Cars, Deleting Cars, and LOADING the Edit Page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        // Security: If not admin, go to login
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            // Case 1: Delete a car
            int id = Integer.parseInt(request.getParameter("id"));
            carBean.deleteCar(id);
            // Refresh the list by calling this same servlet again
            response.sendRedirect("CarServlet");

        } else if ("edit".equals(action)) {
            // Case 2: Load the Edit Form
            int id = Integer.parseInt(request.getParameter("id"));
            Cars c = carBean.findCarById(id);
            request.setAttribute("car", c);
            request.getRequestDispatcher("edit_car.jsp").forward(request, response);

        } else {
            // Case 3 (Default): Show the Dashboard with the List
            List<Cars> list = carBean.getAllCars();
            request.setAttribute("carList", list);
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            // Common Fields
            String brand = request.getParameter("brand");
            String model = request.getParameter("model");
            String license = request.getParameter("license");
            BigDecimal rate = new BigDecimal(request.getParameter("rate"));
            String image = request.getParameter("image");

            if ("update".equals(action)) {
                // --- UPDATE LOGIC ---
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");

                Cars c = new Cars();
                c.setCarId(id);
                c.setBrand(brand);
                c.setModel(model);
                c.setLicensePlate(license);
                c.setDailyRate(rate);
                c.setImageUrl(image);
                c.setStatus(status);

                carBean.updateCar(c);

                // Add Success Message for Update
                request.getSession().setAttribute("successMessage", "Vehicle updated successfully!");

            } else {
                // --- ADD NEW CAR LOGIC ---
                if (carBean.isLicensePlateExists(license)) {
                    request.setAttribute("errorMessage", "Error: License Plate already exists!");

                    // RELOAD LIST so the dashboard isn't empty on error
                    List<Cars> list = carBean.getAllCars();
                    request.setAttribute("carList", list);

                    request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
                    return; // Stop here
                }

                Cars c = new Cars();
                c.setBrand(brand);
                c.setModel(model);
                c.setLicensePlate(license);
                c.setDailyRate(rate);
                c.setImageUrl(image);
                c.setStatus("AVAILABLE");

                carBean.addCar(c);

                // Add Success Message for Add
                request.getSession().setAttribute("successMessage", "New vehicle added successfully!");
            }

            // --- THE CRITICAL FIX ---
            // Redirect to the SERVLET, not the JSP. 
            // This forces 'doGet' to run again, fetching the fresh list of cars.
            response.sendRedirect("CarServlet");

        } catch (Exception e) {
            e.printStackTrace();
            // Optional: Set error message in session for this too
            response.sendRedirect("CarServlet");
        }
    }
}
