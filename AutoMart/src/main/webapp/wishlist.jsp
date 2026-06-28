<%@ page import="java.util.*, java.text.NumberFormat, com.automart.model.*" %>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<Car> cars = (List<Car>) request.getAttribute("cars");
    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
%>

<style>
    /* ── Page Background ── */
    body {
        background: linear-gradient(145deg, #ddeeff 0%, #cce4f8 40%, #b8d6f0 100%) !important;
        min-height: 100vh;
        font-family: 'Inter', 'Segoe UI', sans-serif;
    }

    /* ── Section Title ── */
    .section-title h2 {
        color: #1a3a5c;
        font-size: 1.75rem;
        font-weight: 700;
    }
    .section-title .muted {
        color: #4a7aaa;
        font-size: 0.9rem;
        margin-top: 5px;
    }

    /* ── Cards Grid ── */
    .grid.cards {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
        gap: 24px;
        margin-top: 20px;
    }

    /* ── Car Card ── */
    .car-card {
        background: #ffffff;
        border: 2px solid #8acca8;
        border-radius: 14px;
        overflow: hidden;
        box-shadow: 0 4px 18px rgba(20, 80, 50, 0.10);
        transition: transform 0.2s, box-shadow 0.2s;
        display: flex;
        flex-direction: column;
    }
    .car-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 28px rgba(20, 80, 50, 0.18);
    }

    /* ── Card Image ── */
    .car-card img {
        width: 100%;
        height: 180px;
        object-fit: cover;
        border-bottom: 2px solid #c0e8d4;
        display: block;
    }

    /* ── Card Body ── */
    .car-card .body {
        padding: 16px;
        display: flex;
        flex-direction: column;
        gap: 6px;
        flex: 1;
    }

    .car-card .body h3 {
        font-size: 1rem;
        font-weight: 700;
        color: #0a3a22;
        margin: 0;
    }

    .car-card .body .price {
        font-size: 1.1rem;
        font-weight: 700;
        color: #1d7a50;
        margin: 0;
    }

    .car-card .body .meta {
        font-size: 0.8rem;
        color: #5a8a6e;
        margin: 0 0 8px;
    }

    /* ── Buttons ── */
    .car-card .btn {
        display: inline-block;
        padding: 7px 16px;
        background: #0d3520;
        color: #c8f0d8;
        border: none;
        border-radius: 7px;
        font-size: 0.8rem;
        font-weight: 600;
        text-decoration: none;
        cursor: pointer;
        transition: background 0.2s;
        margin-right: 8px;
    }
    .car-card .btn:hover { background: #052210; }

    .car-card .btn.danger {
        background: #7a1a1a;
        color: #fce8e8;
        border: none;
        border-radius: 7px;
        padding: 7px 16px;
        font-size: 0.8rem;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.2s;
    }
    .car-card .btn.danger:hover { background: #5a1010; }

    /* ── Empty State ── */
    .panel {
        background: #ffffff;
        border: 2px solid #8acca8;
        border-radius: 12px;
        padding: 40px;
        text-align: center;
        color: #3a6e52;
        font-size: 1rem;
        font-weight: 500;
        margin-top: 20px;
        box-shadow: 0 4px 16px rgba(20, 80, 50, 0.08);
    }
</style>

<section class="container">
    <div class="section-title">
        <div>
            <h2>My Wishlist</h2>
            <p class="muted">Vehicles saved for quick comparison.</p>
        </div>
    </div>

    <div class="grid cards">
        <% for (Car car : cars) { %>
            <article class="car-card">
                <img src="<%=ctx%>/<%=car.getPrimaryImage()%>" alt="<%=car.getCarName()%>">
                <div class="body">
                    <h3><%=car.getCarName()%></h3>
                    <p class="price"><%=money.format(car.getPrice())%></p>
                    <p class="meta"><%=car.getBrandName()%> · <%=car.getCity()%></p>
                    <div>
                        <a class="btn" href="<%=ctx%>/car-details?id=<%=car.getCarId()%>">Details</a>
                        <form action="<%=ctx%>/wishlist" method="post" style="display:inline">
                            <input type="hidden" name="carId" value="<%=car.getCarId()%>">
                            <input type="hidden" name="action" value="remove">
                            <button class="btn danger" type="submit">Remove</button>
                        </form>
                    </div>
                </div>
            </article>
        <% } %>
    </div>

    <% if (cars.isEmpty()) { %>
        <div class="panel">&#10084; Your wishlist is empty. Browse cars and save your favourites!</div>
    <% } %>
</section>

<%@ include file="/WEB-INF/footer.jsp" %>