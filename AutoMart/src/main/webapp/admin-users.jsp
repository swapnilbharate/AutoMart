<%@ page import="java.util.*, com.automart.model.*" %>
<%@ include file="/WEB-INF/header.jsp" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>

<style>
body { background: #22d3ee; }

.au-wrap { max-width: 1100px; margin: 0 auto; padding: 36px 24px 60px; }

.au-heading { margin-bottom: 28px; }
.au-heading h2 { margin: 0 0 4px; font-size: 1.75rem; font-weight: 800; color: #0f172a; }
.au-heading p  { margin: 0; color: #0e7490; font-size: 0.95rem; }

.au-card {
    background: #ffffff;
    border-radius: 14px;
    border: 1.5px solid #a5f3fc;
    box-shadow: 0 4px 24px rgba(8,145,178,0.15);
    overflow: hidden;
}

.au-card-hd {
    background: linear-gradient(135deg, #0f766e 0%, #0d9488 100%);
    padding: 16px 24px;
    display: flex;
    align-items: center;
    gap: 10px;
}
.au-card-hd h3 { margin: 0; color: #fff; font-size: 1.05rem; font-weight: 700; }
.au-badge {
    margin-left: 8px;
    background: rgba(255,255,255,0.25);
    color: #fff;
    font-size: 0.78rem; font-weight: 700;
    padding: 2px 10px; border-radius: 20px;
}

.au-card-body { padding: 24px; }

/* Table */
.au-tbl-wrap { overflow-x: auto; border-radius: 10px; border: 2.5px solid #0e7490; }
.au-tbl {
    width: 100%; border-collapse: collapse; font-size: 0.89rem;
}
.au-tbl thead tr {
    background: linear-gradient(135deg, #0f766e, #0d9488);
}
.au-tbl thead th {
    padding: 13px 15px;
    text-align: left;
    font-size: 0.76rem; font-weight: 700;
    color: #fff; text-transform: uppercase; letter-spacing: 0.05em;
    border-right: 2px solid rgba(255,255,255,0.3);
    border-bottom: 2.5px solid #0e7490;
    white-space: nowrap;
}
.au-tbl thead th:last-child { border-right: none; }

.au-tbl tbody tr {
    border-bottom: 2px solid #0e7490;
    transition: background .15s;
}
.au-tbl tbody tr:last-child { border-bottom: none; }
.au-tbl tbody tr:nth-child(even) { background: #f0fdff; }
.au-tbl tbody tr:hover { background: #cffafe !important; }

.au-tbl tbody td {
    padding: 10px 15px;
    vertical-align: middle;
    border-right: 2px solid #0e7490;
    color: #1e293b;
}
.au-tbl tbody td:last-child { border-right: none; }

/* Inline inputs inside table */
.au-tbl input[type="text"],
.au-tbl input:not([type="submit"]):not([type="hidden"]):not([type="checkbox"]) {
    width: 100%;
    padding: 7px 10px;
    border: 1.5px solid #a5f3fc;
    border-radius: 7px;
    font-size: 0.87rem;
    font-family: inherit;
    color: #0f172a;
    background: #f0fdff;
    box-sizing: border-box;
    transition: border-color .2s, box-shadow .2s;
}
.au-tbl input:focus {
    outline: none;
    border-color: #0891b2;
    box-shadow: 0 0 0 3px rgba(8,145,178,0.13);
    background: #fff;
}
.au-tbl select {
    width: 100%;
    padding: 7px 10px;
    border: 1.5px solid #a5f3fc;
    border-radius: 7px;
    font-size: 0.87rem;
    font-family: inherit;
    color: #0f172a;
    background: #f0fdff;
    box-sizing: border-box;
    transition: border-color .2s;
}
.au-tbl select:focus {
    outline: none;
    border-color: #0891b2;
    box-shadow: 0 0 0 3px rgba(8,145,178,0.13);
}

/* Email cell */
.c-email { color: #0369a1; font-size: 0.86rem; }
.c-num   { color: #94a3b8; font-size: 0.8rem; font-weight: 700; text-align: center; }

/* Role badge colors */
.role-admin {
    display: inline-block; padding: 3px 11px;
    background: #fef9c3; color: #854d0e;
    border: 1px solid #fde68a;
    border-radius: 20px; font-size: 0.76rem; font-weight: 700;
}
.role-user {
    display: inline-block; padding: 3px 11px;
    background: #e0f2fe; color: #0369a1;
    border: 1px solid #bae6fd;
    border-radius: 20px; font-size: 0.76rem; font-weight: 700;
}

/* Action buttons */
.ac-act { display: flex; gap: 7px; align-items: center; }
.btn-save {
    display: inline-flex; align-items: center;
    padding: 6px 14px;
    background: linear-gradient(135deg, #0f766e, #0d9488);
    color: #fff; border: none; border-radius: 6px;
    font-size: 0.79rem; font-weight: 700; cursor: pointer;
    font-family: inherit;
    transition: transform .15s, box-shadow .15s;
    box-shadow: 0 3px 8px rgba(15,118,110,0.25);
}
.btn-save:hover { transform: translateY(-1px); box-shadow: 0 5px 12px rgba(15,118,110,0.33); }
.btn-del {
    display: inline-flex; align-items: center;
    padding: 6px 14px; background: #fee2e2; color: #b91c1c;
    border: 1px solid #fecaca; border-radius: 6px;
    font-size: 0.79rem; font-weight: 700; cursor: pointer;
    font-family: inherit; transition: background .15s;
}
.btn-del:hover { background: #fecaca; }

.au-empty { text-align: center; padding: 42px 20px; color: #94a3b8; }

@media (max-width: 768px) {
    .au-tbl thead { display: none; }
    .au-tbl tbody tr { display: block; border: 2px solid #0e7490; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); }
    .au-tbl tbody td { display: block; border-right: none; border-bottom: 1px solid #a5f3fc; position: relative; padding: 10px 10px 10px 35%; text-align: right; min-height: 40px; }
    .au-tbl tbody td:last-child { border-bottom: none; }
    .au-tbl tbody td::before {
        content: attr(data-label);
        position: absolute;
        left: 12px;
        width: 30%;
        text-align: left;
        font-weight: 600;
        color: #0f766e;
        top: 50%;
        transform: translateY(-50%);
        font-size: 0.75rem;
        text-transform: uppercase;
    }
    .au-tbl tbody td select, .au-tbl tbody td input { width: 100%; box-sizing: border-box; text-align: right; }
    .ac-act { justify-content: flex-end; }
}
</style>

<div class="au-wrap">

    <div class="au-heading">
        <h2>User Management</h2>
        <p>View, update, or remove user accounts.</p>
    </div>

    <div class="au-card">
        <div class="au-card-hd">
            <h3>All Users <span class="au-badge"><%=users.size()%> accounts</span></h3>
        </div>
        <div class="au-card-body">
            <% if (users.isEmpty()) { %>
            <div class="au-empty"><p>No user accounts found.</p></div>
            <% } else { %>
            <div class="au-tbl-wrap">
                <table class="au-tbl">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>City</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% int i = 1; for (User item : users) { %>
                        <tr>
                            <form action="<%=ctx%>/admin/users" method="post">
                                <input type="hidden" name="userId" value="<%=item.getUserId()%>">
                                <td data-label="#" class="c-num"><%=i++%></td>
                                <td data-label="Name"><input name="name" value="<%=item.getName()%>"></td>
                                <td data-label="Email"><span class="c-email"><%=item.getEmail()%></span></td>
                                <td data-label="Phone"><input name="phone" value="<%=item.getPhone()%>"></td>
                                <td data-label="City"><input name="city" value="<%=item.getCity()%>"></td>
                                <td data-label="Role">
                                    <select name="role">
                                        <option <%= "USER".equals(item.getRole()) ? "selected" : ""%>>USER</option>
                                        <option <%= "ADMIN".equals(item.getRole()) ? "selected" : ""%>>ADMIN</option>
                                    </select>
                                </td>
                                <td data-label="Actions">
                                    <div class="ac-act">
                                        <button class="btn-save" type="submit">Save</button>
                            </form>
                                        <form action="<%=ctx%>/admin/users" method="post" style="display:inline" onsubmit="return confirm('Delete this user?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="userId" value="<%=item.getUserId()%>">
                                            <button class="btn-del" type="submit">Delete</button>
                                        </form>
                                    </div>
                                </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

</div>

<%@ include file="/WEB-INF/footer.jsp" %>
