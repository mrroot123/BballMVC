USE [00TTI_LeagueScores]
GO

/****** Object:  Table [dbo].[Teams]    Script Date: 3/28/2018 9:57:18 PM ******/
DROP TABLE [dbo].[Teams]
GO

/****** Object:  Table [dbo].[Teams]    Script Date: 3/28/2018 9:57:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Teams](
	[TeamsID] [int] IDENTITY(1,1) NOT NULL,
	[LeagueID] [int] NOT NULL,
	[LeagueName] [nchar](10) NOT NULL,
	[TeamFullName] [nchar](30) NOT NULL,
	[TeamCity] [nchar](30) NOT NULL,
	[TeamNameOnly] [nchar](30) NOT NULL,
	[TeamID_Database] [nchar](10) NOT NULL,
	[TeamID_NBA] [nchar](10) NOT NULL,
	[TeamID_ScoresAndOdds] [nchar](30) NOT NULL,
	[TeamID_BasketballReference] [nchar](10) NOT NULL,
	[TeamID_Covers] [nchar](10) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL
) ON [PRIMARY]

GO


