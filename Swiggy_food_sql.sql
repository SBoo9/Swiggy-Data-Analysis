CREATE DATABASE food_db;
USE food_db;
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(255),
    cuisine_type VARCHAR(100),
    location VARCHAR(100),
    contact_number VARCHAR(20)
);
INSERT INTO restaurants (restaurant_id, restaurant_name, cuisine_type, location, contact_number)
VALUES
(1, 'Restaurant A', 'Italian', 'New York', '123-456-7890'),
(2, 'Restaurant B', 'Chinese', 'San Francisco', '987-654-3210'),
(3, 'Restaurant C', 'Indian', 'Los Angeles', '555-555-5555'),
(4, 'Restaurant D', 'Mexican', 'Chicago', '111-222-3333'),
(5, 'Restaurant E', 'Japanese', 'Houston', '444-333-2222');

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    address VARCHAR(255)
);

INSERT INTO customers (customer_id, customer_name, email, phone_number, address)
VALUES
(1, 'John Doe', 'john@example.com', '111-111-1111', '123 Main St, City'),
(2, 'Jane Smith', 'jane@example.com', '222-222-2222', '456 Elm St, City'),
(3, 'Bob Johnson', 'bob@example.com', '333-333-3333', '789 Oak St, City'),
(4, 'Alice Williams', 'alice@example.com', '444-444-4444', '321 Maple St, City'),
(5, 'David Lee', 'david@example.com', '555-555-5555', '987 Pine St, City');


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

INSERT INTO orders (order_id, customer_id, restaurant_id, order_date, total_amount)
VALUES
(1, 1, 1, '2023-08-01', 50.25),
(2, 2, 4, '2023-08-02', 35.75),
(3, 3, 2, '2023-08-03', 42.50),
(4, 4, 3, '2023-08-04', 60.00),
(5, 5, 5, '2023-08-05', 25.00);


CREATE TABLE menu_items (
    item_id INT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(100),
    item_description VARCHAR(255),
    item_price DECIMAL(10, 2),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

INSERT INTO menu_items (item_id, restaurant_id, item_name, item_description, item_price)
VALUES
(1, 1, 'Pasta', 'Delicious Italian pasta', 12.99),
(2, 1, 'Pizza', 'Freshly baked pizza', 15.50),
(3, 2, 'Kung Pao Chicken', 'Spicy chicken dish', 10.75),
(4, 2, 'Chow Mein', 'Stir-fried noodles', 8.99),
(5, 3, 'Butter Chicken', 'Creamy Indian curry', 13.25),
(6, 3, 'Naan', 'Traditional Indian bread', 3.50),
(7, 4, 'Tacos', 'Authentic Mexican tacos', 9.00),
(8, 4, 'Burritos', 'Tortilla-wrapped delicacy', 7.50),
(9, 5, 'Sushi', 'Japanese delicacies', 20.00),
(10, 5, 'Ramen', 'Japanese noodle soup', 12.50);



SELECT restaurant_name,cuisine_type   #Finding restaurant_name and cuisine_type served by all restaurants
FROM resturant;

SELECT COUNT(*) FROM customers;  	#No of customers

SELECT c.customer_id, c.customer_name, c.email, c.phone_number, c.address, SUM(o.total_amount) AS total_spent
FROM customers AS c
JOIN  orders AS o ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.phone_number, c.address
ORDER BY total_spent DESC
LIMIT 5;

SELECT r.restaurant_id,r.restaurant_name,AVG(o.total_amount)    #avg order amount of each restaurant
FROM restaurants AS r
JOIN orders as o ON r.restaurant_id=o.restaurant_id
GROUP BY r.restaurant_id;

SELECT c.customer_name, COUNT(o.customer_id) AS no_of_orders #Find the customer who placed the most number of orders and display their name and total order count.
FROM customers AS c
JOIN orders as o ON c.customer_id=o.customer_id
GROUP BY o.customer_id;

SELECT * FROM menu_items
WHERE item_price>10;


SELECT c.customer_id, c.customer_name  # Customer who ordered from all 5 resturants
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.restaurant_id) = 5;

SELECT m.item_name, m.item_price, r.restaurant_name  	#Find the top 3 most expensive menu items along with their restaurant names:
FROM menu_items m
JOIN restaurants r ON m.restaurant_id = r.restaurant_id
ORDER BY m.item_price DESC
LIMIT 3;


SELECT SUM(total_amount) AS total_revenue  #Calculate the total revenue generated from orders placed on August 3, 2023:
FROM orders
WHERE order_date = '2023-08-03';

SELECT c.customer_id, c.customer_name  	#List all customers who have placed orders from more than one city:
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.location) > 1;

SELECT m.item_name, m.item_price, r.cuisine_type	#Display the menu items with the lowest prices for each cuisine type:
FROM menu_items m
JOIN restaurants r ON m.restaurant_id = r.restaurant_id
WHERE (m.item_price, r.cuisine_type) IN (
    SELECT MIN(item_price), cuisine_type
    FROM menu_items
    GROUP BY cuisine_type
);




