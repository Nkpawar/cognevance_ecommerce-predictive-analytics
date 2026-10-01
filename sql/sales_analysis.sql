USE ecommerce_analytics;


-- ============================================
-- YEARLY SALES
-- ============================================

SELECT
    Year,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM transactions
GROUP BY Year
ORDER BY Year;


-- ============================================
-- MONTHLY SALES
-- ============================================

SELECT
    Year,
    Month,
    Month_Name,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM transactions
GROUP BY
    Year,
    Month,
    Month_Name
ORDER BY
    Year,
    Month;


-- ============================================
-- QUARTERLY SALES
-- ============================================

SELECT
    Year,
    Quarter,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM transactions
GROUP BY
    Year,
    Quarter
ORDER BY
    Year,
    Quarter;


-- ============================================
-- SALES BY COUNTRY
-- ============================================

SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM transactions
GROUP BY Country
ORDER BY Revenue DESC;


-- ============================================
-- SALES BY DAY OF WEEK
-- ============================================

SELECT
    Day_of_Week,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM transactions
GROUP BY Day_of_Week
ORDER BY Revenue DESC;

-- ============================================
-- MONTHLY REVENUE GROWTH
-- CTE + LAG WINDOW FUNCTION
-- ============================================

WITH monthly AS (
    SELECT
        Year,
        Month,
        SUM(Revenue) AS Revenue
    FROM transactions
    GROUP BY Year, Month
)

SELECT
    Year,
    Month,
    ROUND(Revenue, 2) AS Revenue,

    ROUND(
        LAG(Revenue) OVER (
            ORDER BY Year, Month
        ),
        2
    ) AS Previous_Month_Revenue,

    ROUND(
        (
            Revenue -
            LAG(Revenue) OVER (
                ORDER BY Year, Month
            )
        )
        /
        NULLIF(
            LAG(Revenue) OVER (
                ORDER BY Year, Month
            ),
            0
        )
        * 100,
        2
    ) AS Growth_Percent

FROM monthly
ORDER BY Year, Month;

-- ============================================
-- MONTHLY REVENUE RANKING
-- ============================================

WITH monthly_sales AS (
    SELECT
        Year,
        Month,
        Month_Name,
        SUM(Revenue) AS Revenue
    FROM transactions
    GROUP BY Year, Month, Month_Name
)

SELECT
    Year,
    Month,
    Month_Name,
    ROUND(Revenue, 2) AS Revenue,

    RANK() OVER (
        ORDER BY Revenue DESC
    ) AS Revenue_Rank

FROM monthly_sales

ORDER BY Revenue DESC;