SELECT * FROM sales_data_staging;

SELECT
    SUM(Sales) as Total_Sales,
    SUM(Profit) as Total_Profit,
    SUM(Quantity) as Total_Quantity,
    COUNT(DISTINCT Order_ID) as Total_Order,
    AVG(Sales) as Avg_order_Value,
    (SUM(Profit) / SUM(Sales)) * 100 as Profit_Margin
FROM 
    sales_data_staging;

SELECT 
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Order
FROM
    sales_data_staging
GROUP BY Month
ORDER BY Month ASC;

SELECT
    Category,
    SUM(Sales) as Total_Sales,
    SUM(Profit) as Total_Profit,
    SUM(Quantity) as Total_Quantity,
    COUNT(DISTINCT Order_ID) as Total_Orders,
    (SUM(Profit) / SUM(Sales)) * 100 as Profit_Margin
FROM
    sales_data_staging
GROUP BY Category
ORDER BY Total_Sales DESC;

SELECT
    Customer_ID,
    Customer_Name,
    SUM(Sales) as Total_Sales,
    SUM(Profit) as Total_Profit,
    COUNT(DISTINCT Order_ID) as Total_Orders,
    (SUM(Profit) / SUM(Sales)) * 100 as Profit_Margin
FROM 
    sales_data_staging
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

WITH Customer_Sales as(
    SELECT
        Customer_Name,
        Customer_ID,
        SUM(Sales) as Total_Sales
    FROM
        sales_data_staging
    GROUP BY Customer_Name , Customer_ID
)

SELECT
	Customer_Name,
    Customer_ID,
    Total_Sales,
    RANK() OVER(ORDER BY Total_Sales DESC) as Sales_Rank
FROM
    Customer_Sales
ORDER BY Sales_Rank;

SELECT
    Region,
    SUM(Sales) as Total_Sales,
    SUM(Profit) as Total_Profit,
    COUNT(DISTINCT Order_ID) as Total_Orders,
    (SUM(Profit) / SUM(Sales)) * 100 as Profit_Margin
FROM 
    sales_data_staging
GROUP BY Region
ORDER BY Total_Sales DESC;

SELECT
    Product_ID,
    Product_Name,
    Category,
    SUM(Sales) as Total_Sales,
    SUM(Profit) as Total_Profit,
    (SUM(Profit) / SUM(Sales)) * 100 as Profit_Margin
FROM
    sales_data_staging
Group by Product_ID,Product_Name,Category
ORDER BY Total_Sales DESC
LIMIT 5;

WITH Rank_Analysis as(
    SELECT
        Product_ID,
        Product_Name,
        Category,
        SUM(Sales) as Total_Sales
	FROM
        sales_data_staging
	GROUP BY Product_ID,Product_Name,Category
)

SELECT
    Product_ID,
    Product_Name,
    Category,
    Total_Sales,
    RANK() OVER(PARTITION BY Category ORDER BY Total_Sales DESC) as Product_Rank
FROM Rank_Analysis
ORDER BY Category , Product_Rank ASC;

WITH Product_Sales as(
    SELECT
        Product_ID,
        Product_Name,
        Category,
        SUM(Sales) as Total_Sales
	FROM sales_data_staging
    GROUP BY Product_ID,Product_Name,Category
),
Ranked_Product as (
    SELECT
        Product_ID,
        Product_Name,
        Category,
        Total_Sales,
        RANK() OVER(PARTITION BY Category ORDER BY Total_Sales) as Product_Rank
	FROM Product_Sales
)
SELECT * 
FROM 
    Ranked_Product
WHERE Product_Rank <= 2
ORDER BY Category , Product_Rank;

SELECT
    Customer_ID,
    Customer_Name,
    SUM(Sales) as Total_Sales
FROM sales_data_staging
GROUP BY CustomerID , Customer_Name
Having
    SUM(Sales)>(
        SELECT
            AVG(Customer_Total)
		FROM(
            SELECT
                Customer_ID,
                SUM(Sales) as Customer_Total
			FROM sales_data_staging
            GROUP BY Customer_ID
		) as Customer_Sales
)ORDER BY Total_Sales DESC;

SELECT
    MONTH(Order_Date) as Month_Number,
    MONTHNAME(Order_Date) as Month_Name,
    SUM(Sales) as Total_Sales,
    SUM(Profit) as Total_Profit
FROM sales_data_staging
GROUP BY MONTH(Order_Date) , MONTHNAME(Order_Date)
ORDER BY Month_Number;

SELECT
    Region,
    Category,
    SUM(Sales) as Total_Sales,
    SUM(Profit) as Total_profit,
    COUNT(DISTINCT Order_ID) as Total_Orders,
    (SUM(Profit) / SUM(Sales))* 100 as Profit_Margin
FROM
    sales_data_staging
GROUP BY Region, Category
ORDER BY Total_Sales DESC;

WITH Product_Sales as(
    SELECT
        Product_ID,
        Product_Name,
        Category,
        SUM(Sales) as Total_Sales
	FROM sales_data_staging
    GROUP BY Product_ID , Product_Name , Category
),

Ranked_Product As(
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY Category
    ORDER BY Total_Sales) as rn
    FROM Product_Sales
)

SELECT
    Product_ID,
    Product_Name,
    Category,
    Total_Sales
FROM Ranked_Product
WHERE rn = 1;

WITH Customer_Analysis as (
    SELECT
        Customer_ID ,
        Customer_Name,
        SUM(Sales) as Total_Sales,
        SUM(Profit) as Total_Profit
	FROM sales_data_staging
    GROUP BY Customer_ID , Customer_Name
)
SELECT
    Customer_ID,
    Customer_Name,
    Total_Sales,
    Total_Profit,
    RANK() OVER(ORDER BY Total_Sales DESC) as Sales_Rank
FROM Customer_Analysis
ORDER BY Sales_Rank;


SELECT
    Sales_Channel,
    Segment,
    SUM(Sales) as Total_Sales,
    SUM(Profit) as Total_Profit,
    COUNT(DISTINCT Order_Id) as Total_Orders
FROM sales_data_staging
GROUP BY Sales_Channel  , Segment
ORDER BY Sales_Channel , Segment DESC;

SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    (SUM(Profit) / SUM(Sales)) * 100 AS Profit_Margin,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM Sales_Data_Staging
GROUP BY Category
ORDER BY Profit_Margin DESC;
    