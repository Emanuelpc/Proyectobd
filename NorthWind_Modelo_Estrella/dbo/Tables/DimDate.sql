CREATE TABLE dbo.DimDate (
    DateKey            INT           NOT NULL, -- Formato numérico YYYYMMDD
    FullDate           DATE          NOT NULL,
    CalendarYear       INT           NOT NULL,
    CalendarQuarter    INT           NOT NULL,
    MonthNumberOfYear  INT           NOT NULL,
    EnglishMonthName   NVARCHAR(10)  NOT NULL,
    CONSTRAINT PK_DimDate PRIMARY KEY CLUSTERED (DateKey)
);
GO