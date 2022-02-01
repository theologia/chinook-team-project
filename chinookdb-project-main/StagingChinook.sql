use master
go

create database [ChinookStaging]
go 

use [ChinookStaging]
go 


create table Customer(
  CustomerId int primary key,
  FirstName nvarchar(50),
  LastName nvarchar(50),
  Company nvarchar(50),
  Address nvarchar(50),
  City nvarchar(50),
  State nvarchar(50),
  Country nvarchar(50),
  PostalCode nvarchar(50),
  Phone nvarchar(50),
  Fax nvarchar(50),
  Email nvarchar(50),
  EmployeeId int,
  EmplLastName nvarchar(50),
  EmplFirstName nvarchar(50),
  EmplTitle nvarchar(50),
  ReportsTo int,
  EmplBirthDate date,
  EmplHireDate date,
  EmplAddress nvarchar(50),
  EmplCity nvarchar(50),
  EmplState nvarchar(50),
  EmplCountry nvarchar(50),
  EmplPostalCode nvarchar(50),
  EmplPhone nvarchar(50),
  EmplFax nvarchar(50),
  EmplEmail nvarchar(50),
);

 create table Track(
 TrackId int  primary key,
 TrackName nvarchar(200),
 Composer nvarchar(220),
 Milliseconds int,
 Bytes int,
 UnitPrice numeric(10,2),
 GenreName nvarchar(120),
 MediaTtpeName nvarchar(120),
 AlbumTitle nvarchar(160),
 ArtistName nvarchar(120)
);



create table Sales(
  InvoiceLineId int primary key,
  InvoiceId int ,
  CustomerId int,
  InvoiceDate date,
  BillingAddress nvarchar(70),
  BillingCity nvarchar(40),
  BillingState nvarchar(40),
  BillingCountry nvarchar(40),
  BillingPostalCode nvarchar(40),
  Total numeric(10,2),
  TrackId int,
  UnitPrice numeric(10,2),
  Quantity int
);




  INSERT INTO [Customer] (CustomerId, FirstName, LastName, Company, Address, City, State, Country, PostalCode, Phone, Fax, Email, EmployeeId, EmplLastName, EmplFirstName, EmplTitle, ReportsTo, EmplBirthDate, EmplHireDate, EmplAddress, EmplCity, EmplState, EmplCountry, EmplPostalCode, EmplPhone, EmplFax, EmplEmail)
  SELECT c.CustomerId, c.FirstName, c.LastName, Company, c.Address, c.City, c.State, c.Country, c.PostalCode, c.Phone, c.Fax, c.Email, e.EmployeeId, e.LastName, e.FirstName, Title, ReportsTo, BirthDate, HireDate, e.Address, e.City, e.State, e.Country, e.PostalCode, e.Phone, e.Fax, e.Email
  FROM [Chinook].[dbo].[Customer] AS c
  INNER JOIN [Chinook].[dbo].[Employee] AS e
  ON  c.[SupportRepId]=e.[EmployeeId]

 

 INSERT INTO [Track] (TrackId, TrackName, Composer, Milliseconds, Bytes, UnitPrice, GenreName, MediaTtpeName, AlbumTitle, ArtistName)
  SELECT distinct(t.TrackId), t.Name, Composer, Milliseconds, Bytes, UnitPrice, g.Name, m.Name, Title, ar.Name
  FROM [Chinook].[dbo].[Track] AS t
  INNER JOIN [Chinook].[dbo].[Genre] AS g
  ON t.[GenreId]=g.[GenreId]
  INNER JOIN [Chinook].[dbo].[MediaType] AS m
  ON t.[MediaTypeId]=m.[MediaTypeId]
  INNER JOIN [Chinook].[dbo].[Album] AS a
  ON t.[AlbumId]=a.[AlbumId]
  INNER JOIN [Chinook].[dbo].[Artist] AS ar
  ON a.ArtistId=ar.ArtistId

  


 
  INSERT INTO [Sales] (InvoiceLineId, InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total, TrackId, UnitPrice, Quantity)
  SELECT  InvoiceLineId, i.InvoiceId, CustomerId, InvoiceDate, BillingAddress, BillingCity, BillingState, BillingCountry, BillingPostalCode, Total, TrackId, UnitPrice, Quantity
  FROM [Chinook].[dbo].[Invoice] AS i
  INNER JOIN [Chinook].[dbo].[InvoiceLine] AS l
  ON i.[InvoiceId]=l.[InvoiceId]



