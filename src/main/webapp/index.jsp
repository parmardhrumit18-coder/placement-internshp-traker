<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Internship Tracker</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f2f5;
               display: flex; justify-content: center;
               align-items: center; height: 100vh; }
        .box { background: white; padding: 40px;
               border-radius: 12px;
               box-shadow: 0 2px 16px rgba(0,0,0,0.1);
               width: 380px; }
        h2 { text-align: center; color: #1a73e8;
             margin-bottom: 24px; }
        label { font-size: 13px; color: #555; display: block;
                margin-bottom: 4px; }
        input { width: 100%; padding: 10px;
                margin-bottom: 16px;
                border: 1px solid #ddd; border-radius: 6px;
                font-size: 14px; }
        input:focus { outline: none;
                      border-color: #1a73e8;
                      box-shadow: 0 0 0 2px
                      rgba(26,115,232,0.15); }
        button { width: 100%; padding: 12px;
                 background: #1a73e8; color: white;
                 border: none; border-radius: 6px;
                 font-size: 16px; cursor: pointer; }
        button:hover { background: #1557b0; }
        .error { color: #c5221f; text-align: center;
                 background: #fce8e6; padding: 10px;
                 border-radius: 6px; margin-bottom: 14px;
                 font-size: 14px; }

        /* Shown after successful registration */
        .success-box { background: #e6f4ea;
                       border: 1px solid #34a853;
                       border-radius: 8px; padding: 16px;
                       margin-bottom: 16px;
                       text-align: center; }
        .success-box p { color: #137333; font-size: 14px;
                         margin-bottom: 8px; }
        .enroll-display { background: white;
                          border: 2px solid #34a853;
                          border-radius: 6px;
                          padding: 8px 16px;
                          display: inline-block;
                          font-size: 20px;
                          font-weight: bold;
                          color: #1a73e8;
                          letter-spacing: 2px; }
        .enroll-note { font-size: 11px; color: #666;
                       margin-top: 8px; display: block; }

        p.nav { text-align: center; margin-top: 16px;
                font-size: 14px; }
        a { color: #1a73e8; text-decoration: none; }
    </style>
</head>
<body>
<div class="box">
    <h2>Internship Tracker</h2>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p class="error"><%= error %></p>
    <% } %>

    <%
        String msg    = request.getParameter("msg");
        String enroll = request.getParameter("enroll");
        if ("registered".equals(msg) && enroll != null) {
    %>
        <div class="success-box">
            <p>Registration successful!</p>
            <p>Your Enrollment Number:</p>
            <div class="enroll-display"><%= enroll %></div>
            <span class="enroll-note">
                Save this number for future reference.
            </span>
        </div>
    <% } %>

    <form action="LoginServlet" method="post">
        <label>Username</label>
        <input type="text" name="username"
               required placeholder="Enter username" />
        <label>Password</label>
        <input type="password" name="password"
               required placeholder="Enter password" />
        <button type="submit">Login</button>
    </form>
    <p class="nav">No account?
        <a href="register.jsp">Register here</a>
    </p>
</div>
</body>
</html>