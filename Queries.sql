-- Monday Coffee DATA Analysis


select * from city
select * from customers
select * from products
select * from sales

--Report and data analysis

-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?

select 
city_name,
round((city_population * 0.25)/1000000,2) as consumers_in_millions,
city_rank
from city
order by 2 desc

-- Q.2 Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

SELECT 
ci.city_name,
sum(s.total) as total_revenue
FROM sales as s 
join
customers as c
on s.customer_id=c.customer_id
join
city as ci
on  ci.city_id=c.city_id
where
DATEPART(quarter, s.sale_date) = 4
and
DATEPART(year, s.sale_date) = 2023
group by ci.city_name
order by total_revenue desc


-- 3. Sales Count for Each Product
-- How many units of each coffee product have been sold?

select p.product_name,
count(s.customer_id) as total_units_sales
from products as p
left join
sales as s
on s.product_id=p.product_id
group by p.product_name
order by total_units_sales desc


-- 4. Average Sales Amount per City
-- What is the average sales amount per customer in each city?

SELECT 
ci.city_name,
sum(s.total) as total_revenue,
count(distinct s.customer_id) as total_customer,
round(sum(s.total)/count(distinct s.customer_id) ,2) average_sales
FROM sales as s 
join
customers as c
on s.customer_id=c.customer_id
join
city as ci
on  ci.city_id=c.city_id

group by ci.city_name
order by average_sales DESC



-- Q.5 City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.

with city_table as(
select 
city_name,
city_population,
round(city_population*0.25,2) as estimated_coffee_consumers
from
city
),

customer_table as(
select ci.city_name,
count(distinct c.customer_id) as unique_cx
from sales s
join customers c
on c.customer_id=s.customer_id
join city ci
on ci.city_id=c.city_id
group by ci.city_name
)

select ct.city_name,ct.estimated_coffee_consumers,cut.unique_cx
from city_table ct 
join customer_table cut
on ct.city_name=cut.city_name


-- Q6
-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?

select * from
(select
ci.city_name,
p.product_name,
count(s.sale_id) as total_orders,dense_rank() over(partition by ci.city_name order by count(s.sale_id) desc) as rnk
from sales s
join products p
on s.product_id=p.product_id
join customers c
on c.customer_id=s.customer_id
join city ci
on ci.city_id=c.city_id
group by ci.city_name,p.product_name)as t1
where rnk <=3


-- Q.7
--Customer Segmentation by City
--How many unique customers are there in each city who have purchased coffee products?

SELECT 
ci.city_name,
count(distinct c.customer_id) as unique_cx
FROM
customers as c
join
city as ci
on  ci.city_id=c.city_id
join sales s
on s.customer_id=c.customer_id
where s.product_id between 1 and 14
group by ci.city_name
order by unique_cx desc


-- -- Q.8
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer

with sales_table as(
SELECT 
ci.city_name,
sum(s.total) as total_revenue,
count(distinct s.customer_id) as total_customer,
round(sum(s.total)/count(distinct s.customer_id) ,2) average_sales
FROM sales as s 
join
customers as c
on s.customer_id=c.customer_id
join
city as ci
on  ci.city_id=c.city_id

group by ci.city_name

),
rent_table as(
select 
city_name,estimated_rent
from city
)

select rt.city_name,
rt.estimated_rent,
ct.total_customer,
ct.average_sales,
round(rt.estimated_rent/ct.total_customer,2) as average_rent

from rent_table rt
join
sales_table ct
on rt.city_name=ct.city_name
order by average_rent


--9. Monthly Sales Growt 
--Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).
--by each city

with monthly_sales as(select 
ci.city_name,
month(sale_date) as month,
year(sale_date) as year,
sum(s.total) as total_sale
from sales s
join customers c
on c.customer_id=s.customer_id
join city ci
on ci.city_id=c.city_id
group by ci.city_name,month(sale_date),year(sale_date)

),
last_month as(
select 
city_name,month,year,
total_sale as current_month,
lag(total_sale) over(partition by city_name order by year,month) as last_month_sale
from monthly_sales
)

select *,
round(((current_month-last_month_sale)/last_month_sale)*100,2) as growth_ratio
from last_month
where last_month_sale is not null


--10. Market Potential Analysis
--Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer


with sales_table as(
SELECT 
ci.city_name,
sum(s.total) as total_revenue,
count(distinct s.customer_id) as total_customer,
round(sum(s.total)/count(distinct s.customer_id) ,2) average_sales
FROM sales as s 
join
customers as c
on s.customer_id=c.customer_id
join
city as ci
on  ci.city_id=c.city_id

group by ci.city_name

),
rent_table as(
select 
city_name,estimated_rent,
cast((city_population*0.25)/1000000 as decimal(10,2)) as coffee_consumer_in_millions
from city
)

select top 3 rt.city_name,
total_revenue,
rt.estimated_rent as total_rent,
ct.total_customer,
coffee_consumer_in_millions,
ct.average_sales,
round(rt.estimated_rent/ct.total_customer,2) as average_rent

from rent_table rt
join
sales_table ct
on rt.city_name=ct.city_name
order by total_revenue desc



/*
-- Recommendation

City 1: Pune
	1. Avg rent per cx is very less,
	2. highest total revenue,
	3. avg_sale per cx is also high

City 2. Delhi
	1. Highest estimated coffee consumer which is 7.7M
	2. Highest total cx which is 68
	3. avg rent per cx 330 (still under 500)

City 3. Jaipur
	1. Highest cx no which is 69
	2. avg rent per cx is very less 156
	3. avg sale per cx is better which at 11.6k
*/





