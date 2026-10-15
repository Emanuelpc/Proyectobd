CREATE TABLE dbo.DimEmployee (
    EmployeeKey INT IDENTITY(1,1) NOT NULL,
    EmployeeID  INT               NOT NULL, -- Código de negocio (OLTP)
    FirstName   NVARCHAR(10)      NOT NULL,
    LastName    NVARCHAR(20)      NOT NULL,
    Title       NVARCHAR(30)      NULL,
    CONSTRAINT PK_DimEmployee PRIMARY KEY CLUSTERED (EmployeeKey)
);
GO