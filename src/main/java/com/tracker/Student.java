package com.tracker;

public class Student {
    private int id;
    private int userId;
    private String fullName;
    private String branch;
    private float cgpa;
    private String phone;
    private String enrollmentNo;

    public Student() {}

    public Student(int id, int userId, String fullName,
                   String branch, float cgpa, String phone,
                   String enrollmentNo) {
        this.id = id;
        this.userId = userId;
        this.fullName = fullName;
        this.branch = branch;
        this.cgpa = cgpa;
        this.phone = phone;
        this.enrollmentNo = enrollmentNo;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { 
        this.fullName = fullName; 
    }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public float getCgpa() { return cgpa; }
    public void setCgpa(float cgpa) { this.cgpa = cgpa; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { 
        this.enrollmentNo = enrollmentNo; 
    }
}