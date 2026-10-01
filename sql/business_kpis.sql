USE ecommerce_analytics;


-- ============================================
-- TOTAL REVENUE
-- ============================================

SELECT
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM transactions;


-- ============================================
-- TOTAL ORDERS
-- ============================================

SELECT
    COUNT(DISTINCT Invoice) AS Total_Orders
FROM transactions;


-- ============================================
-- TOTAL CUSTOMERS
-- ============================================

SELECT
    COUNT(DISTINCT CustomerID) AS Total_Customers
FROM transactions;


-- ============================================
-- TOTAL PRODUCTS
-- ============================================

SELECT
    COUNT(DISTINCT StockCode) AS Total_Products
FROM transactions;


-- ============================================
-- TOTAL QUANTITY SOLD
-- ============================================

SELECT
    SUM(Quantity) AS Total_Quantity_Sold
FROM transactions;


-- ============================================
-- AVERAGE ORDER VALUE
-- ============================================

SELECT
    ROUND(
        SUM(Revenue) / NULLIF(COUNT(DISTINCT Invoice), 0),
        2
    ) AS Average_Order_Value
FROM transactions;

-- ============================================
-- MONTHLY SALES VIEW
-- ============================================

CREATE OR REPLACE VIEW monthly_sales_view AS

SELECT
    Year,
    Month,
    Month_Name,
    Quarter,
    ROUND(SUM(Revenue), 2) AS Revenue,
    SUM(Quantity) AS Quantity_Sold,
    COUNT(DISTINCT Invoice) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers

FROM transactions

GROUP BY
    Year,
    Month,
    Month_Name,
    Quarter;

    -- ============================================
-- CUSTOMER SEGMENT VIEW
-- ============================================

CREATE OR REPLACE VIEW customer_segment_view AS

SELECT
    Customer_Segment,
    COUNT(*) AS Customer_Count,
    ROUND(SUM(Monetary), 2) AS Total_Revenue,
    ROUND(AVG(Monetary), 2) AS Average_Monetary,
    ROUND(AVG(Frequency), 2) AS Average_Frequency,
    ROUND(AVG(Recency), 2) AS Average_Recency

FROM customer_rfm

GROUP BY Customer_Segment;