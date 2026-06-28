<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.NumberFormat, com.automart.model.*" %>
<%@ include file="/WEB-INF/header.jsp" %>

<%
List<Car> featuredCars = (List<Car>) request.getAttribute("featuredCars");
List<Car> latestCars   = (List<Car>) request.getAttribute("latestCars");
List<Brand> brands     = (List<Brand>) request.getAttribute("brands");
Integer totalCars      = (Integer) request.getAttribute("totalCars");
NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<style>
body {
    background: #60a5fa;
}
</style>

<section class="hero">
    <div>
        <h1>Find Your Perfect Used Car</h1>
        <p>
            India's trusted marketplace for certified pre-owned vehicles.
            Browse verified listings, compare prices, contact sellers directly
            and drive home your dream car with confidence.
        </p>

        <form class="search-band" action="<%=ctx%>/cars" method="get">
            <input type="search" name="q" placeholder="Search by car, model, brand">

            <select name="brandId">
                <option value="">All Brands</option>
                <% for (Brand brand : brands) { %>
                <option value="<%=brand.getBrandId()%>"><%=brand.getBrandName()%></option>
                <% } %>
            </select>

            <select name="fuelType">
                <option value="">Fuel Type</option>
                <option>Petrol</option>
                <option>Diesel</option>
                <option>CNG</option>
                <option>Electric</option>
                <option>Hybrid</option>
            </select>

            <input type="text" name="city" placeholder="Enter City">

            <button class="btn primary" type="submit">Search Cars</button>
        </form>
    </div>

    <div class="hero-visual"></div>
</section>

<!-- ═══ FEATURED CARS ═══ -->
<section class="container">
    <div class="section-title">
        <div>
            <h2>Featured Cars
                <span style="font-size:13px; font-weight:500; color:#64748B; margin-left:8px;">
                    <%=totalCars%> total cars available
                </span>
            </h2>
            <p class="muted">Premium certified used cars selected by AutoMart experts.</p>
        </div>
        <a class="btn small" href="<%=ctx%>/cars">View All Cars</a>
    </div>

    <div class="grid cards">
        <% if (featuredCars == null || featuredCars.isEmpty()) { %>
            <p style="color:#64748B; font-size:14px;">No featured cars available right now.</p>
        <% } else { %>
            <% for (Car car : featuredCars) { %>
            <article class="car-card">
                <img src="<%=ctx%>/<%=car.getPrimaryImage()%>"
                     alt="<%=car.getCarName()%>"
                     onerror="this.style.background='linear-gradient(135deg,#0D1B2A,#1A3A4A)'; this.removeAttribute('src');">
                <div class="body">
                    <span class="chip"><%=car.getStatus()%></span>
                    <h3><%=car.getCarName()%></h3>
                    <p class="price"><%=money.format(car.getPrice())%></p>
                    <p class="meta">
                        &#128663; <%=car.getBrandName()%> &bull;
                        &#128197; <%=car.getManufacturingYear()%> &bull;
                        &#9981; <%=car.getFuelType()%> &bull;
                        &#128205; <%=car.getCity()%>
                    </p>
                    <a class="btn primary" href="<%=ctx%>/car-details?id=<%=car.getCarId()%>">View Details</a>
                </div>
            </article>
            <% } %>
        <% } %>
    </div>
</section>

<!-- ═══ RECENTLY ADDED CARS ═══ -->
<section class="container">
    <div class="section-title">
        <div>
            <h2>Recently Added Cars</h2>
            <p class="muted">Discover the newest arrivals from trusted sellers across India.</p>
        </div>
    </div>

    <div class="grid cards">
        <% if (latestCars == null || latestCars.isEmpty()) { %>
            <p style="color:#64748B; font-size:14px;">No cars available right now.</p>
        <% } else { %>
            <% for (Car car : latestCars) { %>
            <article class="car-card">
                <img src="<%=ctx%>/<%=car.getPrimaryImage()%>"
                     alt="<%=car.getCarName()%>"
                     onerror="this.style.background='linear-gradient(135deg,#0D1B2A,#1A3A4A)'; this.removeAttribute('src');">
                <div class="body">
                    <span class="chip"><%=car.getStatus()%></span>
                    <h3><%=car.getCarName()%></h3>
                    <p class="price"><%=money.format(car.getPrice())%></p>
                    <p class="meta">
                        &#128663; <%=car.getBrandName()%> &bull;
                        &#128197; <%=car.getManufacturingYear()%> &bull;
                        &#9981; <%=car.getFuelType()%> &bull;
                        &#9881; <%=car.getTransmissionType()%> &bull;
                        &#128205; <%=car.getCity()%>
                    </p>
                    <a class="btn primary" href="<%=ctx%>/car-details?id=<%=car.getCarId()%>">View Details</a>
                </div>
            </article>
            <% } %>
        <% } %>
    </div>
</section>

<!-- ═══ WHY CHOOSE AUTOMART ═══ -->
<section class="container">
    <div class="panel">
        <h2>Why Choose AutoMart?</h2>
        <div class="grid two">
            <div>
                <h3>&#10003; Verified Listings</h3>
                <p>All vehicles are reviewed before being published.</p>
            </div>
            <div>
                <h3>&#10003; Trusted Sellers</h3>
                <p>Connect directly with genuine car owners and dealers.</p>
            </div>
            <div>
                <h3>&#10003; Best Market Prices</h3>
                <p>Compare multiple vehicles and get the best value.</p>
            </div>
            <div>
                <h3>&#10003; Easy Contact</h3>
                <p>Reach sellers quickly through inquiry forms.</p>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/footer.jsp" %>