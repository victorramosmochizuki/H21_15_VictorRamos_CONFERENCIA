-- Crear base de datos H21_EVENTOS
CREATE DATABASE H21_EVENTOS;
GO


-- Ponemos en uso la base de datos H21_EVENTOS
USE H21_EVENTOS;
GO


-- Crear tabla PARTICIPANTE
CREATE TABLE PARTICIPANTE (
	IDPAR int NOT NULL IDENTITY (1,1),
	NOMPAR varchar(30) NOT NULL,
	APEPAR varchar(30) NOT NULL,
	DNIPAR char(8) NOT NULL,
	ESTPAR char(1) NOT NULL,
	CONSTRAINT Pk_PARTICIPANTE PRIMARY KEY (IDPAR)   
)
GO



-- Crear tabla PONENTE
CREATE TABLE PONENTE (
	IDPON int NOT NULL IDENTITY (1,1),
	NOMPON varchar(30) NOT NULL,
	APEPON varchar(30) NOT NULL,
	DNIPON char(8) NOT NULL,
	ESTPON char(1) NOT NULL,
	CONSTRAINT Pk_PONENTE PRIMARY KEY (IDPON)   
)
GO

-- Crear tabla VENDEDOR
CREATE TABLE VENDEDOR (
	IDVEN int NOT NULL IDENTITY (1,1),
	NOMVEN varchar(30) NOT NULL,
	APEVEN varchar(30) NOT NULL,
	DNIVEN char(8) NOT NULL,
	TELFVEN char(9),
	ESTVEN char(1) NOT NULL,
	CONSTRAINT Pk_VENDEDOR PRIMARY KEY (IDVEN)   
)
GO

-- Crear tabla EVENTO
CREATE TABLE EVENTO (
	IDEVE int NOT NULL IDENTITY (1,1),
	NOMEVE varchar(80) NOT NULL,
	FECHEVE varchar(30) NOT NULL,
	IDPON int NOT NULL,
	CONSTRAINT Pk_EVENTO PRIMARY KEY (IDEVE)   
)
GO


-- Crear tabla TICKET
CREATE TABLE TICKET (
	IDTIC int NOT NULL IDENTITY (1,1),
	FECHTIC date NOT NULL,
	IDPAR int NOT NULL,
	IDVEN int NOT NULL,
	IMPTIC decimal(4,1) NOT NULL,
	CONSTRAINT Pk_TICKET PRIMARY KEY (IDTIC)   
)
GO

-- Crear tabla TICKET_DETALLE
CREATE TABLE TICKET_DETALLE (
	IDTIDE int NOT NULL IDENTITY (1,1),
	IDEVE int NOT NULL,
	IDTIC int NOT NULL,
	SUBTOT decimal(3,1) NOT NULL,
	CONSTRAINT Pk_TICKET_DETALLE PRIMARY KEY (IDTIDE)   
)
GO





-- Relacionando la tabla PONENTE con la tabla EVENTO
ALTER TABLE EVENTO
ADD CONSTRAINT FK_PONENTE_EVENTO
FOREIGN KEY (IDPON) REFERENCES PONENTE (IDPON);

-- Relacionando la tabla PONENTE con la tabla EVENTO
ALTER TABLE TICKET_DETALLE
ADD CONSTRAINT FK_EVENTO_TICKET_DETALLE
FOREIGN KEY (IDEVE) REFERENCES EVENTO (IDEVE);


-- Relacionando la tabla PONENTE con la tabla EVENTO
ALTER TABLE TICKET_DETALLE
ADD CONSTRAINT FK_TICKET_TICKET_DETALLE
FOREIGN KEY (IDTIC) REFERENCES TICKET (IDTIC);


-- Relacionando la tabla PONENTE con la tabla EVENTO
ALTER TABLE TICKET
ADD CONSTRAINT FK_VENDEDOR_TICKET
FOREIGN KEY (IDVEN) REFERENCES VENDEDOR (IDVEN);


-- Relacionando la tabla PONENTE con la tabla EVENTO
ALTER TABLE TICKET
ADD CONSTRAINT FK_PARTICIPANTE_TICKET
FOREIGN KEY (IDPAR) REFERENCES PARTICIPANTE (IDPAR);





-- Insetar registros en la tabla PONENTE
INSERT INTO PONENTE
	(NOMPON, APEPON, DNIPON, ESTPON)
VALUES
	('Paul', 'Velasco', '77694853', 'A'),
	('Julio', 'Casas', '78564856', 'A'),
	('Luis', 'Quispe', '76564981', 'A'),
	('Alberto', 'Perez', '87564857', 'A'),
	('Cesar', 'Canales', '65568558', 'A'),
	('Carlos', 'Vargas', '87536855', 'A');


-- Insetar registros en la tabla PONENTE
INSERT INTO PARTICIPANTE
	(NOMPAR, APEPAR, DNIPAR, ESTPAR)
