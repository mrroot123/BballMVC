//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BballMVC.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class DailySummary
    {
        public int DailySummaryID { get; set; }
        public System.DateTime GameDate { get; set; }
        public string LeagueName { get; set; }
        public string Season { get; set; }
        public string SubSeason { get; set; }
        public int SubSeasonPeriod { get; set; }
        public int NumOfMatchups { get; set; }
        public Nullable<System.DateTime> LgAvgStartDate { get; set; }
        public Nullable<int> LgAvgGamesBack { get; set; }
        public double LgAvgScoreAway { get; set; }
        public double LgAvgScoreHome { get; set; }
        public double LgAvgScoreFinal { get; set; }
        public double LgAvgShotsMadeAwayPt1 { get; set; }
        public double LgAvgShotsMadeAwayPt2 { get; set; }
        public double LgAvgShotsMadeAwayPt3 { get; set; }
        public double LgAvgShotsMadeHomePt1 { get; set; }
        public double LgAvgShotsMadeHomePt2 { get; set; }
        public double LgAvgShotsMadeHomePt3 { get; set; }
        public double LgAvgLastMinPts { get; set; }
        public double LgAvgLastMinPt1 { get; set; }
        public double LgAvgLastMinPt2 { get; set; }
        public double LgAvgLastMinPt3 { get; set; }
    }
}
