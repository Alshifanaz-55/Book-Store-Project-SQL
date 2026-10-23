CREATE DATABASE bookshopDB

USE bookshopDB

SELECT*FROM books

SELECT*FROM Customers

SELECT*FROM Orders

--Basic Queries 

--1) Retrieve all books in the "Fiction" genre 

SELECT
COUNT(*) AS fiction_books
FROM books
WHERE genre ='fiction'

--2) Find books published after the year 1950 

SELECT book_id,title,Author,Genre,Published_year,
ROUND(Price,2) AS Price,
stock
FROM books
WHERE published_year > 1950

--3) List all customers from the Canada 

SELECT*FROM customers
WHERE country='canada'

--4) Show orders placed in November 2023 

SELECT Order_id,customer_id,Book_id,Order_date,quantity,
ROUND(total_amount,2) AS total_amount
FROM orders
WHERE order_date BETWEEN '2023-11-1' AND '2023-11-30'

--5) Retrieve the total stock of books available 

SELECT SUM(Stock) AS Total_stock
FROM books

--6) Find the details of the most expensive book 

SELECT Book_id,title,Author,Genre,Published_year,
ROUND(price,2) AS Price,
Stock
FROM books 
WHERE Price=(SELECT MAX(Price) from Books)

--7) Show all customers who ordered more than 1 quantity of a book 

SELECT order_id,customer_id,book_id,Order_date,quantity,
ROUND(total_amount,2) AS total_amount
FROM orders
WHERE quantity> 1

--8) Retrieve all orders where the total amount exceeds $20 

SELECT order_id,Customer_id,Book_id,Order_date,Quantity,
ROUND(total_amount,2) AS total_amount
FROM orders
WHERE total_amount> 20

--9) List all genres available in the Books table 

SELECT DISTINCT genre FROM books

--10) Find the book with the lowest stock 

SELECT TOP 1 Book_id,title,Author,Genre,Published_year,
ROUND(price,2) AS Price,
stock
FROM books
WHERE Stock= ( SELECT MIN(stock) FROM books)

--11) Calculate the total revenue generated from all orders

SELECT SUM(ROUND(Total_Amount,2)) AS total_revenue
FROM orders

--ADVANCE QUESTION

SELECT * FROM Books
SELECT * FROM Orders
SELECT * FROM Customers

--1) RETRIVE THE TOTAL NO. OF BOOKS SOLD FOR EACH GENRE 

SELECT b.genre,
SUM(o.quantity) AS Total_quantity
FROM books b
JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.genre
ORDER BY Total_quantity

--2) FIND THE AVG PRICE OF BOOK IN FANTASY GENRE

SELECT ROUND(AVG(Price),2) AS Avg_price
FROM books
WHERE genre='fantasy'

--3) LIST CUSTOMERS WHO HAVE PLACED AT LEAST 2 ORDERS

SELECT o.customer_id,
c.name,
COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c
ON c.customer_id=o.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(order_id) >=2

--4) FIND THE MOST FREQUENTLY ORDERED BOOK

SELECT TOP 1
o.book_id,
b.title,
COUNT(o.order_id) AS Order_count
FROM Orders o
JOIN books b 
ON o.book_id=b.book_id
GROUP BY o.book_id,b.title
ORDER BY order_count DESC 

--5) SHOW THE TOP 3 MOST EXPENSIVE BOOK IN FANTASY GENRE

SELECT TOP 3 Book_id,title,Author,Genre,Published_year,
ROUND(price,2) AS Price,
Stock
FROM BOOKS
WHERE GENRE='FANTASY'
ORDER BY ROUND(price,2) DESC

--6) RETRIVE THE TOTAL QUANTITY OF BOOKS SOLD BY EACH AUTHOR

SELECT b.author,
SUM(o.quantity) as total_quantity 
FROM orders o
JOIN books b
on b.book_id=o.Book_id
GROUP BY Author
ORDER BY Total_quantity DESC

--7) List the cities where customers who spent over $30 are located 

SELECT DISTINCT C.city,
ROUND(o.total_amount,2) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
WHERE total_amount>30
ORDER BY ROUND(total_amount,2) DESC

--8) Find the customer who spent the most on orders 

SELECT TOP 1 
c.customer_id,
c.name,
SUM(ROUND(o.total_amount,2)) AS total_Spent
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.name
ORDER BY total_spent DESC

--9) Calculate the stock remaining after fulfilling all orders

SELECT b.book_id,b.title, b.stock, COALESCE(SUM(o.quantity),0) AS order_quantity,
b.stock, COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM books b
LEFT JOIN orders o 
ON b.book_id=o.book_id
GROUP BY b.book_id,b.title,b.stock
ORDER BY b.book_id
