<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Internship Tracker</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f2f5;
               display: flex; justify-content: center;
               align-items: center; min-height: 100vh; }
        .box { background: white; padding: 40px; border-radius: 12px;
               box-shadow: 0 2px 16px rgba(0,0,0,0.1); width: 420px; }
        h2 { text-align: center; color: #34a853;
             margin-bottom: 24px; }
        label { font-size: 13px; color: #555; display: block;
                margin-bottom: 4px; }
        input, select { width: 100%; padding: 10px;
                        margin-bottom: 14px;
                        border: 1px solid #ddd;
                        border-radius: 6px; font-size: 14px; }
        input:focus, select:focus {
                        outline: none;
                        border-color: #34a853;
                        box-shadow: 0 0 0 2px
                        rgba(52,168,83,0.15); }
        button { width: 100%; padding: 12px;
                 background: #34a853; color: white;
                 border: none; border-radius: 6px;
                 font-size: 16px; cursor: pointer; }
        button:hover { background: #2d8f47; }
        .error { color: #c5221f; text-align: center;
                 background: #fce8e6; padding: 10px;
                 border-radius: 6px; margin-bottom: 14px;
                 font-size: 14px; }
        p { text-align: center; margin-top: 16px;
            font-size: 14px; }
        a { color: #34a853; text-decoration: none; }
    </style>
</head>
<body>
<div class="box">
    <h2>Student Registration</h2>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p class="error"><%= error %></p>
    <% } %>

    <form action="RegisterServlet" method="post">

        <label>Enrollment Number</label>
        <input type="text"
               name="enrollmentNo"
               required
               placeholder="e.g. 22CE001"
               maxlength="20" />

        <label>Full Name</label>
        <input type="text" name="fullName"
               required placeholder="Your full name" />

        <label>Username</label>
        <input type="text" name="username"
               required placeholder="Choose a username" />

        <label>Password</label>
        <input type="password" name="password"
               required placeholder="Choose a password" />

        <label>Branch</label>
        <select name="branch">
            <option value="Computer Science">
                Computer Science</option>
            <option value="Information Technology">
                Information Technology</option>
            <option value="Electronics">
                Electronics</option>
            <option value="Mechanical">
                Mechanical</option>
            <option value="Civil">
                Civil</option>
        </select>

        <label>CGPA</label>
        <input type="number" name="cgpa"
               step="0.01" min="0" max="10"
               required placeholder="e.g. 8.5" />

        <label>Phone</label>
        <input type="text" name="phone"
               required placeholder="10-digit number" />

        <button type="submit">Register</button>
    </form>
    <p>Already registered?
        <a href="index.jsp">Login here</a>
    </p>
</div>
</body>
</html>