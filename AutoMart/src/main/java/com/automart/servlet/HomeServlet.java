package com.automart.servlet;

import com.automart.dao.BrandDAO;
import com.automart.dao.CarDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            CarDAO carDAO = new CarDAO();
            request.setAttribute("featuredCars", carDAO.featured(6));   // all featured
            request.setAttribute("latestCars",   carDAO.latest(3));     // ✅ only 3 recent
            request.setAttribute("totalCars",    carDAO.countAll());    // ✅ total count
            request.setAttribute("brands",       new BrandDAO().findAll());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException("Unable to load homepage.", ex);
        }
    }
}