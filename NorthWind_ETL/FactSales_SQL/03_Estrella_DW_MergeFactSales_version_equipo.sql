-- Ejecutar en la base: NorthWind_Modelo_Estrella (destino)
-- Version del EQUIPO de DW_MergeFactSales (copiada tal cual del chat del grupo).
-- Vacia FactSales y la recarga completa desde staging.sales, por eso el paquete
-- FactSales.dtsx extrae TODAS las ventas en cada ejecucion (@startRow = 0).
CREATE OR ALTER PROCEDURE [dbo].[DW_MergeFactSales]
AS
BEGIN
    -- Limpiamos y cargamos los hechos asegurando la integridad referencial con las dimensiones
    TRUNCATE TABLE FactSales;

    INSERT INTO FactSales (
        OrderID, CustomerKey, ProductKey, EmployeeKey, ShipperKey, 
        TerritoryRegionKey, OrderDateKey, HistoricalUnitPrice, Quantity, 
        Discount, GrossAmount, FreightAllocated, NetAmount
    )
    SELECT 
        s.OrderID,
        ISNULL(c.CustomerKey, -1),
        ISNULL(p.ProductKey, -1),
        ISNULL(e.EmployeeKey, -1),
        ISNULL(sh.ShipperKey, -1),
        ISNULL(tr.TerritoryRegionKey, -1),
        s.OrderDateKey,
        s.HistoricalUnitPrice,
        s.Quantity,
        s.Discount,
        s.GrossAmount,
        s.FreightAllocated,
        s.NetAmount
    FROM staging.sales s
    LEFT JOIN DimCustomer c ON s.CustomerID = c.CustomerID
    LEFT JOIN DimProduct p ON s.ProductID = p.ProductID
    LEFT JOIN DimEmployee e ON s.EmployeeID = e.EmployeeID
    LEFT JOIN DimShipper sh ON s.ShipperID = sh.ShipperID
    LEFT JOIN DimTerritoryRegion tr ON s.TerritoryID = tr.TerritoryID;
END;
GO
