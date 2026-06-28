package com.automart.servlet;

import com.automart.dao.UserDAO;
import com.automart.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String password = request.getParameter("password");
        if (password == null || password.length() < 6) {
            response.sendRedirect("register.jsp?error=Password must be at least 6 characters");
            return;
        }
        User user = new User();
        user.setName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setPasswordHash(password);
        user.setCity(request.getParameter("city"));
        String role = "ADMIN".equalsIgnoreCase(request.getParameter("role")) ? "ADMIN" : "USER";
        user.setRole(role);
        try {
            new UserDAO().register(user);
            response.sendRedirect("login.jsp?success=Registration successful. Please login.");
        } catch (Exception ex) {
            response.sendRedirect("register.jsp?error=Email already exists or registration failed");
        }
    }
}
