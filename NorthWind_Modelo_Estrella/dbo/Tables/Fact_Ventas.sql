CREATE TABLE [dbo].[Fact_Ventas] (
    [VentaKey]       INT      IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    [ClienteKey]     INT      NOT NULL,
    [ProductoKey]    INT      NOT NULL,
    [EmpleadoKey]    INT      NOT NULL,
    [ProveedorKey]   INT      NOT NULL,
    [TiempoKey]      INT      NOT NULL,
    [OrderID]        INT      NOT NULL,
    -- Métricas cuantitativas
    [Cantidad]       SMALLINT NOT NULL,
    [PrecioUnitario] MONEY    NOT NULL,
    [Descuento]      REAL     NOT NULL,
    [MontoVenta]     MONEY    NOT NULL, -- (Cantidad * PrecioUnitario * (1 - Descuento))
    [CostoEnvio]     MONEY    NULL,     -- Freight prorrateado
    -- Relaciones con dimensiones
    CONSTRAINT [FK_Fact_Cliente] FOREIGN KEY ([ClienteKey]) REFERENCES [dbo].[Dim_Cliente] ([ClienteKey]),
    CONSTRAINT [FK_Fact_Producto] FOREIGN KEY ([ProductoKey]) REFERENCES [dbo].[Dim_Producto] ([ProductoKey]),
    CONSTRAINT [FK_Fact_Empleado] FOREIGN KEY ([EmpleadoKey]) REFERENCES [dbo].[Dim_Empleado] ([EmpleadoKey]),
    CONSTRAINT [FK_Fact_Proveedor] FOREIGN KEY ([ProveedorKey]) REFERENCES [dbo].[Dim_Proveedor] ([ProveedorKey]),
    CONSTRAINT [FK_Fact_Tiempo] FOREIGN KEY ([TiempoKey]) REFERENCES [dbo].[Dim_Tiempo] ([TiempoKey])
);
GO