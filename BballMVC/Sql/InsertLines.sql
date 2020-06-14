use [00TTI_LeagueScores]

Declare @GameDate Date = Convert(Date, GetDate())
	, @LeagueName varchar(10) = 'NBA'
	;

Declare @RotNum int = 0
      ,@TeamAway nchar(4)
      ,@TeamHome nchar(4)
      ,@Line float

      ,@SideLine float
      ,@TotalLine float
      ,@OpenTotalLine float

      ,@PlayType nchar(4)
      ,@PlayDuration nchar(4)
      ,@CreateDate  [datetime2](7) = GetDate()
      ,@LineSource nchar(10)

-- PlayType
Declare @PlayType_Total nchar(4) = 'Tot'
		, @PlayType_Side nchar(4) = 'Side'

		, @PlayDuration_Game nchar(4) = 'Game'
		, @PlayDuration_H1 nchar(4) = 'H1'
		, @PlayDuration_H2 nchar(4) = 'H2'
		, @PlayDuration_Q1 nchar(4) = 'Q1'
		, @PlayDuration_Q2 nchar(4) = 'Q2'
		, @PlayDuration_Q3 nchar(4) = 'Q3'
		, @PlayDuration_Q4 nchar(4) = 'Q4'

If @GameDate < Convert(Date, GetDate())
	Set @CreateDate = @GameDate;



	While @RotNum < 1000		-- Generate TeamStatsAverages
	BEGIN
		Select Top 1 	@TeamAway = r.Team,  @TeamHome = r.Opp,  @RotNum = r.RotNum
						 , @SideLine = r.SideLine, @TotalLine = r.TotalLine, @OpenTotalLine = r.OpenTotalLine, @LineSource = r.BoxScoreSource
			From Rotation r
			Where r.LeagueName = @LeagueName AND r.GameDate = @GameDate AND r.RotNum > @RotNum		-- Need LeagueName since Rotnum using Greater Than to make unique
			Order by r.RotNum
		If @@ROWCOUNT = 0
			BREAK;
		
		If IsNull(@TotalLine, 0) <> 0
		BEGIN
			If IsNull(@OpenTotalLine, 0) <> 0 AND  IsNull(@OpenTotalLine, 0) <> @TotalLine
			BEGIN
				If Exists(Select TOP 1  LineID From Lines Where GameDate = @GameDate  AND  LeagueName = @LeagueName AND PlayType = @PlayType_Total  AND PlayDuration = @PlayDuration_Game)
				BEGIN
				-- write Open
					Set @Line = @OpenTotalLine
					Exec uspInsertLine  @LeagueName, @GameDate, @RotNum,  @TeamAway, @TeamHome, @Line, @PlayType_Total, @PlayDuration_Game, @CreateDate, @LineSource
					Set @CreateDate = DATEADD(s, 1, @CreateDate)
				END
			END

			Select TOP 1  @line = Line From Lines 
			  Where GameDate = @GameDate  AND  LeagueName = @LeagueName AND PlayType = @PlayType_Total  AND PlayDuration = @PlayDuration_Game
			  Order by CreateDate Desc
			If IsNull(@Line, 0) <> @TotalLine
			BEGIN
			-- write Current
				Set @Line = @TotalLine
				Exec uspInsertLine  @LeagueName, @GameDate, @RotNum,  @TeamAway, @TeamHome, @Line, @PlayType_Total, @PlayDuration_Game, @CreateDate, @LineSource

			END

			Select TOP 1  @line = Line From Lines 
			  Where GameDate = @GameDate  AND  LeagueName = @LeagueName AND PlayType = @PlayType_Side  AND PlayDuration = @PlayDuration_Game
			  Order by CreateDate Desc
			If IsNull(@Line, 0) <> @SideLine
			BEGIN
			-- write@SideLine
				Set @Line = @SideLine
				Exec uspInsertLine  @LeagueName, @GameDate, @RotNum,  @TeamAway, @TeamHome, @Line, @PlayType_Side, @PlayDuration_Game, @CreateDate, @LineSource

			END
		END	-- TL <> 0

		Set @RotNum = @RotNum + 1;	-- next row will be > than Home RotNum
	END	-- Rotation Loop

