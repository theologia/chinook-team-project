
use StagingChinook


CREATE TABLE SalesID(id NVARCHAR(MAX));
CREATE TABLE SalesVersionHistory(Version BIGINT,Date DATETIME);
ALTER TABLE  FactSales ADD Version ROWVERSION;


--Initial Load

INSERT INTO SalesID(id)
SELECT [InvoiceLineId] FROM [dbo].[FactSales];

insert into SalesVersionHistory(Version, Date)
SELECT MAX(Version),GETDATE()
FROM [dbo].[FactSales];


--Incremental Load

DECLARE @PreviousLoadMax AS BIGINT= (SELECT MAX(Version)FROM [FactSales] );
INSERT INTO SalesID(id)
SELECT [InvoiceLineId] FROM FactSales WHERE Version> @PreviousLoadMax;
INSERT INTO SalesVersionHistory(Version,Date)
SELECT MAX(Version),GETDATE()
FROM FactSales;

-------------


use StagingChinook


CREATE TABLE SalesPrice(price NVARCHAR(MAX));
CREATE TABLE SalesPriceVersionHistory(Version BIGINT,Date DATETIME);


INSERT INTO SalesPrice(price)
SELECT [UnitPrice] FROM [dbo].[FactSales];

insert into SalesPriceVersionHistory(Version, Date)
SELECT MAX(Version),GETDATE()
FROM [dbo].[FactSales];

DECLARE @PreviousLoadMaxPrice AS BIGINT= (SELECT MAX(Version)FROM [FactSales] );
INSERT INTO SalesPrice(price)
SELECT [InvoiceLineId] FROM FactSales WHERE Version> @PreviousLoadMaxPrice;
INSERT INTO SalesVersionHistory(Version,Date)
SELECT MAX(Version),GETDATE()
FROM FactSales;

