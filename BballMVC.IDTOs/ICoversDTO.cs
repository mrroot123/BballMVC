using System;

namespace BballMVC.IDTOs
{
   public interface ICoversDTO
   {
      string BoxscoreNumber { get; set; }
      DateTime GameDate { get; set; }
      int GameStatus { get; set; }
      string GameTime { get; set; }
      string LeagueName { get; set; }
      float? LineSideClose { get; set; }
      float? LineSideOpen { get; set; }
      float? LineTotal { get; set; }
      float? LineTotalOpen { get; set; }
      int Period { get; set; }
      int RotNum { get; set; }
      int ScoreAway { get; set; }
      int ScoreHome { get; set; }
      int SecondsLeftInPeriod { get; set; }
      string TeamAway { get; set; }
      string TeamHome { get; set; }
      string Url { get; set; }
   }
}