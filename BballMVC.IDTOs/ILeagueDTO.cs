using System;
namespace BballMVC.IDTOs
{
   public interface ILeagueDTO
   {
      string BoxScoresL5MinURL { get; set; }
      double DefaultOTamt { get; set; }
      string LeagueColor { get; set; }
      string LeagueName { get; set; }
      int MinutesPerPeriod { get; set; }
      bool MultiYearLeague { get; set; }
      int NumberOfTeams { get; set; }
      int OverTimeMinutes { get; set; }
      int Periods { get; set; }
      DateTime StartDate { get; set; }
   }
}