package com.tracker;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/PlacementServlet")
public class PlacementServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        StudentDAO dao = new StudentDAO();
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if ("apply".equals(action)) {
            int companyId = Integer.parseInt(
                request.getParameter("companyId"));
            Student student = dao.getStudentByUsername(username);
            boolean result = dao.applyToCompany(
                student.getId(), companyId);
            String msg = result
                ? "Applied+successfully!"
                : "Already+applied+to+this+company.";
            response.sendRedirect("dashboard.jsp?msg=" + msg);

        } else if ("updateStatus".equals(action)) {
            int appId = Integer.parseInt(
                request.getParameter("appId"));
            String status = request.getParameter("status");
            dao.updateStatus(appId, status);
            response.sendRedirect("admin.jsp?msg=Status+updated");

        } else if ("addCompany".equals(action)) {
            String name = request.getParameter("name");
            String role = request.getParameter("roleOffered");
            float pkg   = Float.parseFloat(
                request.getParameter("packageLpa"));
            String type = request.getParameter("type");
            dao.addCompany(name, role, pkg, type);
            response.sendRedirect("admin.jsp?msg=Company+added");
        }
    }
}