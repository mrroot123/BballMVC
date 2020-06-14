USE [00TTI_LeagueScores]
GO

/****** Object:  Table [dbo].[AdjustmentsCodes]    Script Date: 3/25/2018 8:11:03 PM ******/
If OBJECT_ID('[AdjustmentsCodes]') is not null
	DROP TABLE [dbo].[AdjustmentsCodes]
GO

/****** Object:  Table [dbo].[AdjustmentsCodes]    Script Date: 3/25/2018 8:11:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AdjustmentsCodes](
	[AdjustmentsCodesID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nchar](1) NOT NULL,
	[Description] [nchar](15) NOT NULL,
	[Range] [bit] NOT NULL,
	 CONSTRAINT PK_AdjustmentsCodes_ID PRIMARY KEY (AdjustmentsCodesID)
) ON [PRIMARY]

GO


