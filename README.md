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

12. **Write a SQL query to find the average visibility of items with a rating of 5**:
```sql
SELECT Item_Identifier, AVG(Item_Visibility), Rating
FROM blinkit
WHERE Rating = 5
GROUP BY Item_identifier;
```

13. **Write a SQL query to get the list of outlets that were set up before 2015**:
```sql
SELECT Outlet_Identifier, Outlet_Location_Type
FROM blinkit
WHERE Outlet_Establishment_Year < 2015
GROUP BY Outlet_Identifier, Outlet_Location_Type;
```

14. **Write a SQL query to classify outlets into 'High' and 'Low' sales categories based on their total sales (threshold = 70000)**:
```sql
SELECT Outlet_Identifier, SUM(Total_Sales) AS Sales_for_each_Outlet, 
       CASE 
       WHEN SUM(Total_Sales)> 70000 THEN 'High'
       ELSE 'Low'
       END as Sales_Category
FROM blinkit
GROUP BY Outlet_Identifier;
```
15. **Write a SQL query to round the visibility of each product to 3 decimal places**:
```sql
SELECT ROUND(Item_Visibility, 3)
FROM blinkit;
GROUP BY Outlet_Identifier;
```
## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Zero Analyst

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **YouTube**: [Subscribe to my channel for tutorials and insights](https://www.youtube.com/@zero_analyst)
- **Instagram**: [Follow me for daily tips and updates](https://www.instagram.com/zero_analyst/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/najirr)
- **Discord**: [Join our community to learn and grow together](https://discord.gg/36h5f2Z5PK)

Thank you for your support, and I look forward to connecting with you!
