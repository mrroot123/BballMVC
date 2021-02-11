using System;


namespace BballMVC.IDTOs
{
   public interface ITodaysPlaysDTO
   {
      string Author { get; set; }
      DateTime CreateDate { get; set; }
      string CreateUser { get; set; }
      int? FinalScore { get; set; }
      int? ScoreAway { get; set; }
      int? ScoreHome { get; set; }
      DateTime GameDate { get; set; }
      TimeSpan GameTime { get; set; }
      string Info { get; set; }
      double Juice { get; set; }
      string LeagueName { get; set; }
      double Line { get; set; }
      decimal? OtAffacted { get; set; }
      string Out { get; set; }
      double PlayAmount { get; set; }
      string PlayDirection { get; set; }
      string PlayLength { get; set; }
      double PlayWeight { get; set; }
      int? Result { get; set; }
      double? ResultAmount { get; set; }
      int RotNum { get; set; }
      string TeamAway { get; set; }
      string TeamHome { get; set; }
      int TodaysPlaysID { get; set; }
      int? TranType { get; set; }
      DateTime WeekEndDate { get; set; }
   }
}
