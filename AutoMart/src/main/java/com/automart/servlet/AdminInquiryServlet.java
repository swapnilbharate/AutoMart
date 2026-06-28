package com.automart.servlet;

import com.automart.dao.ContactRequestDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/inquiries")
public class AdminInquiryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("requests", new ContactRequestDAO().findAll());
            request.getRequestDispatcher("/admin-inquiries.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException("Unable to load inquiries.", ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            new ContactRequestDAO().updateStatus(Integer.parseInt(request.getParameter("requestId")), request.getParameter("status"));
            response.sendRedirect("inquiries?success=Inquiry updated");
        } catch (Exception ex) {
            throw new ServletException("Inquiry update failed.", ex);
        }
    }
}
