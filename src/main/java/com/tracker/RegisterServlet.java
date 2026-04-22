package com.tracker;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username     = request.getParameter("username");
        String password     = request.getParameter("password");
        String fullName     = request.getParameter("fullName");
        String branch       = request.getParameter("branch");
        float  cgpa         = Float.parseFloat(
                                  request.getParameter("cgpa"));
        String phone        = request.getParameter("phone");
        String enrollmentNo = request.getParameter("enrollmentNo");

        StudentDAO dao = new StudentDAO();
        boolean success = dao.registerStudent(
            username, password, fullName,
            branch, cgpa, phone, enrollmentNo);

        if (success) {
            response.sendRedirect(
                "index.jsp?msg=registered&enroll="
                + enrollmentNo);
        } else {
            request.setAttribute("error",
                "Registration failed. Username or " +
                "Enrollment Number may already exist.");
            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);
        }
    }
}