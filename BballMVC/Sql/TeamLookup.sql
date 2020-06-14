USE [00TTI_LeagueScores]		
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeamLookupSourceToSource]') AND type in (N'P', N'PC'))
       DROP PROCEDURE [dbo].[TeamLookupSourceToSource]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO			-- Set @ProcStartLine to THIS LINE NUMBER
-- ==================================================================
-- Author:                 Keith Doran
-- Create date:            10/12/2019
-- Description:            Return TeamNameInDatabase column by SourceName (Covers BBref, NBA etc) from Team Table
-- ==================================================================
-- Change History
-- ==================================================================
-- 
-- ==================================================================
CREATE PROCEDURE [dbo].[TeamLookupSourceToSource] (       
         @StartDate		Date
       , @TeamSourceFrom varchar(30)
       , @TeamSourceTo	varchar(30)
       , @TeamName		varchar(30)
        )
AS
       SET NOCOUNT ON;	-- Do not count affected Rows
              
       BEGIN
			BEGIN TRY
				-- Validate Passed Fields Example --
				If IsNull(@StartDate, GetDate()) = GetDate()
					BEGIN
						Raiserror('Invalid StartDate passed' , 16, 1)
					END

				If IsNull(@TeamSourceTo, '') = ''
					BEGIN
						Raiserror('Invalid TeamSourceTo passed' , 16, 1)
					END

				If IsNull(@TeamSourceFrom, '') = ''
					BEGIN
						Raiserror('Invalid TeamSourceFrom passed' , 16, 1)
					END

				If IsNull(@TeamName, '') = ''
					BEGIN
						Raiserror('Invalid TeamName passed' , 16, 1)
					END
					
			  Select Top 1 *
				 From Team t
				 Where t.StartDate <= @StartDate
					AND t.TeamSource = @TeamSourceTo
					AND t.TeamNameInDatabase
					 =  (		  Select Top 1 t.TeamNameInDatabase
							 From Team t
							 Where t.StartDate <= @StartDate
								AND t.TeamSource = @TeamSourceFrom
								AND t.TeamName = @TeamName
							)
			END TRY
			BEGIN catch
				Declare @DBID int = DB_ID(), @DBNAME varchar(255) = DB_NAME(), @crLf as Varchar(2) = CHAR(13)+CHAR(10)
						, @ProcName Varchar(128) = isnull(OBJECT_NAME(@@PROCID), 'Proc Name not available')
						, @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT
						, @ProcStartLine INT = 9;	-- Line Number of preceeding "GO" statement
				SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
				Set @ErrorMessage = 'ERROR MESSAGE: ' + @ErrorMessage 
				IF @ErrorSeverity > 10
					BEGIN
						Set @ErrorMessage = @ErrorMessage 
										+ @crLf 
										+ @crLf + 'PROC: ' + @ProcName +  ' - Error Line: ' + CONVERT(varchar, ERROR_LINE()+@ProcStartLine) 
										+ @crLf + 'ErrorSeverity: ' + CONVERT(varchar, @ErrorSeverity)
										+ @crLf + 'ErrorState:    ' + CONVERT(varchar, @ErrorState)
					END
				If @@TRANCOUNT > 0
					BEGIN
						Rollback Tran
						Set @ErrorMessage = @ErrorMessage + @crLf + '*** TRANSACTION ROLLED BACK ***'
					END
					
				Raiserror(@ErrorMessage, @ErrorSeverity, @ErrorState, @DBID, @DBNAME)	

			END catch
	
      END
GO
