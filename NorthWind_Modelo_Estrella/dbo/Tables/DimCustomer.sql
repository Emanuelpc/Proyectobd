CREATE TABLE dbo.DimCustomer (
    CustomerKey   INT IDENTITY(1,1) NOT NULL,
    CustomerID    NCHAR(5)          NOT NULL, -- Código de negocio (OLTP)
    CompanyName   NVARCHAR(40)      NOT NULL,
    ContactName   NVARCHAR(30)      NULL,
    CONSTRAINT PK_DimCustomer PRIMARY KEY CLUSTERED (CustomerKey)
);
GO