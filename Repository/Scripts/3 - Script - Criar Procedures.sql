﻿USE DB_BAKER
GO


--------------------------------------------------------------------------------------------------------------------------------------------
-- INSERIR PRODUTOS
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.spINSProduto
	@CD_PRODUTO         INT,
	@CD_USUARIO         UNIQUEIDENTIFIER,
	@NM_PRODUTO         VARCHAR(100), 
	@DS_PRODUTO         VARCHAR(300),
	@VL_PRECO           DECIMAL(6,2),
    @VB_IMAGEM          VARBINARY(MAX),
    @PRODUTOS_RESTRITOS XML = NULL      -- Exemplo: 
                                        --'<AlimentoRestrito>
                                        --     <Item>
                                        --         <CD_ALIMENTO_RESTRITO>1</CD_ALIMENTO_RESTRITO>
                                        --     </Item>
                                        --     <Item>
                                        --         <CD_ALIMENTO_RESTRITO>2</CD_ALIMENTO_RESTRITO>
                                        --     </Item>
                                        --</AlimentoRestrito>'

AS
BEGIN

    INSERT INTO dbo.TBL_PRODUTOS
    (
		CD_USUARIO,
		NM_PRODUTO, 
		DS_PRODUTO,
		VL_PRECO,
        BO_CANCELADO,
        VB_IMAGEM
    )
    VALUES
    (
		@CD_USUARIO,
		@NM_PRODUTO, 
		@DS_PRODUTO,
		@VL_PRECO,
        0,
        @VB_IMAGEM
    )

    -- ADQUIRE O ID DO PRODUTO QUE ACABOU DE SER CADASTRADO 
    SET @CD_PRODUTO = SCOPE_IDENTITY()


    -- CADASTRAR PRODUTO COM ALIMENTOS RESTRITIVOS
    IF (@PRODUTOS_RESTRITOS IS NOT NULL)
    BEGIN

        declare @hDoc AS INT    
        exec    sp_xml_preparedocument @hDoc OUTPUT, @PRODUTOS_RESTRITOS

        ;WITH Dados AS  
        (  
            SELECT  
	                CD_PRODUTO = @CD_PRODUTO,
                    CD_ALIMENTO_RESTRITO
    
            FROM OPENXML(@hDoc, 'AlimentoRestrito\Item')  
            WITH  
            (     
                CD_ALIMENTO_RESTRITO INT 'CD_ALIMENTO_RESTRITO'
            )
        )   
        MERGE   dbo.TBL_PRODUTOS_ALIMENTOS_RESTRITOS as TargetTbl  
        USING   Dados   as SourceTbl  
  
        ON  TargetTbl.CD_PRODUTO            = SourceTbl.CD_PRODUTO  
        and TargetTbl.CD_ALIMENTO_RESTRITO  = SourceTbl.CD_ALIMENTO_RESTRITO  
   
        WHEN NOT MATCHED 
             THEN INSERT (CD_PRODUTO, CD_ALIMENTO_RESTRITO) VALUES (SourceTbl.CD_PRODUTO, SourceTbl.CD_ALIMENTO_RESTRITO);

    END

END
GO


--------------------------------------------------------------------------------------------------------------------------------------------
-- ALTERAR PRODUTOS
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.spUPDProduto
	@CD_PRODUTO BIGINT,
	@CD_USUARIO UNIQUEIDENTIFIER,
	@NM_PRODUTO VARCHAR(100), 
	@DS_PRODUTO VARCHAR(300),
	@VL_PRECO DECIMAL(6,2) ,
    @VB_IMAGEM VARBINARY(MAX),
    @PRODUTOS_RESTRITOS XML = NULL      -- Exemplo: 
                                        --'<AlimentoRestrito>
                                        --     <Item>
                                        --         <CD_ALIMENTO_RESTRITO>1</CD_ALIMENTO_RESTRITO>
                                        --     </Item>
                                        --     <Item>
                                        --         <CD_ALIMENTO_RESTRITO>2</CD_ALIMENTO_RESTRITO>
                                        --     </Item>
                                        --</AlimentoRestrito>'

