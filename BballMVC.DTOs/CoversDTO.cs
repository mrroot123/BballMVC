using System;
using BballMVC.IDTOs;

namespace BballMVC.DTOs
{

   public class CoversDTO : ICoversDTO
   {

      public DateTime GameDate { get; set; }
      public string LeagueName { get; set; }
      public int RotNum { get; set; }
      public string GameTime { get; set; }
      public string TeamAway { get; set; }
      public string TeamHome { get; set; }
      public string Url { get; set; }
      public string BoxscoreNumber { get; set; }
      public float? LineTotalOpen { get; set; }
      public float? LineTotal { get; set; }
      public float? LineSideOpen { get; set; }
      public float? LineSideClose { get; set; }
      public int GameStatus { get; set; }             // 0-Not Started   1-In Progress  2-Final  (-1)-Canceled
      public int ScoreAway { get; set; }
      public int ScoreHome { get; set; }
      public int Period { get; set; }
      public int SecondsLeftInPeriod { get; set; }
   }
}