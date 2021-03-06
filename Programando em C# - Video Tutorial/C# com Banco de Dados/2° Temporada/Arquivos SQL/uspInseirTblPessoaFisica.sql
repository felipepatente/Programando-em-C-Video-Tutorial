ALTER PROCEDURE [dbo].[uspPessoaFisicaInserir]
	@nome AS VARCHAR(50),
	@CPF AS VARCHAR(11),
	@RG AS VARCHAR(20),
	@DataNascimento AS DATE
AS
BEGIN
-- Exceção (TRY/CATCH)
-- Transação

	BEGIN TRY
		BEGIN TRAN

			-- Não deixa inserir CPF igual no banco
			IF(EXISTS(SELECT IDPessoaFisica FROM tblPessoaFisica WHERE CPF = @CPF))
			BEGIN
				RAISERROR('CPF já existe',14,1);
			END;

			DECLARE @IDPessoa AS INT;
			
			-- 1° Inserir na tabela tblPessoa
			INSERT INTO tblPessoa (IDPessoaTipo)
			VALUES(1);

			SET @IDPessoa = @@IDENTITY;

			--2° Inserir na tabela tblPessoaFisica
			INSERT INTO 
				tblPessoaFisica (IDPessoaFisica, Nome, CPF, RG, DataNascimento)
			VALUES
				(@IDPessoa, @nome, @CPF, @RG, @DataNascimento);

			SELECT @IDPessoa AS Retorno;
			
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() AS Retorno;
	END CATCH
END