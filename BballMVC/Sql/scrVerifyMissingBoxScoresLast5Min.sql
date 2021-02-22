
Select b.GameDate, Count(*)
 From BoxScores b
 Left Join BoxScoresLast5Min L5 on L5.GameDate = b.GameDate and L5.RotNum = b.RotNum
 Where b.Season = '2021' and L5.GameDate is Null
 Group by b.GameDate
