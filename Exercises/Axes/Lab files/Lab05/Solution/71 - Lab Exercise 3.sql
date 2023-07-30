---------------------------------------------------------------------
-- LAB 05
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- 
-- Write a SELECT statement against the Sales.Orders table and retrieve the orderid and orderdate columns. 
-- Retrieve the 20 most recent orders, ordered by orderdate.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 72 - Lab Exercise 3 - Task 1 Result.txt.
---------------------------------------------------------------------

SELECT
	TOP(20)
	orderid
	,orderdate
FROM Sales.Orders
ORDER BY orderdate DESC

---------------------------------------------------------------------
-- Task 2
-- 
-- Write a SELECT statement to retrieve the same result as in task 1, but use the OFFSET-FETCH clause.
--
-- Execute the written statement and compare the results that you got with the results from task 1.
---------------------------------------------------------------------

SELECT
	orderid
	,orderdate
FROM Sales.Orders
ORDER BY orderdate DESC
OFFSET (0) ROWS FETCH NEXT (20) ROWS ONLY

---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement to retrieve the productname and unitprice columns from the Production.Products table.
--
-- Execute the T-SQL statement and notice the number of the rows returned.
-- 
-- Modify the SELECT statement to include only the top 10 percent of products based on unitprice ordering.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 73 - Lab Exercise 3 - Task 2 Result.txt. Notice the number of rows returned.
--
-- Is it possible to implement this task with the OFFSET-FETCH clause?
---------------------------------------------------------------------

SELECT
	TOP 10 PERCENT
	productname
	,unitprice
FROM Production.Products
ORDER BY unitprice DESC

SELECT
	productname
	,unitprice
FROM Production.Products
ORDER BY unitprice DESC
OFFSET (0) ROWS FETCH NEXT (SELECT CAST(CEILING((COUNT(*) * 10.0/100.0)) as int) FROM Production.Products) ROWS ONLY


