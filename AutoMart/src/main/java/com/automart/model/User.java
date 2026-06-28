package com.automart.model;

public class User {
    private int userId;
    private String name;
    private String email;
    private String phone;
    private String passwordHash;
    private String city;
    private String role;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}
