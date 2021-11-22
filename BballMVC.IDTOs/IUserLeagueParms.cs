using System;

namespace BballMVC.IDTOs
{
   public interface IUserLeagueParmsDTO
   {
      bool BothHome_Away { get; set; }
      bool BoxscoresSpanSeasons { get; set; }
      double BxScLinePct { get; set; }
      double BxScTmStrPct { get; set; }
      int GB1 { get; set; }
      int GB2 { get; set; }
      int GB3 { get; set; }
      string LeagueName { get; set; }
      int LgAvgGamesBack { get; set; }
      DateTime LgAvgStartDate { get; set; }
      int LoadRotationDaysAhead { get; set; }
      double RecentLgHistoryAdjPct { get; set; }
      DateTime StartDate { get; set; }
      double TeamAdjPct { get; set; }
      int TeamAvgGamesBack { get; set; }
      double TeamPaceAdjPct { get; set; }
      int TeamPaceGamesBack { get; set; }
      int TeamSeedGames { get; set; }
      int TeamStrengthGamesBack { get; set; }
      bool TempRow { get; set; }
      double Threshold { get; set; }
      double TmStrAdjPct { get; set; }
      double TodaysMUPsOppAdjPctPt1 { get; set; }
      double TodaysMUPsOppAdjPctPt2 { get; set; }
      double TodaysMUPsOppAdjPctPt3 { get; set; }
      int UserLeagueParmsID { get; set; }
      string UserName { get; set; }
      int VolatilityGamesBack { get; set; }
      double WeightGB1 { get; set; }
      double WeightGB2 { get; set; }
      double WeightGB3 { get; set; }
   }
}