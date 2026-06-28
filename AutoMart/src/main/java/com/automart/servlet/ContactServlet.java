package com.automart.servlet;

import com.automart.dao.ContactRequestDAO;
import com.automart.model.ContactRequest;
import com.automart.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/contact-seller")
public class ContactServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ContactRequest contact = new ContactRequest();
            User user = (User) request.getSession().getAttribute("user");
            if (user != null) {
                contact.setUserId(user.getUserId());
            }
            contact.setCarId(Integer.parseInt(request.getParameter("carId")));
            contact.setName(request.getParameter("name"));
            contact.setEmail(request.getParameter("email"));
            contact.setPhone(request.getParameter("phone"));
            contact.setMessage(request.getParameter("message"));
            new ContactRequestDAO().create(contact);
            response.sendRedirect("car-details?id=" + contact.getCarId() + "&success=Request sent to dealer");
        } catch (Exception ex) {
            throw new ServletException("Contact request failed.", ex);
        }
    }
}
