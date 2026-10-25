# Proyectobd

## Grupo: Northwind DW

## Integrantes del Grupo

| N.º | Nombre completo                | Cód. SIS  | Usuario de GitHub |
| --- | ------------------------------ | --------- | ----------------- |
| 1   | Emanuel Vladimir Peredo Claros | 202001829 | Emanuelpc         |
| 2   | Amadeo Diego Siles Revilla     | 202103893 | amadeosilesing    |
| 3   | Brenda Calizaya Antezana       | 202105268 | BrendaCali        |
| 4   | Ever Blanco Vela               | 202103777 | EverBlancoVela    |

## Descripción

Proyecto de inteligencia de negocios construido sobre la base de datos de ejemplo **Northwind**. Cubre el ciclo completo: base transaccional, Data Warehouse con modelo estrella, carga de datos y visualización en Power BI.

Contiene tres componentes:

1. **Base de datos OLTP (`Proyectobd`)**: esquema transaccional normalizado de Northwind (`Categories`, `Customers`, `Employees`, `Orders`, `OrderDetails`, `Products`, `Shippers`, `Suppliers`, `Region`, `Territories`, entre otras).
2. **Data Warehouse (`NorthWind_Modelo_Estrella`)**: modelo estrella desnormalizado para análisis.
3. **Visualización (`Visualizacion`)**: informe interactivo de 4 páginas en Power BI (`NorthWind_Modelo_Estrella.pbix`), conectado al Data Warehouse.

## Modelo estrella

**Proceso de negocio:** ventas. **Grano de la tabla de hechos:** una fila por línea de pedido (pedido + producto).

**Tabla de hechos**

| Tabla       | Claves foráneas                                                                                | Métricas                                                                                      |
| ----------- | ---------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `FactSales` | `CustomerKey`, `ProductKey`, `EmployeeKey`, `ShipperKey`, `TerritoryRegionKey`, `OrderDateKey` | `HistoricalUnitPrice`, `Quantity`, `Discount`, `GrossAmount`, `FreightAllocated`, `NetAmount` |

`OrderID` se conserva como dimensión degenerada.

**Dimensiones** (todas con clave subrogada `IDENTITY` y la clave de negocio del OLTP)

| Dimensión            | Origen en el OLTP                       | Detalle                                                                |
| -------------------- | --------------------------------------- | ---------------------------------------------------------------------- |
| `DimCustomer`        | `Customers`                             | Cliente y contacto                                                     |
| `DimProduct`         | `Products` + `Categories` + `Suppliers` | Categoría y proveedor aplanados en una sola tabla                      |
| `DimEmployee`        | `Employees`                             | Vendedor y cargo                                                       |
| `DimShipper`         | `Shippers`                              | Transportista                                                          |
| `DimTerritoryRegion` | `Territories` + `Region`                | Territorio y región aplanados                                          |
| `DimDate`            | No existe en el OLTP                    | Calendario con año, trimestre y mes (`DateKey` con formato `YYYYMMDD`) |

**Capa de carga (ETL)**

- Esquema `staging` con una tabla de paso por cada dimensión y para las ventas.
- Procedimientos `DW_Merge*` (`DW_MergeDimCustomer`, `DW_MergeDimProduct`, `DW_MergeFactSales`, etc.) que cargan el modelo desde staging.
- Tabla `PackageConfig` con `LastRowVersion` para carga incremental, apoyada en los procedimientos `GetLastPackageRowVersion` y `UpdateLastPackageRowVersion`.

## Visualización en Power BI

Informe interactivo en el archivo `Visualizacion/NorthWind_Modelo_Estrella.pbix`, conectado al Data Warehouse en modo Importar. Incluye los datos cargados, así que se puede abrir y explorar sin necesidad de tener SQL Server en línea.

**Páginas**

