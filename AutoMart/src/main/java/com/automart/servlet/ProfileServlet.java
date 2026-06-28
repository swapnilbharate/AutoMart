package com.automart.servlet;

import com.automart.dao.UserDAO;
import com.automart.dao.ContactRequestDAO;
import com.automart.model.User;
import com.automart.model.ContactRequest;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User sessionUser = (User) request.getSession().getAttribute("user");
            ContactRequestDAO contactDAO = new ContactRequestDAO();
            List<ContactRequest> myRequests = contactDAO.getRequestsByUserId(sessionUser.getUserId());
            request.setAttribute("requests", myRequests);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User sessionUser = (User) request.getSession().getAttribute("user");
            User user = new User();
            user.setUserId(sessionUser.getUserId());
            user.setName(request.getParameter("name"));
            user.setPhone(request.getParameter("phone"));
            user.setCity(request.getParameter("city"));
            UserDAO dao = new UserDAO();
            dao.updateProfile(user);
            String newPassword = request.getParameter("newPassword");
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                dao.changePassword(user.getUserId(), newPassword);
            }
            request.getSession().setAttribute("user", dao.findById(user.getUserId()));
            response.sendRedirect("profile?success=Profile updated");
        } catch (Exception ex) {
            throw new ServletException("Profile update failed.", ex);
        }
    }
}