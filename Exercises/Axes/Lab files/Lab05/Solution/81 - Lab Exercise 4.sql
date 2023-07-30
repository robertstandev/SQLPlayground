---------------------------------------------------------------------
-- LAB 05
--
-- Exercise 4
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
--
-- Write a SELECT statement to retrieve the custid, orderid, and orderdate columns from the Sales.Orders table. Order the rows by orderdate and orderid. Retrieve the first 20 rows.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 82 - Lab Exercise 4 - Task 1 Result.txt.
---------------------------------------------------------------------

SELECT
	TOP(20)
	O.custid
	,O.orderid
	,O.orderdate
FROM Sales.Orders AS O
ORDER BY orderdate,	orderid

---------------------------------------------------------------------
-- Task 2
-- 
-- Copy the SELECT statement in task 1 and modify the OFFSET-FETCH clause to skip the first 20 rows and fetch the next 20 rows.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 83 - Lab Exercise 4 - Task 2 Result.txt. 
---------------------------------------------------------------------

SELECT
	O.custid
	,O.orderid
	,O.orderdate
FROM Sales.Orders AS O
ORDER BY orderdate,	orderid
OFFSET (20) ROWS FETCH NEXT (20) ROWS ONLY

---------------------------------------------------------------------
-- Task 3
-- 
-- You are given the parameters @pagenum for requested page number and @pagesize for requested page size. Can you work out how to write a generic form of the OFFSET-FETCH clause using those parameters? (Do not worry about not being familiar with those parameters yet.)
---------------------------------------------------------------------
DECLARE @pagenum INT = 20
DECLARE @pagesize INT = 20

SELECT
	O.custid
	,O.orderid
	,O.orderdate
FROM Sales.Orders AS O
ORDER BY orderdate,	orderid
OFFSET (@pagenum) ROWS FETCH NEXT (@pagesize) ROWS ONLY