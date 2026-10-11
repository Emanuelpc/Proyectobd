CREATE TABLE [dbo].[Dim_Producto] (
    [ProductoKey] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [ProductID] INT NOT NULL,
    [ProductName] NVARCHAR(40) NOT NULL,
    [CategoryName] NVARCHAR(15) NULL
);