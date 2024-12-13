USE master
GO
declare @SQL varchar(1000)

select @SQL = ISNULL(@SQL,'')+' KILL '+Info+char(10) 
FROM (
select cast(spid as varchar) as Info from sysprocesses a
	join sysdatabases b on a.dbid = b.dbid
where b.name = 'TestAngajare')X

exec (@SQL)
GO

if exists (select 1 from sysdatabases where name ='TestAngajare')
DROP DATABASE TestAngajare
GO
CREATE DATABASE TestAngajare
GO
USE TestAngajare
GO
IF OBJECT_ID ('Invoice') IS NOT NULL
ALTER TABLE [dbo].[Invoice] DROP CONSTRAINT [FK_Invoice_Partner]
GO

IF OBJECT_ID ('ClientOrder') IS NOT NULL
ALTER TABLE [dbo].[ClientOrder] DROP CONSTRAINT [FK_Order_Partner]
GO

IF OBJECT_ID ('InvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[InvoiceDetail] DROP CONSTRAINT [FK_InvoiceDetail_Invoice]
GO

IF OBJECT_ID ('ClientOrderDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetail] DROP CONSTRAINT [FK_OrderDetail_Order]
GO

IF OBJECT_ID ('InvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[InvoiceDetail] DROP CONSTRAINT [FK_InvoiceDetail_Item]
GO

IF OBJECT_ID ('ClientOrderDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetail] DROP CONSTRAINT [FK_OrderDetail_Item]
GO

IF OBJECT_ID ('Discounts') IS NOT NULL
ALTER TABLE [dbo].[Discounts] DROP CONSTRAINT [FK_Discounts_Item]
GO

IF OBJECT_ID ('Discounts') IS NOT NULL
ALTER TABLE [dbo].[Discounts] DROP CONSTRAINT [FK_Discounts_Partner]
GO

IF OBJECT_ID ('InvoiceDetail') IS NOT NULL
DROP TABLE [dbo].[InvoiceDetail]
GO

IF OBJECT_ID ('InvoiceDetail') IS NULL
CREATE TABLE [dbo].[InvoiceDetail](
	[InvoiceDetailId] [int] NOT NULL,
	[InvoiceId] [int] NULL,
	[ItemId] [int] NULL,
	[Qtty] [decimal](18, 4) NULL,
	[Amount] [decimal](18, 2) NULL,
	[VAT] [decimal](18, 2) NULL,
	[VATPercent] [decimal](18, 6) NULL,
	[UnitPrice] [decimal](18, 4) NULL,
 CONSTRAINT [PK_InvoiceDetail] PRIMARY KEY CLUSTERED 
(
	[InvoiceDetailId] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

IF OBJECT_ID ('ClientOrderDetail') IS NOT NULL
DROP TABLE [dbo].[ClientOrderDetail]
GO

IF OBJECT_ID ('ClientOrderDetail') IS NULL
CREATE TABLE [dbo].[ClientOrderDetail](
	[OrderDetailId] [int] NOT NULL,
	[OrderId] [int] NULL,
	[ItemId] [int] NULL,
	[Qtty] [decimal](18, 4) NULL,
	[Amount] [decimal](18, 2) NULL,
	[VAT] [decimal](18, 2) NULL,
	[VATPercent] [decimal](18, 6) NULL,
	[UnitPrice] [decimal](18, 4) NULL,
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[OrderDetailId] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

IF OBJECT_ID ('Invoice') IS NOT NULL
DROP TABLE [dbo].[Invoice]
GO

IF OBJECT_ID ('Invoice') IS NULL
CREATE TABLE [dbo].[Invoice](
	[InvoiceId] [int] NOT NULL,
	[InvoiceNumber] [varchar](25) NULL,
	[InvoiceDate] [datetime] NULL,
	[InvoiceDueDate] [datetime] NULL,
	[PartnerId] [int] NULL,
	[TotalAmount] [decimal](18, 2) NULL,
	[VATAmount] [decimal](18, 2) NULL,
	[TotalPayment] [decimal](18, 2) NULL, 
 CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED 
(
	[InvoiceId] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

IF OBJECT_ID ('ClientOrder') IS NOT NULL
DROP TABLE [dbo].[ClientOrder]
GO

IF OBJECT_ID ('ClientOrder') IS NULL
CREATE TABLE [dbo].[ClientOrder](
	[OrderId] [int] NOT NULL,
	[OrderNumber] [varchar](25) NULL,
	[OrderDate] [datetime] NULL,
	[PartnerId] [int] NULL,
	[DeliveryAddressId] [int] NULL,
	[TotalAmount] [decimal](18, 2) NULL,
	[VATAmount] [decimal](18, 2) NULL,
	[TotalPayment] [decimal](18, 2) NULL, 
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

IF OBJECT_ID('PartnerAddress') IS NOT NULL
DROP TABLE PartnerAddress

go

IF OBJECT_ID('PartnerAddress') IS NULL
CREATE TABLE PartnerAddress(
	[PartnerAddressId] [int] NOT NULL,
	[PartnerId] [int] NOT NULL,
	[Address] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[Country] [varchar](255) NULL,
	[DefaultAddress] [bit] NOT NULL,
	CONSTRAINT PK_PartnerAddress PRIMARY KEY CLUSTERED (PartnerAddressId)
)

GO

if OBJECT_ID('ClientOrderDetailXInvoiceDetail') is not null
drop table ClientOrderDetailXInvoiceDetail

go

if OBJECT_ID('ClientOrderDetailXInvoiceDetail') is null
create table ClientOrderDetailXInvoiceDetail(
	OrderDetailId [int] NOT NULL,
	InvoiceDetailId [int] NOT NULL,
	ConsumedQtty numeric(18,2),
	TotalConsumedQtty numeric(18,2),
	RestQtty numeric(18,2)
	constraint PK_ClientOrderDetailXInvoiceDetail primary key clustered (OrderDetailId, InvoiceDetailId)
)

go

if OBJECT_ID('Discounts') is not null
drop table Discounts

go

IF OBJECT_ID('Discounts') IS NULL
CREATE TABLE Discounts(
	[DiscountId] [int] NOT NULL,
	[PartnerId] [int] not null,
	[ItemId] [int] not null,
	[DictountPercent] [numeric](18,2) NOT NULL,
	CONSTRAINT PK_Discounts PRIMARY KEY CLUSTERED (DiscountId),
	CONSTRAINT UK_Discounts UNIQUE (PartnerId, ItemId)
)
GO

IF OBJECT_ID ('Partner') IS NOT NULL
DROP TABLE [dbo].[Partner]
GO

IF OBJECT_ID ('Partner') IS  NULL

CREATE TABLE [dbo].[Partner](
	[PartnerId] [int] NOT NULL,
	[PartnerCode] [varchar](50) NULL,
	[PartnerName] [varchar](250) NULL,
	[Active] [bit] NULL,
	[PartnerType] [varchar](50) NULL,
	[DueDays] [int] null, 
 CONSTRAINT [PK_Partner] PRIMARY KEY CLUSTERED 
(
	[PartnerId] ASC
)ON [PRIMARY]
) ON [PRIMARY]

GO

IF OBJECT_ID ('Item') IS NOT NULL
DROP TABLE [dbo].[Item]
GO

IF OBJECT_ID ('Item') IS  NULL
CREATE TABLE [dbo].[Item](
	[ItemId] [int] NOT NULL,
	[ItemCode] [varchar](50) NULL,
	[ItemName] [varchar](250) NULL,
	[Active] [bit] NULL,
	[ItemType] [varchar](50) NULL,
 CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)ON [PRIMARY]
) ON [PRIMARY]

GO


IF OBJECT_ID ('Invoice') IS NOT NULL
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [FK_Invoice_Partner] FOREIGN KEY([PartnerId])
REFERENCES [dbo].[Partner] ([PartnerId])
GO

IF OBJECT_ID ('Invoice') IS NOT NULL
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [FK_Invoice_Partner]
GO

IF OBJECT_ID ('ClientOrder') IS NOT NULL
ALTER TABLE [dbo].[ClientOrder]  WITH CHECK ADD  CONSTRAINT [FK_Order_Partner] FOREIGN KEY([PartnerId])
REFERENCES [dbo].[Partner] ([PartnerId])
GO

IF OBJECT_ID ('ClientOrder') IS NOT NULL
ALTER TABLE [dbo].[ClientOrder] CHECK CONSTRAINT [FK_Order_Partner]
GO

IF OBJECT_ID ('InvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[InvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceDetail_Invoice] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice] ([InvoiceId])
GO

IF OBJECT_ID ('InvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[InvoiceDetail] CHECK CONSTRAINT [FK_InvoiceDetail_Invoice]
GO

IF OBJECT_ID ('ClientOrderDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_ClientOrderDetail_ClientOrder] FOREIGN KEY([OrderId])
REFERENCES [dbo].[ClientOrder] ([OrderId])
GO

IF OBJECT_ID ('ClientOrderDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetail] CHECK CONSTRAINT [FK_ClientOrderDetail_ClientOrder]
GO

IF OBJECT_ID ('InvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[InvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceDetail_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([ItemId])
GO

IF OBJECT_ID ('InvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[InvoiceDetail] CHECK CONSTRAINT [FK_InvoiceDetail_Item]
GO

IF OBJECT_ID ('ClientOrderDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_ClientOrderDetail_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([ItemId])
GO

IF OBJECT_ID ('ClientOrderDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetail] CHECK CONSTRAINT [FK_ClientOrderDetail_Item]
GO

IF OBJECT_ID ('Discounts') IS NOT NULL
ALTER TABLE [dbo].[Discounts]  WITH CHECK ADD  CONSTRAINT [FK_Discounts_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([ItemId])
GO

IF OBJECT_ID ('Discounts') IS NOT NULL
ALTER TABLE [dbo].[Discounts] CHECK CONSTRAINT [FK_Discounts_Item]
GO

IF OBJECT_ID ('Discounts') IS NOT NULL
ALTER TABLE [dbo].[Discounts]  WITH CHECK ADD  CONSTRAINT [FK_Discounts_Partner] FOREIGN KEY([PartnerId])
REFERENCES [dbo].[Partner] ([PartnerId])
GO

IF OBJECT_ID ('Discounts') IS NOT NULL
ALTER TABLE [dbo].[Discounts] CHECK CONSTRAINT [FK_Discounts_Partner]
GO

IF OBJECT_ID ('ClientOrderDetailXInvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetailXInvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_ClientOrderDetailXInvoiceDetail_ClientOrderDetail] FOREIGN KEY([OrderDetailId])
REFERENCES [dbo].[ClientOrderDetail] ([OrderDetailId])
GO

IF OBJECT_ID ('ClientOrderDetailXInvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetailXInvoiceDetail] CHECK CONSTRAINT [FK_ClientOrderDetailXInvoiceDetail_ClientOrderDetail]
GO

IF OBJECT_ID ('ClientOrderDetailXInvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetailXInvoiceDetail]  WITH CHECK ADD  CONSTRAINT [FK_ClientOrderDetailXInvoiceDetail_InvoiceDetail] FOREIGN KEY([InvoiceDetailId])
REFERENCES [dbo].[InvoiceDetail] ([InvoiceDetailId])
GO

IF OBJECT_ID ('ClientOrderDetailXInvoiceDetail') IS NOT NULL
ALTER TABLE [dbo].[ClientOrderDetailXInvoiceDetail] CHECK CONSTRAINT [FK_ClientOrderDetailXInvoiceDetail_InvoiceDetail]
GO

IF OBJECT_ID ('PartnerAddress') IS NOT NULL
ALTER TABLE [dbo].[PartnerAddress]  WITH CHECK ADD  CONSTRAINT [FK_PartnerAddress_Partner] FOREIGN KEY([PartnerId])
REFERENCES [dbo].[Partner] ([PartnerId])
GO

IF OBJECT_ID ('PartnerAddress') IS NOT NULL
ALTER TABLE [dbo].[PartnerAddress] CHECK CONSTRAINT [FK_PartnerAddress_Partner]
GO



USE TestAngajare
GO

DECLARE @NumarSubiect int
SET @NumarSubiect = 1

IF NOT EXISTS (select 1 from Item )
INSERT INTO Item
	(ItemId, ItemCode, ItemName, Active, ItemType)
SELECT ItemId, ItemCode, ItemName, Active, ItemType
FROM 
(
SELECT 1 ItemId, 'A1'ItemCode, 'Articol 1' ItemName,  1 Active, 'Date' ItemType UNION ALL
SELECT 2 ItemId, 'A2'ItemCode, 'Articol 2' ItemName,  1 Active, 'Internet' ItemType UNION ALL
SELECT 3 ItemId, 'A3'ItemCode, 'Articol 3' ItemName,  1 Active, 'Marfuri' ItemType UNION ALL
SELECT 4 ItemId, 'A4'ItemCode, 'Articol 4' ItemName,  0 Active, 'Date' ItemType UNION ALL
SELECT 5 ItemId, 'A5'ItemCode, 'Articol 5' ItemName,  1 Active, 'Internet' ItemType UNION ALL
SELECT 6 ItemId, 'A6'ItemCode, 'Articol 6' ItemName,  1 Active, 'Date' ItemType 
)X

IF NOT EXISTS (select 1 from Partner )
INSERT INTO Partner
	(PartnerId, PartnerCode, PartnerName, Active, PartnerType, DueDays) 
SELECT PartnerId, PartnerCode, PartnerName, Active, PartnerType, DueDays
FROM 
(
SELECT 10 PartnerId, 'Part1' PartnerCode, 'Partener 1' PartnerName, 1 Active, 'CLIENT' PartnerType, 7 DueDays UNION ALL
SELECT 12 PartnerId, 'Part2' PartnerCode, 'Partener 2' PartnerName, 1 Active, 'CLIENT' PartnerType, 10 DueDays UNION ALL
SELECT 13 PartnerId, 'Part3' PartnerCode, 'Partener 3' PartnerName, 1 Active, 'CLIENT' PartnerType, 13 DueDays UNION ALL
SELECT 14 PartnerId, 'Part4' PartnerCode, 'Partener 4' PartnerName, 1 Active, 'CLIENT' PartnerType, 10 DueDays UNION ALL
SELECT 15 PartnerId, 'Part5' PartnerCode, 'Partener 5' PartnerName, 1 Active, 'FURNIZOR' PartnerType, 31 DueDays UNION ALL
SELECT 16 PartnerId, 'Part6' PartnerCode, 'Partener 6' PartnerName, 1 Active, 'FURNIZOR' PartnerType, 10 DueDays UNION ALL
SELECT 17 PartnerId, 'Part7' PartnerCode, 'Partener 7' PartnerName, 1 Active, 'CLIENT' PartnerType, 10 DueDays UNION ALL
SELECT 20 PartnerId, 'Part8' PartnerCode, 'Partener 8' PartnerName, 1 Active, 'FURNIZOR' PartnerType, 10 DueDays  
)X

IF NOT EXISTS (select 1 from PartnerAddress)
INSERT INTO PartnerAddress
	(PartnerAddressId, PartnerId, Address, City, Country, DefaultAddress) 
SELECT PartnerAddressId, PartnerId, Address, City, Country, DefaultAddress
FROM 
(
SELECT 1 PartnerAddressId, 10 PartnerId, 'Sos. ABC, nr 13' Address, 'Bucuresti' City, 'Romania' Country, 1 DefaultAddress UNION ALL
SELECT 2 PartnerAddressId, 10 PartnerId, 'Sos. DEF, nr 50' Address, 'Bucuresti' City, 'Romania' Country, 0 DefaultAddress UNION ALL
SELECT 3 PartnerAddressId, 10 PartnerId, 'Sos. GHI, nr 20' Address, 'Bucuresti' City, 'Romania' Country, 0 DefaultAddress UNION ALL
SELECT 4 PartnerAddressId, 14 PartnerId, 'Sos. JKL, nr 84' Address, 'Bucuresti' City, 'Romania' Country, 1 DefaultAddress UNION ALL
SELECT 5 PartnerAddressId, 14 PartnerId, 'Sos. MNO, nr 45' Address, 'Bucuresti' City, 'Romania' Country, 0 DefaultAddress UNION ALL
SELECT 6 PartnerAddressId, 16 PartnerId, 'Sos. PQR, nr 47' Address, 'Bucuresti' City, 'Romania' Country, 1 DefaultAddress UNION ALL
SELECT 7 PartnerAddressId, 17 PartnerId, 'Sos. STU, nr 41' Address, 'Bucuresti' City, 'Romania' Country, 0 DefaultAddress UNION ALL
SELECT 8 PartnerAddressId, 20 PartnerId, 'Sos. VWX, nr 36' Address, 'Bucuresti' City, 'Romania' Country, 1 DefaultAddress
)X

--if not exists (select 1 from Discounts)
--insert into Discounts ()

IF NOT EXISTS (select 1 from ClientOrder )
BEGIN
IF OBJECT_ID ('tempdb..#TempClientOrder') is not null
drop table #TempClientOrder

SELECT  ROW_NUMBER() over (partition by  ItemId order by DocumentDate, PartnerId, ItemId ) OrderId, 
ROW_NUMBER() over (partition by VATPercent order by DocumentDate, PartnerId, ItemId) OrderDetailId, *
INTO #TempClientOrder
FROM (
SELECT top 1000 PartnerId, 1 Tip ,ItemId, 
	DATEADD(dd,PartnerId, cast('20200115' as datetime)) as DocumentDate,
	cast((PartnerId+ItemId)/2 as decimal(19,4)) as Qtty, 
	CAST(PartnerId*ItemId*1.18 as decimal(19,4)) UnitPrice, 
	19 as VATPercent
FROM Partner P, Item I where 1=1 
UNION ALL
SELECT top 1000 PartnerId, 2 Tip , ItemId, 
	DATEADD(dd,PartnerId, cast('20200305' as datetime)) as DocumentDate,
	CASE WHEN PartnerId in (14, 17, 20) THEN -1 ELSE 1 END * CAST((PartnerId-ItemId)/2 as decimal(19,4)) as Qtty, 
	CAST(PartnerId*ItemId*1.18 as decimal(19,4)) UnitPrice, 
	19 as VATPercent
FROM Partner P, Item I where 1=1  
UNION ALL
SELECT top 1000 PartnerId, 3 Tip , ItemId, 
	DATEADD(dd,PartnerId, cast('20200415' as datetime)) as DocumentDate,
	CASE WHEN PartnerId not in (14, 17, 20) THEN -1 ELSE 1 END * CAST((PartnerId-ItemId)/2 as decimal(19,4)) as Qtty, 
	CAST(PartnerId*ItemId*1.18 as decimal(19,4)) UnitPrice, 
	19 as VATPercent
FROM Partner P, Item I where 1=1  
UNION ALL
SELECT top 1000 PartnerId, 4 Tip , ItemId, 
	DATEADD(dd,PartnerId, cast('20200701' as datetime)) as DocumentDate,
	CAST((PartnerId-ItemId)/2 as decimal(19,4)) as Qtty, 
	CAST(PartnerId*ItemId*1.18 as decimal(19,4)) UnitPrice, 
	19 as VATPercent
FROM Partner P, Item I where 1=1  

) X
order by PartnerId, DocumentDate, ItemId
 
DELETE FROM #TempClientOrder WHERE Tip = 4 and ItemId>2

INSERT INTO ClientOrder
	(OrderId, OrderNumber, OrderDate, PartnerId)
SELECT 
	OrderId, 'OrderNo_'+cast(OrderId as varchar)OrderNumber, DocumentDate OrderDate,  PartnerId
FROM #TempClientOrder
	GROUP BY OrderId,DocumentDate,  PartnerId

INSERT INTO ClientOrderDetail	
	(OrderDetailId, OrderId, ItemId, Qtty, VATPercent, UnitPrice)
SELECT OrderDetailId, OrderId, ItemId, Qtty, VATPercent, UnitPrice
FROM #TempClientOrder
END

IF NOT EXISTS (select 1 from Item where ItemId = 7)
INSERT INTO Item
	(ItemId, ItemCode, ItemName, Active, ItemType)
SELECT ItemId, ItemCode, ItemName, Active, ItemType
FROM 
(
 SELECT 7 ItemId, 'A7'ItemCode, 'Articol 7' ItemName,  1 Active, 'Date' ItemType 
)X

UPDATE ClientOrderDetail SET Amount = Qtty * UnitPrice, VAT = (Qtty * UnitPrice) * VATPercent/100
UPDATE I
	SET I.TotalAmount = II.TotalAmount,
		I.VATAmount = II.VATAmount,
		I.TotalPayment = II.TotalAmount + II.VATAmount
FROM ClientOrder I
	JOIN (select OrderId, sum(Amount) as TotalAmount, sum(VAT) as VATAmount
		FROM ClientOrderDetail 
		GROUP BY OrderId) II on I.OrderId = II.OrderId

go

IF NOT EXISTS (select 1 from Invoice )
BEGIN
	IF OBJECT_ID ('tempdb..#TempInvoice') is not null
	drop table #TempInvoice

	create table #TempInvoice (Id int identity(1,1), InvoiceId int, InvoiceDetailId int, OrderId int, OrderDetailId int, PartnerId int, ItemId int, DocumentDate datetime, 
		Qtty numeric(18,2), UnitPrice numeric(18,2), VATPercent int)

	/*comenzi facturate total*/
	insert into #TempInvoice (OrderId, OrderDetailId, PartnerId, ItemId, DocumentDate, Qtty, UnitPrice, VATPercent)
	SELECT co.OrderId, cod.OrderDetailId, co.PartnerId, cod.ItemId, 
		DATEADD(dd,PartnerId, co.OrderDate) DocumentDate,
		cod.Qtty, 
		cod.UnitPrice, 
		cod.VATPercent
	FROM ClientOrder co
	join ClientOrderDetail cod on cod.OrderId=co.OrderId
	where co.OrderId in (select top 10 percent OrderId from ClientOrder order by PartnerId) 

	/*comenzi facturate partial ca nr de detalii*/
	insert into #TempInvoice (OrderId, OrderDetailId, PartnerId, ItemId, DocumentDate, Qtty, UnitPrice, VATPercent)
	SELECT co.OrderId, cod.OrderDetailId, co.PartnerId, cod.ItemId, 
		DATEADD(dd,PartnerId, co.OrderDate) DocumentDate,
		cod.Qtty, 
		cod.UnitPrice, 
		cod.VATPercent
	FROM ClientOrder co
	join ClientOrderDetail cod on cod.OrderId=co.OrderId
	where cod.OrderDetailId in (select top 30 percent cod.OrderDetailId from ClientOrderDetail cod
							left join #TempInvoice ti on ti.OrderDetailId=cod.OrderDetailId 
						where ti.OrderDetailId is null
						order by PartnerId) 
					
	/*comenzi facturate partial ca si cantitate*/
	insert into #TempInvoice (OrderId, OrderDetailId, PartnerId, ItemId, DocumentDate, Qtty, UnitPrice, VATPercent)
	SELECT co.OrderId, cod.OrderDetailId, co.PartnerId, cod.ItemId, 
		DATEADD(dd,PartnerId, co.OrderDate) DocumentDate,
		cast(cod.Qtty*0.7 as numeric(18,2)) Qtty, 
		cod.UnitPrice, 
		cod.VATPercent
	FROM ClientOrder co
	join ClientOrderDetail cod on cod.OrderId=co.OrderId
	where cod.OrderDetailId in (select top 30 percent cod.OrderDetailId from ClientOrderDetail cod
							left join #TempInvoice ti on ti.OrderDetailId=cod.OrderDetailId 
						where ti.OrderDetailId is null
						order by PartnerId) 

	/*facturi fara comenzi*/
	insert into #TempInvoice(PartnerId, ItemId, DocumentDate, Qtty, UnitPrice, VATPercent)
	SELECT top 50 PartnerId, ItemId, 
		DATEADD(dd,PartnerId, cast('20200419' as datetime)) as DocumentDate,
		cast((PartnerId+ItemId)/5 as decimal(19,4)) as Qtty, 
		CAST(PartnerId*ItemId*5.14 as decimal(19,4)) UnitPrice, 
		19 as VATPercent
	FROM Partner P, Item I where 1=1 

	update ti
	set ti.InvoiceDetailId=x.InvoiceDetailId,
		ti.InvoiceId=x.InvoiceId
	from #TempInvoice ti
	join (
		SELECT Id, dense_rank() over (order by DocumentDate, PartnerId) InvoiceId, 
		dense_rank() over (order by DocumentDate, PartnerId, ItemId) InvoiceDetailId
		from #TempInvoice
		) x on x.Id=ti.Id

	INSERT INTO Invoice
		(InvoiceId, InvoiceNumber, InvoiceDate, PartnerId)
	SELECT 
		InvoiceId, 'InvoiceNo_'+cast(InvoiceId as varchar)InvoiceNumber, DocumentDate InvoiceDate,  PartnerId
	FROM #TempInvoice
		GROUP BY InvoiceId,DocumentDate,  PartnerId

	INSERT INTO InvoiceDetail	
		(InvoiceDetailId, InvoiceId, ItemId, Qtty, VATPercent, UnitPrice)
	SELECT InvoiceDetailId, InvoiceId, ItemId, Qtty, VATPercent, UnitPrice
	FROM #TempInvoice


	IF NOT EXISTS (select 1 from Item where ItemId = 7)
	INSERT INTO Item
		(ItemId, ItemCode, ItemName, Active, ItemType)
	SELECT ItemId, ItemCode, ItemName, Active, ItemType
	FROM 
	(
	 SELECT 7 ItemId, 'A7'ItemCode, 'Articol 7' ItemName,  1 Active, 'Date' ItemType 
	)X

	UPDATE InvoiceDetail SET Amount = Qtty * UnitPrice, VAT = (Qtty * UnitPrice) * VATPercent/100
	UPDATE I
		SET I.TotalAmount = II.TotalAmount,
			I.VATAmount = II.VATAmount,
			I.TotalPayment = II.TotalAmount + II.VATAmount
	FROM Invoice I
		JOIN (select InvoiceId, sum(Amount) as TotalAmount, sum(VAT) as VATAmount
			FROM InvoiceDetail 
			GROUP BY InvoiceId) II on I.InvoiceId = II.InvoiceId

	insert into ClientOrderDetailXInvoiceDetail (OrderDetailId, InvoiceDetailId, ConsumedQtty)
	select OrderDetailId, InvoiceDetailId, Qtty
	from #TempInvoice
	where OrderDetailId is not null
	
end
--SELECT * FROM Item
--SELECT * FROM ItemPoints
--SELECT * FROM Partner
--SELECT * FROM Invoice
--SELECT * FROM InvoiceDetail
--SELECT * FROM InvoicePoints
