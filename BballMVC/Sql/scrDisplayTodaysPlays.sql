/****** Script for SelectTopNRows command from SSMS  ******/
Declare @GameDate date = convert(date, getdate());

--Select @@SERVERNAME; return;

-- set @GameDate = DATEADD(d, -1, @GameDate)

SELECT @@SERVERNAME, [GameDate]
      ,[LeagueName]
      ,[RotNum]
      ,[GameTime]
      ,[TeamAway]
      ,[TeamHome]
      ,[PlayDirection]
      ,[Line]
      ,[PlayAmount]
      ,[PlayWeight]
  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]
  where GameDate = @GameDate
  order by RotNum

SELECT[RotNum] as ' '  
      ,[TeamAway] as ' '
      ,[TeamHome] as ' '
      ,Left([PlayDirection],2) as ' '
      ,[Line] as ' '

  FROM [00TTI_LeagueScores].[dbo].[TodaysPlays]
  where GameDate = @GameDate
  order by RotNum