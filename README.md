# dannys-diner-sql-analysis
SQL analysis of Danny's Diner customer, sales, and menu data using joins, aggregations, window functions, and conditional logic to uncover customer spending, purchasing behaviour, membership activity, and loyalty points.
# 🍽️ Danny's Diner — SQL Customer & Sales Analysis

## 📌 Project Overview

This project analyses customer purchasing behaviour at **Danny's Diner** using SQL.

The restaurant has three main datasets containing information about customers, menu items, and sales transactions. The objective of this analysis is to understand customer spending patterns, purchasing preferences, restaurant visits, membership behaviour, and loyalty points.

Using **MySQL**, I answered a series of business questions by combining multiple tables and applying SQL techniques such as joins, aggregation, subqueries, Common Table Expressions, and window functions.

The analysis helps demonstrate how SQL can be used to transform transactional data into meaningful business insights.

---

## 🎯 Project Objectives

The main objectives of this project were to:

* Calculate the total amount spent by each customer.
* Determine how frequently each customer visited the restaurant.
* Identify each customer's first menu purchase.
* Find the restaurant's most purchased menu item.
* Identify the most popular item for each customer.
* Analyse purchases before and after membership.
* Calculate customer spending before joining the membership program.
* Calculate loyalty points earned by customers.
* Apply special loyalty-point rules for customers during their first week of membership.

---

# 🗃️ Database Structure

The project uses three main tables:

### `customer`

Contains information about restaurant customers and their membership dates.

| Column        | Description                                     |
| ------------- | ----------------------------------------------- |
| `customer_id` | Unique customer identifier                      |
| `join_date`   | Date the customer joined the membership program |

---

### `menu`

Contains information about the restaurant's menu items.

| Column         | Description                 |
| -------------- | --------------------------- |
| `product_id`   | Unique menu item identifier |
| `product_name` | Name of the menu item       |
| `price`        | Price of the menu item      |

---

### `sales`

Contains customer purchase transactions.

| Column        | Description                    |
| ------------- | ------------------------------ |
| `customer_id` | Customer who made the purchase |
| `order_date`  | Date of purchase               |
| `product_id`  | Menu item purchased            |

---

# 🛠️ Tools & Technologies

* **MySQL**
* SQL
* MySQL Workbench

### SQL Concepts Used

* `SELECT`
* `FROM`
* `WHERE`
* `JOIN`
* `INNER JOIN`
* `GROUP BY`
* `ORDER BY`
* `LIMIT`
* `COUNT()`
* `COUNT(DISTINCT)`
* `SUM()`
* `CASE WHEN`
* Subqueries
* Window Functions
* `ROW_NUMBER()`
* `RANK()`
* `PARTITION BY`
* `DATE_ADD()`
* Date filtering
* Conditional aggregation

---

# 🔍 Business Questions & Analysis

## Q1. What is the total amount each customer spent at the restaurant?

The `sales` table was joined with the `menu` table to obtain the price of each purchased item.

The total spending for each customer was then calculated using:

```sql
SUM(price)
```

and grouped by customer.

### Purpose

This identifies the highest and lowest spending customers and provides an overview of customer value.

---

## Q2. How many days has each customer visited the restaurant?

The analysis counted the number of unique dates on which each customer made a purchase.

```sql
COUNT(DISTINCT order_date)
```

was used to ensure multiple purchases made on the same day were counted as a single visit day.

### Purpose

This helps measure customer visit frequency and engagement.

---

## Q3. What was the first item purchased by each customer?

A `ROW_NUMBER()` window function was used to rank each customer's purchases chronologically.

```sql
ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY order_date
)
```

The first-ranked record was then selected.

### Purpose

This identifies each customer's first interaction with the restaurant's menu.

---

## Q4. What is the most purchased item on the menu?

The number of purchases for each menu item was calculated using:

```sql
COUNT(order_date)
```

The results were sorted in descending order and the top item was selected.

### Purpose

