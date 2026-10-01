-- ============================================
-- E-COMMERCE ANALYTICS DATABASE SCHEMA
-- ============================================

CREATE DATABASE IF NOT EXISTS ecommerce_analytics;

USE ecommerce_analytics;


-- ============================================
-- TRANSACTIONS TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS transactions (
    Invoice VARCHAR(20),
    StockCode VARCHAR(30),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    Price DECIMAL(12,2),
    CustomerID VARCHAR(30),
    Country VARCHAR(100),
    Revenue DECIMAL(14,2),
    Year INT,
    Month INT,
    Month_Name VARCHAR(20),
    Quarter VARCHAR(5),
    Day_of_Week VARCHAR(20),
    Hour INT
);


-- ============================================
-- CUSTOMER RFM TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS customer_rfm (
    CustomerID VARCHAR(30) PRIMARY KEY,
    Recency INT,
    Frequency INT,
    Monetary DECIMAL(14,2),
    R_Score INT,
    F_Score INT,
    M_Score INT,
    RFM_Score VARCHAR(10),
    Customer_Segment VARCHAR(50)
);


-- ============================================
-- PRODUCT SUMMARY TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS product_summary (
    StockCode VARCHAR(30) PRIMARY KEY,
    Description VARCHAR(255),
    Total_Quantity INT,
    Total_Revenue DECIMAL(14,2),
    Unique_Customers INT
);