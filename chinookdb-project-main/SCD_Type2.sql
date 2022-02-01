use ChinookStaging
go

create table [ChinookStaging].[dbo].Staging_DimCustomer (
    CustomerKey INT IDENTITY(1,1) NOT NULL,
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


INSERT INTO [ChinookStaging].[dbo].[Staging_DimCustomer] (CustomerId,FirstName ,LastName, Company, Address , City ,State ,Country ,PostalCode ,Phone ,Fax ,Email ,EmployeeId ,EmplLastName ,EmplFirstName ,EmplTitle ,ReportsTo ,EmplBirthDate,EmplHireDate,EmplAddress,EmplCity ,EmplState ,EmplCountry,EmplPostalCode ,EmplPhone,EmplFax,EmplEmail )
SELECT CustomerId, FirstName , LastName, isnull(Company,'N/A') ,Address ,City ,isnull(State,'N/A') ,Country ,isnull(PostalCode,'N/A') ,isnull(Phone,'N/A') ,isnull(Fax, 'N/A') ,Email ,EmployeeId ,EmplLastName ,EmplFirstName ,EmplTitle ,ReportsTo ,EmplBirthDate,EmplHireDate,EmplAddress,EmplCity ,EmplState ,EmplCountry,EmplPostalCode ,EmplPhone,EmplFax,EmplEmail   
FROM [ChinookStaging].dbo.Customer;









USE [ChinookDataWarehouse]
GO


INSERT INTO [ChinookDataWarehouse].[dbo].[DimCustomer] ([CustomerId],FirstName ,LastName, Company, Address , City ,State ,Country ,PostalCode ,Phone ,Fax ,Email ,EmployeeId ,EmplLastName ,EmplFirstName ,EmplTitle ,ReportsTo ,EmplBirthDate,EmplHireDate,EmplAddress,EmplCity ,EmplState ,EmplCountry,EmplPostalCode ,EmplPhone,EmplFax,EmplEmail, RowIsCurrent, RowStartDate, RowChangeReason)
SELECT       [CustomerId],
             FirstName,
             LastName,
             Company,
             Address,
             City,
             State,
             Country,
             PostalCode,
             Phone,
             Fax,
             Email,
             EmployeeId,
             EmplLastName,
             EmplFirstName,
             EmplTitle,
             ReportsTo,
             EmplBirthDate,
             EmplHireDate,
             EmplAddress,
             EmplCity,
             EmplState,
             EmplCountry,
             EmplPostalCode,
             EmplPhone,
             EmplFax,
             EmplEmail,
	         1,
             CAST(GetDate() AS Date),
	         ActionName
FROM
(
	MERGE [ChinookDataWarehouse].[dbo].[DimCustomer] AS target
		USING [ChinookStaging].[dbo].[Staging_DimCustomer] as source
		ON target.[CustomerKey] = source.[CustomerKey]
	 WHEN MATCHED 	 AND (source.[FirstName] <> target.[FirstName] OR source.[LastName] <> target.[LastName] OR source.[Company] <> target.[Company] OR source.[Address] <> target.[Address] OR source.[City]<> target.[City] OR source.[State] <> target.[State] OR source.[Country] <> target.[Country] OR source.[PostalCode] <> target.[PostalCode] OR source.[Phone] <> target.[Phone] OR source.[Fax] <> target.[Fax] OR source.[Email] <> target.[Email])  AND target.[RowIsCurrent] = 1 
	 THEN UPDATE SET
		 target.RowIsCurrent = 0,
		 target.RowEndDate = dateadd(day, -1, CAST(GetDate() AS Date)) ,
		 target.RowChangeReason = 'UPDATED NOT CURRENT'
	 WHEN NOT MATCHED THEN
	   INSERT  (
		     [CustomerId],
             FirstName,
             LastName,
             Company,
             Address,
             City,
             State,
             Country,
             PostalCode,
             Phone,
             Fax,
             Email,
             EmployeeId,
             EmplLastName,
             EmplFirstName,
             EmplTitle,
             ReportsTo,
             EmplBirthDate,
             EmplHireDate,
             EmplAddress,
             EmplCity,
             EmplState,
             EmplCountry,
             EmplPostalCode,
             EmplPhone,
             EmplFax,
             EmplEmail,
	         RowStartDate,
        	 RowChangeReason
	   )
	   VALUES( 
	    	 source.[CustomerId],
             source.FirstName,
             source.LastName,
             source.Company,
             source.Address,
             source.City,
             source.State,
             source.Country,
             source.PostalCode,
             source.Phone,
             source.Fax,
             source.Email,
             source.EmployeeId,
             source.EmplLastName,
             source.EmplFirstName,
             source.EmplTitle,
             source.ReportsTo,
             source.EmplBirthDate,
             source.EmplHireDate,
             source.EmplAddress,
             source.EmplCity,
             source.EmplState,
             source.EmplCountry,
             source.EmplPostalCode,
             source.EmplPhone,
             source.EmplFax,
             source.EmplEmail,
		     CAST(GetDate() AS Date),
		    'NEW RECORD'
	   )
	WHEN NOT MATCHED BY Source THEN
		UPDATE SET 
			Target.RowEndDate= dateadd(day, -1, CAST(GetDate() AS Date))
			,target.RowIsCurrent = 0
			,Target.RowChangeReason  = 'SOFT DELETE'
	OUTPUT 
			 source.[CustomerId],
             source.FirstName,
             source.LastName,
             source.Company,
             source.Address,
             source.City,
             source.State,
             source.Country,
             source.PostalCode,
             source.Phone,
             source.Fax,
             source.Email,
             source.EmployeeId,
             source.EmplLastName,
             source.EmplFirstName,
             source.EmplTitle,
             source.ReportsTo,
             source.EmplBirthDate,
             source.EmplHireDate,
             source.EmplAddress,
             source.EmplCity,
             source.EmplState,
             source.EmplCountry,
             source.EmplPostalCode,
             source.EmplPhone,
             source.EmplFax,
             source.EmplEmail,
		     $Action as ActionName   
) AS Mrg
WHERE Mrg.ActionName='UPDATE'
AND [CustomerId] IS NOT NULL

