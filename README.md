# Blinkit Data Analysis SQL Project

## Project Overview

**Project Title**: Blinkit Data Sales Analysis  
**Database**: `dbblinkit`

Performed SQL-based analysis on a retail grocery dataset involving product details, outlet information, and sales transactions. Implemented filtering, aggregation, window functions, and conditional logic to extract business insights like top-selling products, outlet performance, and sales categorization.

## Objectives

1. **Set up a retail sales database**: Create and populate a blinkit sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `dbblinkit`.
- **Table Creation**: A table named `blinkit` is created to store the sales data. The table structure includes columns for Item_Fat_Content, Item_Identifier, Item_Type, Outlet_Establishment_Year, Outlet_Identifier, Outlet_Location_Type, Outlet_Size, Outlet_Type, Item_Visibility, Item_Weight, Total_Sales, Rating. Data is imported in the MySQL Workbench and table is auto created during importing the data.
  
```sql
CREATE DATABASE dbblinkit;
```

### 2. Data Exploration & Cleaning

- **Record Count**: Retrieved total number of records in the Blinkit dataset using COUNT(*).

```sql
SELECT COUNT(*) FROM blinkit;
```

- **Null Value Check**: Checked for null values in the dataset and deleted records with missing data.
```sql
SELECT * FROM blinkit
WHERE 
    Item_Fat_Content IS NULL OR Item_Identifier IS NULL OR Item_Type IS NULL OR 
    Outlet_Establishment_Year IS NULL OR Outlet_Identifier IS NULL OR Outlet_Location_Type IS NULL OR 
    Outlet_Size IS NULL OR Outlet_Type IS NULL OR Item_Visibility IS NULL OR Item_Weight IS NULL
    OR Total_Sales IS NULL OR Rating IS NULL;

DELETE FROM blinkit    
WHERE 
    Item_Fat_Content IS NULL OR Item_Identifier IS NULL OR Item_Type IS NULL OR 
    Outlet_Establishment_Year IS NULL OR Outlet_Identifier IS NULL OR Outlet_Location_Type IS NULL OR 
    Outlet_Size IS NULL OR Outlet_Type IS NULL OR Item_Visibility IS NULL OR Item_Weight IS NULL
    OR Total_Sales IS NULL OR Rating IS NULL;
```

- **Label Standardization**: Identified inconsistent labels in Item_Fat_Content and standardized them using UPDATE statements.

  Replaced 'reg' with 'Regular'.

  Replaced 'LF' with 'Low Fat'.
  
```sql 
SET SQL_SAFE_UPDATES = 0;
UPDATE blinkit
SET Item_Fat_Content = 'Regular'
WHERE Item_Fat_Content = 'reg';

UPDATE Blinkit
SET Item_Fat_Content = 'Low Fat'
WHERE Item_Fat_Content = 'low fat';

SET SQL_SAFE_UPDATES = 1;
```

- **SQL Safe Mode**: Temporarily disabled and re-enabled SQL safe update mode for data cleaning.
```sql
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to extract a list of all products along with their categories and respective weights for product cataloging purposes**:
```sql
SELECT Item_Type, Item_Weight
FROM blinkit;
```

2. **Write a SQL query to identify the different types of fat content labels used for items in the product catalog**:
```sql
SELECT DISTINCT Item_Fat_Content 
FROM blinkit;
```

3. **Write a SQL query to rank all products based on total sales to identify top-performing items**:
```sql
SELECT Item_Identifier, Total_Sales,
       RANK() OVER(ORDER BY Total_Sales DESC)
FROM blinkit;
```

4. **Write a SQL query to generate a list of heavier items (weighing over 12 units) for logistics and storage planning.**:
```sql
SELECT *
FROM blinkit
WHERE Item_Weight > 12.0;
```

5. **Write a SQL query to find the number of product records sold through medium-sized retail outlets**:
```sql
SELECT * 
FROM blinkit
WHERE Outlet_Size = 'Medium';
```

6. **Write a SQL query to isolate all transactions involving 'Frozen Foods' or 'Canned' products for category-specific performance tracking**:
```sql
SELECT *
FROM blinkit
WHERE Item_Type = 'Frozen Foods' OR Item_Type = 'Canned';
```

7. **Write a SQL query to find the average total sales for each type of product we sell:**:
```sql
SELECT Item_Type, Total_Sales,
	    avg(Total_Sales) OVER(PARTITION BY Item_Type)AS AVERAGE_TOTAL_SALE
