-- Ejecutar en la base: NorthWind (origen OLTP)
-- Origen del paquete FactSales. Sigue el mismo patron que GetProductChangesByRowVersion:
-- devuelve las lineas de venta nuevas o modificadas entre @startRow y @endRow.
-- Territorio (opcion A): un territorio por empleado, el de menor TerritoryID.
CREATE OR ALTER PROCEDURE [dbo].[GetSalesChangesByRowVersion]
(
   @startRow BIGINT
  ,@endRow   BIGINT
)
AS
BEGIN
  SET NOCOUNT ON;

  WITH Lineas AS (
    SELECT
         o.OrderID
        ,o.CustomerID
        ,od.ProductID
        ,o.EmployeeID
        ,o.ShipVia                         AS ShipperID
        ,et.TerritoryID
        ,YEAR(o.OrderDate) * 10000 + MONTH(o.OrderDate) * 100 + DAY(o.OrderDate) AS OrderDateKey
        ,od.UnitPrice                      AS HistoricalUnitPrice
        ,od.Quantity
        ,od.Discount
        ,CAST(od.Quantity * od.UnitPrice AS MONEY) AS GrossAmount
        -- Flete del pedido repartido segun el peso de cada linea dentro del pedido
        ,CAST(o.Freight * (od.Quantity * od.UnitPrice)
              / NULLIF(SUM(od.Quantity * od.UnitPrice) OVER (PARTITION BY od.OrderID), 0)
              AS MONEY)                    AS FreightAllocated
        ,od.Quantity * od.UnitPrice * (1 - od.Discount) AS NetBeforeFreight
        ,o.[rowversion]                    AS OrderRV
        ,od.[rowversion]                   AS DetailRV
    FROM dbo.Orders AS o
    INNER JOIN dbo.OrderDetails AS od ON od.OrderID = o.OrderID
    LEFT JOIN (
        SELECT EmployeeID, MIN(TerritoryID) AS TerritoryID
        FROM dbo.EmployeeTerritories
        GROUP BY EmployeeID
    ) AS et ON et.EmployeeID = o.EmployeeID
  )
  SELECT
       OrderID, CustomerID, ProductID, EmployeeID, ShipperID, TerritoryID, OrderDateKey
      ,HistoricalUnitPrice, Quantity, Discount, GrossAmount, FreightAllocated
      ,CAST(NetBeforeFreight + FreightAllocated AS MONEY) AS NetAmount
  FROM Lineas
  WHERE (OrderRV  > CONVERT(ROWVERSION, @startRow) AND OrderRV  <= CONVERT(ROWVERSION, @endRow))
     OR (DetailRV > CONVERT(ROWVERSION, @startRow) AND DetailRV <= CONVERT(ROWVERSION, @endRow));
END
GO
