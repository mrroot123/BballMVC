USE [00TTI_LeagueScores]
GO

/****** Object:  Table [dbo].[TodaysMatchups]    Script Date: 6/20/2020 6:36:07 PM ******/
DROP TABLE [dbo].[TodaysMatchups]
GO

/****** Object:  Table [dbo].[TodaysMatchups]    Script Date: 6/20/2020 6:36:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TodaysMatchups](
	[TodaysMatchupsID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [char](10) NOT NULL,
	[LeagueName] [char](10) NOT NULL,
	[GameDate] [date] NOT NULL,
	[Season] [char](8) NOT NULL,
	[SubSeason] [char](8) NOT NULL,
	[TeamAway] [char](8) NOT NULL,
	[TeamHome] [char](8) NOT NULL,
	[RotNum] [int] NOT NULL,
	[GameTime] [varchar](5) NULL,
	[TV] [char](8) NULL,
	[TmStrAway] [float] NOT NULL,
	[TmStrHome] [float] NOT NULL,
	[UnAdjTotalAway] [float] NOT NULL,
	[UnAdjTotalHome] [float] NOT NULL,
	[UnAdjTotal] [float] NOT NULL,
	[AdjAmt] [float] NOT NULL,
	[AdjAmtAway] [float] NOT NULL,
	[AdjAmtHome] [float] NOT NULL,
	[AdjDbAway] [float] NOT NULL,
	[AdjDbHome] [float] NOT NULL,
	[AdjOTwithSide] [float] NOT NULL,
	[AdjTV] [float] NOT NULL,
	[OurTotalLineAway] [float] NOT NULL,
	[OurTotalLineHome] [float] NOT NULL,
	[OurTotalLine] [float] NOT NULL,
	[SideLine] [float] NOT NULL,
	[TotalLine] [float] NOT NULL,
	[OpenTotalLine] [float] NULL,
	[Play] [char](8) NOT NULL,
	[PlayDiff] [float] NOT NULL,
	[OpenPlayDiff] [float] NULL,
	[AdjustedDiff] [float] NULL,
	[BxScLinePct] [float] NOT NULL,
	[TmStrAdjPct] [float] NOT NULL,
	[GB1] [int] NOT NULL,
	[GB2] [int] NOT NULL,
	[GB3] [int] NOT NULL,
	[WeightGB1] [int] NOT NULL,
	[WeightGB2] [int] NOT NULL,
	[WeightGB3] [int] NOT NULL,
	[AwayProjectedPt1] [float] NULL,
	[AwayProjectedPt2] [float] NULL,
	[AwayProjectedPt3] [float] NULL,
	[HomeProjectedPt1] [float] NULL,
	[HomeProjectedPt2] [float] NULL,
	[HomeProjectedPt3] [float] NULL,
	[AwayAverageAtmpUsPt1] [float] NOT NULL,
	[AwayAverageAtmpUsPt2] [float] NOT NULL,
	[AwayAverageAtmpUsPt3] [float] NOT NULL,
	[HomeAverageAtmpUsPt1] [float] NOT NULL,
	[HomeAverageAtmpUsPt2] [float] NOT NULL,
	[HomeAverageAtmpUsPt3] [float] NOT NULL,
	[AwayGB1] [float] NOT NULL,
	[AwayGB2] [float] NOT NULL,
	[AwayGB3] [float] NOT NULL,
	[HomeGB1] [float] NOT NULL,
	[HomeGB2] [float] NOT NULL,
	[HomeGB3] [float] NOT NULL,
	[AwayGB1Pt1] [float] NOT NULL,
	[AwayGB1Pt2] [float] NOT NULL,
	[AwayGB1Pt3] [float] NOT NULL,
	[AwayGB2Pt1] [float] NOT NULL,
	[AwayGB2Pt2] [float] NOT NULL,
	[AwayGB2Pt3] [float] NOT NULL,
	[AwayGB3Pt1] [float] NOT NULL,
	[AwayGB3Pt2] [float] NOT NULL,
	[AwayGB3Pt3] [float] NOT NULL,
	[HomeGB1Pt1] [float] NOT NULL,
	[HomeGB1Pt2] [float] NOT NULL,
	[HomeGB1Pt3] [float] NOT NULL,
	[HomeGB2Pt1] [float] NOT NULL,
	[HomeGB2Pt2] [float] NOT NULL,
	[HomeGB2Pt3] [float] NOT NULL,
	[HomeGB3Pt1] [float] NOT NULL,
	[HomeGB3Pt2] [float] NOT NULL,
	[HomeGB3Pt3] [float] NOT NULL,
	[TotalBubbleAway] [float] NULL,
	[TotalBubbleHome] [float] NULL
) ON [PRIMARY]
GO