This identifies the restaurant's most popular menu item overall.

---

## Q5. Which item was the most popular for each customer?

The analysis used `RANK()` with `PARTITION BY` to rank menu items separately for every customer.

```sql
RANK() OVER (
    PARTITION BY customer_id
    ORDER BY COUNT(order_date) DESC
)
```

The items ranked number one were then selected.

### Purpose

This identifies individual customer preferences and allows the restaurant to understand what each customer purchases most frequently.

---

## Q6. Which item was purchased first after the customer became a member?

Customer purchase dates were compared with each customer's membership `join_date`.

Only purchases made on or after the membership date were considered.

`ROW_NUMBER()` was then used to identify the first purchase after joining.

### Purpose

This helps understand how customers behave immediately after becoming members.

---

## Q7. Which item was purchased just before the customer became a member?

Purchases made before the customer's membership date were filtered.

The purchases were then ordered from most recent to oldest, allowing the most recent purchase before membership to be identified.

### Purpose

This helps compare customer behaviour immediately before joining the loyalty program.

---

## Q8. What is the total number of items and amount spent before becoming a member?

Purchases made before the membership date were filtered and then aggregated.

The analysis calculated:

* Total items purchased
* Total amount spent

### Purpose

This provides a baseline for comparing customer behaviour before and after membership.

---

## Q9. How many loyalty points would each customer have?

The loyalty program awards:

* **10 points for every $1 spent**
* **Sushi earns 2× points**

A `CASE` statement was used to apply the different point rules.

```sql
CASE
    WHEN product_name = 'sushi'
        THEN price * 20
    ELSE price * 10
END
```

### Purpose

This calculates the loyalty points accumulated by each customer based on their purchases.

---

## Q10. How many points did customers A and B have at the end of January?

The final analysis introduced an additional membership rule:

> During the first week after joining the program, customers earn 2× points on all items.

The analysis therefore considered:

* The customer's membership date
* The first seven days of membership
* Sushi's existing 2× multiplier
* Purchases made up to January 31, 2021
* Customers A and B

`DATE_ADD()` was used to determine the end of the first membership week.

---

# 🧠 Key SQL Techniques

## 1. JOIN

Joins were used to combine information from the three related tables.

For example:

```sql
FROM sales AS s
JOIN menu AS m
    ON s.product_id = m.product_id
```

This allowed sales transactions to be connected to menu prices and product names.

---

## 2. GROUP BY

`GROUP BY` was used to calculate customer-level and product-level metrics.

Examples include:

```sql
GROUP BY customer_id
```

and:

```sql
GROUP BY customer_id, product_name
```

---

## 3. Window Functions

Window functions were an important part of the project.

### `ROW_NUMBER()`

Used to identify the first or most recent purchase for each customer.

### `RANK()`

Used to rank products based on purchase frequency for each customer.

### `PARTITION BY`

Used to restart the ranking for every customer.

For example:

```sql
RANK() OVER (
    PARTITION BY customer_id
    ORDER BY COUNT(order_date) DESC
)
```

This means:

> Rank each customer's products separately based on how often they purchased them.

---

## 4. CASE Statements

`CASE` statements were used to apply business rules.

For example, loyalty points were calculated differently for sushi:

```sql
CASE
    WHEN product_name = 'sushi'
        THEN price * 20
    ELSE price * 10
END
```

This demonstrates how SQL can translate business rules into calculations.

---

# 💡 Key Insights

The analysis provides several useful business insights.

### 1. Customer spending varies

The total-spending analysis makes it possible to identify customers who contribute the most revenue to the restaurant.

These customers could be considered high-value customers and targeted with personalised promotions.

### 2. Visit frequency indicates customer engagement

Counting distinct visit days helps identify frequent customers and customers who visit less often.

This information could support customer-retention strategies.

### 3. Customers have different menu preferences

The customer-level popularity analysis shows that customers do not necessarily prefer the same menu items.

Understanding these preferences can help the restaurant create personalised offers.

