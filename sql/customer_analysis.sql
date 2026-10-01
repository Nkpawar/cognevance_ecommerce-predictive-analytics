USE ecommerce_analytics;


-- ============================================
-- TOP CUSTOMERS BY REVENUE
-- ============================================

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    COUNT(DISTINCT Invoice) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity
FROM transactions
GROUP BY CustomerID
ORDER BY Total_Revenue DESC
LIMIT 20;


-- ============================================
-- CUSTOMER REVENUE BY COUNTRY
-- ============================================

SELECT
    Country,
    COUNT(DISTINCT CustomerID) AS Customers,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM transactions
GROUP BY Country
ORDER BY Revenue DESC;


-- ============================================
-- RFM CUSTOMER SEGMENTS
-- ============================================

SELECT
    Customer_Segment,
    COUNT(*) AS Customer_Count,
    ROUND(SUM(Monetary), 2) AS Segment_Revenue,
    ROUND(AVG(Monetary), 2) AS Average_Monetary
FROM customer_rfm
GROUP BY Customer_Segment
ORDER BY Segment_Revenue DESC;

-- ============================================
-- CUSTOMER REVENUE RANKING
-- WINDOW FUNCTION
-- ============================================

WITH customer_sales AS (
    SELECT
        CustomerID,
        SUM(Revenue) AS Total_Revenue,
        COUNT(DISTINCT Invoice) AS Total_Orders
    FROM transactions
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    ROUND(Total_Revenue, 2) AS Total_Revenue,
    Total_Orders,

    RANK() OVER (
        ORDER BY Total_Revenue DESC
    ) AS Revenue_Rank

FROM customer_sales
ORDER BY Revenue_Rank
LIMIT 20;

-- ============================================
-- RFM SEGMENT ANALYSIS
-- ============================================

SELECT
    Customer_Segment,
    COUNT(*) AS Customer_Count,
    ROUND(SUM(Monetary), 2) AS Total_Revenue,
    ROUND(AVG(Monetary), 2) AS Average_Customer_Value,
    ROUND(AVG(Frequency), 2) AS Average_Frequency,
    ROUND(AVG(Recency), 2) AS Average_Recency
FROM customer_rfm
GROUP BY Customer_Segment
ORDER BY Total_Revenue DESC;

-- ============================================
-- ADVANCED CUSTOMER RANKING
-- RANK, DENSE_RANK, ROW_NUMBER
-- ============================================

WITH customer_sales AS (
    SELECT
        CustomerID,
        SUM(Revenue) AS Total_Revenue,
        COUNT(DISTINCT Invoice) AS Total_Orders,
        SUM(Quantity) AS Total_Quantity
    FROM transactions
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    ROUND(Total_Revenue, 2) AS Total_Revenue,
    Total_Orders,
    Total_Quantity,

    RANK() OVER (
        ORDER BY Total_Revenue DESC
    ) AS Revenue_Rank,

    DENSE_RANK() OVER (
        ORDER BY Total_Revenue DESC
    ) AS Revenue_Dense_Rank,

    ROW_NUMBER() OVER (
        ORDER BY Total_Revenue DESC
    ) AS Customer_Row_Number

FROM customer_sales
ORDER BY Total_Revenue DESC
LIMIT 20;

-- ============================================
-- CUSTOMER LIFETIME VALUE
-- ============================================

SELECT
    CustomerID,
    ROUND(SUM(Revenue), 2) AS Lifetime_Value,
    COUNT(DISTINCT Invoice) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity,

    ROUND(
        SUM(Revenue) /
        NULLIF(COUNT(DISTINCT Invoice), 0),
        2
    ) AS Average_Order_Value

FROM transactions

GROUP BY CustomerID

ORDER BY Lifetime_Value DESC

LIMIT 20;