--Creating the date dimension as a table in MSSQL
-- provides the UK and USA holidays
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date
use [ChinookStaging]
go


DECLARE @StartDate DATETIME = '2009-01-01' --Starting value of Date Range
DECLARE @EndDate DATETIME = '2013-12-22' --End Value of Date Range

--Select DATEPART(QQ , Getdate()) as DayOfMonthValue
--Select CONVERT (char(8),Getdate(),112)

--DATEPART(DW, @CurrentDate)
--Select CONVERT (char(10),Getdate(),103)
--select DATENAME(DW, '16-aug-2013') AS DayName
--select DATEPART(DW, '16-aug-2013') AS DayNumber

--select DATEPART(WW, '16-aug-2013') AS WeekOfYear


DROP TABLE if exists [dbo].[DimDate]


/**********************************************************************************/

CREATE TABLE [dbo].[DimDate]
( [DateKey] INT primary key,
[Date] DATETIME,
[FullDateGREECE] CHAR(10), -- Date in dd-MM-yyyy format
[FullDateUSA] CHAR(10),-- Date in MM-dd-yyyy format
[DayOfMonth] VARCHAR(2), -- Field will hold day number of Month
[DaySuffix] VARCHAR(4), -- Apply suffix as 1st, 2nd ,3rd etc
[DayName] VARCHAR(9), -- Contains name of the day, Sunday, Monday
[DayOfWeekUSA] CHAR(1),-- First Day Sunday=1 and Saturday=7
[DayOfWeekGREECE] CHAR(1),-- First Day Monday=1 and Sunday=7
[DayOfWeekInMonth] VARCHAR(2), --1st Monday or 2nd Monday in Month
[DayOfWeekInYear] VARCHAR(2),
[DayOfQuarter] VARCHAR(3),
[DayOfYear] VARCHAR(3),
[WeekOfMonth] VARCHAR(1),-- Week Number of Month
[WeekOfQuarter] VARCHAR(2), --Week Number of the Quarter
[WeekOfYear] VARCHAR(2),--Week Number of the Year
[Month] VARCHAR(2), --Number of the Month 1 to 12
[MonthName] VARCHAR(9),--January, February etc
[MonthOfQuarter] VARCHAR(2),-- Month Number belongs to Quarter
[Quarter] CHAR(1),
[QuarterName] VARCHAR(9),--First,Second..
[Year] CHAR(4),-- Year value of Date stored in Row
[YearName] CHAR(7), --CY 2012,CY 2013
[MonthYear] CHAR(10), --Jan-2013,Feb-2013
[MMYYYY] CHAR(6),
[FirstDayOfMonth] DATE,
[LastDayOfMonth] DATE,
[FirstDayOfQuarter] DATE,
[LastDayOfQuarter] DATE,
[FirstDayOfYear] DATE,
[LastDayOfYear] DATE,
[IsHolidayUSA] BIT,-- Flag 1=National Holiday, 0-No National Holiday
[IsWeekday] BIT,-- 0=Week End ,1=Week Day
[HolidayUSA] VARCHAR(50),--Name of Holiday in US
[IsHolidayGREECE] BIT Null, -- Flag 1=National Holiday, 0-No National Holiday
[HolidayGREECE] VARCHAR(50) Null --Name of Holiday in GREECE
)
;

/********************************************************************************************/

--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE
@DayOfWeekInMonth INT,
@DayOfWeekInYear INT,
@DayOfQuarter INT,
@WeekOfMonth INT,
@CurrentYear INT,
@CurrentMonth INT,
@CurrentQuarter INT

