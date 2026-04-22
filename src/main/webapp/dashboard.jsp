<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.tracker.*, java.util.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("username") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    String username = (String) sess.getAttribute("username");
    StudentDAO dao = new StudentDAO();
    Student student = dao.getStudentByUsername(username);

    // Only show companies student has NOT applied to
    List<Company> companies = student != null
        ? dao.getAvailableCompanies(student.getId())
        : new ArrayList<>();

    List<String[]> myApps = student != null
        ? dao.getStudentApplications(student.getId())
        : new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f2f5; }

        .header { background: #1a73e8; color: white;
                  padding: 16px 32px;
                  display: flex; justify-content: space-between;
                  align-items: center; }
        .header h1 { font-size: 20px; }
        .header a { color: white; text-decoration: none;
                    background: rgba(255,255,255,0.2);
                    padding: 6px 14px; border-radius: 6px; }

        .container { max-width: 1000px; margin: 30px auto;
                     padding: 0 20px; }

        .card { background: white; border-radius: 12px;
                padding: 24px; margin-bottom: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.06); }

        h2 { color: #1a73e8; margin-bottom: 16px; }

        /* Profile grid */
        .info-grid { display: grid;
                     grid-template-columns: 1fr 1fr;
                     gap: 12px; }
        .info-item { background: #f8f9fa; padding: 12px 16px;
                     border-radius: 8px; }
        .info-item span { font-size: 12px; color: #666;
                          display: block; }
        .info-item strong { font-size: 15px; }

        /* Enrollment number highlight */
        .enroll-box { background: #e8f0fe; 
                      border: 1px solid #1a73e8;
                      border-radius: 8px; padding: 12px 16px;
                      margin-top: 12px;
                      display: flex; align-items: center;
                      gap: 10px; }
        .enroll-box span { font-size: 12px; color: #1557b0; }
        .enroll-box strong { font-size: 18px; color: #1a73e8;
                             letter-spacing: 1px; }

        table { width: 100%; border-collapse: collapse; }
        th { background: #f0f2f5; padding: 10px 12px;
             text-align: left; font-size: 13px; color: #444; }
        td { padding: 10px 12px;
             border-bottom: 1px solid #f0f2f5; font-size: 14px; }

        .badge { padding: 4px 12px; border-radius: 20px;
                 font-size: 12px; font-weight: bold; }
        .applied     { background:#e8f0fe; color:#1a73e8; }
        .selected    { background:#e6f4ea; color:#137333; }
        .rejected    { background:#fce8e6; color:#c5221f; }
        .shortlisted { background:#fef7e0; color:#b06000; }
        .placement   { background:#e8f0fe; color:#1a73e8; }
        .internship  { background:#e6f4ea; color:#137333; }

        .btn { background: #1a73e8; color: white; border: none;
               padding: 6px 16px; border-radius: 6px;
               cursor: pointer; font-size: 13px; }
        .btn:hover { background: #1557b0; }

        .msg { background: #e6f4ea; color: #137333;
               padding: 10px 16px; border-radius: 8px;
               margin-bottom: 16px; }
        .msg.warn { background: #fef7e0; color: #b06000; }

        .empty { text-align: center; color: #999; padding: 20px; }

        .count-badge { background: #1a73e8; color: white;
                       font-size: 11px; padding: 2px 8px;
                       border-radius: 10px; margin-left: 8px;
                       vertical-align: middle; }
    </style>
</head>
<body>

<div class="header">
    <h1>Internship and Placement Tracker</h1>
    <a href="LogoutServlet">Logout</a>
</div>

<div class="container">

    <%
        String msg = request.getParameter("msg");
        if (msg != null) {
            String msgClass = msg.contains("Already") 
                              ? "msg warn" : "msg";
    %>
        <div class="<%= msgClass %>"><%= msg %></div>
    <% } %>

    <!-- Profile Card -->
    <div class="card">
        <h2>My Profile</h2>
        <% if (student != null) { %>
        <div class="info-grid">
            <div class="info-item">
                <span>Full Name</span>
                <strong><%= student.getFullName() %></strong>
            </div>
            <div class="info-item">
                <span>Branch</span>
                <strong><%= student.getBranch() %></strong>
            </div>
            <div class="info-item">
                <span>CGPA</span>
                <strong><%= student.getCgpa() %></strong>
            </div>
            <div class="info-item">
                <span>Phone</span>
                <strong><%= student.getPhone() %></strong>
            </div>
        </div>

        <!-- Enrollment Number -->
        <div class="enroll-box">
            <div>
                <span>Your Enrollment Number</span>
                <strong><%= student.getEnrollmentNo() %></strong>
            </div>
        </div>
        <% } %>
    </div>

    <!-- Available Companies Card -->
    <div class="card">
        <h2>
            Available Opportunities
            <% if (!companies.isEmpty()) { %>
            <span class="count-badge"><%= companies.size() %></span>
            <% } %>
        </h2>

        <% if (companies.isEmpty() && myApps.isEmpty()) { %>
            <p class="empty">No companies available right now.</p>
        <% } else if (companies.isEmpty()) { %>
            <p class="empty">
                You have applied to all available companies!
                Check your applications below.
            </p>
        <% } else { %>
        <table>
            <tr>
                <th>Company</th>
                <th>Role</th>
                <th>Package</th>
                <th>Type</th>
                <th>Action</th>
            </tr>
            <% for (Company c : companies) { %>
            <tr>
                <td><strong><%= c.getName() %></strong></td>
                <td><%= c.getRoleOffered() %></td>
                <td>
                    <%= c.getType().equals("internship")
                        ? "Stipend Based"
                        : c.getPackageLpa() + " LPA" %>
                </td>
                <td>
                    <span class="badge <%= c.getType() %>">
                        <%= c.getType() %>
                    </span>
                </td>
                <td>
                    <form action="PlacementServlet" method="post"
                          style="display:inline">
                        <input type="hidden" 
                               name="action" value="apply"/>
                        <input type="hidden" name="companyId"
                               value="<%= c.getId() %>"/>
                        <button class="btn" type="submit">
                            Apply
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
    </div>

    <!-- My Applications Card -->
    <div class="card">
        <h2>
            My Applications
            <% if (!myApps.isEmpty()) { %>
            <span class="count-badge"><%= myApps.size() %></span>
            <% } %>
        </h2>
        <table>
            <tr>
                <th>Company</th>
                <th>Role</th>
                <th>Package</th>
                <th>Status</th>
                <th>Applied On</th>
            </tr>
            <% for (String[] app : myApps) { %>
            <tr>
                <td><strong><%= app[0] %></strong></td>
                <td><%= app[1] %></td>
                <td>
                    <%= app[2].equals("0.0") 
                        ? "Stipend Based" 
                        : app[2] + " LPA" %>
                </td>
                <td>
                    <span class="badge <%= app[3] %>">
                        <%= app[3].toUpperCase() %>
                    </span>
                </td>
                <td><%= app[4] %></td>
            </tr>
            <% } %>
            <% if (myApps.isEmpty()) { %>
            <tr>
                <td colspan="5" class="empty">
                    No applications yet. Apply above!
                </td>
            </tr>
            <% } %>
        </table>
    </div>

</div>
</body>
</html>