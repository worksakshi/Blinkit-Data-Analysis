#To use the database you must first select the database.
USE dbblinkit;

#Datacleaning & Exploration.
#Total records in the table.
SELECT COUNT(*) FROM blinkit;

#Checking and removing the null values.
SELECT * FROM blinkit
WHERE 
    Item_Fat_Content IS NULL OR Item_Identifier IS NULL OR Item_Type IS NULL OR 
    Outlet_Establishment_Year IS NULL OR Outlet_Identifier IS NULL OR Outlet_Location_Type IS NULL OR 
    Outlet_Size IS NULL OR Outlet_Type IS NULL OR Item_Visibility IS NULL OR Item_Weight IS NULL
    OR Total_Sales IS NULL OR Rating IS NULL;

DELETE FROM retail_sales    
WHERE 
    Item_Fat_Content IS NULL OR Item_Identifier IS NULL OR Item_Type IS NULL OR 
    Outlet_Establishment_Year IS NULL OR Outlet_Identifier IS NULL OR Outlet_Location_Type IS NULL OR 
    Outlet_Size IS NULL OR Outlet_Type IS NULL OR Item_Visibility IS NULL OR Item_Weight IS NULL
    OR Total_Sales IS NULL OR Rating IS NULL;

#Identify the different types of fat content labels used for items in the product catalog.
SELECT DISTINCT Item_Fat_Content 
FROM blinkit;

#Standardizing the values of the Fat Content
SET SQL_SAFE_UPDATES = 0;
UPDATE blinkit
SET Item_Fat_Content = 'Regular'
WHERE Item_Fat_Content = 'reg';

UPDATE Blinkit
SET Item_Fat_Content = 'Low Fat'
WHERE Item_Fat_Content = 'low fat';

#Enabling the safe mode.
SET SQL_SAFE_UPDATES = 1;

# Business Insights
# Q1) Extract a list of all products along with their categories and respective weights for product cataloging purposes
SELECT Item_Type, Item_Weight
FROM blinkit;

# Q2) Write a SQL query to identify the different types of fat content labels used for items in the product catalog:
SELECT DISTINCT Item_Fat_Content 
FROM blinkit;

# Q3) Write a SQL query to rank all products based on total sales to identify top-performing items:
SELECT Item_Identifier, Total_Sales, 
	   RANK() OVER(ORDER BY Total_Sales DESC)
FROM blinkit;

# Q4) Write a SQL query to generate a list of heavier items (weighing over 12 units) for logistics and storage planning:
SELECT *
FROM blinkit
WHERE Item_Weight > 12.0;

# Q5) Write a SQL query to find the number of product records sold through medium-sized retail outlets:
SELECT * 
FROM blinkit
WHERE Outlet_Size = 'Medium';

# Q6) Write a SQL query to isolate all transactions involving 'Frozen Foods' or 'Canned' products for category-specific performance tracking
SELECT *
FROM blinkit
WHERE Item_Type = 'Frozen Foods' OR Item_Type = 'Canned';

# Q7) Write a SQL query to find the average total sales for each type of product we sell
SELECT Item_Type, Total_Sales,
	    avg(Total_Sales) OVER(PARTITION BY Item_Type)AS AVERAGE_TOTAL_SALE
FROM blinkit;

# Q8) Write a SQL query to identify which Outlet_Type has the highest average sales
SELECT Outlet_Type, AVG(Total_Sales) as Average_Sales
FROM blinkit
GROUP BY Outlet_Type
ORDER BY Average_Sales DESC
LIMIT 1;

# Q9) Write a SQL query to find out how many items were sold at each outlet and the total sales volume for every store location
SELECT Outlet_Identifier, COUNT(Item_Identifier) AS Item_Sold, SUM(Total_Sales) AS Total_Sales
FROM blinkit
GROUP BY Outlet_Identifier;

# Q10) Write a SQL query to find the average weight of items for each fat content category
SELECT Item_Fat_Content, AVG(Item_Weight) AS Average_Weight
FROM blinkit
GROUP BY Item_Fat_Content;

# Q11) Write a SQL query to find out how many unique products are listed in the inventory
SELECT COUNT(DISTINCT Item_Identifier) AS Unique_Products
FROM blinkit;

# Q12) Write a SQL query to identify the top 5 products that have generated the highest total sales
SELECT Item_Identifier, SUM(Total_Sales) AS Sales, 
	   RANK() OVER(ORDER BY SUM(Total_Sales) DESC) AS Sales_Rank
FROM blinkit
GROUP BY Item_Identifier
LIMIT 5;

# Q13) Write a SQL query to find the average visibility of items with a rating of 5
SELECT Item_Identifier, AVG(Item_Visibility), Rating
FROM blinkit
WHERE Rating = 5
GROUP BY Item_identifier;

# Q14) Write a SQL query to get the list of outlets that were set up before 2015
SELECT Outlet_Identifier, Outlet_Location_Type
FROM blinkit
WHERE Outlet_Establishment_Year < 2015
GROUP BY Outlet_Identifier, Outlet_Location_Type;

# Q15) Write a SQL query to classify outlets into 'High' and 'Low' sales categories based on their total sales (threshold = 70000)
SELECT Outlet_Identifier, SUM(Total_Sales) AS Sales_for_each_Outlet, 
       CASE 
       WHEN SUM(Total_Sales)> 70000 THEN 'High'
       ELSE 'Low'
       END as Sales_Category
FROM blinkit
GROUP BY Outlet_Identifier;

# Q16) Write a SQL query to round the visibility of each product to 3 decimal places
SELECT ROUND(Item_Visibility, 3)
FROM blinkit;
