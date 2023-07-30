---------------------------------------------------------------------
-- LAB 03
--
-- Exercise 4
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- Write a SELECT statement to display the categoryid and productname columns from the Production.Products table.
---------------------------------------------------------------------

SELECT
	categoryid
	,productname
FROM Production.Products

---------------------------------------------------------------------
-- Task 2
-- Enhance the SELECT statement in task 1 by adding a CASE expression that generates a result column named categoryname. The new column should hold the translation of the category ID to its respective category name, based on the mapping table supplied earlier. Use the value “Other” for any category IDs not found in the mapping table.
---------------------------------------------------------------------

SELECT
	Prod.categoryid
	,Prod.productname
	,CASE
		WHEN Prod.categoryid = '1' THEN Categ.categoryname
		WHEN Prod.categoryid = '2' THEN Categ.categoryname
		WHEN Prod.categoryid = '3' THEN Categ.categoryname
		WHEN Prod.categoryid = '4' THEN Categ.categoryname
		WHEN Prod.categoryid = '5' THEN Categ.categoryname
		WHEN Prod.categoryid = '6' THEN Categ.categoryname
		WHEN Prod.categoryid = '7' THEN Categ.categoryname
		WHEN Prod.categoryid = '8' THEN Categ.categoryname
		ELSE 'Other'
	END AS categoryname
FROM Production.Products AS Prod
	LEFT JOIN Production.Categories AS Categ WITH(NOLOCK) ON Categ.categoryid = Prod.categoryid 

---------------------------------------------------------------------
-- Task 3
-- Modify the SELECT statement in task 2 by adding a new column named iscampaign. This will show the description “Campaign Products” for the categories Beverages, Produce, and Seafood and the description “Non-Campaign Products” for all other categories.
---------------------------------------------------------------------
SELECT
	Prod.categoryid
	,Prod.productname
	,CASE
		WHEN Prod.categoryid = '1' THEN Categ.categoryname
		WHEN Prod.categoryid = '2' THEN Categ.categoryname
		WHEN Prod.categoryid = '3' THEN Categ.categoryname
		WHEN Prod.categoryid = '4' THEN Categ.categoryname
		WHEN Prod.categoryid = '5' THEN Categ.categoryname
		WHEN Prod.categoryid = '6' THEN Categ.categoryname
		WHEN Prod.categoryid = '7' THEN Categ.categoryname
		WHEN Prod.categoryid = '8' THEN Categ.categoryname
		ELSE 'Other'
	END AS categoryname
	,CASE
		WHEN Categ.categoryname = 'Produce' THEN 'Campaign Products'
		WHEN Categ.categoryname = 'Seafood' THEN 'Campaign Products'
		WHEN Categ.categoryname = 'Beverages' THEN 'Campaign Products'
		ELSE 'Non-Campaign Products'
	END AS iscampaign
FROM Production.Products AS Prod
	LEFT JOIN Production.Categories AS Categ WITH(NOLOCK) ON Categ.categoryid = Prod.categoryid 