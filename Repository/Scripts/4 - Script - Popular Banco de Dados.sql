use DB_BAKER
go

BEGIN TRANSACTION
--ROLLBACK
--COMMIT 

DECLARE	@CD_USUARIO  UNIQUEIDENTIFIER,
        @CD_PADEIRO  UNIQUEIDENTIFIER,
		@CD_CLIENTE  UNIQUEIDENTIFIER,
        @CD_CARRINHO INT

--------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRO DE USUÁRIOS
--------------------------------------------------------------------------------------------------------------------------------------------
insert into dbo.TBL_USUARIOS
(CD_USUARIO, NM_USUARIO,DS_EMAIL,DS_TELEFONE,NM_ESTADO,NM_CIDADE,DS_ENDERECO,CD_CEP,CD_SENHA,CD_CPF_CNPJ)
values
(newid(),'GABRIEL (PADEIRO)', 'gabriel@gmail.com', '13997138002','SP','SANTOS',     'RUA PARA, 45','1100002','123','02002002000202'),
(newid(),'LUIS (PADEIRO)',    'luis@gmail.com',    '13997138001','SP','SANTOS',     'RUA SÃO PAULO, 100','1100001','123','01001001000101'),
(newid(),'FERNANDO (PADEIRO)','fernando@gmail.com','13997138003','SP','SANTOS',     'RUA PARANA, 100','1100003','123','03003003000303'),
(newid(),'CLAUDIO (PADEIRO)', 'claudio@gmail.com', '13997138004','SP','SANTOS',     'RUA REI ALBERTO, 30','1100004','123','04004004000404'),
(newid(),'DIOGO (PADEIRO)',   'diogo@gmail.com',   '13997138005','SP','SANTOS',     'AV. CONSELHEIRO NÉBIAS, 1000','1100005','123','05005005000505'),
(newid(),'MAURICIO (PADEIRO)','mauricio@gmail.com','13997138006','SP','SANTOS',     'RUA TOCANTINS, 122','1100006','123','06006006000606'),
(newid(),'RENAN (PADEIRO)',   'renan@gmail.com',   '13997138007','SP','SANTOS',     'AV. AMADOR BUENO, 300','1100007','123','07007007000707'),
(newid(),'ANTONIO (PADEIRO)', 'antonio@gmail.com', '13997138008','SP','SANTOS',     'RUA SENADOR FEIJÓ, 501','1100008','123','08008008000808'),
(newid(),'FELIPE (PADEIRO)',  'felipe@gmail.com',  '13997138009','SP','GUARUJÁ',    'RUA MONTENEGRO, 15','1100009','123','09009009000809'),
(newid(),'JULIO (PADEIRO)',   'julio@gmail.com',   '13997138010','SP','SÃO VICENTE','AV. PRESIDENTE WILSON 133, 311','1100010','123','00000008000000'),

(newid(),'JOÃO (CLIENTE)',    'joao@gmail.com',    '13997138011','SP','SANTOS',     'AV. PEDRO LESSA, 501','1100011','123','11100011100'),
(newid(),'PEDRO (CLIENTE)',   'pedro@gmail.com',   '13997138012','SP','GUARUJÁ',    'RUA GUARARAPES, 10','1100012','123','22200022200'),
(newid(),'ROGERIO (CLIENTE)', 'rogerio@gmail.com', '13997138013','SP','SÃO VICENTE','RUA TREZE DE MAIO, 25','1100013','123','33300033300')
--------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRO ALIMENTOS RESTRITIVOS
--------------------------------------------------------------------------------------------------------------------------------------------
insert  into dbo.TBL_ALIMENTO_RESTRITIVO (DS_ALIMENTO) values
('LACTOSE'),
('GLÚTEN'),
('LOW-CARB')


--------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRO DE PRODUTOS POR PADEIRO
--------------------------------------------------------------------------------------------------------------------------------------------
SELECT  @CD_USUARIO = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'GABRIEL (PADEIRO)'

