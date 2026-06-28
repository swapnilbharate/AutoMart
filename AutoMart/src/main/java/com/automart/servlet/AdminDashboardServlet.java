package com.automart.servlet;

import com.automart.dao.DashboardDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("stats", new DashboardDAO().getStats());
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException("Unable to load admin dashboard.", ex);
        }
    }
}
