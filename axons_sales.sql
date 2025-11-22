use alxons;
-- Total  Revenue
SELECT SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM orderdetails od;

-- Sales by Product
SELECT p.productName, SUM(od.quantityOrdered * od.priceEach) AS sales
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productName
ORDER BY sales DESC;

-- Top 5 Customers by Revenue
SELECT c.customerName, SUM(od.quantityOrdered * od.priceEach) AS total_spent
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
ORDER BY total_spent DESC
LIMIT 5;

-- Customers Who Haven’t Made a Purchase
SELECT c.customerName 
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE o.orderNumber IS NULL;

-- Customer Payment Status
SELECT c.customerName, SUM(p.amount) AS total_paid, c.creditLimit
FROM customers c
LEFT JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerName, c.creditLimit
ORDER BY total_paid DESC;

-- Sales by Employee
SELECT e.firstName, e.lastName, SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY e.firstName, e.lastName
ORDER BY total_sales DESC;

-- Sales by Office Location
SELECT o.city, SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM offices o
JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders ord ON c.customerNumber = ord.customerNumber
JOIN orderdetails od ON ord.orderNumber = od.orderNumber
GROUP BY o.city
ORDER BY total_sales DESC;

-- Top Selling customers

SELECT customerName, 
       SUM(od.quantityOrdered * od.priceEach) AS total_sales,
       RANK() OVER (ORDER BY SUM(od.quantityOrdered * od.priceEach) DESC) AS sales_rank
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY customerName;



-- Orders Pending Shipment

SELECT orderNumber, orderDate, status 
FROM orders
WHERE status NOT IN ('Shipped', 'Delivered');

-- Late Shipments
SELECT orderNumber, orderDate, requiredDate, shippedDate
FROM orders
WHERE shippedDate > requiredDate;


-- 
SELECT DATE_FORMAT(o.orderDate, '%Y-%m') AS month, 
       SUM(od.quantityOrdered * od.priceEach) AS monthly_sales,
       SUM(SUM(od.quantityOrdered * od.priceEach)) OVER (ORDER BY DATE_FORMAT(o.orderDate, '%Y-%m')) AS running_total
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY month
ORDER BY month;

-- Previous Month Sales

SELECT extract(month from o.orderDate) AS month, 
       SUM(od.quantityOrdered * od.priceEach) AS monthly_sales,
       LAG(SUM(od.quantityOrdered * od.priceEach)) OVER (ORDER BY extract(month from o.orderDate)) AS prev_month_sales
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY month
ORDER BY month;

























