<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.tracker.*, java.util.*" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || !"admin".equals(sess.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    StudentDAO dao = new StudentDAO();
    List<String[]> pendingApps = dao.getPendingApplications();
    List<String[]> updatedApps = dao.getUpdatedApplications();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f2f5; }

        .header { background: #ea4335; color: white; 
                  padding: 16px 32px;
                  display: flex; justify-content: space-between;
                  align-items: center; }
        .header h1 { font-size: 20px; }
        .header a { color: white; text-decoration: none;
                    background: rgba(255,255,255,0.2);
                    padding: 6px 14px; border-radius: 6px; }

        .container { max-width: 1100px; margin: 30px auto; 
                     padding: 0 20px; }

        .card { background: white; border-radius: 12px; 
                padding: 24px; margin-bottom: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.06); }

        .grid2 { display: grid;
                 grid-template-columns: 1fr 1fr; gap: 24px; }

        h2 { margin-bottom: 16px; }
        .h-red   { color: #ea4335; }
        .h-orange{ color: #f57c00; }
        .h-green { color: #34a853; }

        label { font-size: 13px; color: #555; display: block;
                margin-bottom: 4px; }
        input, select { width: 100%; padding: 9px; 
                        margin-bottom: 12px;
                        border: 1px solid #ddd; border-radius: 6px;
                        font-size: 14px; }
        .btn-add { background: #ea4335; color: white; border: none;
                   padding: 10px 20px; border-radius: 6px;
                   font-size: 15px; cursor: pointer; width: 100%; }
        .btn-add:hover { background: #c5221f; }

        table { width: 100%; border-collapse: collapse; }
        th { background: #f0f2f5; padding: 10px 12px;
             text-align: left; font-size: 13px; color: #444; }
        td { padding: 10px 12px; 
             border-bottom: 1px solid #f0f2f5; font-size: 14px; }

        .badge { padding: 4px 12px; border-radius: 20px;
                 font-size: 12px; font-weight: bold; }
        .badge.applied     { background:#e8f0fe; color:#1a73e8; }
        .badge.shortlisted { background:#fef7e0; color:#b06000; }
        .badge.selected    { background:#e6f4ea; color:#137333; }
        .badge.rejected    { background:#fce8e6; color:#c5221f; }

        .status-form { display: flex; gap: 6px; align-items: center; }
        .status-form select { margin: 0; padding: 5px; width: auto; }
        .status-form button { background: #1a73e8; color: white;
                              border: none; padding: 5px 12px;
                              border-radius: 5px; cursor: pointer;
                              white-space: nowrap; }
        .status-form button:hover { background: #1557b0; }

        .msg { background: #e6f4ea; color: #137333;
               padding: 10px 16px; border-radius: 8px;
               margin-bottom: 16px; }

        .stat-box { background: #f8f9fa; border-radius: 8px;
                    padding: 16px; margin-bottom: 12px; }
        .stat-box h3 { font-size: 32px; color: #ea4335; }
        .stat-box p  { color: #666; font-size: 14px; 
                       margin-top: 4px; }

        .empty { text-align: center; color: #999; padding: 20px; }

        .section-title {
            font-size: 16px; font-weight: 500;
            padding: 8px 0 12px;
            border-bottom: 2px solid #f0f2f5;
            margin-bottom: 16px;
        }
        .pending-header { 
            border-left: 4px solid #f57c00; 
            padding-left: 10px; 
        }
        .updated-header { 
            border-left: 4px solid #34a853; 
            padding-left: 10px; 
        }
    </style>
</head>
<body>

<div class="header">
    <h1>Admin Panel - Internship Tracker</h1>
    <a href="LogoutServlet">Logout</a>
</div>

<div class="container">

    <%
        String msg = request.getParameter("msg");
        if (msg != null) {
    %>
        <div class="msg">✅ <%= msg %></div>
    <% } %>

    <!-- Top Grid: Add Company + Stats -->
    <div class="grid2">

        <!-- Add Company -->
        <div class="card">
            <h2 class="h-red">Add New Company</h2>
            <form action="PlacementServlet" method="post">
                <input type="hidden" name="action" value="addCompany"/>
                <label>Company Name</label>
                <input type="text" name="name"
                       required placeholder="e.g. Google" />
                <label>Role Offered</label>
                <input type="text" name="roleOffered"
                       required placeholder="e.g. Software Engineer" />
                <label>Package LPA (enter 0 for internship)</label>
                <input type="number" name="packageLpa"
                       step="0.1" min="0" required
                       placeholder="e.g. 5.5" />
                <label>Type</label>
                <select name="type">
                    <option value="placement">Placement</option>
                    <option value="internship">Internship</option>
                </select>
                <button class="btn-add" type="submit">
                    Add Company
                </button>
            </form>
        </div>

        <!-- Stats -->
        <div class="card">
            <h2 class="h-red">Dashboard Stats</h2>
            <div class="stat-box">
                <h3><%= pendingApps.size() %></h3>
                <p>Pending Applications (need review)</p>
            </div>
            <div class="stat-box">
                <h3><%= updatedApps.size() %></h3>
                <p>Reviewed Applications</p>
            </div>
            <div class="stat-box">
                <h3>
                <%
                    int selectedCount = 0;
                    for (String[] a : updatedApps) {
                        if ("selected".equals(a[3])) selectedCount++;
                    }
                    out.print(selectedCount);
                %>
                </h3>
                <p>Students Selected</p>
            </div>
        </div>

    </div>

    <!-- TABLE 1: Pending Applications -->
    <div class="card">
        <div class="section-title pending-header">
            <h2 class="h-orange">
                Pending Applications
                — Needs Your Review
                (<%= pendingApps.size() %>)
            </h2>
        </div>
        <table>
            <tr>
                <th>#</th>
                <th>Student Name</th>
                <th>Company</th>
                <th>Status</th>
                <th>Applied Date</th>
                <th>Update Status</th>
            </tr>
            <% for (String[] app : pendingApps) { %>
            <tr>
                <td><%= app[0] %></td>
                <td><strong><%= app[1] %></strong></td>
                <td><%= app[2] %></td>
                <td>
                    <span class="badge applied">
                        APPLIED
                    </span>
                </td>
                <td><%= app[4] %></td>
                <td>
                    <form class="status-form"
                          action="PlacementServlet" method="post">
                        <input type="hidden"
                               name="action" value="updateStatus"/>
                        <input type="hidden"
                               name="appId" value="<%= app[0] %>"/>
                        <select name="status">
                            <option value="shortlisted">
                                Shortlisted
                            </option>
                            <option value="selected">
                                Selected
                            </option>
                            <option value="rejected">
                                Rejected
                            </option>
                        </select>
                        <button type="submit">Update</button>
                    </form>
                </td>
            </tr>
            <% } %>
            <% if (pendingApps.isEmpty()) { %>
            <tr>
                <td colspan="6" class="empty">
                    No pending applications.
                </td>
            </tr>
            <% } %>
        </table>
    </div>

    <!-- TABLE 2: Updated/Reviewed Applications -->
    <div class="card">
        <div class="section-title updated-header">
            <h2 class="h-green">
                Reviewed Applications
                — Already Updated
                (<%= updatedApps.size() %>)
            </h2>
        </div>
        <table>
            <tr>
                <th>#</th>
                <th>Student Name</th>
                <th>Company</th>
                <th>Final Status</th>
                <th>Applied Date</th>
                <th>Change Status</th>
            </tr>
            <% for (String[] app : updatedApps) { %>
            <tr>
                <td><%= app[0] %></td>
                <td><strong><%= app[1] %></strong></td>
                <td><%= app[2] %></td>
                <td>
                    <span class="badge <%= app[3] %>">
                        <%= app[3].toUpperCase() %>
                    </span>
                </td>
                <td><%= app[4] %></td>
                <td>
                    <form class="status-form"
                          action="PlacementServlet" method="post">
                        <input type="hidden"
                               name="action" value="updateStatus"/>
                        <input type="hidden"
                               name="appId" value="<%= app[0] %>"/>
                        <select name="status">
                            <option value="shortlisted">
                                Shortlisted
                            </option>
                            <option value="selected">
                                Selected
                            </option>
                            <option value="rejected">
                                Rejected
                            </option>
                            <option value="applied">
                                Move back to Pending
                            </option>
                        </select>
                        <button type="submit">Change</button>
                    </form>
                </td>
            </tr>
            <% } %>
            <% if (updatedApps.isEmpty()) { %>
            <tr>
                <td colspan="6" class="empty">
                    No reviewed applications yet.
                    Update statuses from the table above.
                </td>
            </tr>
            <% } %>
        </table>
    </div>

</div>
</body>
</html>