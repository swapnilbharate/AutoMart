<%@ page import="java.util.*, com.automart.model.*" %>
<%@ include file="/WEB-INF/header.jsp" %>

<style>
  .am-page { background: #f3f0ff; min-height: 100vh; padding: 2rem 1.5rem; }
  .am-panel { background: #fff; border-radius: 12px; border: 1.5px solid #c4b5fd; padding: 1.5rem; margin-bottom: 1.5rem; }
  .am-panel-header { display: flex; align-items: center; gap: 10px; margin-bottom: 1.25rem; }
  .am-accent { width: 4px; height: 26px; background: #7c3aed; border-radius: 2px; }
  .am-panel h1 { font-size: 22px; font-weight: 500; color: #2e1065; }
  .am-panel h2 { font-size: 18px; font-weight: 500; color: #2e1065; margin: 0; }
  .am-muted { font-size: 13px; color: #9ca3af; margin-bottom: 1.2rem; margin-top: 0.25rem; }
  .am-form { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
  .am-form label { display: flex; flex-direction: column; gap: 5px; font-size: 12px; font-weight: 600; color: #6d28d9; letter-spacing: 0.4px; }
  .am-form label.full { grid-column: 1 / -1; }
  .am-form input { height: 38px; border: 1.5px solid #c4b5fd; border-radius: 8px; padding: 0 12px; font-size: 14px; color: #1e1b4b; background: #fff; outline: none; }
  .am-form input:disabled { background: #faf5ff; color: #a78bfa; border-color: #ede9fe; }
  .am-form input:focus { border-color: #7c3aed; box-shadow: 0 0 0 3px rgba(124,58,237,0.12); }
  .am-btn { height: 38px; padding: 0 1.75rem; background: #7c3aed; color: #fff; border: none; border-radius: 8px; font-size: 14px; font-weight: 500; cursor: pointer; }
  .am-avatar { width: 38px; height: 38px; border-radius: 50%; background: #ede9fe; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 600; color: #5b21b6; flex-shrink: 0; border: 1.5px solid #c4b5fd; }
  .am-table-wrap { border-radius: 10px; overflow: hidden; border: 2px solid #7c3aed; }
  .am-table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
  .am-table thead tr { background: #ede9fe; }
  .am-table thead th { padding: 12px 16px; text-align: left; color: #4c1d95; font-size: 11px; font-weight: 700; letter-spacing: 0.9px; text-transform: uppercase; border-bottom: 2px solid #7c3aed; border-right: 1.5px solid #a78bfa; }
  .am-table thead th:last-child { border-right: none; text-align: center; }
  .am-table tbody tr { background: #fff; border-bottom: 1.5px solid #c4b5fd; }
  .am-table tbody tr:last-child { border-bottom: none; }
  .am-table tbody tr:hover { background: #faf7ff; }
  .am-table td { padding: 12px 16px; vertical-align: middle; border-right: 1px solid #ddd6fe; }
  .am-table td:last-child { border-right: none; text-align: center; }
  .am-vehicle-cell { display: flex; align-items: center; gap: 9px; }
  .am-vehicle-name { font-weight: 600; font-size: 13px; color: #3b0764; }
  .am-vehicle-sub { font-size: 11px; color: #a78bfa; margin-top: 2px; }
  .am-msg { font-size: 13px; color: #64748b; line-height: 1.55; }
  .am-date { font-size: 12px; color: #a78bfa; white-space: nowrap; }
  .am-badge { display: inline-block; padding: 5px 14px; border-radius: 20px; font-size: 11px; font-weight: 700; letter-spacing: 0.6px; }
  .am-badge-open { background: #ede9fe; color: #5b21b6; border: 1px solid #a78bfa; }
  .am-badge-contacted { background: #fef9c3; color: #854d0e; border: 1px solid #fcd34d; }
  .am-badge-closed { background: #fee2e2; color: #9f1239; border: 1px solid #fca5a5; }
</style>

<div class="am-page">
  <div class="am-panel">
    <div class="am-panel-header">
      <div class="am-accent"></div>
      <h1>Profile Management</h1>
    </div>
    <form action="<%=ctx%>/profile" method="post" class="am-form" data-validate>
      <label>NAME<input required name="name" value="<%=currentUser.getName()%>"></label>
      <label>EMAIL<input disabled value="<%=currentUser.getEmail()%>"></label>
      <label>PHONE<input required name="phone" value="<%=currentUser.getPhone()%>"></label>
      <label>CITY<input required name="city" value="<%=currentUser.getCity()%>"></label>
      <label class="full">NEW PASSWORD
        <input type="password" name="newPassword" placeholder="Leave blank to keep current password">
      </label>
      <button class="am-btn" type="submit">Update Profile</button>
    </form>
  </div>

  <%
    List<com.automart.model.ContactRequest> myRequests =
      (List<com.automart.model.ContactRequest>) request.getAttribute("requests");
  %>
  <% if (myRequests != null && !myRequests.isEmpty()) { %>
  <div class="am-panel">
    <div class="am-panel-header">
      <div class="am-accent"></div>
      <h2>My Dealer Requests</h2>
    </div>
    <p class="am-muted">Track the status of your contact requests sent to dealers.</p>
    <div class="am-table-wrap">
      <table class="am-table">
        <thead>
          <tr>
            <th style="width:26%">Vehicle</th>
            <th style="width:38%">Message</th>
            <th style="width:16%">Date</th>
            <th style="width:20%">Status</th>
          </tr>
        </thead>
        <tbody>
        <% for (com.automart.model.ContactRequest cr : myRequests) {
          String st = cr.getStatus();
          String badgeClass = "am-badge-open";
          if ("CONTACTED".equals(st)) badgeClass = "am-badge-contacted";
          else if ("CLOSED".equals(st)) badgeClass = "am-badge-closed";
          String name = cr.getCarName();
          String initials = name.length() >= 2
            ? String.valueOf(name.charAt(0)) + String.valueOf(name.lastIndexOf(' ') > 0 ? name.charAt(name.lastIndexOf(' ')+1) : name.charAt(1))
            : name.substring(0,1);
        %>
          <tr>
            <td>
              <div class="am-vehicle-cell">
                <div class="am-avatar"><%=initials.toUpperCase()%></div>
                <div>
                  <div class="am-vehicle-name"><%=cr.getCarName()%></div>
                </div>
              </div>
            </td>
            <td class="am-msg"><%=cr.getMessage()%></td>
            <td class="am-date"><%=cr.getCreatedAt()%></td>
            <td><span class="am-badge <%=badgeClass%>"><%=st%></span></td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>
  </div>
  <% } %>
</div>

<%@ include file="/WEB-INF/footer.jsp" %>