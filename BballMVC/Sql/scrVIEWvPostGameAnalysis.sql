USE [00TTI_LeagueScores]
GO

EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vPostGameAnalysis'
GO

EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vPostGameAnalysis'
GO

/****** Object:  View [dbo].[vPostGameAnalysis]    Script Date: 7/16/2020 10:00:52 PM ******/
DROP VIEW [dbo].[vPostGameAnalysis]
GO

/****** Object:  View [dbo].[vPostGameAnalysis]    Script Date: 7/16/2020 10:00:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vPostGameAnalysis]
AS
SELECT tm.*	
							 , b.OtPeriods, b.ScoreReg, 
   b.ScoreOT, b.ScoreRegUs, b.ScoreRegOp, b.ScoreOTUs, b.ScoreOTOp, b.ScoreQ1Us, b.ScoreQ1Op, b.ScoreQ2Us, b.ScoreQ2Op, b.ScoreQ3Us, b.ScoreQ3Op, b.ScoreQ4Us, b.ScoreQ4Op, b.ShotsActualMadeUsPt1, 
   b.ShotsActualMadeUsPt2, b.ShotsActualMadeUsPt3, b.ShotsActualMadeOpPt1, b.ShotsActualMadeOpPt2, b.ShotsActualMadeOpPt3, b.ShotsActualAttemptedUsPt1, b.ShotsActualAttemptedUsPt2, b.ShotsActualAttemptedUsPt3, 
   b.ShotsActualAttemptedOpPt1, b.ShotsActualAttemptedOpPt2, b.ShotsActualAttemptedOpPt3, b.ShotsMadeUsRegPt1, b.ShotsMadeUsRegPt2, b.ShotsMadeUsRegPt3, b.ShotsMadeOpRegPt1, b.ShotsMadeOpRegPt2, 
   b.ShotsMadeOpRegPt3, b.ShotsAttemptedUsRegPt1, b.ShotsAttemptedUsRegPt2, b.ShotsAttemptedUsRegPt3, b.ShotsAttemptedOpRegPt1, b.ShotsAttemptedOpRegPt2, b.ShotsAttemptedOpRegPt3, b.TurnOversUs, 
   b.TurnOversOp, b.OffRBUs, b.OffRBOp, b.AssistsUs, b.AssistsOp, b.Pace
FROM            dbo.TodaysMatchups AS tm INNER JOIN
                         dbo.BoxScores AS b ON tm.RotNum + 1 = b.RotNum AND tm.GameDate = b.GameDate
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tm"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 280
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vPostGameAnalysis'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vPostGameAnalysis'
GO


