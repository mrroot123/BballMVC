﻿
using System;
using BballMVC.IDTOs;

namespace BballMVC.DTOs
{
   public class TodaysPlaysDTO : ITodaysPlaysDTO
   {
      public int TodaysPlaysID { get; set; }
      public Nullable<int> TranType { get; set; }
      public System.DateTime GameDate { get; set; }
      public string LeagueName { get; set; }
      public int RotNum { get; set; }
      public System.TimeSpan GameTime { get; set; }
      public string TeamAway { get; set; }
      public string TeamHome { get; set; }
      public System.DateTime WeekEndDate { get; set; }
      public string PlayLength { get; set; }
      public string PlayDirection { get; set; }
      public double Line { get; set; }
      public string Info { get; set; }
      public double PlayAmount { get; set; }
      public double PlayWeight { get; set; }
      public double Juice { get; set; }
      public string Out { get; set; }
      public string Author { get; set; }
      public Nullable<int> Result { get; set; }
      public Nullable<decimal> OtAffacted { get; set; }
      public Nullable<int> FinalScore { get; set; }
      public Nullable<int> ScoreAway { get; set; }
      public Nullable<int> ScoreHome { get; set; }
      public Nullable<int> RegScoreAway { get; set; }
      public Nullable<int> RegScoreHome { get; set; }
      public Nullable<double> ResultAmount { get; set; }
      public string CreateUser { get; set; }
      public System.DateTime CreateDate { get; set; }
   }
}
