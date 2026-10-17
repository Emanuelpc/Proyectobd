CREATE TABLE dbo.DimTerritoryRegion (
    TerritoryRegionKey   INT IDENTITY(1,1) NOT NULL,
    TerritoryID          NVARCHAR(20)      NOT NULL, -- Código de negocio (OLTP)
    TerritoryDescription NCHAR(50)         NOT NULL,
    RegionID             INT               NOT NULL,
    RegionDescription    NCHAR(50)         NOT NULL, -- Desnormalizado de Region
    CONSTRAINT PK_DimTerritoryRegion PRIMARY KEY CLUSTERED (TerritoryRegionKey)
);
GO