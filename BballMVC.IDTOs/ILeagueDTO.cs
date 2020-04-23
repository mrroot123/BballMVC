namespace BballMVC.IDTOs
{
   public interface ILeagueDTO
   {
      string LeagueName { get; set; }
      int MinutesPerPeriod { get; set; }
      bool MultiYearLeague { get; set; }
      int OverTimeMinutes { get; set; }
      int Periods { get; set; }
   }
}