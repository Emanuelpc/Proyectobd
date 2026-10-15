CREATE TABLE dbo.DimProduct (
    ProductKey       INT IDENTITY(1,1) NOT NULL,
    ProductID        INT               NOT NULL, -- Código de negocio (OLTP)
    ProductName      NVARCHAR(40)      NOT NULL,
    CategoryName     NVARCHAR(15)      NOT NULL, -- Desnormalizado de Categories
    SupplierName     NVARCHAR(40)      NOT NULL, -- Desnormalizado de Suppliers
    CurrentUnitPrice MONEY             NOT NULL,
    CONSTRAINT PK_DimProduct PRIMARY KEY CLUSTERED (ProductKey)
);
GO