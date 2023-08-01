---------------------------------------------------------------------
-- LAB 06
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- 
-- Write a SELECT statement to return columns that contain:
--  The current date and time. Use the alias currentdatetime.
--  Just the current date. Use the alias currentdate.
--  Just the current time. Use the alias currenttime.
--  Just the current year. Use the alias currentyear.
--  Just the current month number. Use the alias currentmonth.
--  Just the current day of month number. Use the alias currentday.
--  Just the current week number in the year. Use the alias currentweeknumber.
--  The name of the current month based on the currentdatetime column. Use the alias currentmonthname.
-- 
-- Execute the written statement and compare the results that you got with the desired results shown in the file 52 - Lab Exercise 1 - Task 1 Result.txt. Your results will be different because of the current date and time value.
--
-- Can you use the alias currentdatetime as the source in the second column calculation (currentdate)? Please explain.
--In SELECT all columns are computed in parallel
---------------------------------------------------------------------

SELECT
	GETDATE() AS currentdatetime
	,FORMAT(GETDATE(), 'yyyy-MM-dd') AS currentdate
	,CAST(GETDATE()AS TIME) AS currenttime
	,FORMAT(GETDATE(), 'yyyy') AS currentyear
	,FORMAT(GETDATE(), 'MM') AS currentmonth
	,FORMAT(GETDATE(), 'dd') AS currentday
	,DATEPART(WW, GETDATE()) AS currentweeknumber
	,DATENAME(MONTH, GETDATE()) AS currentmonthname

---------------------------------------------------------------------
-- Task 2
--  
-- Write December 11, 2015, as a column with a data type of date. Use the different possibilities inside the T-SQL language (cast, convert, specific function, etc.) and use the alias somedate.
---------------------------------------------------------------------

DECLARE @DateString VARCHAR(100) = 'December 11, 2015'

SELECT
	CAST(@DateString AS DATE) AS somedate
	,CONVERT(DATE, 'December 11, 2015') AS somedate
	,FORMAT(CAST(@DateString AS DATE), 'MMMM dd, yyyy') AS somedate

---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement to return columns that contain:
--  Three months from the current date and time. Use the alias threemonths.
--  Number of days between the current date and the first column (threemonths). Use the alias diffdays.
--  Number of weeks between April 4, 1992, and September 16, 2011. Use the alias diffweeks.
--  First day in the current month based on the current date and time. Use the alias firstday.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 53 - Lab Exercise 1 - Task 3 Result.txt. Some results will be different because of the current date and time value.
---------------------------------------------------------------------

SELECT
	DATEADD(MONTH, 3, GETDATE()) AS threemonths
	,DATEDIFF(DAY, GETDATE(), (SELECT DATEADD(MONTH, 3, GETDATE()))) AS diffdays
	,DATEDIFF(WEEK, 'April 4, 1992', 'September 16, 2011') AS diffweeks
	,DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1) as firstday

---------------------------------------------------------------------
-- Task 4
-- 
-- The IT department has written a T-SQL statement that creates and populates a table named Sales.Somedates. 
--
-- Execute the provided T-SQL statement.
-- 
-- Write a SELECT statement against the Sales.Somedates table and retrieve the isitdate column. Add a new column named converteddate with a new date data type value based on the column isitdate. If the column isitdate cannot be converted to a date data type for a specific row, then return a NULL. 
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 54 - Lab Exercise 1 - Task 4 Result.txt. 
-- 
-- What is the difference between the SYSDATETIME and CURRENT_TIMESTAMP functions?
--CURRENT_TIMESTAMP has less precision (ms) than SYSDATETIME
-- What is a language-neutral format for the DATE type?
--YYYYMMDD
---------------------------------------------------------------------

SET NOCOUNT ON;

DROP TABLE IF EXISTS Sales.Somedates;

CREATE TABLE Sales.Somedates (
	isitdate varchar(9)
);

INSERT INTO Sales.Somedates (isitdate) VALUES 
	('20110101'),
	('20110102'),
	('20110103X'),
	('20110104'),
	('20110105'),
	('20110106'),
	('20110107Y'),
	('20110108');

SET NOCOUNT OFF;

SELECT
	isitdate
	,TRY_CAST(isitdate AS DATE) AS converteddate
FROM Sales.Somedates;





---------------------------------------------------------------------
-- Task 5
-- 
-- copy-paste text about lab from doc file
---------------------------------------------------------------------
-- drop the table 

DROP TABLE Sales.Somedates;
