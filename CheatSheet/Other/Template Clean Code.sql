/****** Object:  StoredProcedure [API].[sp_OrdersIn_Add]    Script Date: 8/10/2023 4:27:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [API].[sp_OrdersIn_Add]
	@Parameters NVARCHAR(MAX),
	@Response NVARCHAR(MAX) OUT,
	@Log NVARCHAR(MAX) = NULL OUT,
	@Forced BIT = 0,
	@Debug BIT = 0
AS
---================================
--- Write here what the procedure does and what parameter it has
---================================
BEGIN
	SET NOCOUNT ON;

	/* Declare */
	BEGIN
		DECLARE @ProcedureStartDate DATETIME = dbo.GETDATE2()
		DECLARE @TranCount INT = @@TRANCOUNT
		DECLARE @ProcedureName VARCHAR(250) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)
		DECLARE @TranName VARCHAR(250) = CONCAT(@ProcedureName, NEWID())
	END--End declare

	/* Start procedure debug */
	SET @Log = CONCAT(@Log, [dbo].[fx_DebugLine](@@PROCID, '0000' , ''))
	
	---=====================================================================
	BEGIN TRY

		IF @TranCount > 0
			SAVE TRAN @TranName
		ELSE 
			BEGIN TRAN

		SET @Log = CONCAT(@Log, [dbo].[fx_DebugLine](@@PROCID, '1000' , ''))

		/* Write your code here */

		INSERT INTO dbo.tblDebugging 
			(Description,
			LogText)
		SELECT TOP(1)
			[Description] = @ProcedureName
			,[LogText] = @Parameters
			

		IF @trancount = 0
			COMMIT TRAN
	END TRY
	---=====================================================================

	---=====================================================================
	BEGIN CATCH
		IF XACT_STATE() = -1 OR XACT_STATE() = 1 AND @TranCount = 0
			ROLLBACK TRAN
		IF XACT_STATE() = 1 AND @TranCount > 0
			ROLLBACK TRAN @TranName;

		/* Error debug */
		SET @Log = CONCAT(@Log, [dbo].[fx_DebugLine](@@PROCID, '9998' , ''))

		EXEC [dbo].[sp_LogError] 
			@ErrorType = 'ERROR',
			@ErrorSeverity = NULL,
			@ErrorSource = NULL, 
			@ErrorDetails = NULL, --OUT
			@PersonID = NULL,
			@ForceLog = 0,
			@PrintError = 0,
			@OrderID = NULL,
			@OrderNumber = NULL,
			@ErrorSuffix = '',
			@ProcID = @@PROCID,
			@RaiseError = 1,
			@SendEmail = 0,
			@TaskID = NULL,
			@TranslateError = 0,
			@CheckContextValues = 0,
			@Log = @Log OUT,
			@Forced = @Forced,
			@Debug = @Debug
	END CATCH
	---=====================================================================

	/* End procedure debug */
	SET @Log = CONCAT(@Log, [dbo].[fx_DebugLine](@@PROCID, '9999' , ''))

	---=====================================================================
	---Log high procedure execution time
	---=====================================================================
	BEGIN 
		--get the total execution time of the procedure
		DECLARE @ProcedureEndDate DATETIME = dbo.GETDATE2()
		DECLARE @ProcedureExecuteDurationMilliseconds INT = DATEDIFF(MILLISECOND, @ProcedureStartDate, @ProcedureEndDate)

		--log the total execution time if above the settings treshold
		IF @ProcedureExecuteDurationMilliseconds > dbo.fx_Tools_DebuggingTime()
		BEGIN
			INSERT INTO [dbo].[tblDebugging]
				   ([ItemID]
				   ,[idOrder]
				   ,[idTask]
				   ,[idAdmPerson]
				   ,[Duration]
				   ,[BeginDate]
				   ,[EndDate]
				   ,[Description]
				   ,[Description2]
				   ,[Description3]
				   ,[Description4]
				   ,[Description5]
				   ,[LogText]
				   ,[SourceName]
				   ,[Errors])
			 SELECT TOP(1)
					[ItemID] = NULL --Here add ProcessType, EntityID, OrderID, etc..
				   ,[idOrder] = NULL
				   ,[idTask] = NULL
				   ,[idAdmPerson] = NULL
				   ,[Duration] = @ProcedureExecuteDurationMilliseconds
				   ,[BeginDate] = @ProcedureStartDate
				   ,[EndDate] = @ProcedureEndDate
				   ,[Description] = 'High execution time'
				   ,[Description2] = ''
				   ,[Description3] = ''
				   ,[Description4] = ''
				   ,[Description5] = ''
				   ,[LogText] = ISNULL(@Log, '')
				   ,[SourceName] = @ProcedureName
				   ,[Errors] = ERROR_MESSAGE()
		END
	END
	---=====================================================================
END

