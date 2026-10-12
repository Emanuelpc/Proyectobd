# Proyectobd

## Grupo: Northwind DW

## Integrantes del Grupo

| N.º | Nombre completo | Cód. SIS | Usuario de GitHub |
|-----|-----------------|----------|-------------------|
| 1 | Emanuel Vladimir Peredo Claros | 202001829 | Emanuelpc |
| 2 | Amadeo Diego Siles Revilla | 202103893 | amadeosilesing |
| 3 | Brenda Calizaya Antezana | 202105268 | BrendaCali |
| 4 | Ever Blanco Vela | 202103777 | EverBlancoVela |

## Descripción

Proyecto de base de datos SQL Server construido en Visual Studio a partir de la base de datos de ejemplo **Northwind**. Contiene dos proyectos en una misma solución:

1. **Base de datos OLTP (`Proyectobd`)**: esquema transaccional normalizado de Northwind (tablas `Categories`, `Customers`, `Employees`, `Orders`, `OrderDetails`, `Products`, `Shippers`, `Suppliers`, `Region`, `Territories`, entre otras).
2. **Base de datos desnormalizada (`NorthWind_Modelo_Estrella`)**: modelo estrella para análisis.

## Modelo estrella

**Tabla de hechos**
- `Fact_Ventas`

**Dimensiones**
- `Dim_Cliente`
- `Dim_Empleado`
- `Dim_Producto`
- `Dim_Proveedor`
- `Dim_Tiempo`

## Estructura del repositorio

```
Proyectobd/
├── Proyectobd/                  # Proyecto OLTP (dbo/Tables)
├── NorthWind_Modelo_Estrella/   # Proyecto modelo estrella (dbo/Tables)
└── README.md
```

## Cómo usar el proyecto

1. Clonar el repositorio: `git clone https://github.com/Emanuelpc/Proyectobd.git`
2. Abrir la solución `Proyectobd.sln` en Visual Studio 2026 (con la carga de trabajo *Almacenamiento y procesamiento de datos*).
3. Compilar la solución.
4. Publicar cada proyecto en SQL Server 
## Herramientas

- SQL Server y SQL Server Management Studio (SSMS)
- Visual Studio Community 2026 con SQL Server Data Tools
- Git y GitHub
