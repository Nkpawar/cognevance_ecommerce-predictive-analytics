USE ecommerce_analytics;


-- ============================================
-- TOP PRODUCTS BY REVENUE
-- ============================================

SELECT
    StockCode,
    Description,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM transactions
GROUP BY StockCode, Description
ORDER BY Total_Revenue DESC
LIMIT 20;


-- ============================================
-- TOP PRODUCTS BY QUANTITY
-- ============================================

SELECT
    StockCode,
    Description,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM transactions
GROUP BY StockCode, Description
ORDER BY Total_Quantity DESC
LIMIT 20;


-- ============================================
-- PRODUCT REVENUE CONTRIBUTION
-- ============================================

SELECT
    StockCode,
    Description,
    ROUND(SUM(Revenue), 2) AS Product_Revenue,
    ROUND(
        SUM(Revenue) /
        NULLIF((SELECT SUM(Revenue) FROM transactions), 0)
        * 100,
        2
    ) AS Revenue_Contribution_Percent
FROM transactions
GROUP BY StockCode, Description
ORDER BY Product_Revenue DESC
LIMIT 20;

-- ============================================
-- PRODUCT REVENUE CONTRIBUTION
-- ============================================

WITH product_sales AS (
    SELECT
        StockCode,
        MAX(Description) AS Description,
        SUM(Quantity) AS Total_Quantity,
        SUM(Revenue) AS Product_Revenue
    FROM transactions
    GROUP BY StockCode
)

SELECT
    StockCode,
    Description,
    Total_Quantity,
    ROUND(Product_Revenue, 2) AS Product_Revenue,

    ROUND(
        Product_Revenue /
        SUM(Product_Revenue) OVER () * 100,
        2
    ) AS Revenue_Contribution_Percent

FROM product_sales
ORDER BY Product_Revenue DESC
LIMIT 20;

-- ============================================
-- PRODUCT PERFORMANCE VIEW
-- ============================================

CREATE OR REPLACE VIEW product_performance_view AS

SELECT
    StockCode,
    MAX(Description) AS Description,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    COUNT(DISTINCT CustomerID) AS Unique_Customers

FROM transactions

GROUP BY StockCode;

-- ============================================
-- COUNTRY PERFORMANCE
-- ============================================

SELECT
    Country,

    COUNT(DISTINCT CustomerID) AS Customers,

    COUNT(DISTINCT Invoice) AS Orders,

    SUM(Quantity) AS Quantity_Sold,

    ROUND(SUM(Revenue), 2) AS Revenue,

    ROUND(
        SUM(Revenue) /
        NULLIF(COUNT(DISTINCT Invoice), 0),
        2
    ) AS Average_Order_Value

FROM transactions

GROUP BY Country

ORDER BY Revenue DESC;

-- ============================================
-- PRODUCT REVENUE RANKING
-- ============================================

WITH product_sales AS (
    SELECT
        StockCode,
        MAX(Description) AS Description,
        SUM(Quantity) AS Total_Quantity,
        SUM(Revenue) AS Total_Revenue
    FROM transactions
    GROUP BY StockCode
)

SELECT
    StockCode,
    Description,
    Total_Quantity,
    ROUND(Total_Revenue, 2) AS Total_Revenue,

    RANK() OVER (
        ORDER BY Total_Revenue DESC
    ) AS Revenue_Rank

FROM product_sales

ORDER BY Revenue_Rank

LIMIT 20;

-- ============================================
-- TOP PRODUCT IN EACH COUNTRY
-- ============================================

WITH country_products AS (
    SELECT
        Country,
        StockCode,
        MAX(Description) AS Description,
        SUM(Revenue) AS Revenue
    FROM transactions
    GROUP BY Country, StockCode
),

ranked_products AS (
    SELECT
        Country,
        StockCode,
        Description,
        Revenue,

        ROW_NUMBER() OVER (
            PARTITION BY Country
            ORDER BY Revenue DESC
        ) AS Product_Rank

    FROM country_products
)

SELECT
    Country,
    StockCode,
    Description,
    ROUND(Revenue, 2) AS Revenue

FROM ranked_products

WHERE Product_Rank = 1

ORDER BY Revenue DESC;