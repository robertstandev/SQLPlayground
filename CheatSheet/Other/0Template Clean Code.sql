SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_YourProcedureName]
	@Data NVARCHAR(1000),
	@PersonID INT = 1,
	@Log NVARCHAR(MAX) = NULL OUT,
	@Forced BIT = 0,
	@Debug BIT = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	--DECLARATIONS
	BEGIN
		DECLARE @ProcedureSchema VARCHAR(10) = OBJECT_SCHEMA_NAME(@@PROCID)
		DECLARE @ProcedureName VARCHAR(100) = OBJECT_NAME(@@PROCID)
		DECLARE @trancount INT = @@TRANCOUNT
		DECLARE @tranName VARCHAR(1000) = ISNULL(@ProcedureName + '-', '') + CAST(NEWID() AS VARCHAR(100))
		
		--Other variables
	END
	
	IF @trancount > 0
		SAVE TRAN @tranName
	ELSE 
		BEGIN TRAN
	BEGIN TRY
        IF EXISTS (
            SELECT 1
            FROM sys.procedures p WITH(NOLOCK)
            WHERE p.name = @ProcedureName
                AND p.schema_name = 'CUST'
            ) 
        AND @ProcedureSchema <> 'CUST'
        BEGIN
            EXEC [CUST].@ProcedureName @Data = @Data, @PersonID = @PersonID, @Forced = @Forced, @Log = @Log OUT; -- Execute CUST schema procedure
        END
        ELSE
        BEGIN
        	--Initialize Variables
		BEGIN
			PRINT 'Do selects here with joins to get the data that you want to check for / filter for in the above code like = get if personid is admin or get if orderid is idorderin etc'
		END

        
            IF @Debug = 1
                PRINT '100: ' + CONVERT(VARCHAR(100), dbo.GETDATE2(), 114) + ' --> ' + @ProcedureSchema + '.' + @ProcedureName;


            EXEC dbo.sp_Event_Before
                @Data = @Data, 
                @PersonID = @PersonID, 
                @Forced = @Forced,
                @Debug = @Debug

            /*

            Your code here


            */

            EXEC dbo.sp_Event_After
                @Data = @Data, 
                @PersonID = @PersonID, 
                @Forced = @Forced,
                @Debug = @Debug,
                @Log = @Log OUT

            IF @Debug = 1
                PRINT '900: ' + CONVERT(VARCHAR(100), dbo.GETDATE2(), 114) + ' --> ' + @ProcedureSchema + '.' + @ProcedureName;
        END
    END TRY  -- `COMMIT TRAN` should be here
    BEGIN CATCH
        IF XACT_STATE() = -1 OR XACT_STATE() = 1 and @trancount = 0
            ROLLBACK TRAN
        IF XACT_STATE() = 1 and @trancount > 0
            ROLLBACK TRAN @tranName;
        
        EXEC [dbo].[sp_LogError] 
            @ProcID = @@PROCID, 
            @RaiseError = 1, 
            @Debug = @Debug, 
            @OrderID = @OrderInID, 
            @ErrorSuffix = @OrderInState, 
            @Forced = @Forced, 
            @Log = @Log OUT, 
            @PersonID = @PersonID;
            -- Consider adding more specific error handling here (e.g., RAISERROR)
    END CATCH
END
