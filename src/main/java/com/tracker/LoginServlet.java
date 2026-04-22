package com.tracker;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        StudentDAO dao = new StudentDAO();
        String role = dao.loginUser(username, password);

        if (role != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", role);
            if (role.equals("admin")) {
                response.sendRedirect("admin.jsp");
            } else {
                response.sendRedirect("dashboard.jsp");
            }
        } else {
            request.setAttribute("error", 
                "Invalid username or password!");
            request.getRequestDispatcher("index.jsp")
                   .forward(request, response);
        }
    }
}