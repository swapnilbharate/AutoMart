<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.automart.model.*" %>
<%@ include file="/WEB-INF/header.jsp" %>

<%
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
%>

<style>
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
    background: linear-gradient(160deg, #E8F5F0 0%, #EEF2FB 50%, #FDF6EC 100%);
    min-height: 100vh;
    font-family: 'Segoe UI', sans-serif;
}

/* ── PAGE WRAPPER ── */
.dash-page {
    padding: 2rem 2.5rem 3rem;
    max-width: 1400px;
    margin: 0 auto;
}

/* ── BANNER ── */
.dash-banner {
    background: linear-gradient(120deg, #0D1B2A 0%, #0F6E56 100%);
    border-radius: 16px;
    padding: 2rem 2.5rem;
    margin-bottom: 2rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
}

.dash-banner-left h1 {
    font-size: 28px;
    font-weight: 700;
    color: #ffffff;
    margin-bottom: 6px;
}

.dash-banner-left p {
    font-size: 14px;
    color: rgba(255,255,255,0.70);
    line-height: 1.7;
    max-width: 560px;
}

.dash-banner-right {
    display: flex;
    gap: 1rem;
    flex-shrink: 0;
}

.dash-quick-btn {
    background: rgba(255,255,255,0.12);
    color: #fff;
    border: 1.5px solid rgba(255,255,255,0.25);
    border-radius: 8px;
    padding: 8px 18px;
    font-size: 13px;
    font-weight: 600;
    text-decoration: none;
    white-space: nowrap;
    transition: background .15s;
}

.dash-quick-btn:hover { background: rgba(255,255,255,0.22); }

/* ── STATS GRID ── */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 1rem;
    margin-bottom: 2rem;
}

.stat-card {
    border-radius: 14px;
    border: 0.5px solid rgba(0,0,0,0.07);
    padding: 1.4rem 1.25rem;
    text-align: center;
    transition: transform .2s, box-shadow .2s;
    position: relative;
    overflow: hidden;
}

