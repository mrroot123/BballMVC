USE [00TTI_LeagueScores]
GO

/****** Object:  Table [dbo].[TodaysPlays]    Script Date: 3/25/2018 9:19:36 PM ******/
If OBJECT_ID('[TodaysPlays]') is not null
	DROP TABLE [dbo].[TodaysPlays]
GO

/****** Object:  Table [dbo].[TodaysPlays]    Script Date: 3/25/2018 9:19:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TodaysPlays](
	[TodaysPlaysID] [int] IDENTITY(1,1) NOT NULL,
	[TranType] [int] NULL,
	[PlayDate] [date] NOT NULL,
	[LeagueName] [nchar](10) NOT NULL,
	[RotNum] [int] NOT NULL,
	[GameTime] [time](7) NOT NULL,
	[TeamAway] [nchar](10) NOT NULL,
	[TeamHome] [nchar](10) NOT NULL,
	[PlayType] [nchar](10) NOT NULL,
	[UO] [nchar](10) NOT NULL,
	[Line] [decimal](6, 1) NOT NULL,
	[Info] [nchar](10) NOT NULL,
	[PlayAmount] [smallmoney] NOT NULL,
	[PlayWeight] [decimal](5, 2) NOT NULL,
	[Juice] [decimal](5, 2) NOT NULL,
	[Out] [nchar](10) NOT NULL,
	[Author] [nchar](10) NOT NULL,
	[Result] [nchar](1) NULL,
	[OT] [bit] NULL,
	[FinalScore] [int] NULL,
	[ResultAmount] [smallmoney] NULL,
	[CreateUser] [nchar](10) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	 CONSTRAINT PK_TodaysPlays_ID PRIMARY KEY (TodaysPlaysID)
) ON [PRIMARY]

GO


