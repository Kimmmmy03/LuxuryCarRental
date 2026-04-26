package com.rental.web;

import com.rental.entity.Cars;
import com.rental.session.CarBeanLocal;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = {"/HomeServlet"})
public class HomeServlet extends HttpServlet {

    @EJB
    private CarBeanLocal carBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get all cars from the Database
        List<Cars> carList = carBean.getAllCars();

        // 2. Pass them to the JSP
        request.setAttribute("featuredCars", carList);

        // 3. Send user to the homepage
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}