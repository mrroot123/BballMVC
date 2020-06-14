USE [00TTI_LeagueScores]
GO

INSERT INTO [dbo].[ParmTable]
           ([ParmName]
           ,[ParmValue]
           ,[DotNetType]
           ,[Description]
           ,[Scope]
           ,[CreateUser]
           ,[CreateDate]
			  )
     VALUES
           (
			  'BoxscoresLastUpdateDate'
           ,'1/1/2000'
           ,'dateTime'
           ,'Date the LoadBoxscores method was successfully run'
           ,null
           ,'Sql Script'
           ,GetDate()
			  )
GO


