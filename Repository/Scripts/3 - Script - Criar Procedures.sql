USE DB_BAKER
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
    @ALIMENTOS_RESTRITOS XML = NULL      -- Exemplo: 
                                         --'<ALIMENTOSRESTRITOS>
                                         --    <ITEM>
                                         --        <CD_ALIMENTO_RESTRITO>1</CD_ALIMENTO_RESTRITO>
                                         --    </ITEM>
                                         --    <ITEM>
                                         --        <CD_ALIMENTO_RESTRITO>2</CD_ALIMENTO_RESTRITO>
                                         --    </ITEM>
                                        --</ALIMENTOSRESTRITOS>'

AS
BEGIN


    -- CADASTRO DE PODUTOS
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


    -- CADASTRAR PRODUTO E SEU ALIMENTOS RESTRITIVOS
    IF (@ALIMENTOS_RESTRITOS IS NOT NULL)
    BEGIN

        declare @hDoc AS INT    
        exec    sp_xml_preparedocument @hDoc OUTPUT, @ALIMENTOS_RESTRITOS

        ;WITH Dados AS  
        (  
            SELECT  
	                CD_PRODUTO = @CD_PRODUTO,
                    CD_ALIMENTO_RESTRITO
    
            FROM OPENXML(@hDoc, '/ALIMENTOSRESTRITOS/ITEM')  
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
	@CD_PRODUTO INT,
	@CD_USUARIO UNIQUEIDENTIFIER,
	@NM_PRODUTO VARCHAR(100), 
	@DS_PRODUTO VARCHAR(300),
	@VL_PRECO DECIMAL(6,2),
    @VB_IMAGEM VARBINARY(MAX),
    @ALIMENTOS_RESTRITOS XML = NULL      -- Exemplo: 
                                         --'<ALIMENTOSRESTRITOS>
                                         --    <ITEM>
                                         --        <CD_ALIMENTO_RESTRITO>1</CD_ALIMENTO_RESTRITO>
                                         --    </ITEM>
                                         --    <ITEM>
                                         --        <CD_ALIMENTO_RESTRITO>2</CD_ALIMENTO_RESTRITO>
                                         --    </ITEM>
                                        --</ALIMENTOSRESTRITOS>'

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


     -- CADASTRAR PRODUTO E SEU ALIMENTOS RESTRITIVOS
    IF (@ALIMENTOS_RESTRITOS IS NOT NULL)
    BEGIN

        declare @hDoc AS INT    
        exec    sp_xml_preparedocument @hDoc OUTPUT, @ALIMENTOS_RESTRITOS

        ;WITH Dados AS  
        (  
            SELECT  
	                CD_PRODUTO = @CD_PRODUTO,
                    CD_ALIMENTO_RESTRITO
    
            FROM OPENXML(@hDoc, '/ALIMENTOSRESTRITOS/ITEM')  
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
    @CD_PRODUTO INT
AS
BEGIN


    -- A EXLUSÃO DO PRODUTO SERÁ IDENTIFICADO PELA COLUNA BO_CANCELADO, E NÃO EXLCUIDO DA TABELA, 
    -- ASSIM EVITA A PERDA DO HITÓRICO DESSE PRODUTO DE COMPRAS DESTES PRODUTO
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

    -- LISTAR PRODUTOS POR PADEIRO
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
    @NM_CIDADE  VARCHAR(50) = NULL

AS
BEGIN


    -- ESTA CTE "ALIMENTOS", RETORNA UMA TABELA COM TODOS OS CLIENTES E QUAIS ALIMENTOS RESTRITIVOS ELE UTILIZA NOS PRODUTOS DELE.
    ;WITH ALIMENTOS AS
    (
        SELECT  *                
        FROM    (

                    SELECT  
                            P.CD_USUARIO,
                            AR.DS_ALIMENTO, 
                            CD_ALIMENTO_RESTRITO = CASE WHEN AR.CD_ALIMENTO_RESTRITO IS NOT NULL THEN 1 ELSE 0 END

                    FROM    dbo.TBL_PRODUTOS_ALIMENTOS_RESTRITOS   PA  WITH (NOLOCK)
                            INNER JOIN dbo.TBL_ALIMENTOS_RESTRITOS AR  WITH (NOLOCK)
                            ON  PA.CD_ALIMENTO_RESTRITO = AR.CD_ALIMENTO_RESTRITO
                            INNER JOIN dbo.TBL_PRODUTOS  P  WITH (NOLOCK)
                            ON  P.CD_PRODUTO = PA.CD_PRODUTO
                ) AS Alimentos
    
        -- ESTE PIVOT CRIA AS COLUNAS DE CADA ALIMENTO RESTRITIVO NA TABELA (CTE) "ALIMENTOS", 
        -- CASO NECESSITE CADASTRAR UM NOVO ALIMENTO RESRTRITIVO, DEVE-SE INCLUIR ELE NA LISTA DA SENTENÇA "FOR" 
        -- E NA SUA TABELA DE DOMINIO (dbo.TBL_ALIMENTOS_RESTRITOS).
        PIVOT   (
                    SUM(Alimentos.CD_ALIMENTO_RESTRITO) 
                    FOR Alimentos.DS_ALIMENTO IN ([GLUTEN], [LACTOSE], [LOW-CARB], [ARTESANAL])
                ) AS PivotTable      
    )
    -- RETORNA OS DADOS DOS PADEIROS CADASTRADOS PARA UMA DETERMINADA CIDADE OU TODAS E QUAIS ALIMENTOS RESTRITIVOS 
    -- CADA PADEIRO UTUILIZA NOS SEUS PRODUTOS.
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
            US.CD_CPF_CNPJ,
            [GLUTEN]    = CASE WHEN SUM(ISNULL(AL.[GLUTEN],0))    > 0 THEN 1 ELSE 0 END,
            [LACTOSE]   = CASE WHEN SUM(ISNULL(AL.[LACTOSE],0))   > 0 THEN 1 ELSE 0 END,
            [LOW-CARB]  = CASE WHEN SUM(ISNULL(AL.[LOW-CARB],0))  > 0 THEN 1 ELSE 0 END,
            [ARTESANAL] = CASE WHEN SUM(ISNULL(AL.[ARTESANAL],0)) > 0 THEN 1 ELSE 0 END    

    FROM    dbo.TBL_USUARIOS            US  WITH (NOLOCK)

            INNER JOIN dbo.TBL_PRODUTOS PR  WITH (NOLOCK)
            ON  US.CD_USUARIO = PR.CD_USUARIO

            LEFT JOIN   ALIMENTOS       AL
            ON  AL.CD_USUARIO = PR.CD_USUARIO

    WHERE
            (UPPER(US.NM_CIDADE) = UPPER(@NM_CIDADE) OR @NM_CIDADE IS NULL)
	AND		LEN(TRIM(US.CD_CPF_CNPJ)) = 14		-- 14 caracteres define ser um CNPJ (PJ) e 11 caracteres define ser um CPF (PF)

    GROUP BY
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

        INNER JOIN dbo.TBL_USUARIOS         PD  WITH (NOLOCK)
        ON  PE.CD_PADEIRO = PD.CD_USUARIO


        --  CALCULA O VALOR TOTAL DOS PRODUTOS, POR PEDIDO
        OUTER APPLY
        (
            SELECT  
                    P.CD_PEDIDO,
                    VL_TOTAL = SUM(R.VL_PRECO)
            
            FROM    dbo.TBL_PEDIDOS                     P  WITH (NOLOCK)

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
  	@CD_PRODUTO INT,
	@QT_PRODUTO SMALLINT, 
	@VL_PRECO   DECIMAL(6,2)

AS    
BEGIN    

    -- CADASTRAR UM CARRINHO POR CLIENTE
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


    -- SALVA O PRODUTO PARA O CARRINHO/CLIENTE, CASO O PRODUTO JÁ ESTEJA CADASTRADO SERÁ ATUALIZADO APENAS A QUANTIDADE DO PRODUTO
    ;WITH Dados AS  
    (  
        SELECT  
                CD_CARRINHO = @CD_CARRINHO,
	            CD_PRODUTO  = @CD_PRODUTO,
                QT_PRODUTO  = @QT_PRODUTO,
                VL_PRECO    = @VL_PRECO
    )   
    MERGE   dbo.TBL_ITENS_DO_CARRINHO as TargetTbl  
    USING   Dados   as SourceTbl  
  
    ON  TargetTbl.CD_CARRINHO = SourceTbl.CD_CARRINHO  
    and TargetTbl.CD_PRODUTO  = SourceTbl.CD_PRODUTO  
   
    WHEN NOT MATCHED 
            THEN INSERT (CD_CARRINHO, CD_PRODUTO, QT_PRODUTO, VL_PRECO) VALUES (SourceTbl.CD_CARRINHO, SourceTbl.CD_PRODUTO, SourceTbl.QT_PRODUTO, SourceTbl.VL_PRECO)

	WHEN MATCHED THEN
		UPDATE SET QT_PRODUTO = SourceTbl.QT_PRODUTO;

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
		     IT.CD_ITENS_DO_CARRINHO,
             CA.CD_CARRINHO,
             PR.CD_PRODUTO,
             PR.NM_PRODUTO,
             IT.QT_PRODUTO,
             PR.VL_PRECO,
             PR.VB_IMAGEM

     FROM    dbo.TBL_CARRINHOS   CA  WITH (NOLOCK)

             INNER JOIN dbo.TBL_ITENS_DO_CARRINHO  IT  WITH (NOLOCK)
             ON  CA.CD_CARRINHO = IT.CD_CARRINHO

             INNER JOIN dbo.TBL_PRODUTOS  PR  WITH (NOLOCK)
             ON  IT.CD_PRODUTO = PR.CD_PRODUTO

    WHERE   CA.CD_USUARIO = @CD_USUARIO
END
GO


--------------------------------------------------------------------------------------------------------------------------------------------
-- REMOVER PRODUTO DO CARRINHO
--------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.spDELCarrinho 
	@CD_ITENS_DO_CARRINHO INT

AS    
BEGIN  

    -- EXCLUI DA TABELA OS PRODUTOS DO CARRINHO DO CLIENTE
    DELETE FROM dbo.TBL_ITENS_DO_CARRINHO WHERE CD_ITENS_DO_CARRINHO = @CD_ITENS_DO_CARRINHO

END
GO


