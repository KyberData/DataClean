/*
	Script Data Clean Basico
*/

SELECT CONVERT(VARCHAR(10),RTRIM(LTRIM([SKU]))) [SKU]
      ,[dbo].[InitCap] (RTRIM(LTRIM([Produto]))) [Produto]
      ,CONVERT(INT,[Quantidade Vendida]) [Quantidade Vendida]
      ,[Primeiro Nome]
      ,[Sobrenome]
      ,[Data]
      ,[Loja]
      ,[ Preco Unitario ]
  FROM [dbo].[EstudoBaseVenda]

GO
--10/21/2018

-- CORREÇÃO SOBRENOME
SELECT
	convert(varchar(30),case 
			when [Sobrenome] = '' or [Sobrenome] = null or [Sobrenome] is null
				then 'N/C'
			else rtrim(ltrim([Sobrenome])) 
		end) [Sobrenome]
FROM 
	[dbo].[EstudoBaseVenda]


-- CORREÇÃO lOJA
SELECT
	convert(varchar(50),case 
			when [Loja] = '' or [Loja] = null or [Loja] is null or [Loja] = ' '
				then 'N/C'
			else rtrim(ltrim([dbo].[InitCap]([Loja]))) 
		end) [Loja]
FROM 
	[dbo].[EstudoBaseVenda]


-- CORREÇÃO DE DATA
--09/14/2018
select 
	SUBSTRING([Data], 4, 2) 
	+'/'+SUBSTRING([Data], 1, 2)  
	+''+SUBSTRING([Data], 7, 4) 
FROM 
	[dbo].[EstudoBaseVenda]

select
	convert(date,case 
		when [Data] = '' or [Data] = null or [Data] is null or [Data] = ' '
			then '01-01-1900'
		else SUBSTRING([Data], 4, 2)
			+'/'+SUBSTRING([Data], 1, 2)
			+'/'+SUBSTRING([Data], 7, 4)
	end) [Data]
FROM 
	[dbo].[EstudoBaseVenda]


-- CORREÇÃO PREÇO
--R$ 2.500,00
SELECT 
	CONVERT(DECIMAL(10,2),REPLACE(
		REPLACE(
			REPLACE([ Preco Unitario ], 'R$ ', ''), '.', ''), ',', '.')) [Preco Unitario]
FROM 
	[dbo].[EstudoBaseVenda]


-- Criação ODS Operation Data STORE

SELECT 
	convert(varchar(10),rtrim(ltrim([SKU])))						[SKU]
    ,convert(varchar(50),rtrim(ltrim([dbo].[InitCap]([Produto]))))	[Produto]
    ,convert(int,[Quantidade Vendida])								[Quantidade Vendida]
    ,convert(varchar(25),rtrim(ltrim([Primeiro Nome])))				[Primeiro Nome]

	-- CASE PARA CORRIGIR CAMPO VAZIO/NULO/EM BRANC0
    ,convert(varchar(30),case 
				when [Sobrenome] = '' or [Sobrenome] = null or [Sobrenome] is null
					then 'N/C'
				else rtrim(ltrim([Sobrenome])) 
			end) [Sobrenome]

	-- CASE PARA CORRIGIR CAMPO VAZIO/NULO/EM BRANC0 E A ORDEM 
    ,convert(date,case 
				when [Data] = '' or [Data] = null or [Data] is null or [Data] = ' '
					then '01-01-1900'
				else SUBSTRING([Data], 4, 2)
					+'/'+SUBSTRING([Data], 1, 2)
					+'/'+SUBSTRING([Data], 7, 4)
			end) [Data]

	-- CASE PARA CORRIGIR CAMPO VAZIO/NULO/EM BRANC0
    ,convert(varchar(50),case 
				when [Loja] = '' or [Loja] = null or [Loja] is null or [Loja] = ' '
					then 'N/C'
				else rtrim(ltrim([dbo].[InitCap]([Loja]))) 
			end) [Loja]

	--CORRIGIR CAMPO DECIMAL
    ,CONVERT(DECIMAL(10,2),REPLACE(
		REPLACE(
			REPLACE([ Preco Unitario ], 'R$ ', ''), '.', ''), ',', '.'))[Preco Unitario]
	INTO odsBaseVenda
  FROM [dbo].[EstudoBaseVenda]