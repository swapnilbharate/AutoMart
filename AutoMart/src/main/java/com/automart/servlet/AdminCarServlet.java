package com.automart.servlet;

import com.automart.dao.BrandDAO;
import com.automart.dao.CarDAO;
import com.automart.model.Car;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/cars")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 20 * 1024 * 1024)
public class AdminCarServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            CarDAO carDAO = new CarDAO();
            String editId = request.getParameter("editId");
            if (editId != null) {
                request.setAttribute("editCar", carDAO.findById(Integer.parseInt(editId)));
            }
            request.setAttribute("cars", carDAO.findAll(null, null, null, null, null, null, null, null));
            request.setAttribute("brands", new BrandDAO().findAll());
            request.getRequestDispatcher("/admin-cars.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException("Unable to load cars management.", ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            CarDAO dao = new CarDAO();
            if ("delete".equals(action)) {
                dao.delete(Integer.parseInt(request.getParameter("carId")));
                response.sendRedirect("cars?success=Car deleted");
                return;
            }
            Car car = parseCar(request);
            int carId;
            if ("update".equals(action)) {
                car.setCarId(Integer.parseInt(request.getParameter("carId")));
                dao.update(car);
                carId = car.getCarId();
            } else {
                carId = dao.create(car);
            }
            saveUploadedImages(request, dao, carId);
            response.sendRedirect("cars?success=Vehicle saved");
        } catch (Exception ex) {
            throw new ServletException("Vehicle save failed.", ex);
        }
    }

    private Car parseCar(HttpServletRequest request) {
        Car car = new Car();
        car.setBrandId(Integer.parseInt(request.getParameter("brandId")));
        car.setCarName(request.getParameter("carName"));
        car.setModel(request.getParameter("model"));
        car.setManufacturingYear(Integer.parseInt(request.getParameter("manufacturingYear")));
        car.setFuelType(request.getParameter("fuelType"));
        car.setTransmissionType(request.getParameter("transmissionType"));
        car.setMileage(Double.parseDouble(request.getParameter("mileage")));
        car.setColor(request.getParameter("color"));
        car.setPrice(new BigDecimal(request.getParameter("price")));
        car.setCity(request.getParameter("city"));
        car.setSellerName(request.getParameter("sellerName"));
        car.setSellerPhone(request.getParameter("sellerPhone"));
        car.setSellerEmail(request.getParameter("sellerEmail"));
        car.setDescription(request.getParameter("description"));
        car.setStatus(request.getParameter("status"));
        car.setFeatured("on".equals(request.getParameter("featured")));
        return car;
    }

    private void saveUploadedImages(HttpServletRequest request, CarDAO dao, int carId) throws Exception {
        String uploadDir = request.getServletContext().getRealPath("/assets/uploads");
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        boolean first = true;
        for (Part part : request.getParts()) {
            if (!"images".equals(part.getName()) || part.getSize() == 0) {
                continue;
            }
            String submitted = new File(part.getSubmittedFileName()).getName();
            String fileName = System.currentTimeMillis() + "_" + submitted.replaceAll("[^a-zA-Z0-9._-]", "_");
            part.write(uploadDir + File.separator + fileName);
            dao.addImage(carId, "assets/uploads/" + fileName, first);
            first = false;
        }
    }
}
