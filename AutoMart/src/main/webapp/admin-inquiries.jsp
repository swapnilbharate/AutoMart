<%@ page import="java.util.*, com.automart.model.*" %>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<ContactRequest> requests = (List<ContactRequest>) request.getAttribute("requests");
%>

<style>
    /* ── Page Background — light blue ── */
    body {
        background: linear-gradient(145deg, #ddeeff 0%, #cce4f8 40%, #b8d6f0 100%) !important;
        min-height: 100vh;
        font-family: 'Inter', 'Segoe UI', sans-serif;
    }

    /* ── Section Header ── */
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

    /* ── Table ── */
    .container table {
        width: 100%;
        border-collapse: collapse !important;
        border-radius: 12px;
        overflow: hidden;
        border: 2px solid #3a8a58 !important;
        box-shadow: 0 6px 28px rgba(20, 80, 40, 0.15);
    }

    /* ── Header — very dark green FORCED ── */
    .container table thead tr,
    .container table thead tr th,
    table thead tr,
    thead tr {
        background: #052210 !important;
        background-color: #052210 !important;
    }

    .container table thead th,
    table thead th,
    thead th {
        padding: 15px 16px !important;
        text-align: left !important;
        font-size: 0.76rem !important;
        font-weight: 700 !important;
        text-transform: uppercase !important;
        letter-spacing: 1px !important;
        color: #e0f8ec !important;
        border: 1px solid #0a3a1c !important;
        background: #052210 !important;
        background-color: #052210 !important;
    }

    /* ── Rows — light green alternating ── */
    .container table tbody tr:nth-child(odd)  { background: #d4f0e2 !important; }
    .container table tbody tr:nth-child(even) { background: #c0e8d4 !important; }

    .container table tbody tr {
        border-bottom: 1px solid #8acca8 !important;
        transition: background 0.18s;
    }
    .container table tbody tr:hover { background: #aadfc2 !important; }

    /* ── Dark text on light green ── */
    .container table tbody td,
    table tbody td {
        padding: 13px 16px !important;
        font-size: 0.875rem !important;
        color: #0d3520 !important;
        border: 1px solid #8acca8 !important;
        vertical-align: top !important;
        white-space: nowrap !important;
    }
    .container table tbody td:first-child {
        font-weight: 700 !important;
        color: #0a4a28 !important;
    }
    
    /* Allow message column to wrap so it doesn't get ridiculously wide */
    .container table tbody td:nth-child(4) {
        white-space: normal !important;
        min-width: 250px;
    }

    /* ── Dropdown ── */
    .container table select {
        background: #a0d8b8 !important;
        color: #0a3018 !important;
        border: 1px solid #3a8a58 !important;
        border-radius: 5px;
        padding: 5px 8px;
        font-size: 0.8rem;
        font-weight: 500;
        margin-bottom: 6px;
        display: block;
        width: 100%;
    }

    /* ── Button ── */
    .btn.small.primary {
        background: #0d3520 !important;
        color: #c8f0d8 !important;
        border: 1px solid #3a8a58 !important;
        border-radius: 5px;
        padding: 6px 16px;
        font-size: 0.78rem;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.2s;
    }
    .btn.small.primary:hover {
        background: #091e12 !important;
    }
    
    /* ── Responsive Mobile Cards ── */
    @media (max-width: 800px) {
        .container table, .container thead, .container tbody, .container th, .container td, .container tr {
            display: block !important;
            width: 100% !important;
            white-space: normal !important;
            box-sizing: border-box;
        }
        .container thead tr {
            display: none !important;
        }
        .container tr {
            margin-bottom: 20px !important;
            border: 2px solid #3a8a58 !important;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .container td {
            position: relative !important;
            padding: 12px 10px 12px 35% !important;
            text-align: right !important;
            border: none !important;
            border-bottom: 1px solid #8acca8 !important;
            min-height: 45px;
        }
        .container td:last-child {
            border-bottom: none !important;
        }
        .container td::before {
            content: attr(data-label);
            position: absolute;
            left: 12px;
            width: 30%;
            text-align: left;
            font-weight: 700;
            color: #052210;
            top: 12px;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
        }
        .container td form {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .container td select {
            width: auto !important;
            margin-bottom: 0 !important;
        }
        /* Message field might be tall, let title sit at top */
        .container td:nth-child(4)::before {
            top: 12px;
            transform: none;
        }
        .container td:nth-child(4) {
            text-align: left !important;
            padding: 35px 12px 12px !important;
        }
        .container td:nth-child(4)::before {
            width: 100%;
        }
    }
</style>

<section class="container">
    <div class="section-title">
        <div>
            <h2>Customer Inquiries</h2>
            <p class="muted">Manage dealer contact requests and follow-up status.</p>
        </div>
    </div>
    <div style="overflow-x: auto;">
        <table>
            <thead>
                <tr>
                    <th>Vehicle</th>
                    <th>Customer</th>
                    <th>Contact</th>
                    <th>Message</th>
                    <th>Status</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
            <% for (ContactRequest item : requests) { %>
                <tr>
                    <td data-label="Vehicle"><%=item.getCarName()%></td>
                    <td data-label="Customer"><%=item.getName()%></td>
                    <td data-label="Contact"><%=item.getEmail()%><br><%=item.getPhone()%></td>
                    <td data-label="Message"><%=item.getMessage()%></td>
                    <td data-label="Status">
                        <form action="<%=ctx%>/admin/inquiries" method="post">
                            <input type="hidden" name="requestId" value="<%=item.getRequestId()%>">
                            <select name="status">
                                <option <%= "NEW".equals(item.getStatus()) ? "selected" : ""%>>NEW</option>
                                <option <%= "CONTACTED".equals(item.getStatus()) ? "selected" : ""%>>CONTACTED</option>
                                <option <%= "CLOSED".equals(item.getStatus()) ? "selected" : ""%>>CLOSED</option>
                            </select>
                            <button class="btn small primary" type="submit">Update</button>
                        </form>
                    </td>
                    <td data-label="Date"><%=item.getCreatedAt()%></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</section>

<%@ include file="/WEB-INF/footer.jsp" %>