insert into dbo.TBL_PRODUTOS
(CD_USUARIO,NM_PRODUTO,DS_PRODUTO,VL_PRECO)
values
(@CD_USUARIO,'Pão de Leite', NULL, 2.50),
(@CD_USUARIO,'Pão Integral', NULL, 12.50),
(@CD_USUARIO,'Rosquinha', NULL,6.50),
(@CD_USUARIO,'Brioche', NULL,17.90),
(@CD_USUARIO,'Pão Francês', NULL,0.50),
(@CD_USUARIO,'Pão Italiano', NULL,15.50),
(@CD_USUARIO,'Croissant', NULL,7.20),
(@CD_USUARIO,'Pão de Forma', NULL,22.90)


SELECT  @CD_USUARIO = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'DIOGO (PADEIRO)'

insert into dbo.TBL_PRODUTOS
(CD_USUARIO,NM_PRODUTO,DS_PRODUTO,VL_PRECO)
values
(@CD_USUARIO,'Pão de Leite', NULL, 2.70),
(@CD_USUARIO,'Pão Integral', NULL, 12.50),
(@CD_USUARIO,'Rosquinha', NULL,5.00),
(@CD_USUARIO,'Brioche', NULL,14.90),
(@CD_USUARIO,'Pão Francês', NULL,0.80),
(@CD_USUARIO,'Pão de Forma', NULL,19.90)

SELECT  @CD_USUARIO = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'FELIPE (PADEIRO)'

insert into dbo.TBL_PRODUTOS
(CD_USUARIO,NM_PRODUTO,DS_PRODUTO,VL_PRECO)
values
(@CD_USUARIO,'Pão de Leite', NULL, 3.00),
(@CD_USUARIO,'Pão Francês', NULL,0.80),
(@CD_USUARIO,'Pão Italiano', NULL,13.50),
(@CD_USUARIO,'Croissant', NULL,5.50),
(@CD_USUARIO,'Pão de Forma', NULL,20.00)


SELECT  @CD_USUARIO = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'LUIS (PADEIRO)'

insert into dbo.TBL_PRODUTOS
(CD_USUARIO,NM_PRODUTO,DS_PRODUTO,VL_PRECO)
values
(@CD_USUARIO,'Pão de Leite', NULL, 3.00),
(@CD_USUARIO,'Pão Francês', NULL,0.80),
(@CD_USUARIO,'Pão Italiano', NULL,13.50)
--------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRO DE PRODUTOS RESTRITIVOS
--------------------------------------------------------------------------------------------------------------------------------------------
INSERT  INTO dbo.TBL_PRODUTOS_ALIMENTOS_RESTRITOS
SELECT  P.CD_PRODUTO, A.CD_ALIMENTO_RESTRITO
FROM    dbo.TBL_USUARIOS U WITH (NOLOCK)
        INNER JOIN dbo.TBL_PRODUTOS P WITH (NOLOCK) 
        ON  P.CD_USUARIO = U.CD_USUARIO
        OUTER APPLY
        (
            SELECT  R.CD_ALIMENTO_RESTRITO 
            FROM    dbo.TBL_ALIMENTO_RESTRITIVO R WITH(NOLOCK)
            WHERE   R.DS_ALIMENTO IN ('LACTOSE')
        ) A
WHERE   U.NM_USUARIO IN ('GABRIEL (PADEIRO)','DIOGO (PADEIRO)','FELIPE (PADEIRO)','LUIS (PADEIRO)')
AND     P.NM_PRODUTO IN ('Pão de Leite')
UNION
SELECT  P.CD_PRODUTO, A.CD_ALIMENTO_RESTRITO
FROM    dbo.TBL_USUARIOS U WITH (NOLOCK)
        INNER JOIN dbo.TBL_PRODUTOS P WITH (NOLOCK) 
        ON  P.CD_USUARIO = U.CD_USUARIO
        OUTER APPLY
        (
            SELECT  R.CD_ALIMENTO_RESTRITO 
            FROM    dbo.TBL_ALIMENTO_RESTRITIVO R WITH(NOLOCK)
            WHERE   R.DS_ALIMENTO IN ('GLÚTEN')
        ) A
