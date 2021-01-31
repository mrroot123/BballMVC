use [00TTI_LeagueScores]

Select @@SERVERNAME as server, 'BoxScores' as 'Table', Min(GameDate) as Min, Max(GameDate) as Max, count(*) as games
 From BoxScores
 --where GameDate > '1/1/2021'