CREATE TABLE [dbo].[Dim_Cliente] (
    [ClienteKey] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CustomerID] NCHAR(5) NOT NULL,
    [CompanyName] NVARCHAR(40) NOT NULL,
    [Country] NVARCHAR(15) NULL
);