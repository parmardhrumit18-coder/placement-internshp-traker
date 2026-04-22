package com.tracker;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // Register new student
    public boolean registerStudent(String username, String password,
                                   String fullName, String branch,
                                   float cgpa, String phone,
                                   String enrollmentNo) {

        String checkSQL   =
            "SELECT COUNT(*) FROM users WHERE username = ?";
        String checkEnrollSQL =
            "SELECT COUNT(*) FROM students WHERE enrollment_no = ?";
        String userSQL    =
            "INSERT INTO users (username, password, role) " +
            "VALUES (?, ?, 'student') RETURNING id";
        String studentSQL =
            "INSERT INTO students (user_id, full_name, branch, " +
            "cgpa, phone, enrollment_no) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Check duplicate username
            PreparedStatement checkStmt =
                conn.prepareStatement(checkSQL);
            checkStmt.setString(1, username);
            ResultSet checkRs = checkStmt.executeQuery();
            checkRs.next();
            int count = checkRs.getInt(1);
            checkStmt.close();

            if (count > 0) {
                conn.rollback();
                conn.close();
                return false;
            }

            // Check duplicate enrollment number
            PreparedStatement checkEnroll =
                conn.prepareStatement(checkEnrollSQL);
            checkEnroll.setString(1, enrollmentNo);
            ResultSet enrollRs = checkEnroll.executeQuery();
            enrollRs.next();
            int enrollCount = enrollRs.getInt(1);
            checkEnroll.close();

            if (enrollCount > 0) {
                conn.rollback();
                conn.close();
                return false;
            }

            // Insert into users
            PreparedStatement ps1 =
                conn.prepareStatement(userSQL);
            ps1.setString(1, username);
            ps1.setString(2, password);
            ResultSet rs = ps1.executeQuery();
            int userId = 0;
            if (rs.next()) userId = rs.getInt(1);
            ps1.close();

            if (userId == 0) {
                conn.rollback();
                conn.close();
                return false;
            }

            // Insert into students
            PreparedStatement ps2 =
                conn.prepareStatement(studentSQL);
            ps2.setInt(1, userId);
            ps2.setString(2, fullName);
            ps2.setString(3, branch);
            ps2.setFloat(4, cgpa);
            ps2.setString(5, phone);
            ps2.setString(6, enrollmentNo);
            ps2.executeUpdate();
            ps2.close();

            conn.commit();
            return true;

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Login
    public String loginUser(String username, String password) {
        String sql =
            "SELECT role FROM users " +
            "WHERE username=? AND password=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("role");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get student by username
    public Student getStudentByUsername(String username) {
        String sql =
            "SELECT s.* FROM students s " +
            "JOIN users u ON s.user_id = u.id " +
            "WHERE u.username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Student(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("branch"),
                    rs.getFloat("cgpa"),
                    rs.getString("phone"),
                    rs.getString("enrollment_no")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get available companies not yet applied
    public List<Company> getAvailableCompanies(int studentId) {
        List<Company> list = new ArrayList<>();
        String sql =
            "SELECT * FROM companies WHERE id NOT IN (" +
            "SELECT company_id FROM applications " +
            "WHERE student_id = ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Company(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("role_offered"),
                    rs.getFloat("package_lpa"),
                    rs.getString("type")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get all companies
    public List<Company> getAllCompanies() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT * FROM companies";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Company(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("role_offered"),
                    rs.getFloat("package_lpa"),
                    rs.getString("type")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Apply to company
    public boolean applyToCompany(int studentId, int companyId) {
        String checkSQL  =
            "SELECT COUNT(*) FROM applications " +
            "WHERE student_id=? AND company_id=?";
        String insertSQL =
            "INSERT INTO applications " +
            "(student_id, company_id, status) " +
            "VALUES (?, ?, 'applied')";
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement check =
                conn.prepareStatement(checkSQL);
            check.setInt(1, studentId);
            check.setInt(2, companyId);
            ResultSet rs = check.executeQuery();
            rs.next();
            if (rs.getInt(1) > 0) return false;
            check.close();

            PreparedStatement ps =
                conn.prepareStatement(insertSQL);
            ps.setInt(1, studentId);
            ps.setInt(2, companyId);
            ps.executeUpdate();
            ps.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get student applications
    public List<String[]> getStudentApplications(int studentId) {
        List<String[]> list = new ArrayList<>();
        String sql =
            "SELECT c.name, c.role_offered, c.package_lpa, " +
            "a.status, a.applied_date " +
            "FROM applications a " +
            "JOIN companies c ON a.company_id = c.id " +
            "WHERE a.student_id = ? " +
            "ORDER BY a.applied_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("name"),
                    rs.getString("role_offered"),
                    String.valueOf(rs.getFloat("package_lpa")),
                    rs.getString("status"),
                    String.valueOf(rs.getDate("applied_date"))
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Admin — pending applications
    public List<String[]> getPendingApplications() {
        List<String[]> list = new ArrayList<>();
        String sql =
            "SELECT a.id, s.full_name, c.name, " +
            "a.status, a.applied_date " +
            "FROM applications a " +
            "JOIN students s ON a.student_id = s.id " +
            "JOIN companies c ON a.company_id = c.id " +
            "WHERE a.status = 'applied' " +
            "ORDER BY a.applied_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt("id")),
                    rs.getString("full_name"),
                    rs.getString("name"),
                    rs.getString("status"),
                    String.valueOf(rs.getDate("applied_date"))
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Admin — updated applications
    public List<String[]> getUpdatedApplications() {
        List<String[]> list = new ArrayList<>();
        String sql =
            "SELECT a.id, s.full_name, c.name, " +
            "a.status, a.applied_date " +
            "FROM applications a " +
            "JOIN students s ON a.student_id = s.id " +
            "JOIN companies c ON a.company_id = c.id " +
            "WHERE a.status IN " +
            "('shortlisted','selected','rejected') " +
            "ORDER BY a.applied_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new String[]{
                    String.valueOf(rs.getInt("id")),
                    rs.getString("full_name"),
                    rs.getString("name"),
                    rs.getString("status"),
                    String.valueOf(rs.getDate("applied_date"))
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Admin — update status
    public boolean updateStatus(int appId, String status) {
        String sql =
            "UPDATE applications SET status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, appId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Admin — add company
    public boolean addCompany(String name, String role,
                               float pkg, String type) {
        String sql =
            "INSERT INTO companies (name, role_offered, " +
            "package_lpa, type) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, role);
            ps.setFloat(3, pkg);
            ps.setString(4, type);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}