AS
BEGIN

    -- LIMPA TODOS OS ALIMENTOS RESTRITOS REFERENTE AO PRODUTO
    DELETE FROM dbo.TBL_PRODUTOS_ALIMENTOS_RESTRITOS WHERE CD_PRODUTO = @CD_PRODUTO      

    -- ATUALIZAR OS DADOS DO PRODUTO
    UPDATE  dbo.TBL_PRODUTOS
    SET
		CD_USUARIO	= @CD_USUARIO,
		NM_PRODUTO	= @NM_PRODUTO,
		DS_PRODUTO	= @DS_PRODUTO,
		VL_PRECO 	= @VL_PRECO,
        VB_IMAGEM   = @VB_IMAGEM
	WHERE
        CD_PRODUTO = @CD_Produto


    -- CADASTRAR PRODUTO COM ALIMENTOS RESTRITIVOS
    IF (@PRODUTOS_RESTRITOS IS NOT NULL)
    BEGIN

        declare @hDoc AS INT    
        exec    sp_xml_preparedocument @hDoc OUTPUT, @PRODUTOS_RESTRITOS

        ;WITH Dados AS  
        (  
            SELECT  
	                CD_PRODUTO = @CD_PRODUTO,
                    CD_ALIMENTO_RESTRITO
    
            FROM OPENXML(@hDoc, 'AlimentoRestrito\Item')  
            WITH  
            (     
                CD_ALIMENTO_RESTRITO INT 'CD_ALIMENTO_RESTRITO'
            )
        )   
        MERGE   dbo.TBL_PRODUTOS_ALIMENTOS_RESTRITOS as TargetTbl  
        USING   Dados   as SourceTbl  
  
        ON  TargetTbl.CD_PRODUTO            = SourceTbl.CD_PRODUTO  
        and TargetTbl.CD_ALIMENTO_RESTRITO  = SourceTbl.CD_ALIMENTO_RESTRITO  
   
        WHEN NOT MATCHED 
             THEN INSERT (CD_PRODUTO, CD_ALIMENTO_RESTRITO) VALUES (SourceTbl.CD_PRODUTO, SourceTbl.CD_ALIMENTO_RESTRITO);

    END

END
GO


--------------------------------------------------------------------------------------------------------------------------------------------
-- EXCLUIR PRODUTOS
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.spDELProduto
    @CD_PRODUTO BIGINT
AS
BEGIN

    UPDATE  dbo.TBL_PRODUTOS
    SET     BO_CANCELADO = 1
	WHERE   CD_PRODUTO = @CD_Produto

END
GO


--------------------------------------------------------------------------------------------------------------------------------------------
-- LISTAR PRODUTOS POR PADEIRO
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.spLSTProduto
    @CD_USUARIO UNIQUEIDENTIFIER = null
AS
BEGIN

	SELECT
		CD_PRODUTO,
		CD_USUARIO,
		NM_PRODUTO, 
		DS_PRODUTO,
		VL_PRECO,
        VB_IMAGEM
	FROM
		dbo.TBL_PRODUTOS PD WITH (NOLOCK)
	WHERE
		(CD_USUARIO = @CD_USUARIO OR @CD_USUARIO is null)
    AND BO_CANCELADO = 0

END
GO


--------------------------------------------------------------------------------------------------------------------------------------------
-- LISTAR LOCALIZACAO DOS PADEIROS
--------------------------------------------------------------------------------------------------------------------------------------------
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


--------------------------------------------------------------------------------------------------------------------------------------------
-- RELATÓRIO DE VENDA POR PADEIRO
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.spRPTVendasPadeiros
    @CD_USUARIO  UNIQUEIDENTIFIER
AS
BEGIN

	SELECT
			PE.CD_PEDIDO,
			NM_PADEIRO          = PD.NM_USUARIO,
			NM_CLIENTE          = CL.NM_USUARIO,
			PE.DT_PEDIDO,
			PR.NM_PRODUTO,
			IT.QT_PRODUTO,
			PR.VL_PRECO,
            VL_SUBTOTAL         = PR.VL_PRECO * IT.QT_PRODUTO,
            VL.VL_TOTAL,
			CL.NM_ESTADO,
			CL.NM_CIDADE,
			CL.DS_ENDERECO
	FROM
		dbo.TBL_PEDIDOS PE  WITH (NOLOCK)

        INNER JOIN dbo.TBL_ITENS_DO_PEDIDO  IT  WITH (NOLOCK)
        ON  PE.CD_PEDIDO = IT.CD_PEDIDO

        INNER JOIN dbo.TBL_PRODUTOS         PR  WITH (NOLOCK)
        ON  IT.CD_PRODUTO = PR.CD_PRODUTO

        INNER JOIN dbo.TBL_USUARIOS         CL  WITH (NOLOCK)
        ON  PE.CD_CLIENTE = CL.CD_USUARIO

        INNER JOIN dbo.TBL_USUARIOS PD  WITH (NOLOCK)
        ON  PE.CD_PADEIRO = PD.CD_USUARIO

        OUTER APPLY
        (
            SELECT  
                    P.CD_PEDIDO,
                    VL_TOTAL = SUM(R.VL_PRECO)
            FROM
		            dbo.TBL_PEDIDOS P  WITH (NOLOCK)

                INNER JOIN dbo.TBL_ITENS_DO_PEDIDO  I  WITH (NOLOCK)
                ON  P.CD_PEDIDO = I.CD_PEDIDO

                INNER JOIN dbo.TBL_PRODUTOS         R  WITH (NOLOCK)
                ON  I.CD_PRODUTO = R.CD_PRODUTO
            WHERE
                    P.CD_PEDIDO = PE.CD_PEDIDO
            GROUP BY
                    P.CD_PEDIDO
        ) VL

    WHERE
            PE.CD_PADEIRO = @CD_USUARIO

