# ☕ Monday Coffee Data Analysis (SQL Project)

## 📌 Project Overview
This project delivers an end-to-end SQL analysis for **Monday Coffee**, a growing coffee chain looking to expand its footprint across major Indian cities. By analyzing sales performance, city demographics, consumer behavior, and rent overhead, this project identifies market potential and recommends the **top 3 target cities** for opening new coffee locations.

---

## 🛠️ Tools & Technologies
- **Database Engine:** Microsoft SQL Server (T-SQL)
- **Database Tool:** SQL Server Management Studio (SSMS)
- **Data Manipulation:** Advanced SQL (CTEs, Window Functions, Aggregate Functions, Multi-Table Joins)

---

## 📂 Repository Structure
```text
├── data/
│   ├── city.csv
│   ├── customers.csv
│   ├── products.csv
│   └── sales.csv
├── scripts/
│   ├── schema.sql         # Table creation & schema definitions
│   └── queries.sql        # SQL queries solving business problems
└── README.md              # Project documentation
---

```
## 📊 Database Schema

The database consists of 4 main tables connected via foreign key relationships:

1. **`city`**
   - Contains city demographics, population, rank, and estimated rent overhead.
   - **Primary Key:** `city_id`

2. **`customers`**
   - Holds customer details linked to their home city.
   - **Primary Key:** `customer_id`
   - **Foreign Key:** `city_id` (references `city.city_id`)

3. **`products`**
   - Stores product catalogue and unit prices.
   - **Primary Key:** `product_id`

4. **`sales`**
   - Tracks transaction records, purchase dates, order totals, and product ratings.
   - **Primary Key:** `sale_id`
   - **Foreign Keys:** `product_id` (references `products.product_id`), `customer_id` (references `customers.customer_id`)
  
## Based on total revenue, average spend per customer, and rent overhead, the top 3 expansion locations are:

1. **Pune 🥇**
**Why**: Lowest rent cost per customer, highest total revenue generated, and strong customer spend averages.

2. **Delhi 🥈**
**Why**: Highest target coffee market (7.7M estimated consumers), highest volume of unique buyers (68), and manageable rent-per-customer ratio (~330).

3. **Jaipur 🥉**
**Why**: Highest overall unique buyer count (69), extremely low rent per customer (156), and strong revenue potential.