### 4. Popular products can guide menu decisions

Identifying the most purchased menu item provides useful information for inventory planning, promotions, and menu management.

### 5. Membership can change customer behaviour

Comparing purchases before and after membership provides an opportunity to understand whether joining the loyalty program influences customer purchasing behaviour.

### 6. Loyalty points can encourage repeat purchases

The points system rewards customers for spending, while additional multipliers provide incentives to purchase specific products such as sushi and to engage with the program shortly after joining.

---

# 📊 Business Recommendations

Based on the analysis, Danny's Diner could:

### 1. Reward high-value customers

Customers with high total spending could receive exclusive offers or personalised rewards.

### 2. Target infrequent customers

Customers with fewer visit days could receive promotions designed to encourage repeat visits.

### 3. Promote popular menu items

The most frequently purchased products could receive strategic promotion while ensuring sufficient inventory.

### 4. Use personalised recommendations

Customer-specific purchase preferences can be used to recommend menu items and create targeted promotions.

### 5. Analyse membership effectiveness

The restaurant can compare spending and visit frequency before and after membership to determine whether the loyalty program is driving customer engagement.

### 6. Use loyalty points strategically

Special point multipliers can be used to encourage customers to join the program, return after joining, or purchase selected products.

---

# 📈 Analysis Workflow

The project followed this workflow:

```text
Raw Restaurant Data
        ↓
Explore Database Tables
        ↓
Understand Table Relationships
        ↓
Join Customer, Sales & Menu Tables
        ↓
Calculate Customer Spending
        ↓
Analyse Visit Frequency
        ↓
Analyse Product Preferences
        ↓
Analyse Membership Behaviour
        ↓
Calculate Loyalty Points
        ↓
Generate Business Insights
        ↓
Develop Recommendations
```

---

# 📁 Project Structure

```text
dannys-diner-sql-analysis/
│
├── README.md
│
└── sql/
    └── dannys_diner_analysis.sql
```

---

# 🎓 Skills Demonstrated

Through this project, I demonstrated my ability to:

* Query relational databases using SQL.
* Join multiple tables using primary and foreign keys.
* Aggregate transactional data.
* Analyse customer spending behaviour.
* Calculate unique customer visits.
* Use window functions for ranking and sequencing.
* Use `ROW_NUMBER()` to identify first and latest transactions.
* Use `RANK()` to identify top products for individual customers.
* Apply business rules using `CASE`.
* Work with dates using `DATE_ADD()`.
* Analyse customer behaviour before and after membership.
* Calculate loyalty rewards.
* Translate business questions into SQL queries.
* Turn SQL analysis into business recommendations.

---

# 🚀 Future Improvements

The project could be extended by:

* Building a **Power BI dashboard** for customer and sales analysis.
* Creating customer segments based on spending and visit frequency.
* Calculating customer lifetime value.
* Analysing monthly revenue trends.
* Comparing member and non-member spending.
* Creating a customer loyalty dashboard.
* Identifying customers at risk of becoming inactive.
* Analysing product combinations and purchase patterns.
* Creating automated customer reports.

---

# 📌 Conclusion

This project demonstrates how SQL can be used to analyse restaurant transactions and turn raw customer and sales data into actionable business insights.

By combining customer, menu, and sales information, the analysis provides a clearer understanding of:

* Customer spending
* Visit frequency
* Product popularity
* Individual customer preferences
* Membership behaviour
* Loyalty points

The project also demonstrates the importance of **window functions, joins, aggregation, conditional logic, and date functions** when solving real-world business problems with SQL.

The overall goal is not only to answer SQL questions but to use data to help a business make better decisions about **customers, products, loyalty programs, and revenue**.

**Skills:** SQL | Python | Excel | Power BI | Data Analysis

---

## ⭐ Project Focus

**SQL • Customer Analytics • Sales Analysis • Restaurant Analytics • Data Analysis • Window Functions • Business Intelligence**
