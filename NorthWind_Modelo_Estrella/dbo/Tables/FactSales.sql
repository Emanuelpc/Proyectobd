CREATE TABLE dbo.FactSales (
    SalesKey            INT IDENTITY(1,1) NOT NULL,
    OrderID             INT               NOT NULL, -- Dimensión degenerada (Id transaccional)
    CustomerKey         INT               NOT NULL,
    ProductKey          INT               NOT NULL,
    EmployeeKey         INT               NOT NULL,
    ShipperKey          INT               NOT NULL,
    TerritoryRegionKey  INT               NOT NULL,
    OrderDateKey        INT               NOT NULL,
    HistoricalUnitPrice MONEY             NOT NULL,
    Quantity            SMALLINT          NOT NULL,
    Discount            REAL              NOT NULL,
    GrossAmount         MONEY             NOT NULL, -- Métrica Calculada (Qty * Price)
    FreightAllocated    MONEY             NOT NULL, -- Métrica Calculada Prorrateada
    NetAmount           MONEY             NOT NULL, -- Métrica Calculada (Gross - Disc + Freight)

    CONSTRAINT PK_FactSales PRIMARY KEY CLUSTERED (SalesKey),
    
    -- Restricciones de Clave Foránea (FK)
    CONSTRAINT FK_FactSales_DimCustomer FOREIGN KEY (CustomerKey) 
        REFERENCES dbo.DimCustomer (CustomerKey),
    CONSTRAINT FK_FactSales_DimProduct FOREIGN KEY (ProductKey) 
        REFERENCES dbo.DimProduct (ProductKey),
    CONSTRAINT FK_FactSales_DimEmployee FOREIGN KEY (EmployeeKey) 
        REFERENCES dbo.DimEmployee (EmployeeKey),
    CONSTRAINT FK_FactSales_DimShipper FOREIGN KEY (ShipperKey) 
        REFERENCES dbo.DimShipper (ShipperKey),
    CONSTRAINT FK_FactSales_DimTerritoryRegion FOREIGN KEY (TerritoryRegionKey) 
        REFERENCES dbo.DimTerritoryRegion (TerritoryRegionKey),
    CONSTRAINT FK_FactSales_DimDate FOREIGN KEY (OrderDateKey) 
        REFERENCES dbo.DimDate (DateKey)
);
GO