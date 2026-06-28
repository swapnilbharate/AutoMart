package com.automart.servlet;

import com.automart.dao.WishlistDAO;
import com.automart.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            request.setAttribute("cars", new WishlistDAO().findByUser(user.getUserId()));
            request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException("Unable to load wishlist.", ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            int carId = Integer.parseInt(request.getParameter("carId"));
            String action = request.getParameter("action");
            WishlistDAO dao = new WishlistDAO();
            if ("remove".equals(action)) {
                dao.remove(user.getUserId(), carId);
            } else {
                dao.add(user.getUserId(), carId);
            }
            response.sendRedirect(request.getHeader("Referer") != null ? request.getHeader("Referer") : "wishlist");
        } catch (Exception ex) {
            throw new ServletException("Wishlist action failed.", ex);
        }
    }
}
