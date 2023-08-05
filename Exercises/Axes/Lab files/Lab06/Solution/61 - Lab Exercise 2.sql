---------------------------------------------------------------------
-- LAB 07
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement to retrieve distinct values for the custid column from the Sales.Orders table. Filter the results to include only orders placed in February 2008.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 62 - Lab Exercise 2 - Task 1 Result.txt.
---------------------------------------------------------------------

SELECT
	DISTINCT
		O.custid
FROM Sales.Orders AS O
WHERE O.orderdate >= 'February 2008'
	AND O.orderdate < 'MARCH 2008'

-------

SELECT
	DISTINCT
		O.custid
FROM Sales.Orders AS O
WHERE O.orderdate BETWEEN 'February 2008'
	AND 'MARCH 2008'


---------------------------------------------------------------------
-- Task 2
-- 
-- Write a SELECT statement with these columns:
--  Current date and time
--  First date of the current month
--  Last date of the current month
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 63 - Lab Exercise 2 - Task 2 Result.txt. The results will differ because they rely on the current date.
---------------------------------------------------------------------

SELECT
	GETDATE()
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)-- sau CAST(GETDATE() - DAY(GETDATE()) + 1 AS DATE)
	,EOMONTH(GETDATE())
---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement against the Sales.Orders table and retrieve the orderid, custid, and orderdate columns. Filter the results to include only orders placed in the last five days of the order month.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 64 - Lab Exercise 2 - Task 3 Result.txt.
---------------------------------------------------------------------

SELECT
	orderid
	,custid
	,orderdate
FROM Sales.Orders
WHERE orderdate BETWEEN DATEADD(DAY, -4, EOMONTH(orderdate))
	AND EOMONTH(orderdate)

---------------------------------------------------------------------
-- Task 4
-- 
-- Write a SELECT statement against the Sales.Orders and Sales.OrderDetails tables and retrieve all the distinct values for the productid column. Filter the results to include only orders placed in the first 10 weeks of the year 2007.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 65 - Lab Exercise 2 - Task 4 Result.txt.
---------------------------------------------------------------------
SELECT
	DISTINCT
		productid
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD ON OD.orderid = O.orderid
WHERE orderdate BETWEEN DATEFROMPARTS(YEAR('2007'), 1, 1) 
	AND DATEADD(DAY, -2, DATEADD(WEEK, 10, '2007'))

--

SELECT
	DISTINCT
		productid
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD ON OD.orderid = O.orderid
WHERE YEAR(orderdate) = 2007
	AND DATEPART(WEEK, orderdate) <= 10