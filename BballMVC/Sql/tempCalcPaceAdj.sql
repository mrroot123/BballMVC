
Declare  @LeagueName varchar(8), @GameDate Date, @Team varchar(8), @GamesBack int
/*

1	Get Last 7
2	Replace Klunkers w n-1
3	If Klunkers > 1 EXIT
4	Sum Value Diffs * Col Values
5  If Klunkers, DROP Final Adj by 1
	   
*/
Begin
	Begin	
		Declare
			  @KlunkerValue int = 10
			, @KlunkerCtr int = 0
			, @Divisor int = 50
			, @ColValueValue int = 5
			, @ColValue int 
			, @AdjPace float

		Set @LeagueName = 'NBA'
		Set @GameDate = '2/22/2021'
		Set @Team = 'was'
		Set @GamesBack = 7


		DECLARE @tblColValue TABLE (RowNum int, ColValue INT)
		Insert into @tblColValue values(1, @ColValueValue);  Set @ColValueValue = @ColValueValue +1;
		Insert into @tblColValue values(2, @ColValueValue);  Set @ColValueValue = @ColValueValue +1;
		Insert into @tblColValue values(3, @ColValueValue);  Set @ColValueValue = @ColValueValue +1;
		Insert into @tblColValue values(4, @ColValueValue);  Set @ColValueValue = @ColValueValue +1;
		Insert into @tblColValue values(5, @ColValueValue);  Set @ColValueValue = @ColValueValue +1;
		Insert into @tblColValue values(6, @ColValueValue);  Set @ColValueValue = @ColValueValue +1;
		Insert into @tblColValue values(7, @ColValueValue);  Set @ColValueValue = @ColValueValue +1;

		DECLARE @tblPace TABLE (RowNum int, Pace int)
		-- 10 get Last 7
--Insert into @tblPace values(1, 190)
--Insert into @tblPace values(2, 185)
--Insert into @tblPace values(3, 180)
--Insert into @tblPace values(4, 177)
--Insert into @tblPace values(5, 165)
  Insert Into @tblPace
		Select  ROW_NUMBER() OVER (Order by GameDate ) AS RowNum , Pace
		  From
		  (
				Select top (@GamesBack) *
				 from Boxscores b
				  Where b.LeagueName = @LeagueName
					 AND b.GameDate < @GameDate
					 AND b.Team = @Team
					 AND b.Pace is Not Null
				 Order by GameDate Desc
		 ) x
		 order by GameDate 


		Select * from @tblColValue
		Select * from @tblPace
	End
	
	Declare @r int, @Pace0 float, @Pace1 float, @Direction int, @ctr float

	-- Edit for Klunkers
	Set @ctr= 0
	Set  @r = 1

	While 1=1
	Begin

		Select Top 1 
			@r = p1.RowNum
			, @Pace1 = p1.Pace
			, @Pace0 = p0.Pace
			, @ColValue = c.ColValue
		  From @tblPace p1
		  Join @tblPace p0 ON p0.RowNum = p1.RowNum - 1
		  Join @tblColValue c ON c.RowNum = p1.RowNum - 1
		  Where p1.RowNum > @r
		  Order by p1.RowNum
		If @@ROWCOUNT = 0
			Break;
		if abs(@Pace1 - @Pace0) >= @KlunkerValue
		Begin
			If @Pace1 - @Pace0 > 0 AND @ctr < 0.0	-- Klunker HI and Direction down then Its a Klunker
				OR
			   @Pace1 - @Pace0 < 0 AND @ctr > 0.0	-- Klunker LO and Direction UP then Its a Klunker
			Begin

				If @KlunkerCtr = 1
				Begin
					Select 0.0
					Return 
				End
				Set @KlunkerCtr = @KlunkerCtr + 1
				Update @tblPace
					Set Pace = 
					(
						Select AVG(Pace)
						  From @tblPace p
						  Where p.RowNum < @r
					)
					Where RowNum = @r
			End	-- If
		End	-- If Abs
		Set @ctr = @ctr + (@Pace1 - @Pace0)
	End	-- while

	Select * from @tblPace

	-- Count Differentials
	Set @ctr = 0
	Set  @r = 1

	While 1=1
	Begin

		Select Top 1 
			@r = p1.RowNum
			, @Pace1 = p1.Pace
			, @Pace0 = p0.Pace
			, @ColValue = c.ColValue
		  From @tblPace p1
		  Join @tblPace p0 ON p0.RowNum = p1.RowNum - 1
		  Join @tblColValue c ON c.RowNum = p1.RowNum - 1
		  Where p1.RowNum > @r
		  Order by p1.RowNum
		If @@ROWCOUNT = 0
			Break;

		Set @ctr = @ctr + ((@Pace1 - @Pace0) * @ColValue)		
	End

	Set @AdjPace = @ctr / @Divisor
	If @KlunkerCtr > 0 AND @AdjPace > 0
		Set @AdjPace = @AdjPace - 1
	else
		If @KlunkerCtr > 0 AND @AdjPace < 0
			Set @AdjPace = @AdjPace + 1

	print 'KlunkerCtr: ' + Convert(VarChar, @KlunkerCtr	)
	Select Round(@AdjPace * 2, 0) / 2  as AdjPace
--	, @KlunkerCtr as KlunkerCtr
End
