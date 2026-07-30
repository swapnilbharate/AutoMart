<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.automart.model.User" %>

<%
    User currentUser = (User) session.getAttribute("user");
    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoMart | Buy & Sell Used Cars in India</title>

    <link rel="stylesheet" href="<%=ctx%>/assets/css/style.css">
    <script defer src="<%=ctx%>/assets/js/app.js"></script>
</head>

<body>

<header class="site-header">

    <div style="display: flex; align-items: center; gap: 15px;">
        <button class="nav-toggle" type="button" data-nav-toggle>
            &#9776;
        </button>
        <a class="brand" href="<%=ctx%>/home">
            AutoMart
        </a>
    </div>

    <nav class="nav" data-nav
         style="display:flex;align-items:center;gap:15px;flex-wrap:wrap;">

        <a href="<%=ctx%>/home">Home</a>

        <a href="<%=ctx%>/cars">Browse Cars</a>

        <% if (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>

            <a href="<%=ctx%>/admin/dashboard">Admin Dashboard</a>
            <a href="<%=ctx%>/admin/cars">Manage Cars</a>
            <a href="<%=ctx%>/admin/users">Users</a>
            <a href="<%=ctx%>/admin/inquiries">Inquiries</a>

        <% } else if (currentUser != null) { %>

            <a href="<%=ctx%>/wishlist">Wishlist</a>
            <a href="<%=ctx%>/profile">Profile</a>

        <% } %>

        <% if (currentUser == null) { %>

            <a href="<%=ctx%>/login.jsp"
               style="display:inline-block;
                      padding:12px 28px;
                      background:#ffffff;
                      color:#111827;
                      text-decoration:none;
                      border-radius:10px;
                      font-size:16px;
                      font-weight:600;
                      width:auto;
                      flex:none;
                      box-shadow:0 2px 8px rgba(0,0,0,0.1);">
                Login
            </a>

            <a href="<%=ctx%>/register.jsp"
               style="display:inline-block;
                      padding:12px 28px;
                      background:#14b8a6;
                      color:white;
                      text-decoration:none;
                      border-radius:10px;
                      font-size:16px;
                      font-weight:600;
                      width:auto;
                      flex:none;
                      box-shadow:0 2px 8px rgba(0,0,0,0.15);">
                Register
            </a>

        <% } else { %>

            <span class="welcome"
                  style="font-size:16px;font-weight:600;">
                Hi, <%=currentUser.getName()%>
            </span>

            <a href="<%=ctx%>/logout"
               style="display:inline-block;
                      padding:12px 28px;
                      background:#ef4444;
                      color:white;
                      text-decoration:none;
                      border-radius:10px;
                      font-size:16px;
                      font-weight:600;
                      width:auto;
                      flex:none;
                      box-shadow:0 2px 8px rgba(0,0,0,0.15);">
                Logout
            </a>

        <% } %>

    </nav>

</header>

<main>

<% if (request.getParameter("success") != null) { %>
    <div class="alert success">
        <%= request.getParameter("success") %>
    </div>
<% } %>

<% if (request.getParameter("error") != null) { %>
    <div class="alert error">
        <%= request.getParameter("error") %>
    </div>
<% } %>