WHERE   U.NM_USUARIO IN ('GABRIEL (PADEIRO)','DIOGO (PADEIRO)','FELIPE (PADEIRO)','LUIS (PADEIRO)')
AND     P.NM_PRODUTO IN ('Pão de Leite', 'Pão Integral', 'Pão Francês', 'Pão Italiano', 'Pão de Forma')
UNION
SELECT  P.CD_PRODUTO, A.CD_ALIMENTO_RESTRITO
FROM    dbo.TBL_USUARIOS U WITH (NOLOCK)
        INNER JOIN dbo.TBL_PRODUTOS P WITH (NOLOCK) 
        ON  P.CD_USUARIO = U.CD_USUARIO
        OUTER APPLY
        (
            SELECT  R.CD_ALIMENTO_RESTRITO 
            FROM    dbo.TBL_ALIMENTO_RESTRITIVO R WITH(NOLOCK)
            WHERE   R.DS_ALIMENTO IN ('LOW-CARB')
        ) A
WHERE   U.NM_USUARIO IN ('GABRIEL (PADEIRO)','DIOGO (PADEIRO)','FELIPE (PADEIRO)','LUIS (PADEIRO)')
AND     P.NM_PRODUTO IN ('Rosquinha', 'Brioche')




--------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRO DE PEDIDOS
--------------------------------------------------------------------------------------------------------------------------------------------
SELECT  @CD_PADEIRO = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'DIOGO (PADEIRO)'
SELECT  @CD_CLIENTE = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'JOÃO (CLIENTE)'

insert into dbo.TBL_PEDIDOS
(CD_PEDIDO, CD_PADEIRO, CD_CLIENTE, DT_PEDIDO, DS_OBSERVACAO)
values
(newid(), @CD_PADEIRO, @CD_CLIENTE, getdate(), null)

SELECT  @CD_CLIENTE = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'PEDRO (CLIENTE)'

insert into dbo.TBL_PEDIDOS
(CD_PEDIDO, CD_PADEIRO, CD_CLIENTE, DT_PEDIDO, DS_OBSERVACAO)
values
(newid(), @CD_PADEIRO, @CD_CLIENTE, getdate(), null)

--------------------------------------------------------------------------------------------------------------------------------------------

SELECT  @CD_PADEIRO = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'GABRIEL (PADEIRO)'
SELECT  @CD_CLIENTE = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'JOÃO (CLIENTE)'

insert into dbo.TBL_PEDIDOS
(CD_PEDIDO, CD_PADEIRO, CD_CLIENTE, DT_PEDIDO, DS_OBSERVACAO)
values
(newid(), @CD_PADEIRO, @CD_CLIENTE, getdate(), null)

SELECT  @CD_CLIENTE = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'ROGERIO (CLIENTE)'

insert into dbo.TBL_PEDIDOS
(CD_PEDIDO, CD_PADEIRO, CD_CLIENTE, DT_PEDIDO, DS_OBSERVACAO)
values
(newid(), @CD_PADEIRO, @CD_CLIENTE, getdate(), null)

--------------------------------------------------------------------------------------------------------------------------------------------

SELECT  @CD_PADEIRO = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'FELIPE (PADEIRO)'
SELECT  @CD_CLIENTE = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'ROGERIO (CLIENTE)'

insert into dbo.TBL_PEDIDOS
(CD_PEDIDO, CD_PADEIRO, CD_CLIENTE, DT_PEDIDO, DS_OBSERVACAO)
values
(newid(), @CD_PADEIRO, @CD_CLIENTE, getdate(), null)
--------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRO DE ITENS DE PEDIDOS
--------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO dbo.TBL_ITENS_DO_PEDIDO
SELECT
        PE.CD_PEDIDO,
        PD.CD_PRODUTO,
        QT_PRODUTO = 1,
        VL_PRECO = PD.VL_PRECO
