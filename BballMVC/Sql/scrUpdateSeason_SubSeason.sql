use [00TTI_LeagueScores]

if 1 = 2
	UPDATE        Rotation
	SET           Rotation.Season = x.Season
			, Rotation.SubSeason = x.SubSeason
			, Rotation.SubSeasonPeriod = 0
	FROM          Rotation r
	INNER JOIN    Boxscores  x
	ON            x.GameDate = r.GameDate and x.RotNum = r.RotNum

if 1 = 2
	Select LeagueName, Year(GameDate), count(*) from Rotation
	 Where Season is null
		Group by LeagueName, Year(GameDate)
		order by LeagueName, Year(GameDate)


Declare @SeasonInfoTable Table (
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[Season] [nvarchar](4) NOT NULL,
	[SubSeason] [nvarchar](20) NOT NULL,
	[Bypass] [bit] NOT NULL,
	[IncludePre] [bit] NOT NULL,
	[IncludePost] [bit] NOT NULL,
	[BoxscoreSource] [nvarchar](21) NOT NULL
	)

Declare @GameDate Date, @LeagueName varchar(10), @RotationID int = 0
	, @Season varchar(10), @SubSeason varchar(10)

--Set @GameDate = '5/1/2018' 
--Set @LeagueName = 'NBA'

While 1 < 2
BEGIN
	Select TOP 1
		@RotationID = r.RotationID,  @GameDate = r.GameDate , @LeagueName = r.LeagueName
		from Rotation r
		Where r.Season is null -- and gamedate between '12/1/2018' and '6/1/2019'

					If @@ROWCOUNT = 0
					BREAK;

	-- Select * from Rotation where RotationID = @RotationID

	 Insert @SeasonInfoTable Exec [dbo].[uspQuerySeasonInfo]  @GameDate , @LeagueName 
	 Select @Season = Season, @SubSeason = SubSeason from @SeasonInfoTable

	 Update Rotation
		Set Season = @Season
			, SubSeason = @SubSeason
			, SubSeasonPeriod = 0
			Where RotationID = @RotationID

	-- Select * from Rotation where RotationID = @RotationID
END	

	Select LeagueName, Season, SubSeason, Venue, count(*) from Rotation
	  where LeagueName = 'NBA' and SubSeason = '1-reg' and venue = 'Away'
		Group by LeagueName, Season, SubSeason,  Venue
		order by LeagueName, Season, SubSeason,  Venue
