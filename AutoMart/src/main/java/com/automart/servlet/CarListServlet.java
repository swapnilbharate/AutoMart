package com.automart.servlet;

import com.automart.dao.BrandDAO;
import com.automart.dao.CarDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/cars")
public class CarListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("cars", new CarDAO().findAll(
                    request.getParameter("q"), request.getParameter("brandId"), request.getParameter("fuelType"),
                    request.getParameter("transmissionType"), request.getParameter("minPrice"),
                    request.getParameter("maxPrice"), request.getParameter("year"), request.getParameter("city")));
            request.setAttribute("brands", new BrandDAO().findAll());
            request.getRequestDispatcher("/cars.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException("Unable to load cars.", ex);
        }
    }
}