FROM    
        dbo.TBL_PEDIDOS PE  WITH (NOLOCK)

        CROSS APPLY
        (
            SELECT  *
            FROM    dbo.TBL_PRODUTOS P WITH(NOLOCK)
            WHERE   P.CD_USUARIO = PE.CD_PADEIRO
        )  PD
--------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------
-- CADASTRO CARRINHO
--------------------------------------------------------------------------------------------------------------------------------------------
SELECT  @CD_CLIENTE = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'PEDRO (CLIENTE)'
IF NOT EXISTS (SELECT 1 FROM dbo.TBL_CARRINHOS WITH (NOLOCK) WHERE CD_USUARIO = @CD_CLIENTE)
    INSERT INTO dbo.TBL_CARRINHOS (CD_USUARIO) VALUES (@CD_CLIENTE)

SELECT  @CD_CARRINHO = CD_CARRINHO FROM dbo.TBL_CARRINHOS WITH (NOLOCK) WHERE CD_USUARIO = @CD_CLIENTE
SELECT  @CD_PADEIRO = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'GABRIEL (PADEIRO)'

INSERT INTO dbo.TBL_ITENS_DO_CARRINHO
SELECT
        CA.CD_CARRINHO,
        PD.CD_PRODUTO,
        QT_PRODUTO = 1,
        PD.VL_PRECO
FROM    
        dbo.TBL_CARRINHOS CA  WITH (NOLOCK)

        CROSS APPLY
        (
            SELECT  TOP 3 *
            FROM    dbo.TBL_PRODUTOS P WITH(NOLOCK)
            WHERE   P.CD_USUARIO = @CD_PADEIRO
        )  PD
WHERE
        CA.CD_CARRINHO = @CD_CARRINHO


SELECT  @CD_CLIENTE = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'ROGERIO (CLIENTE)'
IF NOT EXISTS (SELECT 1 FROM dbo.TBL_CARRINHOS WITH (NOLOCK) WHERE CD_USUARIO = @CD_CLIENTE)
    INSERT INTO dbo.TBL_CARRINHOS (CD_USUARIO) VALUES (@CD_CLIENTE)

SELECT  @CD_CARRINHO = CD_CARRINHO FROM dbo.TBL_CARRINHOS WITH (NOLOCK) WHERE CD_USUARIO = @CD_CLIENTE
SELECT  @CD_PADEIRO = CD_USUARIO FROM dbo.TBL_USUARIOS WITH (NOLOCK) WHERE NM_USUARIO = 'LUIS (PADEIRO)'

INSERT INTO dbo.TBL_ITENS_DO_CARRINHO
SELECT
        CA.CD_CARRINHO,
        PD.CD_PRODUTO,
        QT_PRODUTO = 1,
        PD.VL_PRECO
FROM    
        dbo.TBL_CARRINHOS CA  WITH (NOLOCK)

        CROSS APPLY
        (
            SELECT  TOP 2 *
            FROM    dbo.TBL_PRODUTOS P WITH(NOLOCK)
            WHERE   P.CD_USUARIO = @CD_PADEIRO
        )  PD
WHERE
        CA.CD_CARRINHO = @CD_CARRINHO

--------------------------------------------------------------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------------------------------------------------------------
-- DADOS DAS TABELAS
--------------------------------------------------------------------------------------------------------------------------------------------
select * from DB_BAKER.dbo.TBL_USUARIOS  with(nolock)
select * from DB_BAKER.dbo.TBL_PRODUTOS  with(nolock)
select * from DB_BAKER.dbo.TBL_PEDIDOS   with(nolock)
select * from DB_BAKER.dbo.TBL_ITENS_DO_PEDIDO  with(nolock)
select * from DB_BAKER.dbo.TBL_CARRINHOS   with(nolock)
select * from DB_BAKER.dbo.TBL_ITENS_DO_CARRINHO  with(nolock)

