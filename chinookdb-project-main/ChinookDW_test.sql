use master
go


Create database ChinookDataWarehouse;
go

use ChinookDataWarehouse;
go

create table DimCustomer (
    CustomerKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	CustomerId INT NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Company VARCHAR(50) DEFAULT 'N/A' NOT NULL,
	Address VARCHAR(50) NOT NULL,
	City VARCHAR(50)  NOT NULL,
	State VARCHAR(50)  DEFAULT 'N/A' NOT NULL,
	Country VARCHAR(50) NOT NULL,
	PostalCode VARCHAR(50) DEFAULT 'N/A' NOT NULL,
	Phone VARCHAR(50) DEFAULT 'N/A' NOT NULL,
	Fax VARCHAR(50)  DEFAULT 'N/A' NOT NULL,
	Email VARCHAR(50) NOT NULL,
	EmployeeId int NOT NULL,
	EmplLastName VARCHAR(50) NOT NULL,
	EmplFirstName VARCHAR(50) NOT NULL,
	EmplTitle VARCHAR(50) NOT NULL,
	ReportsTo int NOT NULL,
	EmplBirthDate VARCHAR(50) NOT NULL,
	EmplHireDate VARCHAR(50) NOT NULL,
	EmplAddress VARCHAR(50) NOT NULL,
	EmplCity VARCHAR(50) NOT NULL,
	EmplState VARCHAR(50) NOT NULL,
	EmplCountry VARCHAR(50) NOT NULL,
	EmplPostalCode VARCHAR(50) NOT NULL,
	EmplPhone VARCHAR(50) NOT NULL,
	EmplFax VARCHAR(50) NOT NULL,
	EmplEmail VARCHAR(50) NOT NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason VARCHAR(200) NULL
);


create table DimTrack(
  TrackKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  TrackId INT NOT NULL,
  TrackName nvarchar(200) NOT NULL,
  Composer nvarchar(220) DEFAULT 'N/A' NOT NULL,
  Milliseconds int NOT NULL,
  Bytes int NOT NULL,
  UnitPrice numeric(10,2) NOT NULL,
  GenreName nvarchar(120) NOT NULL,
  MediaTtpeName nvarchar(120) NOT NULL,
  AlbumTitle nvarchar(160) NOT NULL,
  ArtistName nvarchar(120) DEFAULT 'N/A' NOT NULL,

);

create table FactSales(
  InvoiceId INT NOT NULL,
  CustomerKey INT NOT NULL,
  TrackKey INT NOT NULL,
  InvoiceDateKey INT NOT NULL,
  TrackId INT  NOT NULL ,
  BillingAddress NVARCHAR(70) NOT NULL,
  BillingCity NVARCHAR(40) NOT NULL,
  BillingState NVARCHAR(40) DEFAULT 'N/A' NOT NULL,
  BillingCountry NVARCHAR(40) NOT NULL,
  BillingPostalCode NVARCHAR(40) DEFAULT 'N/A' NOT NULL,
  Total NUMERIC(10,2) NOT NULL,
  UnitPrice NUMERIC(10,2) NOT NULL,
  Quantity INT NOT NULL
);



INSERT INTO DimCustomer (CustomerId,FirstName ,LastName, Company, Address , City ,State ,Country ,PostalCode ,Phone ,Fax ,Email ,EmployeeId ,EmplLastName ,EmplFirstName ,EmplTitle ,ReportsTo ,EmplBirthDate,EmplHireDate,EmplAddress,EmplCity ,EmplState ,EmplCountry,EmplPostalCode ,EmplPhone,EmplFax,EmplEmail )
SELECT CustomerId, FirstName , LastName, isnull(Company,'N/A') ,Address ,City ,isnull(State,'N/A') ,Country ,isnull(PostalCode,'N/A') ,isnull(Phone,'N/A') ,isnull(Fax, 'N/A') ,Email ,EmployeeId ,EmplLastName ,EmplFirstName ,EmplTitle ,ReportsTo ,EmplBirthDate,EmplHireDate,EmplAddress,EmplCity ,EmplState ,EmplCountry,EmplPostalCode ,EmplPhone,EmplFax,EmplEmail   
FROM [ChinookStaging].dbo.Customer;
 
INSERT INTO [DimTrack] (TrackId, TrackName, Composer, Milliseconds, Bytes, UnitPrice, GenreName, MediaTtpeName, AlbumTitle,ArtistName)
SELECT TrackId, TrackName, isnull(Composer, 'N/A'), Milliseconds, Bytes, UnitPrice, GenreName, MediaTtpeName, AlbumTitle,isnull(ArtistName, 'N/A')
FROM [ChinookStaging].[dbo].[Track]




SELECT *
INTO DimDate
FROM [ChinookStaging].[dbo].[DimDate]



INSERT INTO [FactSales] (InvoiceId,CustomerKey,TrackKey,InvoiceDateKey,TrackId,BillingAddress,BillingCity,BillingState,BillingCountry,BillingPostalCode,Total,UnitPrice,Quantity)
SELECT InvoiceId,customerKey,TrackKey,DateKey,t.TrackId,BillingAddress,BillingCity,isnull(BillingState,'N/A'),BillingCountry,isnull(BillingPostalCode,'N/A'),Total,t.UnitPrice,Quantity
FROM [ChinookStaging].[dbo].[Sales] AS s
INNER JOIN [ChinookDataWarehouse].[dbo].[DimCustomer] AS c
ON s.CustomerId = c.[CustomerId] and c.RowIsCurrent=1 
INNER JOIN [ChinookDataWarehouse].[dbo].[DimTrack] AS t 
ON s.TrackId=t.TrackId
INNER JOIN [ChinookDataWarehouse].[dbo].[DimDate]AS d
ON  s.InvoiceDate= d.Date


ALTER TABLE FactSales
ADD FOREIGN KEY (CustomerKey) REFERENCES [dbo].[DimCustomer] (CustomerKey);


ALTER TABLE FactSales
ADD FOREIGN KEY (TrackKey) REFERENCES [dbo].[DimTrack](TrackKey);


ALTER TABLE DimDate
ADD PRIMARY KEY (DateKey);
go

ALTER TABLE FactSales
ADD FOREIGN KEY (InvoiceDateKey) REFERENCES [dbo].[DimDate](DateKey);


