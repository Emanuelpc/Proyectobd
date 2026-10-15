CREATE TABLE dbo.DimShipper (
    ShipperKey  INT IDENTITY(1,1) NOT NULL,
    ShipperID   INT               NOT NULL, -- Código de negocio (OLTP)
    CompanyName NVARCHAR(40)      NOT NULL,
    CONSTRAINT PK_DimShipper PRIMARY KEY CLUSTERED (ShipperKey)
);
GO