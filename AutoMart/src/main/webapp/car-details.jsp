<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.NumberFormat, com.automart.model.*" %>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    Car car = (Car) request.getAttribute("car");
    Boolean wishlisted = (Boolean) request.getAttribute("wishlisted");
    List<Car> recommendedCars = (List<Car>) request.getAttribute("recommendedCars");
    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }

  .am-pg { background: #e8f4fd; min-height: 100vh; padding: 1.5rem; font-family: sans-serif; }

  .am-detail-grid {
    display: grid;
    grid-template-columns: 1fr 390px;
    gap: 1.5rem;
    margin-bottom: 1.5rem;
  }

  .am-panel {
    background: #fff;
    border-radius: 14px;
    border: 1.5px solid #b3d9f5;
    padding: 1.25rem;
  }

  .am-gallery-wrap {
    border-radius: 10px;
    overflow: hidden;
    border: 1.5px solid #b3d9f5;
    background: #d0eaf9;
  }
  .am-gallery-wrap img {
    width: 100%;
    height: auto;
    display: block;
    object-fit: contain;
  }

  .am-thumbs {
    display: flex;
    gap: 8px;
    margin-top: 10px;
    flex-wrap: wrap;
  }
  .am-thumbs img {
    width: 80px;
    height: 60px;
    object-fit: cover;
    border-radius: 6px;
    border: 1.5px solid #b3d9f5;
    cursor: pointer;
    display: block;
  }
  .am-thumbs img:hover { border-color: #0c6ea8; }

  .am-desc { margin-top: 1rem; }
  .am-desc h2 { font-size: 16px; font-weight: 500; color: #0c3d5e; margin-bottom: 6px; }
  .am-desc p  { font-size: 13px; color: #4a7a9b; line-height: 1.6; }

  .am-chip {
    display: inline-block;
    background: #e8f4fd;
    color: #0c6ea8;
    border: 1px solid #7bc4ef;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 600;
    padding: 3px 12px;
    letter-spacing: 0.5px;
    margin-bottom: 10px;
  }

  .am-aside h1 { font-size: 20px; font-weight: 500; color: #0c3d5e; margin-bottom: 4px; }
  .am-price { font-size: 22px; font-weight: 600; color: #0c6ea8; margin-bottom: 1rem; }

  .am-specs {
    width: 100%;
    border-collapse: collapse;
    font-size: 13px;
    margin-bottom: 1rem;
    border: 1.5px solid #7bc4ef;
    border-radius: 10px;
    overflow: hidden;
  }
  .am-specs thead tr { background: #d0eaf9; }
  .am-specs thead th {
    padding: 8px 12px;
    text-align: left;
    color: #0c3d5e;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.7px;
    text-transform: uppercase;
    border-bottom: 1.5px solid #7bc4ef;
  }
  .am-specs tbody tr { border-bottom: 1px solid #d0eaf9; }
  .am-specs tbody tr:last-child { border-bottom: none; }
  .am-specs tbody tr:hover { background: #f0f8ff; }
  .am-specs td { padding: 9px 12px; vertical-align: middle; border-right: 1px solid #d0eaf9; }
  .am-specs td:first-child { color: #4a7a9b; }
  .am-specs td:last-child  { border-right: none; font-weight: 500; color: #0c3d5e; }

  .am-divider { border: none; border-top: 1.5px solid #d0eaf9; margin: 1rem 0; }

  .am-seller {
    font-size: 12px;
    color: #4a7a9b;
    margin-bottom: 1rem;
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
  }
  .am-seller span { display: flex; align-items: center; gap: 4px; }

  .am-form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
    margin-bottom: 10px;
  }
  .am-form-row label,
  .am-form-single label {
    display: flex;
    flex-direction: column;
    gap: 4px;
    font-size: 11px;
    font-weight: 600;
    color: #0c6ea8;
    letter-spacing: 0.3px;
  }
  .am-form-single { margin-bottom: 10px; }

  .am-form-row input,
  .am-form-single input,
  .am-form-single textarea {
    border: 1.5px solid #b3d9f5;
    border-radius: 8px;
    padding: 7px 10px;
    font-size: 13px;
    color: #0c3d5e;
    background: #fff;
    outline: none;
    width: 100%;
    font-family: inherit;
  }
  .am-form-single textarea { height: 72px; resize: none; }
  .am-form-row input:focus,
  .am-form-single input:focus,
  .am-form-single textarea:focus {
    border-color: #0c6ea8;
    box-shadow: 0 0 0 2px rgba(12,110,168,0.1);
  }

  .am-btn {
    height: 36px;
    padding: 0 1.25rem;
    background: #0c6ea8;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    text-decoration: none;
  }
  .am-btn:hover { background: #0a5a8c; }
  .am-btn-outline {
    background: #fff;
    color: #0c6ea8;
    border: 1.5px solid #0c6ea8;
  }
  .am-btn-outline:hover { background: #e8f4fd; }
  .am-btn-full { width: 100%; margin-bottom: 0.75rem; }

  .am-rec-section {
    background: #fff;
    border-radius: 14px;
    border: 1.5px solid #b3d9f5;
    padding: 1.25rem;
  }
  .am-rec-section h2 {
    font-size: 18px;
    font-weight: 500;
    color: #0c3d5e;
    margin-bottom: 1rem;
  }
  .am-rec-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
  }
  .am-rec-card {
    background: #f0f8ff;
    border-radius: 10px;
    border: 1.5px solid #b3d9f5;
    overflow: hidden;
    width: calc(25% - 0.75rem);
    flex-shrink: 0;
  }
  .am-rec-card:hover { border-color: #0c6ea8; }
  .am-rec-img {
    width: 100%;
    overflow: hidden;
    background: #d0eaf9;
  }
  .am-rec-img img {
    width: 100%;
    height: auto;
    display: block;
    object-fit: contain;
  }
  .am-rec-body { padding: 10px; }
  .am-rec-body h3 { font-size: 13px; font-weight: 500; color: #0c3d5e; margin-bottom: 3px; }
  .am-rec-price  { font-size: 13px; font-weight: 600; color: #0c6ea8; margin-bottom: 8px; }
  .am-rec-btn    { width: 100%; height: 30px; font-size: 12px; }

  @media (max-width: 900px) {
    .am-detail-grid { grid-template-columns: 1fr; }
    .am-rec-card { width: calc(50% - 0.5rem); }
  }
  @media (max-width: 600px) {
    .am-rec-card { width: 100%; }
  }
</style>

<div class="am-pg">

  <div class="am-detail-grid">

    <!-- Left: Gallery + Description -->
    <div>
      <div class="am-gallery-wrap">
        <img src="<%=ctx%>/<%=car.getPrimaryImage()%>" alt="<%=car.getCarName()%>">
      </div>

      <div class="am-thumbs">
        <% for (VehicleImage image : car.getImages()) { %>
          <img src="<%=ctx%>/<%=image.getImagePath()%>" alt="Vehicle image">
        <% } %>
      </div>

      <div class="am-panel am-desc">
        <h2><%=car.getCarName()%></h2>
        <ul style="padding-left: 20px; font-size: 13px; color: #4a7a9b; line-height: 1.8;">
        <% 
            String cleanDesc = car.getDescription() != null ? car.getDescription().replaceAll("[^\\x20-\\x7E]", "") : "";
            String[] sentences = cleanDesc.split("\\.\\s*");
            for (String s : sentences) {
                if (!s.trim().isEmpty()) {
        %>
            <li><%= s.trim() + "." %></li>
        <% 
                }
            } 
        %>
        </ul>
      </div>
    </div>

    <!-- Right: Aside -->
    <aside class="am-panel am-aside">

      <span class="am-chip"><%=car.getStatus()%></span>
      <h1><%=car.getCarName()%></h1>
      <div class="am-price"><%=money.format(car.getPrice())%></div>

      <table class="am-specs">
        <thead>
          <tr>
            <th>Specification</th>
            <th>Details</th>
          </tr>
        </thead>
        <tbody>
          <tr><td>Brand</td>        <td><%=car.getBrandName()%></td></tr>
          <tr><td>Model</td>        <td><%=car.getModel()%></td></tr>
          <tr><td>Year</td>         <td><%=car.getManufacturingYear()%></td></tr>
          <tr><td>Fuel</td>         <td><%=car.getFuelType()%></td></tr>
          <tr><td>Transmission</td> <td><%=car.getTransmissionType()%></td></tr>
          <tr><td>Mileage</td>      <td><%=(int)car.getMileage()%> km</td></tr>
          <tr><td>Color</td>        <td><%=car.getColor()%></td></tr>
          <tr><td>City</td>         <td><%=car.getCity()%></td></tr>
        </tbody>
      </table>

      <% if (currentUser != null) { %>
        <form action="<%=ctx%>/wishlist" method="post">
          <input type="hidden" name="carId" value="<%=car.getCarId()%>">
          <input type="hidden" name="action" value="<%=Boolean.TRUE.equals(wishlisted) ? "remove" : "add"%>">
          <button type="submit"
            class="am-btn am-btn-full <%=Boolean.TRUE.equals(wishlisted) ? "am-btn-outline" : ""%>">
            <%=Boolean.TRUE.equals(wishlisted) ? "&#9825; Remove from Wishlist" : "&#9825; Add to Wishlist"%>
          </button>
        </form>
      <% } %>

      <hr class="am-divider">

      <h3 style="font-size:14px;font-weight:600;color:#0c3d5e;margin-bottom:6px;">Contact Seller</h3>
      <div class="am-seller">
        <span>&#128100; <%=car.getSellerName()%></span>
        <span>&#128222; <%=car.getSellerPhone()%></span>
        <span>&#9993; <%=car.getSellerEmail()%></span>
      </div>

      <form action="<%=ctx%>/contact-seller" method="post">
        <input type="hidden" name="carId" value="<%=car.getCarId()%>">
        <div class="am-form-row">
          <label>NAME
            <input required name="name" value="<%=currentUser == null ? "" : currentUser.getName()%>">
          </label>
          <label>EMAIL
            <input required type="email" name="email" value="<%=currentUser == null ? "" : currentUser.getEmail()%>">
          </label>
        </div>
        <div class="am-form-single">
          <label>PHONE
            <input required name="phone" value="<%=currentUser == null ? "" : currentUser.getPhone()%>">
          </label>
        </div>
        <div class="am-form-single">
          <label>MESSAGE
            <textarea required name="message">I am interested in this vehicle. Please contact me.</textarea>
          </label>
        </div>
        <button class="am-btn am-btn-full" type="submit">&#10148; Send Request</button>
      </form>

    </aside>
  </div>

  <!-- Recommended -->
  <div class="am-rec-section">
    <h2>Recommended Vehicles</h2>
    <div class="am-rec-grid">
      <% for (Car item : recommendedCars) { %>
        <div class="am-rec-card">
          <div class="am-rec-img">
            <img src="<%=ctx%>/<%=item.getPrimaryImage()%>" alt="<%=item.getCarName()%>">
          </div>
          <div class="am-rec-body">
            <h3><%=item.getCarName()%></h3>
            <div class="am-rec-price"><%=money.format(item.getPrice())%></div>
            <a class="am-btn am-rec-btn"
               href="<%=ctx%>/car-details?id=<%=item.getCarId()%>">View</a>
          </div>
        </div>
      <% } %>
    </div>
  </div>

</div>

<%@ include file="/WEB-INF/footer.jsp" %>