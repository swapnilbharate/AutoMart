package com.automart.model;

import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardStats {
    private int totalUsers;
    private int totalCars;
    private int availableCars;
    private int soldCars;
    private int wishlistEntries;
    private Map<String, Integer> listingsByBrand = new LinkedHashMap<>();
    private Map<String, Integer> priceRanges = new LinkedHashMap<>();
    private Map<String, Integer> userActivity = new LinkedHashMap<>();

    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
    public int getTotalCars() { return totalCars; }
    public void setTotalCars(int totalCars) { this.totalCars = totalCars; }
    public int getAvailableCars() { return availableCars; }
    public void setAvailableCars(int availableCars) { this.availableCars = availableCars; }
    public int getSoldCars() { return soldCars; }
    public void setSoldCars(int soldCars) { this.soldCars = soldCars; }
    public int getWishlistEntries() { return wishlistEntries; }
    public void setWishlistEntries(int wishlistEntries) { this.wishlistEntries = wishlistEntries; }
    public Map<String, Integer> getListingsByBrand() { return listingsByBrand; }
    public void setListingsByBrand(Map<String, Integer> listingsByBrand) { this.listingsByBrand = listingsByBrand; }
    public Map<String, Integer> getPriceRanges() { return priceRanges; }
    public void setPriceRanges(Map<String, Integer> priceRanges) { this.priceRanges = priceRanges; }
    public Map<String, Integer> getUserActivity() { return userActivity; }
    public void setUserActivity(Map<String, Integer> userActivity) { this.userActivity = userActivity; }
}