/*Table Data type to store the day of week count for the month and year*/
DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, QuarterCount INT, YearCount INT)

INSERT INTO @DayOfWeek VALUES (1, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (2, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (3, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (4, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (5, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (6, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (7, 0, 0, 0)

--Extract and assign part of Values from Current Date to Variable

DECLARE @CurrentDate AS DATETIME = @StartDate
SET @CurrentMonth = DATEPART(MM, @CurrentDate)
SET @CurrentYear = DATEPART(YY, @CurrentDate)
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate <= @EndDate
BEGIN
/*Begin day of week logic*/

 /*Check for Change in Month of the Current date if Month changed then
Change variable value*/
IF @CurrentMonth != DATEPART(MM, @CurrentDate)
BEGIN
UPDATE @DayOfWeek
SET MonthCount = 0
SET @CurrentMonth = DATEPART(MM, @CurrentDate)
END

 --
/* Check for Change in Quarter of the Current date if Quarter changed then change
Variable value*/

 IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
BEGIN
UPDATE @DayOfWeek
SET QuarterCount = 0
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)
END
/* Check for Change in Year of the Current date if Year changed then change
Variable value*/

 IF @CurrentYear != DATEPART(YY, @CurrentDate)
BEGIN
UPDATE @DayOfWeek
SET YearCount = 0
SET @CurrentYear = DATEPART(YY, @CurrentDate)
END
-- Set values in table data type created above from variables

 UPDATE @DayOfWeek
SET
MonthCount = MonthCount + 1,
QuarterCount = QuarterCount + 1,
YearCount = YearCount + 1
WHERE DOW = DATEPART(DW, @CurrentDate)

 SELECT
@DayOfWeekInMonth = MonthCount,
@DayOfQuarter = QuarterCount,
@DayOfWeekInYear = YearCount
FROM @DayOfWeek
WHERE DOW = DATEPART(DW, @CurrentDate)
/*End day of week logic*/

/* Populate Your Dimension Table with values*/
INSERT INTO [dbo].[DimDate]
SELECT
CONVERT (char(8),@CurrentDate,112) as DateKey,
@CurrentDate AS Date,
CONVERT (char(10),@CurrentDate,103) as FullDateGREECE,
CONVERT (char(10),@CurrentDate,101) as FullDateUSA,
DATEPART(DD, @CurrentDate) AS DayOfMonth,
--Apply Suffix values like 1st, 2nd 3rd etc..
CASE
WHEN DATEPART(DD,@CurrentDate) IN (11,12,13) THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th'
WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 1 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'st'
WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 2 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'nd'
WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 3 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'rd'
ELSE CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th'
END AS DaySuffix,
DATENAME(DW, @CurrentDate) AS DayName,
DATEPART(DW, @CurrentDate) AS DayOfWeekUSA,
-- check for day of week as Per US and change it as per UK format
CASE DATEPART(DW, @CurrentDate)
WHEN 1 THEN 7
WHEN 2 THEN 1
WHEN 3 THEN 2
WHEN 4 THEN 3
WHEN 5 THEN 4
WHEN 6 THEN 5
WHEN 7 THEN 6
END
AS DayOfWeekGREECE,
@DayOfWeekInMonth AS DayOfWeekInMonth,
@DayOfWeekInYear AS DayOfWeekInYear,
@DayOfQuarter AS DayOfQuarter,
DATEPART(DY, @CurrentDate) AS DayOfYear,
DATEPART(WW, @CurrentDate) + 1 - DATEPART(WW, CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)) + '/1/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS WeekOfMonth,
(DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0), @CurrentDate) / 7) + 1 AS WeekOfQuarter,
DATEPART(WW, @CurrentDate) AS WeekOfYear,
DATEPART(MM, @CurrentDate) AS Month,
DATENAME(MM, @CurrentDate) AS MonthName,
CASE
WHEN DATEPART(MM, @CurrentDate) IN (1, 4, 7, 10) THEN 1
WHEN DATEPART(MM, @CurrentDate) IN (2, 5, 8, 11) THEN 2
WHEN DATEPART(MM, @CurrentDate) IN (3, 6, 9, 12) THEN 3
END AS MonthOfQuarter,
DATEPART(QQ, @CurrentDate) AS Quarter,
CASE DATEPART(QQ, @CurrentDate)
WHEN 1 THEN 'First'
WHEN 2 THEN 'Second'
WHEN 3 THEN 'Third'
WHEN 4 THEN 'Fourth'
END AS QuarterName,
DATEPART(YEAR, @CurrentDate) AS Year,
'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MonthYear,
RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, @CurrentDate) - 1), @CurrentDate))) AS FirstDayOfMonth,
CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, (DATEADD(MM, 1, @CurrentDate)))), DATEADD(MM, 1, @CurrentDate)))) AS LastDayOfMonth,
DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
DATEADD(QQ, DATEDIFF(QQ, -1, @CurrentDate), -1) AS LastDayOfQuarter,
CONVERT(DATETIME, '01/01/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS FirstDayOfYear,
CONVERT(DATETIME, '12/31/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS LastDayOfYear,
NULL AS IsHolidayUSA,
CASE DATEPART(DW, @CurrentDate)
WHEN 1 THEN 0
WHEN 2 THEN 1
WHEN 3 THEN 1
WHEN 4 THEN 1
WHEN 5 THEN 1
WHEN 6 THEN 1
WHEN 7 THEN 0
END AS IsWeekday,
NULL AS HolidayUSA, Null, Null

 SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END



/*Add HOLIDAYS GREECE*/

--Πρωτοχρονιά
   UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Πρωτοχρονιά'
	   WHERE [Month] = 1 AND [DayOfMonth]  = 1

--Θεοφάνεια
  UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Θεοφάνεια'
	   WHERE [Month] = 1 AND [DayOfMonth]  = 6  

--Καθαρά Δευτέρα
    UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Καθαρά Δευτέρα'
	   WHERE ([Year] = '2009' AND [Month] = 3 AND [DayOfMonth]  =2) OR ([Year] = '2010' AND [Month] = 2 AND [DayOfMonth]  =15) OR ([Year] = '2011' AND [Month] = 3 AND [DayOfMonth]  =7) OR ([Year] = '2012' AND [Month] = 2 AND [DayOfMonth]  =27) OR ([Year] = '2013' AND [Month] = 3 AND [DayOfMonth]  = 18)

--Ευαγγελισμός της Θεοτόκου
  UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Ευαγγελισμός της Θεοτόκου'
	   WHERE [Month] = 3 AND [DayOfMonth]  =25  

--Μεγάλη Παρασκευή
    UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Μεγάλη Παρασκευή'
	   WHERE ([Year] = '2009' AND [Month] = 4 AND [DayOfMonth]  =17) OR ([Year] = '2010' AND [Month] = 4 AND [DayOfMonth]  =2) OR ([Year] = '2011' AND [Month] = 4 AND [DayOfMonth]  =22) OR ([Year] = '2012' AND [Month] = 4 AND [DayOfMonth]  =13) OR ([Year] = '2013' AND [Month] = 5 AND [DayOfMonth]  = 3)

--Μεγάλο Σάββατο
UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Μεγάλο Σάββατο'
	   WHERE ([Year] = '2009' AND [Month] = 4 AND [DayOfMonth]  =18) OR ([Year] = '2010' AND [Month] = 4 AND [DayOfMonth]  =3) OR ([Year] = '2011' AND [Month] = 4 AND [DayOfMonth]  =23) OR ([Year] = '2012' AND [Month] = 4 AND [DayOfMonth]  =14) OR ([Year] = '2013' AND [Month] = 5 AND [DayOfMonth]  = 4)

--Κυριακή του Πάσχα
    UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Κυριακή του Πάσχα'
	   WHERE ([Year] = '2009' AND [Month] = 4 AND [DayOfMonth]  =19) OR ([Year] = '2010' AND [Month] = 4 AND [DayOfMonth]  =4) OR ([Year] = '2011' AND [Month] = 4 AND [DayOfMonth]  =24) OR ([Year] = '2012' AND [Month] = 4 AND [DayOfMonth]  =15) OR ([Year] = '2013' AND [Month] = 5 AND [DayOfMonth]  = 5)

--Δευτέρα του Πάσχα
    UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Δευτέρα του Πάσχα'
	   WHERE ([Year] = '2009' AND [Month] = 4 AND [DayOfMonth]  =20) OR ([Year] = '2010' AND [Month] = 4 AND [DayOfMonth]  =5) OR ([Year] = '2011' AND [Month] = 4 AND [DayOfMonth]  =25) OR ([Year] = '2012' AND [Month] = 4 AND [DayOfMonth]  =16) OR ([Year] = '2013' AND [Month] = 5 AND [DayOfMonth]  = 6)

--Εργατική Πρωτομαγιά
  UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Εργατική Πρωτομαγιά'
	   WHERE [Month] = 5 AND [DayOfMonth]  =1

--Πεντηκοστή
    UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Πεντηκοστή'
	   WHERE ([Year] = '2009' AND [Month] = 6 AND [DayOfMonth]  =7) OR ([Year] = '2010' AND [Month] = 5 AND [DayOfMonth]  =23) OR ([Year] = '2011' AND [Month] = 6 AND [DayOfMonth]  =12) OR ([Year] = '2012' AND [Month] = 6 AND [DayOfMonth]  =3) OR ([Year] = '2013' AND [Month] = 6 AND [DayOfMonth]  = 23)

--Αγίου Πνεύματος
    UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Αγίου Πνεύματος'
	   WHERE ([Year] = '2009' AND [Month] = 6 AND [DayOfMonth]  =8) OR ([Year] = '2010' AND [Month] = 5 AND [DayOfMonth]  =24) OR ([Year] = '2011' AND [Month] = 6 AND [DayOfMonth]  =13) OR ([Year] = '2012' AND [Month] = 6 AND [DayOfMonth]  =4) OR ([Year] = '2013' AND [Month] = 6 AND [DayOfMonth]  = 24)

--Κοίμηση της Θεοτόκου
  UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Κοίμηση της Θεοτόκου'
	   WHERE [Month] = 8 AND [DayOfMonth]  =15

--Ημέρα του Όχι
  UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Ημέρα του Όχι'
	   WHERE [Month] = 10 AND [DayOfMonth]  =28

--Χριστούγεννα
UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Χριστούγεννα'
	   WHERE [Month] = 12 AND [DayOfMonth]  =25
--Σύναξη της Θεοτόκου
UPDATE [dbo].[DimDate]
       SET HolidayGREECE='Σύναξη της Θεοτόκου'
	   WHERE [Month] = 12 AND [DayOfMonth]  =26

UPDATE [dbo].[DimDate] 
	  SET IsHolidayGREECE = CASE WHEN HolidayGREECE IS NULL THEN 0 WHEN HolidayGREECE IS NOT NULL THEN 1 END 
	  
/*Add HOLIDAYS USA*/
/*THANKSGIVING - Fourth THURSDAY in November*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Thanksgiving Day'
WHERE
[Month] = 11
AND [DayOfWeekUSA] = 'Thursday'
AND DayOfWeekInMonth = 4

 /*CHRISTMAS*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Christmas Day'
WHERE [Month] = 12 AND [DayOfMonth] = 25

 /*4th of July*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Independance Day'
WHERE [Month] = 7 AND [DayOfMonth] = 4

 /*New Years Day*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'New Year''s Day'
WHERE [Month] = 1 AND [DayOfMonth] = 1

 /*Memorial Day - Last Monday in May*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Memorial Day'
FROM [dbo].[DimDate]
WHERE DateKey IN
(
SELECT
MAX(DateKey)
FROM [dbo].[DimDate]
WHERE
[MonthName] = 'May'
AND [DayOfWeekUSA] = 'Monday'
GROUP BY
[Year],
[Month]
)

 /*Labor Day - First Monday in September*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Labor Day'
FROM [dbo].[DimDate]
WHERE DateKey IN
(
SELECT
MIN(DateKey)
FROM [dbo].[DimDate]
WHERE
[MonthName] = 'September'
AND [DayOfWeekUSA] = 'Monday'
GROUP BY
[Year],
[Month]
)

 /*Valentine's Day*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Valentine''s Day'
WHERE
[Month] = 2
AND [DayOfMonth] = 14

 /*Saint Patrick's Day*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Saint Patrick''s Day'
WHERE
[Month] = 3
AND [DayOfMonth] = 17

 /*Martin Luthor King Day - Third Monday in January starting in 1983*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Martin Luthor King Jr Day'
WHERE
[Month] = 1
AND [DayOfWeekUSA] = 'Monday'
AND [Year] >= 1983
AND DayOfWeekInMonth = 3

 /*President's Day - Third Monday in February*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'President''s Day'
WHERE
[Month] = 2
AND [DayOfWeekUSA] = 'Monday'
AND DayOfWeekInMonth = 3

 /*Mother's Day - Second Sunday of May*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Mother''s Day'
WHERE
[Month] = 5
AND [DayOfWeekUSA] = 'Sunday'
AND DayOfWeekInMonth = 2

 /*Father's Day - Third Sunday of June*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Father''s Day'
WHERE
[Month] = 6
AND [DayOfWeekUSA] = 'Sunday'
AND DayOfWeekInMonth = 3

 /*Halloween 10/31*/
UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Halloween'
WHERE
[Month] = 10
AND [DayOfMonth] = 31

 /*Election Day - The first Tuesday after the first Monday in November*/
BEGIN
DECLARE @Holidays TABLE (ID INT IDENTITY(1,1), DateID int, Week TINYINT, YEAR CHAR(4), DAY CHAR(2))

 INSERT INTO @Holidays(DateID, [Year],[Day])
SELECT
DateKey,
[Year],
[DayOfMonth]
FROM [dbo].[DimDate]
WHERE
[Month] = 11
AND [DayOfWeekUSA] = 'Monday'
ORDER BY
YEAR,
DayOfMonth

 DECLARE @CNTR INT, @POS INT, @STARTYEAR INT, @ENDYEAR INT, @MINDAY INT

 SELECT
@CURRENTYEAR = MIN([Year])
, @STARTYEAR = MIN([Year])
, @ENDYEAR = MAX([Year])
FROM @Holidays

 WHILE @CURRENTYEAR <= @ENDYEAR
BEGIN
SELECT @CNTR = COUNT([Year])
FROM @Holidays
WHERE [Year] = @CURRENTYEAR

 SET @POS = 1

 WHILE @POS <= @CNTR
BEGIN
SELECT @MINDAY = MIN(DAY)
FROM @Holidays
WHERE
[Year] = @CURRENTYEAR
AND [Week] IS NULL

 UPDATE @Holidays
SET [Week] = @POS
WHERE
[Year] = @CURRENTYEAR
AND [Day] = @MINDAY

 SELECT @POS = @POS + 1
END

 SELECT @CURRENTYEAR = @CURRENTYEAR + 1
END

 UPDATE [dbo].[DimDate]
SET HolidayUSA = 'Election Day'
FROM [dbo].[DimDate] DT
JOIN @Holidays HL ON (HL.DateID + 1) = DT.DateKey
WHERE
[Week] = 1
END
UPDATE [dbo].[DimDate]
SET IsHolidayUSA = CASE WHEN HolidayUSA IS NULL THEN 0 WHEN HolidayUSA IS NOT NULL THEN 1 END

/*******************************************************************************************************************************************************/
