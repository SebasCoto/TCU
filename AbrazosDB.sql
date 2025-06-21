CREATE DATABASE  IF NOT EXISTS `abrazosdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `abrazosdb`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: abrazosdb
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `archivosuser`
--

DROP TABLE IF EXISTS `archivosuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archivosuser` (
  `Id_ArchivoUser` bigint NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Tipo` varchar(255) NOT NULL,
  `Ruta` varchar(500) NOT NULL,
  `FechaSubida` datetime NOT NULL,
  PRIMARY KEY (`Id_ArchivoUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archivosuser`
--

LOCK TABLES `archivosuser` WRITE;
/*!40000 ALTER TABLE `archivosuser` DISABLE KEYS */;
/*!40000 ALTER TABLE `archivosuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoria`
--

DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria` (
  `id_categoria` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Comestibles','Productos para la alimentacion de las familias'),(2,'Ropa','Ropa para las familias');
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estadoregistro`
--

DROP TABLE IF EXISTS `estadoregistro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estadoregistro` (
  `Id_EstadoRegistro` bigint NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`Id_EstadoRegistro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estadoregistro`
--

LOCK TABLES `estadoregistro` WRITE;
/*!40000 ALTER TABLE `estadoregistro` DISABLE KEYS */;
INSERT INTO `estadoregistro` VALUES (1,'Aceptado'),(2,'Denegado'),(3,'En espera');
/*!40000 ALTER TABLE `estadoregistro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventos`
--

DROP TABLE IF EXISTS `eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventos` (
  `Id_Evento` bigint NOT NULL AUTO_INCREMENT,
  `Nombre_Evento` varchar(50) NOT NULL,
  `Descripcion` longtext NOT NULL,
  `Fecha_Inicio` datetime NOT NULL,
  `Fecha_Final` datetime NOT NULL,
  `Color` varchar(7) NOT NULL,
  `invitados` longtext NOT NULL,
  PRIMARY KEY (`Id_Evento`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventos`
--

LOCK TABLES `eventos` WRITE;
/*!40000 ALTER TABLE `eventos` DISABLE KEYS */;
/*!40000 ALTER TABLE `eventos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expedientes`
--

DROP TABLE IF EXISTS `expedientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expedientes` (
  `Id_Archivo` bigint NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Tipo` varchar(255) NOT NULL,
  `Ruta` varchar(500) NOT NULL,
  `FechaSubida` datetime NOT NULL,
  `Id_Familia` bigint NOT NULL,
  PRIMARY KEY (`Id_Archivo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expedientes`
--

LOCK TABLES `expedientes` WRITE;
/*!40000 ALTER TABLE `expedientes` DISABLE KEYS */;
INSERT INTO `expedientes` VALUES (2,'CasoEsatudio1.pdf','application/pdf','iMrstGkUck5z09C48YoPhm/N+skRXMNzEU3VRzJykCrio41+N6ElJdAuJx3Xmx04j+htGmVRGCOLzpIFvwRtgUHUURFJOegQ1hKVXh9fsr4=','2025-04-01 11:27:13',2);
/*!40000 ALTER TABLE `expedientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `familias`
--

DROP TABLE IF EXISTS `familias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `familias` (
  `id_familia` bigint NOT NULL AUTO_INCREMENT,
  `nombre_representante` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `direccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `telefono` varchar(8) NOT NULL,
  `cantidad_familiares` int NOT NULL,
  `cantidad_ninos` int NOT NULL,
  `id_vulnerabilidad` int NOT NULL,
  `presupuesto` decimal(10,2) DEFAULT NULL,
  `cedula_representante` varchar(100) NOT NULL,
  PRIMARY KEY (`id_familia`),
  KEY `FK_FAMILIAS_VULNERABILIDAD` (`id_vulnerabilidad`),
  CONSTRAINT `FK_FAMILIAS_VULNERABILIDAD` FOREIGN KEY (`id_vulnerabilidad`) REFERENCES `vulnerabilidad` (`id_vulnerabilidad`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `familias`
--

LOCK TABLES `familias` WRITE;
/*!40000 ALTER TABLE `familias` DISABLE KEYS */;
INSERT INTO `familias` VALUES (2,'STEVEN ROBERT CLOUDT ACHOY','Cartago Centro','12345678',4,3,2,126315.79,'901190754');
/*!40000 ALTER TABLE `familias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `id_inventario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `id_categoria` int NOT NULL,
  `stock` int NOT NULL,
  PRIMARY KEY (`id_inventario`),
  KEY `FK_INVENTARIO_CATEGORIA` (`id_categoria`),
  CONSTRAINT `FK_INVENTARIO_CATEGORIA` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=2011 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES (2010,'Frijoles',1,23);
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `id_rol` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (1,'Administrador'),(2,'Voluntario');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` bigint NOT NULL AUTO_INCREMENT,
  `Cedula` varchar(50) NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `apellidos` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `correo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `id_rol` int NOT NULL,
  `fecha_registro` date NOT NULL,
  `password_temp_status` tinyint(1) DEFAULT NULL,
  `password_temp_expiration` datetime DEFAULT NULL,
  `Id_ArchivosUser` bigint DEFAULT NULL,
  `Id_EstadoRegistro` bigint DEFAULT NULL,
  `telefono` int NOT NULL,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (4,'305590015','SEBASTIAN','COTO GONZALEZ	','secogonzalez2005@gmail.com','scoto','Y4dZkkZdfWjaSVA6O/HUOg==',1,'2025-04-25',0,'2025-06-20 13:07:23',NULL,1,0);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vulnerabilidad`
--

DROP TABLE IF EXISTS `vulnerabilidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vulnerabilidad` (
  `id_vulnerabilidad` int NOT NULL,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id_vulnerabilidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vulnerabilidad`
--

LOCK TABLES `vulnerabilidad` WRITE;
/*!40000 ALTER TABLE `vulnerabilidad` DISABLE KEYS */;
INSERT INTO `vulnerabilidad` VALUES (1,'Alta'),(2,'Media'),(3,'Baja');
/*!40000 ALTER TABLE `vulnerabilidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'abrazosdb'
--

--
-- Dumping routines for database 'abrazosdb'
--
/*!50003 DROP PROCEDURE IF EXISTS `AccesoUsuarios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `AccesoUsuarios`(
    IN p_Id_Usuario BIGINT,
    IN p_Id_EstadoRegistro BIGINT
)
BEGIN
    -- Actualizar el estado del usuario
    UPDATE usuarios 
    SET Id_EstadoRegistro = p_Id_EstadoRegistro
    WHERE id_usuario = p_Id_Usuario;

    -- Si el nuevo estado es 2, eliminar el usuario
    IF p_Id_EstadoRegistro = 2 THEN
        DELETE FROM usuarios 
        WHERE id_usuario = p_Id_Usuario
        AND Id_EstadoRegistro = 2;

        SELECT 'ELIMINADO' AS Nombre;
    ELSE
        SELECT Nombre 
        FROM EstadoRegistro 
        WHERE Id_EstadoRegistro = p_Id_EstadoRegistro;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ActualizarContrasenna` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ActualizarContrasenna`(
    IN p_Id_usuario BIGINT,
    IN p_Contrasena VARCHAR(50),
    IN p_ContrasennaAnterior VARCHAR(100),
    IN p_ContrasennaConfirmar VARCHAR(100)
)
BEGIN
    DECLARE v_PasswordActual VARCHAR(100);

    SELECT password INTO v_PasswordActual
    FROM usuarios 
    WHERE id_usuario = p_Id_usuario;

    IF p_ContrasennaAnterior = v_PasswordActual THEN
        UPDATE usuarios
        SET password = p_Contrasena,
            password_temp_status = 0,
            password_temp_expiration = NOW(3)
        WHERE id_usuario = p_Id_usuario;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La contraseña anterior no es correcta.';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ActualizarEvento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ActualizarEvento`(
    IN p_Id_Evento BIGINT,
    IN p_Nombre_Evento VARCHAR(50),
    IN p_Descripcion TEXT,
    IN p_Fecha_Inicio DATETIME,
    IN p_Fecha_Final DATETIME
)
BEGIN
    UPDATE Eventos
    SET Nombre_Evento = p_Nombre_Evento,
        Descripcion = p_Descripcion,
        Fecha_Inicio = p_Fecha_Inicio,
        Fecha_Final = p_Fecha_Final
    WHERE Id_Evento = p_Id_Evento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ActualizarFamilia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ActualizarFamilia`(
    IN p_Id_Familia BIGINT,
    IN p_Nombre_Representante VARCHAR(100),
    IN p_Cedula_Representante VARCHAR(100),
    IN p_Direccion VARCHAR(255),
    IN p_Telefono VARCHAR(8),
    IN p_Cantidad_Familiares INT,
    IN p_Cantidad_Ninos INT,
    IN p_Id_Vulnerabilidad INT
)
BEGIN
    DECLARE v_SUMA_PRESUPUESTO DOUBLE;

    IF NOT EXISTS (
        SELECT 1 FROM familias WHERE id_familia = p_Id_Familia
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se encuentra la familia.';
    ELSE
        UPDATE familias
        SET nombre_representante = p_Nombre_Representante,
            cedula_representante = p_Cedula_Representante,
            direccion = p_Direccion,
            telefono = p_Telefono,
            cantidad_familiares = p_Cantidad_Familiares,
            cantidad_ninos = p_Cantidad_Ninos,
            id_vulnerabilidad = p_Id_Vulnerabilidad
        WHERE id_familia = p_Id_Familia;

        SELECT SUM(presupuesto) INTO v_SUMA_PRESUPUESTO
        FROM familias;

        CALL CalcularPresupuesto(v_SUMA_PRESUPUESTO);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ActualizarProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ActualizarProducto`(
    IN p_Id_Inventario INT,
    IN p_NombreProducto VARCHAR(100),
    IN p_Id_Categoria INT,
    IN p_stock INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM inventario 
        WHERE nombre = p_NombreProducto AND id_inventario != p_Id_Inventario
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto ya existe.';
    ELSE
        UPDATE inventario 
        SET nombre = p_NombreProducto, 
            id_categoria = p_Id_Categoria, 
            stock = p_stock
        WHERE id_inventario = p_Id_Inventario;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ActualizarUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ActualizarUsuario`(
    IN p_Id_Usuario BIGINT,
    IN p_NombreUsuario VARCHAR(100),
    IN p_Apellidos VARCHAR(100),
    IN p_Correo VARCHAR(100),
    IN p_Username VARCHAR(100),
    IN p_Id_Rol INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM usuarios 
        WHERE (username = p_Username OR correo = p_Correo)
        AND id_usuario <> p_Id_Usuario
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre de usuario o correo ya existe.';
    ELSE
        IF EXISTS (
            SELECT 1 FROM usuarios
            WHERE id_usuario = p_Id_Usuario AND (
                nombre <> p_NombreUsuario OR
                apellidos <> p_Apellidos OR
                correo <> p_Correo OR
                username <> p_Username OR
                id_rol <> p_Id_Rol
            )
        ) THEN
            UPDATE usuarios 
            SET nombre = p_NombreUsuario, 
                apellidos = p_Apellidos, 
                correo = p_Correo,
                username = p_Username,
                id_rol = p_Id_Rol
            WHERE id_usuario = p_Id_Usuario;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se realizaron cambios, los datos son iguales.';
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CalcularPresupuesto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `CalcularPresupuesto`(
    IN p_MONTO_TOTAL DECIMAL(10,2)
)
BEGIN
    DECLARE v_SUMA_FACTORES DOUBLE;

    DROP TEMPORARY TABLE IF EXISTS FamiliasTemp;

    CREATE TEMPORARY TABLE FamiliasTemp (
        ID_FAMILIA INT,
        FACTOR DOUBLE
    );

    INSERT INTO FamiliasTemp (ID_FAMILIA, FACTOR)
    SELECT 
        ID_FAMILIA,
        (1.0 * cantidad_familiares) + 
        (2.0 * cantidad_ninos) + 
        CASE id_vulnerabilidad 
            WHEN 1 THEN 3.0
            WHEN 2 THEN 2.0
            WHEN 3 THEN 1.0
            ELSE 1.0
        END AS FACTOR
    FROM Familias;

    SELECT SUM(FACTOR) INTO v_SUMA_FACTORES FROM FamiliasTemp;

    IF v_SUMA_FACTORES = 0 THEN
        SELECT 'No hay familias registradas o no tienen factores válidos.' AS mensaje;
    ELSE
        UPDATE Familias F
        JOIN FamiliasTemp T ON F.ID_FAMILIA = T.ID_FAMILIA
        SET F.presupuesto = (p_MONTO_TOTAL * T.FACTOR) / v_SUMA_FACTORES;

        SELECT 'Presupuesto calculado y actualizado proporcionalmente.' AS mensaje;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EliminarEvento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `EliminarEvento`(
    IN p_Id_Evento BIGINT
)
BEGIN
    DELETE FROM Eventos
    WHERE Id_Evento = p_Id_Evento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EliminarFamilia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `EliminarFamilia`(
    IN p_Id_Familia BIGINT
)
BEGIN
    DELETE FROM familias
    WHERE id_familia = p_Id_Familia;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EliminarProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `EliminarProducto`(
    IN p_Id_Inventario INT
)
BEGIN
    DELETE FROM inventario
    WHERE id_inventario = p_Id_Inventario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EliminarUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `EliminarUsuario`(
    IN p_Id_Usuario BIGINT
)
BEGIN
    DELETE FROM usuarios
    WHERE id_usuario = p_Id_Usuario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IniciarSesion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `IniciarSesion`(
    IN Username VARCHAR(100),
    IN p_password VARCHAR(100)
)
BEGIN
    SELECT
        U.id_usuario,
        U.Nombre AS NombreUsuario,
        U.apellidos,
        r.nombre AS NombreRol,
        U.Correo,
        U.Id_EstadoRegistro,
        U.username,
        U.password_temp_status
    FROM usuarios U
    JOIN rol r ON U.id_rol = r.id_rol
    WHERE U.username = Username
      AND U.password = p_password;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `MostrarEventos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `MostrarEventos`(
    IN p_Id_Evento BIGINT
)
BEGIN
    IF p_Id_Evento = 0 THEN
        SET p_Id_Evento = NULL;
    END IF;

    SELECT *
    FROM Eventos
    WHERE Id_Evento = COALESCE(p_Id_Evento, Id_Evento);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerCategorias` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerCategorias`()
BEGIN
    SELECT id_categoria, nombre
    FROM categoria;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerCorreoById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerCorreoById`(
    IN p_Id_usuario BIGINT
)
BEGIN
    SELECT correo
    FROM usuarios
    WHERE id_usuario = p_Id_usuario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerCorreosSeleccionados` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerCorreosSeleccionados`(
    IN p_CorreoLogueado VARCHAR(100),
    IN p_Filtro VARCHAR(100)
)
BEGIN
    SELECT nombre, correo
    FROM usuarios
    WHERE correo != p_CorreoLogueado
      AND (p_Filtro IS NULL OR nombre LIKE CONCAT('%', p_Filtro, '%'));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerEstados` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerEstados`()
BEGIN
    SELECT Id_EstadoRegistro, Nombre FROM EstadoRegistro;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerExpedientes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerExpedientes`(
    IN p_Id_Expediente BIGINT
)
BEGIN
    DECLARE v_exist INT DEFAULT 0;

    SELECT COUNT(*) INTO v_exist FROM Expedientes WHERE Id_Archivo = p_Id_Expediente;

    IF v_exist = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Expediente no encontrado.';
    ELSE
        IF p_Id_Expediente = 0 THEN
            SET p_Id_Expediente = NULL;
        END IF;

        SELECT 
            E.Id_Archivo,
            E.Nombre,
            E.FechaSubida,
            E.Id_Familia,
            F.nombre_representante AS NombreRepresentante
        FROM Expedientes E
        INNER JOIN familias F ON E.Id_Familia = F.id_familia
        WHERE E.Id_Archivo = COALESCE(p_Id_Expediente, E.Id_Archivo);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerFamilias` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerFamilias`(
    IN p_Id_Familia BIGINT
)
BEGIN
    IF p_Id_Familia = 0 THEN
        SET p_Id_Familia = NULL;
    END IF;

    SELECT
        F.id_familia,
        F.nombre_representante,
        F.cedula_representante,
        F.direccion,
        F.telefono,
        F.cantidad_familiares,
        F.cantidad_ninos,
        F.presupuesto,
        F.id_vulnerabilidad,
        V.nombre AS Nombre_Vulnerabilidad,
        F.presupuesto
    FROM familias F
    INNER JOIN vulnerabilidad V ON F.id_vulnerabilidad = V.id_vulnerabilidad
    WHERE F.id_familia = COALESCE(p_Id_Familia, F.id_familia);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerProductos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerProductos`(
    IN p_Id_Inventario BIGINT
)
BEGIN
    IF p_Id_Inventario = 0 THEN
        SET p_Id_Inventario = NULL;
    END IF;

    SELECT 
        I.id_inventario,
        I.nombre AS NombreProducto,
        I.stock,
        I.id_categoria,
        C.nombre AS NombreCategoria,
        C.descripcion
    FROM inventario I
    JOIN categoria C ON I.id_categoria = C.id_categoria
    WHERE I.id_inventario = COALESCE(p_Id_Inventario, I.id_inventario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerRoles` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerRoles`()
BEGIN
    SELECT * FROM rol;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerUsuarios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerUsuarios`(IN p_Id_usuario BIGINT)
BEGIN
    IF p_Id_usuario = 0 THEN
        SET p_Id_usuario = NULL;
    END IF;

    SELECT  
        U.id_usuario,
        U.Nombre AS NombreUsuario,
        U.apellidos,
        U.username,
        U.Correo,
        U.id_rol,
        E.Id_EstadoRegistro,
        E.Nombre AS NombreEstadoRegistro,
        R.nombre AS NombreRol
    FROM usuarios U
    INNER JOIN rol R ON U.id_rol = R.id_rol
    INNER JOIN EstadoRegistro E ON U.Id_EstadoRegistro = E.Id_EstadoRegistro
    WHERE U.id_usuario = COALESCE(p_Id_usuario, U.id_usuario);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerUsuariosEspera` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerUsuariosEspera`(IN p_Id_usuario BIGINT)
BEGIN
    IF p_Id_usuario = 0 THEN
        SET p_Id_usuario = NULL;
    END IF;

    SELECT  
        U.id_usuario,
        U.Nombre AS NombreUsuario,
        U.apellidos,
        U.username,
        U.Correo,
        U.id_rol,
        E.Id_EstadoRegistro,
        U.Telefono,
        E.Nombre AS NombreEstadoRegistro,
        R.nombre AS NombreRol
    FROM usuarios U
    INNER JOIN rol R ON U.id_rol = R.id_rol
    INNER JOIN EstadoRegistro E ON U.Id_EstadoRegistro = E.Id_EstadoRegistro
    WHERE U.id_usuario != p_Id_usuario
      AND U.Id_EstadoRegistro = 3;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerVoluntarios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerVoluntarios`(IN p_Id_usuario BIGINT)
BEGIN
    IF p_Id_usuario = 0 THEN
        SET p_Id_usuario = NULL;
    END IF;

    SELECT  
        U.id_usuario,
        U.Nombre AS NombreUsuario,
        U.apellidos,
        U.username,
        U.Correo,
        U.id_rol,
        E.Id_EstadoRegistro,
        E.Nombre AS NombreEstadoRegistro,
        R.nombre AS NombreRol
    FROM usuarios U
    INNER JOIN rol R ON U.id_rol = R.id_rol
    INNER JOIN EstadoRegistro E ON U.Id_EstadoRegistro = E.Id_EstadoRegistro
    WHERE U.id_usuario != p_Id_usuario
      AND U.Id_EstadoRegistro = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ObtenerVulnerabilidad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `ObtenerVulnerabilidad`()
BEGIN
    SELECT id_vulnerabilidad, nombre FROM vulnerabilidad;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RecuperarContrasenna` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `RecuperarContrasenna`(
    IN p_Id_usuario BIGINT,
    IN p_Contrasenna VARCHAR(50),
    IN p_ContrasennaAnterior VARCHAR(50),
    IN p_VencimientoContraTemp DATETIME
)
BEGIN
    UPDATE usuarios
    SET password = p_Contrasenna,
        password_temp_expiration = p_VencimientoContraTemp,
        password_temp_status = 1
    WHERE id_usuario = p_Id_usuario;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RegistrarArchivo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `RegistrarArchivo`(
    IN p_Nombre VARCHAR(255),
    IN p_Tipo VARCHAR(100),
    IN p_Ruta VARCHAR(500),
    IN p_Id_Familia BIGINT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM familias WHERE id_familia = p_Id_Familia) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Familia no encontrada.';
    ELSE
        INSERT INTO Expedientes (Nombre, Tipo, Ruta, FechaSubida, Id_Familia)
        VALUES (p_Nombre, p_Tipo, p_Ruta, NOW(), p_Id_Familia);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RegistrarEvento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `RegistrarEvento`(
    IN p_Nombre_Evento VARCHAR(50),
    IN p_Descripcion TEXT,
    IN p_Fecha_Inicio DATETIME,
    IN p_Fecha_Final DATETIME,
    IN p_Color VARCHAR(7),
    IN p_invitados TEXT
)
BEGIN
    INSERT INTO Eventos (Nombre_Evento, Descripcion, Fecha_Inicio, Fecha_Final, Color, Invitados)
    VALUES (p_Nombre_Evento, p_Descripcion, p_Fecha_Inicio, p_Fecha_Final, p_Color, p_invitados);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RegistrarFamilia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `RegistrarFamilia`(
    IN p_Nombre_Representante VARCHAR(100),
    IN p_Cedula_Representante VARCHAR(100),
    IN p_Direccion VARCHAR(255),
    IN p_Telefono VARCHAR(8),
    IN p_Cantidad_Familiares INT,
    IN p_Cantidad_Ninos INT,
    IN p_Id_Vulnerabilidad INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM familias 
        WHERE nombre_representante = p_Nombre_Representante
           OR cedula_representante = p_Cedula_Representante
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El nombre del representante ya tiene una familia registrada.';
    ELSE
        INSERT INTO familias(
            nombre_representante, cedula_representante, direccion, telefono, 
            cantidad_familiares, cantidad_ninos, id_vulnerabilidad)
        VALUES (
            p_Nombre_Representante, p_Cedula_Representante, p_Direccion, p_Telefono, 
            p_Cantidad_Familiares, p_Cantidad_Ninos, p_Id_Vulnerabilidad
        );
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RegistrarProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `RegistrarProducto`(
    IN p_NombreProducto VARCHAR(100),
    IN p_Id_Categoria INT,
    IN p_stock INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM inventario WHERE nombre = p_NombreProducto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este producto ya esta registrado.';
    ELSE
        INSERT INTO inventario(nombre, id_categoria, stock)
        VALUES (p_NombreProducto, p_Id_Categoria, p_stock);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RegistrarUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `RegistrarUsuario`(
    IN p_NombreUsuario VARCHAR(100),
    IN p_Cedula VARCHAR(50),
    IN p_Apellidos VARCHAR(100),
    IN p_Correo VARCHAR(100),
    IN p_Username VARCHAR(100),
    IN p_Password VARCHAR(100),
    IN p_Telefono INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM usuarios
        WHERE Cedula = p_Cedula
           OR Correo = p_Correo
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cedula o correo ya existe.';
    ELSE
        INSERT INTO usuarios(
            nombre, cedula, apellidos, Correo, username, password, 
            id_rol, fecha_registro, password_temp_status, password_temp_expiration, Id_EstadoRegistro, telefono
        )
        VALUES (
            p_NombreUsuario, p_Cedula, p_Apellidos, p_Correo, p_Username, p_Password, 
            2, NOW(), 0, NULL, 3, p_Telefono
        );
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `VerificarCorreo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `VerificarCorreo`(
    IN p_Correo VARCHAR(100)
)
BEGIN
    SELECT  U.id_usuario,
            U.Nombre AS NombreUsuario,
            U.apellidos,
            r.nombre AS NombreRol,
            U.Correo,
            U.Cedula,
            U.username,
            E.Nombre AS NombreEstadoRegistro
    FROM EstadoRegistro E
    JOIN usuarios U ON E.Id_EstadoRegistro = U.Id_EstadoRegistro
    JOIN rol r ON U.id_rol = r.id_rol
    WHERE U.Correo = p_Correo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `VerificarIsVoluntario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`adminAbrazos`@`%` PROCEDURE `VerificarIsVoluntario`(
    IN p_Cedula VARCHAR(100)
)
BEGIN
    SELECT  U.id_usuario,
            U.Nombre AS NombreUsuario,
            U.apellidos,
            r.nombre AS NombreRol,
            U.Correo,
            U.Cedula,
            U.username,
            E.Nombre AS NombreEstadoRegistro
    FROM EstadoRegistro E
    JOIN usuarios U ON E.Id_EstadoRegistro = U.Id_EstadoRegistro
    JOIN rol r ON U.id_rol = r.id_rol
    WHERE U.Cedula = p_Cedula;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-20 14:00:33