FROM blinkit;
```

8. **Write a SQL query to identify which Outlet_Type has the highest average sales**:
```sql
SELECT Outlet_Type, AVG(Total_Sales) as Average_Sales
FROM blinkit
GROUP BY Outlet_Type
ORDER BY Average_Sales DESC
LIMIT 1;
```

9. **Write a SQL query to find out how many items were sold at each outlet and the total sales volume for every store location**:
```sql
SELECT Outlet_Identifier, COUNT(Item_Identifier) AS Item_Sold, SUM(Total_Sales) AS Total_Sales
FROM blinkit
GROUP BY Outlet_Identifier;
```

10. **Write a SQL query to find the average weight of items for each fat content category**:
```sql
SELECT Item_Fat_Content, AVG(Item_Weight) AS Average_Weight
FROM blinkit
GROUP BY Item_Fat_Content;
```

11. **Write a SQL query to find out how many unique products are listed in the inventory**:
```sql
SELECT COUNT(DISTINCT Item_Identifier) AS Unique_Products
FROM blinkit;
```
12. **Write a SQL query to identify the top 5 products that have generated the highest total sales**:
```sql
SELECT Item_Identifier, SUM(Total_Sales) AS Sales, 
	   RANK() OVER(ORDER BY SUM(Total_Sales) DESC) AS Sales_Rank
FROM blinkit
GROUP BY Item_Identifier
LIMIT 5;
```

13. **Write a SQL query to find the average visibility of items with a rating of 5**:
```sql
SELECT Item_Identifier, AVG(Item_Visibility), Rating
FROM blinkit
WHERE Rating = 5
GROUP BY Item_identifier;
```

14. **Write a SQL query to get the list of outlets that were set up before 2015**:
```sql
SELECT Outlet_Identifier, Outlet_Location_Type
FROM blinkit
WHERE Outlet_Establishment_Year < 2015
GROUP BY Outlet_Identifier, Outlet_Location_Type;
```

15. **Write a SQL query to classify outlets into 'High' and 'Low' sales categories based on their total sales (threshold = 70000)**:
```sql
SELECT Outlet_Identifier, SUM(Total_Sales) AS Sales_for_each_Outlet, 
       CASE 
       WHEN SUM(Total_Sales)> 70000 THEN 'High'
       ELSE 'Low'
       END as Sales_Category
FROM blinkit
GROUP BY Outlet_Identifier;
```
16. **Write a SQL query to round the visibility of each product to 3 decimal places**:
```sql
SELECT ROUND(Item_Visibility, 3)
FROM blinkit;
GROUP BY Outlet_Identifier;
```
## Findings

- **Product Diversity**: The dataset includes a wide range of products with various fat content types, weights, and categories such as Frozen Foods, Canned Goods, and Dairy, reflecting 
  Blinkit’s diverse product catalog.
- **High-Selling Products**: Ranking items based on total sales helped identify top-performing products, which are key for inventory planning and promotional strategies.
- **Outlet Performance**: Analysis showed differences in total sales and product volumes across outlet types and sizes. Medium-sized and older outlets played a significant role in 
  overall sales contributions.
- **Outlet Classification**: Outlets were successfully categorized into High and Low sales groups based on total sales volume, helping evaluate outlet-level efficiency.

## Reports

- **Sales Summary Report**: A detailed breakdown of total sales, top-selling products, and average sales per outlet, offering a snapshot of Blinkit's performance.
- **Product Insights Report**: Includes insights on item weight, visibility, and fat content, helping with product categorization and shelf space planning.
- **Outlet Analysis Report**: Provides data on outlet-wise sales, establishment years, and sales-based classification, useful for strategic expansion and resource allocation.

## Conclusion

This SQL-based project on the Blinkit dataset demonstrates the effective use of data cleaning, exploration, and business-focused querying to derive actionable insights. By analyzing product attributes, outlet performance, and sales trends, this project supports strategic decision-making for inventory management, outlet optimization, and marketing. It also reinforces key SQL concepts such as aggregation, window functions, and conditional logic, making it a strong foundation for real-world data analysis in retail.

Thank you and I look forward to connecting with you!
You can reach out to me at work.sakshijadhav@gmail.com
