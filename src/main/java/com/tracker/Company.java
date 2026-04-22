package com.tracker;

public class Company {
    private int id;
    private String name;
    private String roleOffered;
    private float packageLpa;
    private String type;

    public Company() {}

    public Company(int id, String name, String roleOffered,
                   float packageLpa, String type) {
        this.id = id;
        this.name = name;
        this.roleOffered = roleOffered;
        this.packageLpa = packageLpa;
        this.type = type;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getRoleOffered() { return roleOffered; }
    public void setRoleOffered(String r) { this.roleOffered = r; }

    public float getPackageLpa() { return packageLpa; }
    public void setPackageLpa(float p) { this.packageLpa = p; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
}