USE [master]
GO
/****** Object:  Database [AbrazosDB]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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
/****** Object:  Table [dbo].[categoria]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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
/****** Object:  Table [dbo].[Expedientes]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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
 CONSTRAINT [PK_Expedientes] PRIMARY KEY CLUSTERED 
(
	[Id_Archivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[familias]    Script Date: 26/03/2025 04:20:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[familias](
	[id_familia] [int] IDENTITY(1,1) NOT NULL,
	[nombre_representante] [nvarchar](100) NOT NULL,
	[direccion] [nvarchar](255) NOT NULL,
	[telefono] [char](8) NOT NULL,
	[cantidad_familiares] [int] NOT NULL,
	[cantidad_ninos] [int] NOT NULL,
	[id_vulnerabilidad] [int] NULL,
	[presupuesto] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_familia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[inventario]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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
/****** Object:  Table [dbo].[presupuestos]    Script Date: 26/03/2025 04:20:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[presupuestos](
	[id_presupuesto] [int] IDENTITY(1,1) NOT NULL,
	[id_familia] [int] NOT NULL,
	[monto_total] [decimal](10, 2) NOT NULL,
	[descripcion] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_presupuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rol]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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
/****** Object:  Table [dbo].[usuarios]    Script Date: 26/03/2025 04:20:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios](
	[id_usuario] [bigint] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
	[apellidos] [nvarchar](100) NOT NULL,
	[correo] [nvarchar](100) NOT NULL,
	[username] [nvarchar](100) NOT NULL,
	[password] [nvarchar](100) NOT NULL,
	[id_rol] [int] NOT NULL,
	[fecha_registro] [date] NOT NULL,
	[password_temp_status] [bit] NULL,
	[password_temp_expiration] [datetime] NULL,
 CONSTRAINT [PK__usuarios__4E3E04AD0492928B] PRIMARY KEY CLUSTERED 
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voluntarios]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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
/****** Object:  Table [dbo].[vulnerabilidad]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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
SET IDENTITY_INSERT [dbo].[Expedientes] ON 
GO
INSERT [dbo].[Expedientes] ([Id_Archivo], [Nombre], [Tipo], [Ruta], [FechaSubida]) VALUES (1, N'TCU req.docx', N'application/vnd.openxmlformats-officedocument.wordprocessingml.document', N'D:\Ufidelitas\TCU\TCUApi\TCUApi\ArchivosSubidos\TCU req.docx', CAST(N'2025-03-26T12:45:48.760' AS DateTime))
GO
INSERT [dbo].[Expedientes] ([Id_Archivo], [Nombre], [Tipo], [Ruta], [FechaSubida]) VALUES (3, N'SebastianCoto_SC707_V_Portafolio1.pdf', N'application/pdf', N'iMrstGkUck5z09C48YoPhm/N+skRXMNzEU3VRzJykCrio41+N6ElJdAuJx3Xmx04f3ErP8zY6k81Pje8S2R5ByYLjdZg2ethfK7CkciGABoMseYzXJI8pgEK2qzf48d8', CAST(N'2025-03-26T13:24:48.923' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Expedientes] OFF
GO
SET IDENTITY_INSERT [dbo].[rol] ON 
GO
INSERT [dbo].[rol] ([id_rol], [nombre]) VALUES (1, N'Administrador')
GO
INSERT [dbo].[rol] ([id_rol], [nombre]) VALUES (2, N'Voluntario')
GO
SET IDENTITY_INSERT [dbo].[rol] OFF
GO
SET IDENTITY_INSERT [dbo].[usuarios] ON 
GO
INSERT [dbo].[usuarios] ([id_usuario], [nombre], [apellidos], [correo], [username], [password], [id_rol], [fecha_registro], [password_temp_status], [password_temp_expiration]) VALUES (1, N'Sebastian', N'Coto Gonzalez', N'secogonzalez2005@gmail.com', N'SebasCoto', N'123', 1, CAST(N'2025-02-24' AS Date), 0, NULL)
GO
INSERT [dbo].[usuarios] ([id_usuario], [nombre], [apellidos], [correo], [username], [password], [id_rol], [fecha_registro], [password_temp_status], [password_temp_expiration]) VALUES (4, N'Laura', N'Gonzalez', N'lgc2811@gmail.com', N'lgonzalez', N'JK75RNPA9J', 2, CAST(N'2025-03-26' AS Date), 0, NULL)
GO
SET IDENTITY_INSERT [dbo].[usuarios] OFF
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
ALTER TABLE [dbo].[usuarios]  WITH CHECK ADD  CONSTRAINT [FK_USUARIOS_ROL] FOREIGN KEY([id_rol])
REFERENCES [dbo].[rol] ([id_rol])
GO
ALTER TABLE [dbo].[usuarios] CHECK CONSTRAINT [FK_USUARIOS_ROL]
GO
ALTER TABLE [dbo].[voluntarios]  WITH CHECK ADD  CONSTRAINT [FK_VOLUNTARIOS_USUARIOS] FOREIGN KEY([id_usuario])
REFERENCES [dbo].[usuarios] ([id_usuario])
GO
ALTER TABLE [dbo].[voluntarios] CHECK CONSTRAINT [FK_VOLUNTARIOS_USUARIOS]
GO
/****** Object:  StoredProcedure [dbo].[ActualizarUsuario]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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

    IF EXISTS(SELECT 1 FROM dbo.usuarios 
              WHERE username = @Username
                 OR Correo = @Correo)
    BEGIN
        RAISERROR('El nombre de usuario o correo ya existe.', 16, 1);
    END
    ELSE
    BEGIN
        UPDATE dbo.usuarios SET nombre = @NombreUsuario, apellidos = @Apellidos, correo =@Correo,username =@Username,id_rol = @Id_Rol
		WHERE id_usuario = @Id_Usuario
    END

END
GO
/****** Object:  StoredProcedure [dbo].[DescargarArchivo]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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
/****** Object:  StoredProcedure [dbo].[EliminarUsuario]    Script Date: 26/03/2025 04:20:07 p. m. ******/
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
/****** Object:  StoredProcedure [dbo].[IniciarSesion]    Script Date: 26/03/2025 04:20:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IniciarSesion]
	@username varchar(15),
	@password varchar(50)
AS
BEGIN
	
	SELECT	U.id_usuario,
			U.Nombre 'NombreUsuario',
			apellidos,
			r.nombre as 'NombreRol',
			Correo,
			username
	FROM	dbo.usuarios U
	JOIN dbo.rol r  ON U.id_rol = r.id_rol
	WHERE   username = @username
		AND password = @password

END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarArchivo]    Script Date: 26/03/2025 04:20:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RegistrarArchivo]
	 @Nombre NVARCHAR(255),
    @Tipo NVARCHAR(100),
    @Ruta NVARCHAR(500)
AS
BEGIN
	
	INSERT INTO dbo.Expedientes (Nombre, Tipo, Ruta, FechaSubida)
    VALUES (@Nombre, @Tipo, @Ruta,GETDATE());

END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarUsuario]    Script Date: 26/03/2025 04:20:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RegistrarUsuario]
    @NombreUsuario nvarchar(100),
    @Apellidos nvarchar(100),
    @Correo nvarchar(100),
    @Username nvarchar(100),
    @Password nvarchar(100),
    @Id_Rol int
AS
BEGIN

    IF EXISTS(SELECT 1 FROM dbo.usuarios 
              WHERE username = @Username
                 OR Correo = @Correo)
    BEGIN
        RAISERROR('El nombre de usuario o correo ya existe.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO dbo.usuarios(nombre, apellidos, Correo, username, password, id_rol, fecha_registro, password_temp_status, password_temp_expiration)
        VALUES (@NombreUsuario, @Apellidos, @Correo, @Username, @Password, @Id_Rol, GETDATE(), 0, NULL)
    END

END
GO
USE [master]
GO
ALTER DATABASE [AbrazosDB] SET  READ_WRITE 
GO
