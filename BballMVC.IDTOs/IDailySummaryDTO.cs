using System;

namespace BballMVC.IDTOs
{
   public interface IDailySummaryDTO
   {
      double? AdjRecentLeagueHistory { get; set; }
      int DailySummaryID { get; set; }
      DateTime GameDate { get; set; }
      string LeagueName { get; set; }
      double? LgAvgAssistsAway { get; set; }
      double? LgAvgAssistsHome { get; set; }
      int LgAvgGamesBack { get; set; }
      int? LgAvgGamesBackActual { get; set; }
      double? LgAvgLastMinPt1 { get; set; }
      double? LgAvgLastMinPt2 { get; set; }
      double? LgAvgLastMinPt3 { get; set; }
      double? LgAvgLastMinPts { get; set; }
      double? LgAvgOffRBAway { get; set; }
      double? LgAvgOffRBHome { get; set; }
      double? LgAvgPace { get; set; }
      double LgAvgScoreAway { get; set; }
      double LgAvgScoreFinal { get; set; }
      double LgAvgScoreHome { get; set; }
      double LgAvgShotsMadeAwayPt1 { get; set; }
      double LgAvgShotsMadeAwayPt2 { get; set; }
      double LgAvgShotsMadeAwayPt3 { get; set; }
      double LgAvgShotsMadeHomePt1 { get; set; }
      double? LgAvgShotsMadeHomePt2 { get; set; }
      double? LgAvgShotsMadeHomePt3 { get; set; }
      DateTime? LgAvgStartDate { get; set; }
      DateTime? LgAvgStartDateActual { get; set; }
      double? LgAvgTotalLine { get; set; }
      double? LgAvgTurnOversAway { get; set; }
      double? LgAvgTurnOversHome { get; set; }
      double? LgAvgVolatilityGame { get; set; }
      double? LgAvgVolatilityTeam { get; set; }
      int NumOfMatchups { get; set; }
      string Season { get; set; }
      string SubSeason { get; set; }
      int SubSeasonPeriod { get; set; }
      DateTime? TS { get; set; }
   }
}