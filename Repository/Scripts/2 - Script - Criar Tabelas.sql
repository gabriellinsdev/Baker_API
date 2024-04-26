﻿USE DB_BAKER
GO

BEGIN TRANSACTION
--ROLLBACK
--COMMIT 


CREATE TABLE dbo.TBL_USUARIOS
(
	CD_USUARIO  UNIQUEIDENTIFIER NOT NULL,
	NM_USUARIO  VARCHAR(100) NOT NULL,
	DS_EMAIL    VARCHAR(100) NOT NULL, 
	DS_TELEFONE VARCHAR(11) NOT NULL,
	NM_ESTADO   VARCHAR(50) NOT NULL,
	NM_CIDADE   VARCHAR(50) NOT NULL,
	DS_ENDERECO VARCHAR(100) NOT NULL,
	CD_CEP      CHAR(8) NOT NULL,
	CD_SENHA    VARCHAR(60) NOT NULL,
	CD_CPF_CNPJ VARCHAR(14) NOT NULL,
	CONSTRAINT PK_TBL_USUARIOS PRIMARY KEY (CD_USUARIO)
)
GO

CREATE TABLE dbo.TBL_PRODUTOS
(
	CD_PRODUTO        INT IDENTITY(1,1) NOT NULL,
	CD_USUARIO        UNIQUEIDENTIFIER NOT NULL,
	NM_PRODUTO        VARCHAR(100) NOT NULL, 
	DS_PRODUTO        VARCHAR(300),
	VL_PRECO          DECIMAL(6,2) NOT NULL,
	BO_CANCELADO      BIT DEFAULT(0),
	VB_IMAGEM		  VARBINARY(MAX),
	CONSTRAINT PK_TBL_PRODUTOS PRIMARY KEY (CD_PRODUTO), 
	CONSTRAINT FK_TBL_PRODUTOS_TBL_USUARIOS FOREIGN KEY (CD_USUARIO) REFERENCES dbo.TBL_USUARIOS (CD_USUARIO) 
)
GO

CREATE TABLE dbo.TBL_ALIMENTOS_RESTRITOS
(
    CD_ALIMENTO_RESTRITO INT NOT NULL,
    DS_ALIMENTO          VARCHAR(300) NOT NULL,
    CONSTRAINT PK_TBL_ALIMENTOS_RESTRITOS PRIMARY KEY (CD_ALIMENTO_RESTRITO),
    CONSTRAINT UK_CD_ALIMENTO_RESTRITO UNIQUE (CD_ALIMENTO_RESTRITO)
)


CREATE TABLE dbo.TBL_PRODUTOS_ALIMENTOS_RESTRITOS
(
	CD_PRODUTO_ALIMENTOS_RESTRITOS INT IDENTITY(1,1) NOT NULL,
	CD_PRODUTO                     INT NOT NULL,
	CD_ALIMENTO_RESTRITO           INT NOT NULL,
	CONSTRAINT PK_TBL_PRODUTOS_ALIMENTOS_RESTRITOS    PRIMARY KEY (CD_PRODUTO_ALIMENTOS_RESTRITOS),
	CONSTRAINT FK_TBL_PRODUTOS_ALIMENTOS_RESTRITOS_TBL_PRODUTOS FOREIGN KEY (CD_PRODUTO) REFERENCES dbo.TBL_PRODUTOS (CD_PRODUTO),
	CONSTRAINT FK_TBL_PRODUTOS_ALIMENTOS_RESTRITOS_TBL_ALIMENTOS_RESTRITOS FOREIGN KEY (CD_ALIMENTO_RESTRITO) REFERENCES dbo.TBL_ALIMENTOS_RESTRITOS (CD_ALIMENTO_RESTRITO) 
)
GO


CREATE TABLE dbo.TBL_CARRINHOS
(
	CD_CARRINHO INT IDENTITY(1,1) NOT NULL,
	CD_USUARIO  UNIQUEIDENTIFIER NOT NULL,
	CONSTRAINT PK_TBL_CARRINHOS PRIMARY KEY (CD_CARRINHO), 
	CONSTRAINT FK_TBL_CARRINHOS_TBL_USUARIOS FOREIGN KEY (CD_USUARIO) REFERENCES dbo.TBL_USUARIOS (CD_USUARIO) 
)
GO

CREATE TABLE dbo.TBL_ITENS_DO_CARRINHO
(
	CD_ITENS_DO_CARRINHO INT IDENTITY(1,1) NOT NULL,
	CD_CARRINHO          INT NOT NULL,
	CD_PRODUTO           INT NOT NULL,
	QT_PRODUTO           SMALLINT NOT NULL,
	VL_PRECO             DECIMAL(6,2) NOT NULL,
	CONSTRAINT PK_TBL_ITENS_DO_CARRINHO PRIMARY KEY (CD_ITENS_DO_CARRINHO), 
	CONSTRAINT FK_TBL_ITENS_DO_CARRINHO_TBL_CARRINHOS FOREIGN KEY (CD_CARRINHO) REFERENCES dbo.TBL_CARRINHOS (CD_CARRINHO), 
	CONSTRAINT FK_TBL_ITENS_DO_CARRINHO_TBL_PRODUTOS  FOREIGN KEY (CD_PRODUTO)  REFERENCES dbo.TBL_PRODUTOS  (CD_PRODUTO)
)
GO

CREATE TABLE dbo.TBL_PEDIDOS
(
	CD_PEDIDO     UNIQUEIDENTIFIER NOT NULL,
	CD_PADEIRO    UNIQUEIDENTIFIER NOT NULL,
	CD_CLIENTE    UNIQUEIDENTIFIER NOT NULL,
	DT_PEDIDO     DATETIME NOT NULL, 
	DS_OBSERVACAO VARCHAR(300),
	CONSTRAINT PK_TBL_PEDIDOS PRIMARY KEY (CD_PEDIDO), 
	CONSTRAINT FK_TBL_PEDIDOS_TBL_USUARIOS_PADEIRO FOREIGN KEY (CD_PADEIRO) REFERENCES dbo.TBL_USUARIOS (CD_USUARIO), 
	CONSTRAINT FK_TBL_PEDIDOS_TBL_USUARIOS_CLIENTE FOREIGN KEY (CD_CLIENTE) REFERENCES dbo.TBL_USUARIOS (CD_USUARIO)
)
GO

CREATE TABLE dbo.TBL_ITENS_DO_PEDIDO
(
	CD_ITENS_DO_PEDIDO INT IDENTITY(1,1) NOT NULL,
	CD_PEDIDO          UNIQUEIDENTIFIER NOT NULL,
	CD_PRODUTO         INT NOT NULL,
	QT_PRODUTO         SMALLINT NOT NULL,
	VL_PRECO           DECIMAL(6,2) NOT NULL,
	CONSTRAINT PK_TBL_ITENS_DO_PEDIDO PRIMARY KEY (CD_ITENS_DO_PEDIDO), 
	CONSTRAINT FK_TBL_ITENS_DO_PEDIDO_TBL_PEDIDOS  FOREIGN KEY (CD_PEDIDO)  REFERENCES dbo.TBL_PEDIDOS (CD_PEDIDO), 
	CONSTRAINT FK_TBL_ITENS_DO_PEDIDO_TBL_PRODUTOS FOREIGN KEY (CD_PRODUTO) REFERENCES dbo.TBL_PRODUTOS (CD_PRODUTO)
)
GO

--ROLLBACK
--COMMIT 
