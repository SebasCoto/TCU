USE [master]
GO
/****** Object:  Database [AbrazosDB]    Script Date: 20/06/2025 10:07:40 a. m. ******/
CREATE DATABASE [AbrazosDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'abrazos', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\abrazos.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'abrazos_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\abrazos_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [AbrazosDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AbrazosDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AbrazosDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AbrazosDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AbrazosDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AbrazosDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AbrazosDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [AbrazosDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AbrazosDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AbrazosDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AbrazosDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AbrazosDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AbrazosDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AbrazosDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AbrazosDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AbrazosDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AbrazosDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [AbrazosDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AbrazosDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AbrazosDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AbrazosDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AbrazosDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AbrazosDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AbrazosDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AbrazosDB] SET RECOVERY FULL 
GO
ALTER DATABASE [AbrazosDB] SET  MULTI_USER 
GO
ALTER DATABASE [AbrazosDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AbrazosDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AbrazosDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AbrazosDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AbrazosDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AbrazosDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'AbrazosDB', N'ON'
GO
ALTER DATABASE [AbrazosDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [AbrazosDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [AbrazosDB]
GO
/****** Object:  Table [dbo].[ArchivosUser]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArchivosUser](
	[Id_ArchivoUser] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Tipo] [varchar](255) NOT NULL,
	[Ruta] [varchar](500) NOT NULL,
	[FechaSubida] [datetime] NOT NULL,
 CONSTRAINT [PK_ArchivosUser] PRIMARY KEY CLUSTERED 
(
	[Id_ArchivoUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[categoria]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[categoria](
	[id_categoria] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
	[descripcion] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_categoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadoRegistro]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoRegistro](
	[Id_EstadoRegistro] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EstadoRegistro] PRIMARY KEY CLUSTERED 
(
	[Id_EstadoRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Eventos]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Eventos](
	[Id_Evento] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre_Evento] [varchar](50) NOT NULL,
	[Descripcion] [text] NOT NULL,
	[Fecha_Inicio] [datetime] NOT NULL,
	[Fecha_Final] [datetime] NOT NULL,
	[Color] [varchar](7) NOT NULL,
	[invitados] [text] NOT NULL,
 CONSTRAINT [PK_Eventos] PRIMARY KEY CLUSTERED 
(
	[Id_Evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Expedientes]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Expedientes](
	[Id_Archivo] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Tipo] [varchar](255) NOT NULL,
	[Ruta] [varchar](500) NOT NULL,
	[FechaSubida] [datetime] NOT NULL,
	[Id_Familia] [bigint] NOT NULL,
 CONSTRAINT [PK_Expedientes] PRIMARY KEY CLUSTERED 
(
	[Id_Archivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[familias]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[familias](
	[id_familia] [bigint] IDENTITY(1,1) NOT NULL,
	[nombre_representante] [nvarchar](100) NOT NULL,
	[direccion] [nvarchar](255) NOT NULL,
	[telefono] [varchar](8) NOT NULL,
	[cantidad_familiares] [int] NOT NULL,
	[cantidad_ninos] [int] NOT NULL,
	[id_vulnerabilidad] [int] NOT NULL,
	[presupuesto] [decimal](10, 2) NULL,
	[cedula_representante] [varchar](100) NOT NULL,
 CONSTRAINT [PK__familias__609C48522D019818] PRIMARY KEY CLUSTERED 
(
	[id_familia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[inventario]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[inventario](
	[id_inventario] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
	[id_categoria] [int] NOT NULL,
	[stock] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_inventario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[presupuestos]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[presupuestos](
	[id_presupuesto] [int] IDENTITY(1,1) NOT NULL,
	[id_familia] [bigint] NOT NULL,
	[monto_total] [decimal](10, 2) NOT NULL,
	[descripcion] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK__presupue__3E94B4E548F609DD] PRIMARY KEY CLUSTERED 
(
	[id_presupuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rol]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rol](
	[id_rol] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios](
	[id_usuario] [bigint] IDENTITY(1,1) NOT NULL,
	[Cedula] [varchar](50) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
	[apellidos] [nvarchar](100) NOT NULL,
	[correo] [nvarchar](100) NOT NULL,
	[username] [nvarchar](100) NOT NULL,
	[password] [nvarchar](100) NOT NULL,
	[id_rol] [int] NOT NULL,
	[fecha_registro] [date] NOT NULL,
	[password_temp_status] [bit] NULL,
	[password_temp_expiration] [datetime] NULL,
	[Id_ArchivosUser] [bigint] NULL,
	[Id_EstadoRegistro] [bigint] NULL,
 CONSTRAINT [PK__usuarios__4E3E04AD0492928B] PRIMARY KEY CLUSTERED 
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voluntarios]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voluntarios](
	[id_voluntario] [int] IDENTITY(1,1) NOT NULL,
	[id_usuario] [bigint] NOT NULL,
	[habilidades] [nvarchar](255) NOT NULL,
	[horario_disponible] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK__voluntar__9A7281F9D648F070] PRIMARY KEY CLUSTERED 
(
	[id_voluntario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vulnerabilidad]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vulnerabilidad](
	[id_vulnerabilidad] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_vulnerabilidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[familias]  WITH CHECK ADD  CONSTRAINT [FK_FAMILIAS_VULNERABILIDAD] FOREIGN KEY([id_vulnerabilidad])
REFERENCES [dbo].[vulnerabilidad] ([id_vulnerabilidad])
GO
ALTER TABLE [dbo].[familias] CHECK CONSTRAINT [FK_FAMILIAS_VULNERABILIDAD]
GO
ALTER TABLE [dbo].[inventario]  WITH CHECK ADD  CONSTRAINT [FK_INVENTARIO_CATEGORIA] FOREIGN KEY([id_categoria])
REFERENCES [dbo].[categoria] ([id_categoria])
GO
ALTER TABLE [dbo].[inventario] CHECK CONSTRAINT [FK_INVENTARIO_CATEGORIA]
GO
ALTER TABLE [dbo].[presupuestos]  WITH CHECK ADD  CONSTRAINT [FK_PRESUPUESTOS_FAMILIAS] FOREIGN KEY([id_familia])
REFERENCES [dbo].[familias] ([id_familia])
GO
ALTER TABLE [dbo].[presupuestos] CHECK CONSTRAINT [FK_PRESUPUESTOS_FAMILIAS]
GO
ALTER TABLE [dbo].[voluntarios]  WITH CHECK ADD  CONSTRAINT [FK_VOLUNTARIOS_USUARIOS] FOREIGN KEY([id_usuario])
REFERENCES [dbo].[usuarios] ([id_usuario])
GO
ALTER TABLE [dbo].[voluntarios] CHECK CONSTRAINT [FK_VOLUNTARIOS_USUARIOS]
GO
/****** Object:  StoredProcedure [dbo].[AccesoUsuarios]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AccesoUsuarios]
    @Id_Usuario bigint,
    @Id_EstadoRegistro Bigint
AS
BEGIN
    UPDATE dbo.usuarios 
    SET Id_EstadoRegistro = @Id_EstadoRegistro
    WHERE id_usuario = @Id_Usuario;

    IF (@Id_EstadoRegistro = 2)
    BEGIN
        DELETE FROM usuarios 
        WHERE id_usuario = @Id_Usuario
        AND Id_EstadoRegistro = 2;

        SELECT 'ELIMINADO' AS Nombre;
        RETURN;
    END

    SELECT Nombre 
    FROM dbo.EstadoRegistro 
    WHERE Id_EstadoRegistro = @Id_EstadoRegistro;
END
GO
/****** Object:  StoredProcedure [dbo].[ActualizarContrasenna]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarContrasenna]
    @Id_usuario bigint,
    @Contrasena varchar(50),
    @ContrasennaAnterior varchar(100),
    @ContrasennaConfirmar varchar(100)
AS
BEGIN
    DECLARE @PasswordActual varchar(100);

    SELECT @PasswordActual = password 
    FROM usuarios 
    WHERE id_usuario = @Id_usuario;

    IF (@ContrasennaAnterior = @PasswordActual)
    BEGIN
        UPDATE usuarios
        SET password = @Contrasena,
            password_temp_status = 0,
            password_temp_expiration = GETDATE()
        WHERE id_usuario = @Id_usuario;
    END
    ELSE
    BEGIN
        RAISERROR('La contraseña anterior no es correcta.', 16, 1);
    END
END
GO
/****** Object:  StoredProcedure [dbo].[ActualizarEvento]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ActualizarEvento]
	@Id_Evento BIGINT,
	@Nombre_Evento varchar(50),
	@Descripcion text ,
    @Fecha_Inicio Datetime,
	@Fecha_Final Datetime
AS
BEGIN
        UPDATE dbo.Eventos SET Nombre_Evento = @Nombre_Evento, Descripcion = @Descripcion, Fecha_Inicio =@Fecha_Inicio,Fecha_Final = @Fecha_Final
		WHERE Id_Evento = @Id_Evento
    

END
GO
/****** Object:  StoredProcedure [dbo].[ActualizarFamilia]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarFamilia]
    @Id_Familia bigint,
    @Nombre_Representante nvarchar(100),
    @Cedula_Representante varchar(100),
    @Direccion nvarchar(255),
    @Telefono varchar(8),
    @Cantidad_Familiares int,
    @Cantidad_Ninos int,
    @Id_Vulnerabilidad int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.familias 
                   WHERE id_familia = @Id_Familia)
    BEGIN
        RAISERROR('No se encuentra la familia.', 16, 1);
    END
    ELSE
    BEGIN
        UPDATE dbo.familias
        SET nombre_representante = @Nombre_Representante,
            cedula_representante = @Cedula_Representante,
            direccion = @Direccion,
            telefono = @Telefono,
            cantidad_familiares = @Cantidad_Familiares,
            cantidad_ninos = @Cantidad_Ninos,
            id_vulnerabilidad = @Id_Vulnerabilidad
        WHERE id_familia = @Id_Familia;

        DECLARE @SUMA_PRESUPUESTO FLOAT;
        SELECT @SUMA_PRESUPUESTO = SUM(presupuesto) 
        FROM dbo.familias;

        PRINT @SUMA_PRESUPUESTO;
        EXEC [dbo].[CalcularPresupuesto] @MONTO_TOTAL = @SUMA_PRESUPUESTO;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[ActualizarProducto]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarProducto]
	@Id_Inventario INT,
	@NombreProducto NVARCHAR(100),
	@Id_Categoria INT,
    @stock INT
AS
BEGIN

    -- Verifica si existe otro producto con el mismo nombre y que no sea el mismo producto
    IF EXISTS(SELECT 1 FROM dbo.inventario 
              WHERE nombre = @NombreProducto AND id_inventario != @Id_Inventario)
    BEGIN
        RAISERROR('El producto ya existe.', 16, 1);
    END
    ELSE
    BEGIN
        -- Actualiza el producto
        UPDATE dbo.inventario 
        SET nombre = @NombreProducto, id_categoria = @Id_Categoria, stock = @stock
		WHERE id_inventario = @Id_Inventario
    END

END
GO
/****** Object:  StoredProcedure [dbo].[ActualizarUsuario]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarUsuario]
    @Id_Usuario bigint,
    @NombreUsuario nvarchar(100),
    @Apellidos nvarchar(100),
    @Correo nvarchar(100),
    @Username nvarchar(100),
    @Id_Rol int
AS
BEGIN
    -- Validar si el correo o username ya existen para otro usuario
    IF EXISTS(SELECT 1 FROM dbo.usuarios 
              WHERE (username = @Username OR correo = @Correo)
                AND id_usuario <> @Id_Usuario)
    BEGIN
        RAISERROR('El nombre de usuario o correo ya existe.', 16, 1);
    END
    ELSE
    BEGIN
        -- Verificar si hay diferencias con los datos actuales
        IF EXISTS(SELECT 1 FROM dbo.usuarios
                  WHERE id_usuario = @Id_Usuario AND
                        (nombre <> @NombreUsuario OR
                         apellidos <> @Apellidos OR
                         correo <> @Correo OR
                         username <> @Username OR
                         id_rol <> @Id_Rol ))
        BEGIN
            -- Solo actualiza si los datos son diferentes
            UPDATE dbo.usuarios 
            SET nombre = @NombreUsuario, 
                apellidos = @Apellidos, 
                correo = @Correo,
                username = @Username,
                id_rol = @Id_Rol
            WHERE id_usuario = @Id_Usuario;

        END
        ELSE
        BEGIN
            RAISERROR('No se realizaron cambios, los datos son iguales.', 0, 1);
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[CalcularPresupuesto]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CalcularPresupuesto] 
    @MONTO_TOTAL MONEY  
AS
BEGIN
    DECLARE @SUMA_FACTORES FLOAT;
    
    IF OBJECT_ID('tempdb..#FamiliasTemp') IS NOT NULL
        DROP TABLE #FamiliasTemp;

    CREATE TABLE #FamiliasTemp (
        ID_FAMILIA INT,
        FACTOR FLOAT,
        PRESUPUESTO MONEY
    );

    INSERT INTO #FamiliasTemp (ID_FAMILIA, FACTOR)
    SELECT 
        ID_FAMILIA,
        (1.0 * cantidad_familiares) + (2.0 * CANTIDAD_NINOS) + 
        CASE id_vulnerabilidad 
            WHEN 1 THEN 3.0
            WHEN 2 THEN 2.0
            WHEN 3 THEN 1.0
            ELSE 1.0
        END
    FROM Familias;

    SELECT @SUMA_FACTORES = SUM(FACTOR) FROM #FamiliasTemp;

    IF @SUMA_FACTORES = 0
    BEGIN
        PRINT 'No hay familias registradas o no tienen factores válidos.';
        RETURN;
    END

    UPDATE F
    SET F.PRESUPUESTO = (@MONTO_TOTAL * T.FACTOR) / @SUMA_FACTORES
    FROM Familias F
    INNER JOIN #FamiliasTemp T ON F.ID_FAMILIA = T.ID_FAMILIA;

    PRINT 'Presupuesto calculado y actualizado proporcionalmente.';
END;
GO
/****** Object:  StoredProcedure [dbo].[DescargarArchivo]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DescargarArchivo]
	@Id_Archivo BIGINT
AS
BEGIN

	SELECT Nombre,
		   Ruta,
		   Tipo
	FROM Expedientes
	WHERE Id_Archivo = @Id_Archivo
END
GO
/****** Object:  StoredProcedure [dbo].[EliminarEvento]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EliminarEvento]
	@Id_Evento bigint
AS
BEGIN
	
	DELETE FROM Eventos
	WHERE Id_Evento = @Id_Evento

END
GO
/****** Object:  StoredProcedure [dbo].[EliminarFamilia]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EliminarFamilia]
	@Id_Familia bigint
AS
BEGIN
	
	DELETE FROM familias
	WHERE id_familia = @Id_Familia

END
GO
/****** Object:  StoredProcedure [dbo].[EliminarProducto]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EliminarProducto]
	@Id_Inventario INT
AS
BEGIN
	
	DELETE FROM inventario
	WHERE id_inventario = @Id_Inventario

END
GO
/****** Object:  StoredProcedure [dbo].[EliminarUsuario]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EliminarUsuario]
	@Id_Usuario bigint
AS
BEGIN
	
	DELETE FROM usuarios
	WHERE id_usuario = @Id_Usuario

END
GO
/****** Object:  StoredProcedure [dbo].[IniciarSesion]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IniciarSesion]
	@Username nvarchar(100),
	@password nvarchar(100)
AS
BEGIN
	
	SELECT	U.id_usuario,
			U.Nombre 'NombreUsuario',
			apellidos,
			r.nombre as 'NombreRol',
			Correo,
			Id_EstadoRegistro,
			username,
			password_temp_status
	FROM	dbo.usuarios U
	JOIN dbo.rol r  ON U.id_rol = r.id_rol
	WHERE   username = @Username
		AND password = @password

END
GO
/****** Object:  StoredProcedure [dbo].[MostrarEventos]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[MostrarEventos]
	@Id_Evento BIGINT
AS
BEGIN

	IF(@Id_Evento = 0)
		SET @Id_Evento = NULL

	SELECT *
	FROM Eventos
	WHERE  Id_Evento= ISNULL(@Id_Evento,Id_Evento)


END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerCategorias]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerCategorias]
AS
BEGIN

	

	SELECT id_categoria, nombre
	FROM categoria


END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerCorreoById]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerCorreoById]
	@Id_usuario bigint
AS
BEGIN
	SELECT correo
	FROM usuarios
	WHERE id_usuario = @Id_usuario
END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerCorreosSeleccionados]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ObtenerCorreosSeleccionados]
    @CorreoLogueado NVARCHAR(100),
    @Filtro NVARCHAR(100) = NULL
AS
BEGIN
    SELECT nombre, correo
    FROM usuarios
    WHERE correo != @CorreoLogueado
      AND (@Filtro IS NULL OR nombre LIKE '%' + @Filtro + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerEstados]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerEstados]
AS
BEGIN

	

	SELECT Id_EstadoRegistro, Nombre
	FROM EstadoRegistro


END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerExpedientes]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerExpedientes]
 @Id_Expediente BIGINT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM dbo.Expedientes 
              WHERE Id_Archivo = @Id_Expediente)
    BEGIN
        RAISERROR('Expediente no encontrado.', 16, 1);
    END
	ELSE
	BEGIN
		IF(@Id_Expediente = 0)
			SET @Id_Expediente = NULL
	
		SELECT	E.Id_Archivo,
				E.Nombre,
				E.FechaSubida,
				E.Id_Familia,
				F.nombre_representante 'NombreRepresentante'
		FROM	dbo.Expedientes E
		INNER	JOIN dbo.familias F ON E.Id_Familia = F.id_familia
		WHERE  Id_Archivo= ISNULL(@Id_Expediente,Id_Archivo)
	END
END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerFamilias]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerFamilias]
 @Id_Familia BIGINT
AS
BEGIN

	IF(@Id_Familia = 0)
		SET @Id_Familia = NULL
	
	SELECT	F.id_familia,
			F.nombre_representante,
			F.cedula_representante,
			F.direccion,
			F.telefono,
			F.cantidad_familiares,
			F.cantidad_ninos,
			F.presupuesto,
			F.id_vulnerabilidad,
			V.nombre 'Nombre_Vulnerabilidad',
			F.presupuesto
	FROM	dbo.familias F
	INNER	JOIN dbo.vulnerabilidad V ON F.id_vulnerabilidad = V.id_vulnerabilidad
	WHERE  id_familia= ISNULL(@Id_Familia,id_familia)

END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerProductos]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerProductos]
 @Id_Inventario BIGINT
AS
BEGIN

	IF(@Id_Inventario = 0)
		SET @Id_Inventario = NULL
	
	SELECT id_inventario,	
		   I.nombre 'NombreProducto',
		   stock,
		   I.id_categoria,
		   C.nombre as 'NombreCategoria',
		   C.descripcion
	FROM inventario I
	JOIN categoria C ON I.id_categoria = C.id_categoria
	WHERE  id_inventario= ISNULL(@Id_Inventario,id_inventario)

END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerRoles]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerRoles]
AS
BEGIN

	

	SELECT *
	FROM rol


END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerUsuarios]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerUsuarios]
 @Id_usuario BIGINT
AS
BEGIN

	IF(@Id_usuario = 0)
		SET @Id_usuario = NULL
	
	SELECT	U.id_usuario,
			U.Nombre 'NombreUsuario',
			U.apellidos,
			U.username,
			Correo,
			U.id_rol,
			E.Id_EstadoRegistro,
			E.Nombre 'NombreEstadoRegistro',
			R.nombre 'NombreRol'
	FROM	dbo.usuarios U
	INNER	JOIN dbo.rol R ON U.id_rol = R.id_rol
	JOIN dbo.EstadoRegistro E ON U.Id_EstadoRegistro = E.Id_EstadoRegistro
	WHERE  id_usuario= ISNULL(@Id_usuario,id_usuario)

END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerUsuariosEspera]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerUsuariosEspera]
 @Id_usuario BIGINT
AS
BEGIN

	IF(@Id_usuario = 0)
		SET @Id_usuario = NULL
	
	SELECT	U.id_usuario,
			U.Nombre 'NombreUsuario',
			U.apellidos,
			U.username,
			Correo,
			U.id_rol,
			E.Id_EstadoRegistro,
			E.Nombre 'NombreEstadoRegistro',
			R.nombre 'NombreRol'
	FROM	dbo.usuarios U
	INNER	JOIN dbo.rol R ON U.id_rol = R.id_rol
	JOIN dbo.EstadoRegistro E ON U.Id_EstadoRegistro = E.Id_EstadoRegistro
	WHERE  id_usuario != @Id_usuario
	AND u.Id_EstadoRegistro = 3

END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerVoluntarios]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerVoluntarios]
 @Id_usuario BIGINT
AS
BEGIN

	IF(@Id_usuario = 0)
		SET @Id_usuario = NULL
	
	SELECT	U.id_usuario,
			U.Nombre 'NombreUsuario',
			U.apellidos,
			U.username,
			Correo,
			U.id_rol,
			E.Id_EstadoRegistro,
			E.Nombre 'NombreEstadoRegistro',
			R.nombre 'NombreRol'
	FROM	dbo.usuarios U
	INNER	JOIN dbo.rol R ON U.id_rol = R.id_rol
	JOIN dbo.EstadoRegistro E ON U.Id_EstadoRegistro = E.Id_EstadoRegistro
	WHERE  id_usuario != @Id_usuario
	AND u.Id_EstadoRegistro = 1

END
GO
/****** Object:  StoredProcedure [dbo].[ObtenerVulnerabilidad]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerVulnerabilidad]
AS
BEGIN

	

	SELECT id_vulnerabilidad,nombre
	FROM vulnerabilidad


END
GO
/****** Object:  StoredProcedure [dbo].[RecuperarContrasenna]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RecuperarContrasenna]
	@Id_usuario bigint,
	@Contrasenna varchar(50),
	@ContrasennaAnterior varchar(50),
	@VencimientoContraTemp Datetime
AS
BEGIN
	

		UPDATE usuarios
		SET password = @Contrasenna, password_temp_expiration = @VencimientoContraTemp, password_temp_status = 1
		WHERE Id_Usuario = @Id_Usuario


END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarArchivo]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RegistrarArchivo]
	 @Nombre NVARCHAR(255),
    @Tipo NVARCHAR(100),
    @Ruta NVARCHAR(500),
	@Id_Familia bigint
AS
BEGIN
	
	 IF NOT EXISTS(SELECT 1 FROM dbo.familias 
              WHERE id_familia = @Id_Familia)
    BEGIN
        RAISERROR('Familia no encontrada.', 16, 1);
    END
    ELSE
    BEGIN
       INSERT INTO dbo.Expedientes (Nombre, Tipo, Ruta, FechaSubida,Id_Familia)
		VALUES (@Nombre, @Tipo, @Ruta,GETDATE(),@Id_Familia);
    END

	

END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarEvento]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarEvento]
	@Nombre_Evento varchar(50),
	@Descripcion text,
	@Fecha_Inicio datetime,
	@Fecha_Final datetime,
	@Color varchar(7),
	@invitados text
AS
BEGIN
    INSERT INTO dbo.Eventos (Nombre_Evento, Descripcion, Fecha_Inicio, Fecha_Final, Color, Invitados)
    VALUES (@Nombre_Evento, @Descripcion, @Fecha_Inicio, @Fecha_Final, @Color, @invitados)
END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarFamilia]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RegistrarFamilia]
    @Nombre_Representante nvarchar(100),
    @Cedula_Representante varchar(100),
    @Direccion nvarchar(255),
    @Telefono varchar(8),
    @Cantidad_Familiares int,
	@Cantidad_Ninos int,
	@Id_Vulnerabilidad int
AS
BEGIN

    IF EXISTS(SELECT 1 FROM dbo.familias 
              WHERE nombre_representante = @Nombre_Representante
                 OR cedula_representante = @Cedula_Representante)
    BEGIN
        RAISERROR('El nombre del representante ya tiene una familia registrada.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO dbo.familias(nombre_representante, cedula_representante, direccion, telefono, cantidad_familiares, cantidad_ninos, id_vulnerabilidad)
        VALUES (@Nombre_Representante, @Cedula_Representante, @Direccion, @Telefono, @Cantidad_Familiares, @Cantidad_Ninos, @Id_Vulnerabilidad)
    END

END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarProducto]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RegistrarProducto]
    @NombreProducto nvarchar(100),
	@Id_Categoria INT ,
    @stock INT
AS
BEGIN

    IF EXISTS(SELECT 1 FROM dbo.inventario 
              WHERE nombre = @NombreProducto)
    BEGIN
        RAISERROR('Este producto ya esta registrado.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO dbo.inventario(nombre,id_categoria,stock)
        VALUES (@NombreProducto,@Id_Categoria, @stock)
    END

END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarUsuario]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RegistrarUsuario]
    @NombreUsuario nvarchar(100),
	@Cedula varchar(50) ,
    @Apellidos nvarchar(100),
    @Correo nvarchar(100),
    @Username nvarchar(100),
    @Password nvarchar(100)
AS
BEGIN

    IF EXISTS(SELECT 1 FROM dbo.usuarios 
              WHERE Cedula = @Cedula
                 OR Correo = @Correo)
    BEGIN
        RAISERROR('La cedula o correo ya existe.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO dbo.usuarios(nombre,cedula,apellidos, Correo, username, password, id_rol, fecha_registro, password_temp_status, password_temp_expiration,Id_EstadoRegistro)
        VALUES (@NombreUsuario,@Cedula, @Apellidos, @Correo, @Username, @Password, 2, GETDATE(), 0, NULL,3)
    END

END
GO
/****** Object:  StoredProcedure [dbo].[VerificarCorreo]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[VerificarCorreo]
	@Correo nvarchar(100)
AS
BEGIN
	
	SELECT	U.id_usuario,
			U.Nombre 'NombreUsuario',
			apellidos,
			r.nombre as 'NombreRol',
			Correo,
			Cedula,
			username,
			E.Nombre 'NombreEstadoRegistro'
	FROM	dbo.EstadoRegistro E
	JOIN dbo.usuarios U ON E.Id_EstadoRegistro = U.Id_EstadoRegistro
	JOIN dbo.rol r  ON U.id_rol = r.id_rol
	WHERE   correo = @Correo

END
GO
/****** Object:  StoredProcedure [dbo].[VerificarIsVoluntario]    Script Date: 20/06/2025 10:07:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[VerificarIsVoluntario]
	@Cedula nvarchar(100)
AS
BEGIN
	
	SELECT	U.id_usuario,
			U.Nombre 'NombreUsuario',
			apellidos,
			r.nombre as 'NombreRol',
			Correo,
			U.Cedula
			username,
			E.Nombre 'NombreEstadoRegistro'
	FROM	dbo.EstadoRegistro E
	JOIN dbo.usuarios U ON E.Id_EstadoRegistro = U.Id_EstadoRegistro
	JOIN dbo.rol r  ON U.id_rol = r.id_rol
	WHERE   Cedula = @Cedula

END
GO
USE [master]
GO
ALTER DATABASE [AbrazosDB] SET  READ_WRITE 
GO
