
using System;
using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public class TodaysPlaysDTO : ITodaysPlaysDTO  
   {
      public int TodaysPlaysID { get; set; }
      public System.DateTime GameDate { get; set; }
      public string LeagueName { get; set; }
      public int RotNum { get; set; }
      public string GameTime { get; set; }
      public string TeamAway { get; set; }
      public string TeamHome { get; set; }
      public System.DateTime WeekEndDate { get; set; }
      public string PlayLength { get; set; }
      public string PlayDirection { get; set; }
      public string PlayType { get; set; }
      public double Line { get; set; }
      public string Info { get; set; }
      public double PlayAmount { get; set; }
      public double PlayWeight { get; set; }
      public double Juice { get; set; }
      public string Out { get; set; }
      public string Author { get; set; }
      public string Result { get; set; }
      public Nullable<bool> OT { get; set; }
      public Nullable<int> Score { get; set; }
      public Nullable<double> ResultAmount { get; set; }
      public string CreateUser { get; set; }
      public System.DateTime CreateDate { get; set; }
   }
}