| Página               | Contenido                                                                                                                                                       |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Resumen comercial    | Filtros de año, categoría y cliente; tarjetas de ventas netas, pedidos, unidades, ticket promedio y descuento; ventas por mes y por categoría; textos dinámicos |
| Productos y clientes | Top 10 clientes y productos; ventas netas contra ventas con descuento alto por categoría; tabla de detalle                                                      |
| Logística            | Flete total y sobre ventas; pedidos grandes contra estándar; ventas por transportista, región y vendedor                                                        |
| Tendencias           | Ventas netas, brutas y del año anterior por mes; crecimiento interanual; ventas por trimestre                                                                   |

**Medidas DAX principales** (tabla `FactSales`)

| Medida                                    | Definición                                                                                   |
| ----------------------------------------- | -------------------------------------------------------------------------------------------- |
| `Total Net Sales`                         | `SUM(FactSales[NetAmount])`                                                                  |
| `Total Gross Sales`                       | `SUM(FactSales[GrossAmount])`                                                                |
| `Discount %`                              | Descuento sobre ventas brutas                                                                |
| `Total Orders`                            | `DISTINCTCOUNT(FactSales[OrderID])`                                                          |
| `Avg Ticket`                              | Ventas netas entre pedidos distintos                                                         |
| `Total Freight`                           | Flete asignado a las ventas                                                                  |
| `Total Orders Big` / `Standard`           | Pedidos con ventas netas sobre / bajo el umbral                                              |
| `Net Sales Top 10 Customers` / `Products` | Ranking de los 10 mejores                                                                    |
| `Total Net Sales PY` / `Net Sales YoY %`  | Comparación contra el mismo período del año anterior, solo con meses presentes en ambos años |

**Supuestos y limitaciones**

- "Pedido grande" es un pedido con ventas netas de 2,000 o más (medida `Big Order Threshold`).
- "Descuento alto" es una línea con descuento de 10% o más (medida `Big Discount Threshold`).
- El Data Warehouse no almacena país de envío ni país del cliente, por lo que la geografía se analiza por región y territorio.
- Las medidas del año anterior y del crecimiento interanual requieren seleccionar **un solo año** en el filtro; con "Todas" muestran "(En blanco)".
- Los datos de Northwind abarcan de julio de 1996 a mayo de 1998.

## Estructura del repositorio

```
Proyectobd/
├── Proyectobd/                  # Proyecto OLTP (dbo/Tables)
├── NorthWind_Modelo_Estrella/   # Proyecto del Data Warehouse (dbo/Tables, staging, procedimientos)
├── Visualizacion/
│   └── NorthWind_Modelo_Estrella.pbix   # Informe de Power BI
└── README.md
```

## Cómo usar el proyecto

**Bases de datos**

1. Clonar el repositorio: `git clone https://github.com/Emanuelpc/Proyectobd.git`
2. Abrir la solución `Proyectobd.sln` en Visual Studio 2026 (con la carga de trabajo _Almacenamiento y procesamiento de datos_).
3. Compilar la solución.
4. Publicar cada proyecto en SQL Server.
5. Cargar el Data Warehouse ejecutando la capa de carga (staging y procedimientos `DW_Merge*`).

**Informe de Power BI**

1. Abrir `Visualizacion/NorthWind_Modelo_Estrella.pbix` con Power BI Desktop. Los datos ya vienen incluidos, así que el informe se ve de inmediato.
2. Para actualizar con los datos de tu propio SQL Server, ir a _Transformar datos → Administrar parámetros_ y revisar:
   - `ServerName`: `localhost` (cambiar si se usa otra instancia).
   - `DatabaseName`: `NorthWind_Modelo_Estrella`.
3. Hacer clic en **Actualizar** e ingresar las credenciales de Windows.
4. Navegar entre páginas con los botones de la parte superior y filtrar con los selectores de año, categoría y cliente.

## Herramientas

- SQL Server y SQL Server Management Studio (SSMS)
- Visual Studio Community 2026 con SQL Server Data Tools
- Power BI Desktop
- Git y GitHub
