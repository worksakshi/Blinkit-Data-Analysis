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

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```sql
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
SET SQL_SAFE_UPDATES = 1;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
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
