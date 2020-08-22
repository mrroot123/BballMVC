using System;


namespace BballMVC.IDTOs
{
   public interface ITodaysPlaysDTO
   {
      string Author { get; set; }
      DateTime CreateDate { get; set; }
      string CreateUser { get; set; }
      DateTime GameDate { get; set; }
      string GameTime { get; set; }
      string Info { get; set; }
      double Juice { get; set; }
      string LeagueName { get; set; }
      double Line { get; set; }
      bool? OT { get; set; }
      string Out { get; set; }
      double PlayAmount { get; set; }
      string PlayLength { get; set; }
      string PlayType { get; set; }
      double PlayWeight { get; set; }
      string Result { get; set; }
      double? ResultAmount { get; set; }
      int RotNum { get; set; }
      int? Score { get; set; }
      string TeamAway { get; set; }
      string TeamHome { get; set; }
      int TodaysPlaysID { get; set; }
      DateTime WeekEndDate { get; set; }
   }
}