END
GO


--------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRAR CARRINHO
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.spINSCarrinho 
        @CD_USUARIO UNIQUEIDENTIFIER,
        @PRODUTOS   XML = NULL          -- Exemplo: 
                                        --'<Carrinho>
                                        --     <Item>
                                        --         <CD_USUARIO>3fa85f64-5717-4562-b3fc-2c963f66afa6</CD_USUARIO>
                                        --         <CD_PRODUTO>1</CD_PRODUTO>
                                        --         <QT_PRODUTO>2</QT_PRODUTO>
                                        --         <VL_PRECO>3</VL_PRECO>
                                        --     </Item>
                                        --     <Item>
                                        --         <CD_USUARIO>3fa85f64-5717-4562-b3fc-2c963f66afa6</CD_USUARIO>
                                        --         <CD_PRODUTO>4</CD_PRODUTO>
                                        --         <QT_PRODUTO>5</QT_PRODUTO>
                                        --         <VL_PRECO>6</VL_PRECO>
                                        --     </Item>
                                        --</Carrinho>'
AS    
BEGIN    

    declare @hDoc AS INT    
    exec    sp_xml_preparedocument @hDoc OUTPUT, @PRODUTOS

    -- CADASTRAR CARRINHO
    ;WITH DADOS AS
    (
        SELECT  CD_USUARIO = @CD_USUARIO
    )
    MERGE   dbo.TBL_CARRINHOS AS TargetTbl  
    USING   DADOS             AS SourceTbl  
  
    ON  TargetTbl.CD_USUARIO = SourceTbl.CD_USUARIO
  
    WHEN NOT MATCHED
         THEN INSERT (CD_USUARIO) VALUES (SourceTbl.CD_USUARIO);


    -- OBTEM O CODIGO DO CARRINHO
    DECLARE @CD_CARRINHO INT

    SELECT  @CD_CARRINHO = CD_CARRINHO
    FROM    dbo.TBL_CARRINHOS CA WITH (NOLOCK)
    WHERE   CA.CD_USUARIO = @CD_USUARIO


    -- LIMPA TODOS OS ITENS CADASTRADOS
    DELETE FROM dbo.TBL_ITENS_DO_CARRINHO WHERE CD_CARRINHO = @CD_CARRINHO      

    IF (@PRODUTOS IS NOT NULL)
    BEGIN

        ;WITH Dados AS  
        (  
            SELECT  
                    CD_CARRINHO = @CD_CARRINHO,
	                CD_PRODUTO,
                    QT_PRODUTO,
                    VL_PRECO
    
            FROM    OPENXML(@hDoc, 'Carrinho/Item')  
            WITH  
            (     
                CD_PRODUTO INT 'CD_PRODUTO',
                QT_PRODUTO INT 'QT_PRODUTO',
                VL_PRECO   DECIMAL 'VL_PRECO'
            )
        )   
        MERGE   dbo.TBL_ITENS_DO_CARRINHO as TargetTbl  
        USING   Dados   as SourceTbl  
  
        ON  TargetTbl.CD_CARRINHO = SourceTbl.CD_CARRINHO  
        and TargetTbl.CD_PRODUTO  = SourceTbl.CD_PRODUTO  
   
        WHEN NOT MATCHED 
             THEN INSERT (CD_CARRINHO, CD_PRODUTO, QT_PRODUTO, VL_PRECO) VALUES (SourceTbl.CD_CARRINHO, SourceTbl.CD_PRODUTO, SourceTbl.QT_PRODUTO, SourceTbl.VL_PRECO);

    END

END
GO

--------------------------------------------------------------------------------------------------------------------------------------------
-- LISTAR PRODUTOS DO CARRINHO
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.spLSTCarrinho
	@CD_USUARIO UNIQUEIDENTIFIER
AS
BEGIN


    SELECT  
            CA.CD_CARRINHO,
            PR.CD_PRODUTO,
            PR.NM_PRODUTO,
            IT.QT_PRODUTO,
            PR.VL_PRECO

    FROM    dbo.TBL_CARRINHOS   CA  WITH (NOLOCK)

            INNER JOIN dbo.TBL_ITENS_DO_CARRINHO  IT  WITH (NOLOCK)
            ON  CA.CD_CARRINHO = IT.CD_CARRINHO

            INNER JOIN dbo.TBL_PRODUTOS  PR  WITH (NOLOCK)
            ON  IT.CD_PRODUTO = PR.CD_PRODUTO

    WHERE   CA.CD_USUARIO = @CD_USUARIO
END