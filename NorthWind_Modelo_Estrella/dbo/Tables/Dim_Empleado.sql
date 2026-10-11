CREATE TABLE [dbo].[Dim_Empleado] (
    [EmpleadoKey] INT           IDENTITY (1, 1) NOT NULL PRIMARY KEY,
    [EmployeeID]  INT           NOT NULL,
    [NombreCompleto] NVARCHAR (60) NOT NULL,
    [Title]       NVARCHAR (30) NULL,
    [City]        NVARCHAR (15) NULL,
    [Country]     NVARCHAR (15) NULL
);
GO