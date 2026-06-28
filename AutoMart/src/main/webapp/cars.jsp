<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.text.NumberFormat, com.automart.model.*" %>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Car> cars = (List<Car>) request.getAttribute("cars");
    List<Brand> brands = (List<Brand>) request.getAttribute("brands");
    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<style>
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
    background: linear-gradient(160deg, #C8EDE0 0%, #D6E8FB 50%, #F5EDDA 100%);
    min-height: 100vh;
    font-family: 'Segoe UI', sans-serif;
}

.browse-page {
    padding: 2rem 2.5rem 3rem;
    max-width: 1400px;
    margin: 0 auto;
}

.browse-header {
    background: linear-gradient(120deg, #0D1B2A 0%, #0F6E56 100%);
    border-radius: 16px;
    padding: 1.75rem 2.5rem;
    margin-bottom: 1.75rem;
}

.browse-header h2 {
    font-size: 26px;
    font-weight: 700;
    color: #ffffff;
    margin-bottom: 5px;
}

.browse-header p {
    font-size: 14px;
    color: rgba(255,255,255,0.65);
    line-height: 1.6;
}

.filter-panel {
    background: rgba(255,255,255,0.72);
    backdrop-filter: blur(8px);
    border-radius: 14px;
    border: 1px solid rgba(20,184,154,0.2);
    padding: 1.4rem 1.5rem;
    margin-bottom: 1.75rem;
    display: grid;
    grid-template-columns: repeat(4, 1fr) auto auto;
    gap: 10px;
    align-items: center;
    box-shadow: 0 4px 20px rgba(14,110,86,0.10);
}

.filter-panel input,
.filter-panel select {
    width: 100%;
    padding: 9px 12px;
    font-size: 13px;
    border: 1.5px solid #B2D8CC;
    border-radius: 8px;
    background: #ffffff;
    color: #0D2B22;
    font-weight: 500;
    outline: none;
    font-family: inherit;
    transition: border-color .15s, box-shadow .15s;
}

.filter-panel input:focus,
.filter-panel select:focus {
    border-color: #14B89A;
    box-shadow: 0 0 0 3px rgba(20,184,154,0.15);
    background: #F4FAF7;
}

.filter-panel input::placeholder { color: #5A8A78; font-weight: 400; }
.filter-panel select { color: #0D2B22; }
.filter-panel select option { color: #1A202C; font-weight: 400; }

.btn.primary {
    display: block;
    width: 100%;
    text-align: center;
    background: #14B89A;
    color: #fff;
    border: none;
    border-radius: 8px;
    padding: 9px 18px;
    font-size: 13px;
    font-weight: 600;
    text-decoration: none;
    cursor: pointer;
    white-space: nowrap;
    transition: background .15s;
    font-family: inherit;
}

.btn.primary:hover { background: #0F6E56; }

.btn {
    display: block;
    width: 100%;
    text-align: center;
    background: transparent;
    color: #14B89A;
    border: 1.5px solid #14B89A;
    border-radius: 8px;
    padding: 8px 18px;
    font-size: 13px;
    font-weight: 600;
    text-decoration: none;
    cursor: pointer;
    white-space: nowrap;
    transition: background .15s;
    font-family: inherit;
}

.btn:hover { background: #E1F5EE; }

.results-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 1.1rem;
}

.results-bar .count {
    font-size: 13px;
    color: #475569;
    font-weight: 500;
}

.results-bar .count strong {
    color: #0F6E56;
    font-weight: 700;
}

.grid.cards {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.1rem;
    margin-bottom: 2rem;
}

.car-card {
    background: #ffffff;
    border-radius: 14px;
    border: 0.5px solid rgba(0,0,0,0.07);
    overflow: hidden;
    transition: transform .2s, box-shadow .2s;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.car-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 28px rgba(14,110,86,0.13);
}

.car-card img {
    width: 100%;
    height: 175px;
    object-fit: cover;
    display: block;
    background: linear-gradient(135deg, #0D1B2A, #1A3A4A);
}

.car-card .body {
    padding: 1rem 1.1rem;
}

.chip {
    display: inline-block;
    font-size: 11px;
    font-weight: 600;
    padding: 3px 11px;
    border-radius: 20px;
    background: #D4F5EC;
    color: #0F6E56;
    margin-bottom: .55rem;
    text-transform: capitalize;
    letter-spacing: .3px;
}

.car-card h3 {
    font-size: 14px;
    font-weight: 700;
    color: #1A202C;
    margin-bottom: 5px;
}

.car-card .price {
    font-size: 18px;
    font-weight: 700;
    color: #0F6E56;
    margin-bottom: 7px;
}

.car-card .meta {
    font-size: 12px;
    color: #475569;
    line-height: 1.8;
    margin-bottom: 4px;
}

.car-card .muted {
    font-size: 12px;
    color: #94A3B8;
    margin-bottom: .85rem;
}

.empty-state {
    background: #ffffff;
    border-radius: 14px;
    border: 0.5px solid rgba(0,0,0,0.07);
    padding: 3rem 2rem;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.empty-state p {
    font-size: 15px;
    color: #64748B;
}
</style>

<div class="browse-page">

    <div class="browse-header">
        <h2>Browse Cars</h2>
        <p>Search by brand, budget, fuel, transmission, model year, and city.</p>
    </div>

    <form class="filter-panel" action="<%=ctx%>/cars" method="get">

        <input type="search" name="q"
               value="<%=request.getParameter("q") == null ? "" : request.getParameter("q")%>"
               placeholder="Keyword">

        <select name="brandId">
            <option value="">Brand</option>
            <% for (Brand brand : brands) { %>
                <option value="<%=brand.getBrandId()%>"
                    <%=String.valueOf(brand.getBrandId()).equals(request.getParameter("brandId")) ? "selected" : ""%>>
                    <%=brand.getBrandName()%>
                </option>
            <% } %>
        </select>

        <select name="fuelType">
            <option value="">Fuel</option>
            <% for (String f : Arrays.asList("Petrol","Diesel","CNG","Electric","Hybrid")) { %>
                <option <%=f.equals(request.getParameter("fuelType")) ? "selected" : ""%>><%=f%></option>
            <% } %>
        </select>

        <select name="transmissionType">
            <option value="">Transmission</option>
            <option <%= "Manual".equals(request.getParameter("transmissionType")) ? "selected" : ""%>>Manual</option>
            <option <%= "Automatic".equals(request.getParameter("transmissionType")) ? "selected" : ""%>>Automatic</option>
        </select>

        <input type="number" name="minPrice"
               value="<%=request.getParameter("minPrice") == null ? "" : request.getParameter("minPrice")%>"
               placeholder="Min price">

        <input type="number" name="maxPrice"
               value="<%=request.getParameter("maxPrice") == null ? "" : request.getParameter("maxPrice")%>"
               placeholder="Max price">

        <input type="number" name="year"
               value="<%=request.getParameter("year") == null ? "" : request.getParameter("year")%>"
               placeholder="Year from">

        <input type="text" name="city"
               value="<%=request.getParameter("city") == null ? "" : request.getParameter("city")%>"
               placeholder="City">

        <button class="btn primary" type="submit">Apply Filters</button>
        <a class="btn" href="<%=ctx%>/cars">Reset</a>

    </form>

    <% if (!cars.isEmpty()) { %>
    <div class="results-bar">
        <span class="count"><strong><%=cars.size()%></strong> car<%= cars.size() == 1 ? "" : "s" %> found</span>
    </div>
    <% } %>

    <% if (!cars.isEmpty()) { %>
    <div class="grid cards">
        <% for (Car car : cars) { %>
            <article class="car-card">

                <img src="<%=ctx%>/<%=car.getPrimaryImage()%>"
                     alt="<%=car.getCarName()%>"
                     onerror="this.style.background='linear-gradient(135deg,#0D1B2A,#1A3A4A)'; this.removeAttribute('src');">

                <div class="body">
                    <span class="chip"><%=car.getStatus()%></span>
                    <h3><%=car.getCarName()%></h3>
                    <p class="price"><%=money.format(car.getPrice())%></p>
                    <p class="meta"><%=car.getBrandName()%> &bull; <%=car.getManufacturingYear()%> &bull; <%=car.getFuelType()%> &bull; <%=car.getTransmissionType()%></p>
                    <p class="muted">&#128205; <%=car.getCity()%> &bull; &#128664; <%=(int)car.getMileage()%> km</p>
                    <a class="btn primary" href="<%=ctx%>/car-details?id=<%=car.getCarId()%>">View Details</a>
                </div>

            </article>
        <% } %>
    </div>
    <% } else { %>
    <div class="empty-state">
        <p>No cars matched the selected filters. Try adjusting your search.</p>
    </div>
    <% } %>

</div>

<%@ include file="/WEB-INF/footer.jsp" %>