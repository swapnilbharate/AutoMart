package com.automart.servlet;

import com.automart.dao.UserDAO;
import com.automart.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = new UserDAO().login(request.getParameter("email"), request.getParameter("password"));
            if (user == null) {
                response.sendRedirect("login.jsp?error=Invalid email or password");
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60);
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/cars");
            }
        } catch (Exception ex) {
            throw new ServletException("Login failed.", ex);
        }
    }
}
