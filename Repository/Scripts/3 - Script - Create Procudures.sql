﻿USE DB_BAKER
GO

-- INSERIR PRODUTOS

CREATE OR ALTER PROCEDURE dbo.spINSProduto
	@CD_PRODUTO INT,
	@CD_USUARIO UNIQUEIDENTIFIER,
	@NM_PRODUTO VARCHAR(100), 
	@DS_CAMINHO_IMAGEM VARCHAR(100),
	@DS_PRODUTO VARCHAR(300),
	@VL_PRECO DECIMAL(6,2) 

AS
BEGIN

    INSERT INTO dbo.TBL_PRODUTOS
    (
		CD_USUARIO ,
		NM_PRODUTO , 
		DS_CAMINHO_IMAGEM ,
		DS_PRODUTO ,
		VL_PRECO
    )
    VALUES
    (
		@CD_USUARIO ,
		@NM_PRODUTO , 
		@DS_CAMINHO_IMAGEM ,
		@DS_PRODUTO ,
		@VL_PRECO
    )

END
GO


-- ALTERAR PRODUTOS

CREATE OR ALTER PROCEDURE dbo.spUPDProduto
	@CD_PRODUTO BIGINT,
	@CD_USUARIO UNIQUEIDENTIFIER,
	@NM_PRODUTO VARCHAR(100), 
	@DS_CAMINHO_IMAGEM VARCHAR(100),
	@DS_PRODUTO VARCHAR(300),
	@VL_PRECO DECIMAL(6,2) 

AS
BEGIN

    UPDATE  dbo.TBL_PRODUTOS
    SET
		CD_USUARIO	= @CD_USUARIO,
		NM_PRODUTO	= @NM_PRODUTO,
		DS_PRODUTO	= @DS_PRODUTO,
		VL_PRECO 	= @VL_PRECO,
		DS_CAMINHO_IMAGEM	= @DS_CAMINHO_IMAGEM
	WHERE
        CD_PRODUTO = @CD_Produto

END
GO


-- EXCLUIR PRODUTOS

CREATE OR ALTER PROCEDURE dbo.spDELProduto
    @CD_PRODUTO BIGINT
AS
BEGIN

    DELETE FROM dbo.TBL_PRODUTOS WHERE CD_Produto = @CD_PRODUTO


END
GO


-- LISTAR PRODUTOS POR PADEIRO

CREATE OR ALTER PROCEDURE dbo.spLSTProduto
    @CD_USUARIO UNIQUEIDENTIFIER = null
AS
BEGIN

	SELECT
		CD_PRODUTO,
		CD_USUARIO,
		NM_PRODUTO, 
		DS_CAMINHO_IMAGEM,
		DS_PRODUTO,
		VL_PRECO
	FROM
		dbo.TBL_PRODUTOS PD WITH (NOLOCK)
	WHERE
		CD_USUARIO = @CD_USUARIO OR @CD_USUARIO is null

END
GO


-- LISTAR LOCALIZACAO DOS PADEIROS

CREATE OR ALTER PROCEDURE dbo.spLSTLocalizacaoPadeiros
    @NM_CIDADE  VARCHAR(50)
AS
BEGIN

	SELECT
            US.CD_USUARIO,
            US.NM_USUARIO,
            US.DS_EMAIL,
            US.DS_TELEFONE,
            US.NM_ESTADO,
            US.NM_CIDADE,
            US.DS_ENDERECO,
            US.CD_CEP,
            US.CD_SENHA,
            US.CD_CPF_CNPJ
	FROM
		dbo.TBL_USUARIOS US  WITH (NOLOCK)

    WHERE
            UPPER(US.NM_CIDADE) = UPPER(@NM_CIDADE)
	AND		LEN(TRIM(US.CD_CPF_CNPJ)) = 14		-- 14 caracteres define ser um CNPJ

END
GO