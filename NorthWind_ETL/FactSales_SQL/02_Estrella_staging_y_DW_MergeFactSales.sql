-- Ejecutar en la base: NorthWind_Modelo_Estrella (destino)
-- Si tus companeros ya crearon el esquema staging, CREATE SCHEMA se omite solo.
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'staging')
    EXEC('CREATE SCHEMA staging');
GO

IF OBJECT_ID('staging.factsales') IS NULL
CREATE TABLE staging.factsales (
    OrderID             INT          NOT NULL,
    CustomerID          NCHAR(5)     NOT NULL,
    ProductID           INT          NOT NULL,
    EmployeeID          INT          NOT NULL,
    ShipperID           INT          NOT NULL,
    TerritoryID         NVARCHAR(20) NOT NULL,
    OrderDateKey        INT          NOT NULL,
    HistoricalUnitPrice MONEY        NOT NULL,
    Quantity            SMALLINT     NOT NULL,
    Discount            REAL         NOT NULL,
    GrossAmount         MONEY        NOT NULL,
    FreightAllocated    MONEY        NOT NULL,
    NetAmount           MONEY        NOT NULL
);
GO

-- Mezcla staging -> FactSales. Traduce cada codigo de negocio a la clave de su dimension.
-- Si alguna linea no encuentra su dimension, falla con un mensaje (no pierde filas en silencio).
CREATE OR ALTER PROCEDURE [dbo].[DW_MergeFactSales]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @faltan INT;
    SELECT @faltan = COUNT(*)
    FROM staging.factsales s
    WHERE NOT EXISTS (SELECT 1 FROM dbo.DimCustomer        c  WHERE c.CustomerID  = s.CustomerID)
       OR NOT EXISTS (SELECT 1 FROM dbo.DimProduct         p  WHERE p.ProductID   = s.ProductID)
       OR NOT EXISTS (SELECT 1 FROM dbo.DimEmployee        e  WHERE e.EmployeeID  = s.EmployeeID)
       OR NOT EXISTS (SELECT 1 FROM dbo.DimShipper         sh WHERE sh.ShipperID  = s.ShipperID)
       OR NOT EXISTS (SELECT 1 FROM dbo.DimTerritoryRegion t  WHERE t.TerritoryID = s.TerritoryID)
       OR NOT EXISTS (SELECT 1 FROM dbo.DimDate            d  WHERE d.DateKey     = s.OrderDateKey);

    IF @faltan > 0
    BEGIN
        DECLARE @msg NVARCHAR(200) = CONCAT(@faltan, N' linea(s) de staging.factsales no tienen su dimension cargada. Cargue primero las dimensiones.');
        THROW 50001, @msg, 1;
    END

    MERGE dbo.FactSales AS t
    USING (
        SELECT s.OrderID, c.CustomerKey, p.ProductKey, e.EmployeeKey, sh.ShipperKey,
               tr.TerritoryRegionKey, s.OrderDateKey, s.HistoricalUnitPrice, s.Quantity,
               s.Discount, s.GrossAmount, s.FreightAllocated, s.NetAmount
        FROM staging.factsales s
        INNER JOIN dbo.DimCustomer        c  ON c.CustomerID   = s.CustomerID
        INNER JOIN dbo.DimProduct         p  ON p.ProductID    = s.ProductID
        INNER JOIN dbo.DimEmployee        e  ON e.EmployeeID   = s.EmployeeID
        INNER JOIN dbo.DimShipper         sh ON sh.ShipperID   = s.ShipperID
        INNER JOIN dbo.DimTerritoryRegion tr ON tr.TerritoryID = s.TerritoryID
    ) AS src
       ON t.OrderID = src.OrderID AND t.ProductKey = src.ProductKey
    WHEN MATCHED AND (   t.CustomerKey         <> src.CustomerKey
                      OR t.EmployeeKey         <> src.EmployeeKey
                      OR t.ShipperKey          <> src.ShipperKey
                      OR t.TerritoryRegionKey  <> src.TerritoryRegionKey
                      OR t.OrderDateKey        <> src.OrderDateKey
                      OR t.HistoricalUnitPrice <> src.HistoricalUnitPrice
                      OR t.Quantity            <> src.Quantity
                      OR t.Discount            <> src.Discount
                      OR t.GrossAmount         <> src.GrossAmount
                      OR t.FreightAllocated    <> src.FreightAllocated
                      OR t.NetAmount           <> src.NetAmount) THEN
        UPDATE SET CustomerKey = src.CustomerKey, EmployeeKey = src.EmployeeKey,
                   ShipperKey = src.ShipperKey, TerritoryRegionKey = src.TerritoryRegionKey,
                   OrderDateKey = src.OrderDateKey, HistoricalUnitPrice = src.HistoricalUnitPrice,
                   Quantity = src.Quantity, Discount = src.Discount, GrossAmount = src.GrossAmount,
                   FreightAllocated = src.FreightAllocated, NetAmount = src.NetAmount
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (OrderID, CustomerKey, ProductKey, EmployeeKey, ShipperKey, TerritoryRegionKey,
                OrderDateKey, HistoricalUnitPrice, Quantity, Discount, GrossAmount,
                FreightAllocated, NetAmount)
        VALUES (src.OrderID, src.CustomerKey, src.ProductKey, src.EmployeeKey, src.ShipperKey,
                src.TerritoryRegionKey, src.OrderDateKey, src.HistoricalUnitPrice, src.Quantity,
                src.Discount, src.GrossAmount, src.FreightAllocated, src.NetAmount);
END
GO