.stat-card.c1 { background: linear-gradient(135deg, #C8F5E9 0%, #A5EDD5 100%); }
.stat-card.c2 { background: linear-gradient(135deg, #DBEAFE 0%, #BFDBFE 100%); }
.stat-card.c3 { background: linear-gradient(135deg, #D1FAE5 0%, #A7F3D0 100%); }
.stat-card.c4 { background: linear-gradient(135deg, #FEF3C7 0%, #FDE68A 100%); }
.stat-card.c5 { background: linear-gradient(135deg, #FCE7F3 0%, #FBCFE8 100%); }

.stat-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 24px rgba(0,0,0,0.09);
}

.stat-card::before {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 4px;
    border-radius: 14px 14px 0 0;
}

.stat-card.c1::before { background: #14B89A; }
.stat-card.c2::before { background: #3B82F6; }
.stat-card.c3::before { background: #10B981; }
.stat-card.c4::before { background: #F59E0B; }
.stat-card.c5::before { background: #EC4899; }

.stat-card .stat-icon {
    font-size: 22px;
    margin-bottom: 8px;
    display: block;
}

.stat-card .stat-label {
    font-size: 12px;
    color: #64748B;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: .6px;
    display: block;
    margin-bottom: 8px;
}

.stat-card .stat-value {
    font-size: 36px;
    font-weight: 700;
    color: #0D1B2A;
    line-height: 1;
    display: block;
}

.stat-card.c1 .stat-value { color: #0F6E56; }
.stat-card.c2 .stat-value { color: #1D4ED8; }
.stat-card.c3 .stat-value { color: #059669; }
.stat-card.c4 .stat-value { color: #D97706; }
.stat-card.c5 .stat-value { color: #BE185D; }

/* ── CHART ROW ── */
.chart-row {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.25rem;
}

.panel {
    border-radius: 14px;
    border: 0.5px solid rgba(0,0,0,0.07);
    padding: 1.5rem;
}

.panel:nth-child(1) { background: linear-gradient(160deg, #E8FBF5 0%, #F0FDFB 100%); }
.panel:nth-child(2) { background: linear-gradient(160deg, #EBF3FE 0%, #F4F8FF 100%); }
.panel:nth-child(3) { background: linear-gradient(160deg, #FFF8EC 0%, #FFFBF2 100%); }

.panel h3 {
    font-size: 15px;
    font-weight: 700;
    color: #1A202C;
    margin-bottom: 1.25rem;
    padding-bottom: .75rem;
    border-bottom: 1.5px solid rgba(0,0,0,0.08);
    display: flex;
    align-items: center;
    gap: 8px;
}

.panel h3::before {
    content: '';
    display: inline-block;
    width: 4px;
    height: 16px;
    background: #14B89A;
    border-radius: 2px;
    flex-shrink: 0;
}

/* ── BAR ROWS ── */
.bar {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 14px;
}

.bar:last-child { margin-bottom: 0; }

.bar-label {
    font-size: 13px;
    color: #475569;
    font-weight: 500;
    min-width: 90px;
    flex-shrink: 0;
}

.bar-track {
    flex: 1;
    background: #F1F5F9;
    border-radius: 6px;
    height: 10px;
    overflow: hidden;
}

.bar-fill {
    height: 100%;
    border-radius: 6px;
    background: linear-gradient(90deg, #14B89A, #0F6E56);
    min-width: 8px;
    transition: width .4s ease;
}

.bar-count {
    font-size: 13px;
    font-weight: 700;
    color: #0F6E56;
    min-width: 20px;
    text-align: right;
    flex-shrink: 0;
}

/* ── PRICE panel accent ── */
.panel.price .bar-fill {
    background: linear-gradient(90deg, #3B82F6, #1D4ED8);
}
.panel.price .bar-count { color: #1D4ED8; }

/* ── ACTIVITY panel accent ── */
.panel.activity .bar-fill {
    background: linear-gradient(90deg, #F59E0B, #D97706);
}
.panel.activity .bar-count { color: #D97706; }
</style>


<div class="dash-page">

    <!-- BANNER -->
    <div class="dash-banner">
        <div class="dash-banner-left">
            <h1>Admin Dashboard</h1>
            <p>Monitor users, vehicle listings, wishlist activity and marketplace performance from one place.</p>
        </div>
        <div class="dash-banner-right">
            <a class="dash-quick-btn" href="<%=ctx%>/admin/cars">Manage Cars</a>
            <a class="dash-quick-btn" href="<%=ctx%>/admin/users">Manage Users</a>
        </div>
    </div>

    <!-- STATS CARDS -->
    <div class="stats-grid">

        <div class="stat-card c1">
            <span class="stat-icon">👥</span>
            <span class="stat-label">Total Users</span>
            <span class="stat-value"><%=stats.getTotalUsers()%></span>
        </div>

        <div class="stat-card c2">
            <span class="stat-icon">🚗</span>
            <span class="stat-label">Total Cars</span>
            <span class="stat-value"><%=stats.getTotalCars()%></span>
        </div>

        <div class="stat-card c3">
            <span class="stat-icon">✅</span>
            <span class="stat-label">Available Cars</span>
            <span class="stat-value"><%=stats.getAvailableCars()%></span>
        </div>

        <div class="stat-card c4">
            <span class="stat-icon">🏷️</span>
            <span class="stat-label">Sold Cars</span>
            <span class="stat-value"><%=stats.getSoldCars()%></span>
        </div>

        <div class="stat-card c5">
            <span class="stat-icon">❤️</span>
            <span class="stat-label">Wishlist Entries</span>
            <span class="stat-value"><%=stats.getWishlistEntries()%></span>
        </div>

    </div>

    <!-- CHARTS ROW -->
    <div class="chart-row">

        <!-- Listings by Brand -->
        <div class="panel">
            <h3>Listings by Brand</h3>
            <%
                int maxBrand = 1;
                for (Map.Entry<String,Integer> e : stats.getListingsByBrand().entrySet())
                    if (e.getValue() > maxBrand) maxBrand = e.getValue();
            %>
            <% for (Map.Entry<String,Integer> entry : stats.getListingsByBrand().entrySet()) { %>
            <div class="bar">
                <span class="bar-label"><%=entry.getKey()%></span>
                <div class="bar-track">
                    <div class="bar-fill" style="width:<%=Math.round((entry.getValue() * 100.0) / maxBrand)%>%"></div>
                </div>
                <span class="bar-count"><%=entry.getValue()%></span>
            </div>
            <% } %>
        </div>

        <!-- Price Distribution -->
        <div class="panel price">
            <h3>Price Distribution</h3>
            <%
                int maxPrice = 1;
                for (Map.Entry<String,Integer> e : stats.getPriceRanges().entrySet())
                    if (e.getValue() > maxPrice) maxPrice = e.getValue();
            %>
            <% for (Map.Entry<String,Integer> entry : stats.getPriceRanges().entrySet()) { %>
            <div class="bar">
                <span class="bar-label"><%=entry.getKey()%></span>
                <div class="bar-track">
                    <div class="bar-fill" style="width:<%=Math.round((entry.getValue() * 100.0) / maxPrice)%>%"></div>
                </div>
                <span class="bar-count"><%=entry.getValue()%></span>
            </div>
            <% } %>
        </div>

        <!-- User Activity -->
        <div class="panel activity">
            <h3>User Activity</h3>
            <%
                int maxActivity = 1;
                for (Map.Entry<String,Integer> e : stats.getUserActivity().entrySet())
                    if (e.getValue() > maxActivity) maxActivity = e.getValue();
            %>
            <% for (Map.Entry<String,Integer> entry : stats.getUserActivity().entrySet()) { %>
            <div class="bar">
                <span class="bar-label"><%=entry.getKey()%></span>
                <div class="bar-track">
                    <div class="bar-fill" style="width:<%=Math.round((entry.getValue() * 100.0) / maxActivity)%>%"></div>
                </div>
                <span class="bar-count"><%=entry.getValue()%></span>
            </div>
            <% } %>
        </div>

    </div>

</div>

<%@ include file="/WEB-INF/footer.jsp" %>
