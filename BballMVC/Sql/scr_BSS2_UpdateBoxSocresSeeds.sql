Use [00TTI_LeagueScores]


	Declare @LeagueName varchar(4) = 'WNBA', @Season varchar(4) = '20', @UserName varchar(25) = 'Test'

	SELECT ThisYearShotsMadePt1	, -- LastYearShotsMadePt1 ,LastYearMadeTmStr , AdjustmentAmountMade,
	 *  FROM [00TTI_LeagueScores].[dbo].[BoxScoresSeeds] where  LeagueName = @LeagueName AND UserName = @UserName AND Season = @Season

	Update BoxScoresSeeds
		Set ThisYearShotsMadePt1 = LastYearShotsMadePt1 * ((LastYearMadeTmStr + AdjustmentAmountMade) / LastYearMadeTmStr)
		, ThisYearShotsMadePt2 = LastYearShotsMadePt2 * ((LastYearMadeTmStr + AdjustmentAmountMade) / LastYearMadeTmStr)
		, ThisYearShotsMadePt3 = LastYearShotsMadePt3 * ((LastYearMadeTmStr + AdjustmentAmountMade) / LastYearMadeTmStr)

		, ThisYearShotsAllowedPt1 = LastYearShotsAllowedPt1 * ((LastYearAllowedTmStr + AdjustmentAmountAllowed) / LastYearAllowedTmStr)
		, ThisYearShotsAllowedPt2 = LastYearShotsAllowedPt2 * ((LastYearAllowedTmStr + AdjustmentAmountAllowed) / LastYearAllowedTmStr)
		, ThisYearShotsAllowedPt3 = LastYearShotsAllowedPt3 * ((LastYearAllowedTmStr + AdjustmentAmountAllowed) / LastYearAllowedTmStr)

			WHERE LeagueName = @LeagueName AND UserName = @UserName AND Season = @Season

	SELECT ThisYearShotsMadePt1, ThisYearShotsAllowedPt1, *  FROM [00TTI_LeagueScores].[dbo].[BoxScoresSeeds] where  LeagueName = @LeagueName AND UserName = @UserName AND Season = @Season
