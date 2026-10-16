create database Monday_coffee
use Monday_coffee

-- Creating the tables

--table 1 - City
create table city
(
city_id int primary key,
city_name varchar(50),
city_population bigint,
estimated_rent float,
city_rank int,
)

--table 2 - Customers

CREATE TABLE customers 
(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(25),
    city_id INT,
    CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
)

-- table 3 - products
CREATE TABLE products 
(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(35),
    Price float
)

-- table 4 - sales

CREATE TABLE sales
(
    sale_id INT PRIMARY KEY,
    sale_date date,
    product_id INT,
    customer_id INT,
    total FLOAT,
    rating INT,
    CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
)


