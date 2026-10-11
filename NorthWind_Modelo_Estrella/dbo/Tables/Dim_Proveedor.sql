CREATE TABLE [dbo].[Dim_Proveedor] (
    [ProveedorKey] INT           IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    [SupplierID]   INT           NOT NULL,
    [CompanyName]  NVARCHAR (40) NOT NULL,
    [City]         NVARCHAR (15) NULL,
    [Country]      NVARCHAR (15) NULL
);
GO