package com.automart.servlet;

import com.automart.dao.CarDAO;
import com.automart.dao.WishlistDAO;
import com.automart.model.Car;
import com.automart.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/car-details")
public class CarDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp?error=Please login first to view car details");
                return;
            }

            int carId = Integer.parseInt(request.getParameter("id"));
            Car car = new CarDAO().findById(carId);
            if (car == null) {
                response.sendRedirect("cars?error=Car not found");
                return;
            }
            request.setAttribute("wishlisted", new WishlistDAO().exists(user.getUserId(), carId));
            request.setAttribute("car", car);
            request.setAttribute("recommendedCars", new CarDAO().recommended(car.getCarId(), car.getBrandId(), car.getCity()));
            request.getRequestDispatcher("/car-details.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException("Unable to load car details.", ex);
        }
    }
}
