package com.automart.servlet;

import com.automart.dao.UserDAO;
import com.automart.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("users", new UserDAO().findAll());
            request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException("Unable to load user management.", ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            UserDAO dao = new UserDAO();
            if ("delete".equals(request.getParameter("action"))) {
                dao.deleteUser(Integer.parseInt(request.getParameter("userId")));
            } else {
                User user = new User();
                user.setUserId(Integer.parseInt(request.getParameter("userId")));
                user.setName(request.getParameter("name"));
                user.setPhone(request.getParameter("phone"));
                user.setCity(request.getParameter("city"));
                user.setRole(request.getParameter("role"));
                dao.updateUser(user);
            }
            response.sendRedirect("users?success=User updated");
        } catch (Exception ex) {
            throw new ServletException("User update failed.", ex);
        }
    }
}
