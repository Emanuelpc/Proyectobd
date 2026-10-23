-- Ejecutar en la base: NorthWind_Modelo_Estrella (destino)
-- Crea staging.sales SOLO si no existe (el equipo ya la tiene en sus bases).
-- Columnas = las que usa DW_MergeFactSales y el paquete FactSales.dtsx.
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'staging')
    EXEC('CREATE SCHEMA staging');
GO

IF OBJECT_ID('staging.sales') IS NULL
CREATE TABLE staging.sales (
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
