CREATE TABLE [dbo].[Dim_Tiempo] (
    [TiempoKey]       INT          NOT NULL PRIMARY KEY, -- Formato AAAAMMDD (Ej: 20261010)
    [Fecha]           DATE         NOT NULL,
    [Año]             INT          NOT NULL,
    [Trimestre]       INT          NOT NULL,
    [Mes]             INT          NOT NULL,
    [NombreMes]       NVARCHAR(15) NOT NULL,
    [DiaDelMes]       INT          NOT NULL,
    [NombreDiaSemana] NVARCHAR(15) NOT NULL,
    [EsFinDeSemana]   BIT          NOT NULL
);
GO