VALUES
	('Pedro', 'Llosa', '92564843', 'A'),
	('Ana', 'Campos', '76564981', 'A'),
	('Jesus', 'Avalos', '40923892', 'A'),
	('Rosa', 'Gamez', '85568558', 'A'),
	('Alfredo', 'Velasco', '90367892', 'A');


-- Insetar registros en la tabla PONENTE
INSERT INTO VENDEDOR
	(NOMVEN, APEVEN, DNIVEN, TELFVEN, ESTVEN)
VALUES
	('Javier', 'Ramos', '43567654', '985452361','A'),
	('Jose', 'Castillo', '76564981', '987253412','A'),
	('Erika', 'Perez', '43500985', '964853241','A'),
	('Beto', 'Gonzales', '67567654', '956742563','A'),
	('Vanesa', 'Goya', '58936855', '948625648','A');

-- Insetar registros en la tabla PONENTE
INSERT INTO EVENTO
	(NOMEVE, FECHEVE, IDPON)
VALUES
	('Ciberseguridad', '22-07-2021', '1'),
	('Transformación Digital', '23-07-2021', '2'),
	('Desarrollo de Software Empresarial', '24-07-2021', '3');


-- Insetar registros en la tabla PONENTE
INSERT INTO TICKET
	(FECHTIC, IDPAR, IDVEN, IMPTIC)
VALUES
	('20-07-2021', '1', '5', '80'),
	('19-07-2021', '2', '4', '120'),
	('18-07-2021', '2', '3', '40'),
	('18-07-2021', '4', '2', '80'),
	('17-07-2021', '5', '1', '120');

-- Insetar registros en la tabla PONENTE
INSERT INTO TICKET_DETALLE
	(IDEVE, IDTIC, SUBTOT)
VALUES
	('1', '1', '40'),
	('2', '1', '40'),
	('3', '3', '40'),
	('1', '4', '40'),
	('3', '4', '40');





--Listar los participantes activos de forma ascendente
CREATE VIEW vListar
AS
SELECT
	P.IDPAR,
	P.NOMPAR,
	P.APEPAR,
	P.DNIPAR,
	P.ESTPAR,
	ROW_NUMBER() OVER (ORDER BY P.IDPAR DESC) AS ORDEN
FROM PARTICIPANTE AS P
WHERE 
	ESTPAR= 'A'
GO


--Listar los datos de los participantes con su respectivo evento
CREATE VIEW vListarPE
AS
SELECT
	P.NOMPAR,
	P.APEPAR,
	E.NOMEVE
FROM PARTICIPANTE AS P
	INNER JOIN TICKET AS T ON
	P.IDPAR = T.IDPAR
	INNER JOIN TICKET_DETALLE AS TD ON
	T.IDTIC = TD.IDTIC
	INNER JOIN EVENTO AS E ON
	TD.IDEVE = E.IDEVE
GO


--Listar los datos del evento con su respectivo ponente
CREATE VIEW vListarEP
AS
SELECT
	E.NOMEVE,
	P.NOMPON,
	P.APEPON
FROM EVENTO AS E
	INNER JOIN PONENTE AS P ON
	E.IDPON = P.IDPON
GO


--Listar ticket con su respetivo nombre del vendedor y cliente
CREATE VIEW vListarTicket
AS
SELECT
	T.IDTIC,
	P.NOMPAR,
	P.APEPAR,
	V.NOMVEN,
	V.APEVEN,
	T.FECHTIC,
	T.IMPTIC
FROM TICKET AS T
	INNER JOIN PARTICIPANTE AS P ON
	T.IDPAR = P.IDPAR
	INNER JOIN VENDEDOR AS V ON
	T.IDVEN = V.IDVEN
GO


--Procedimiento almacenado para Insertar Participantes y que no haya duplicado de DNI
CREATE PROCEDURE spInsertPARTICIPANTES
(
@NOMCLI VARCHAR(30),
@APECLI VARCHAR(30),
@DNICLI CHAR(8),
@ESTCLI CHAR (1)
)
AS 
    BEGIN
    SET NOCOUNT ON
        BEGIN TRAN
        BEGIN TRY
            IF (SELECT COUNT(*) FROM dbo.PARTICIPANTES WHERE dbo.PARTICIPANTES.DNICLI= @DNICLI) = 1
                ROLLBACK TRAN;
            ELSE
                INSERT INTO dbo.PARTICIPANTES
                (NOMCLI, APECLI, DNICLI, ESTCLI)
                VALUES
                (UPPER(@NOMCLI), UPPER(@APECLI), @DNICLI, UPPER(@ESTCLI))
                COMMIT TRAN
        END TRY
        BEGIN CATCH
			SELECT 'El cliente que intenta agregar ya existe.' AS 'ERROR'
            IF @@TRANCOUNT > 0 ROLLBACK TRAN;
              
        END CATCH
    END
GO