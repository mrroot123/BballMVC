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
    
    public partial class TeamStrength
    {
        public int TeamStrengthID { get; set; }
        public string LeagueName { get; set; }
        public System.DateTime GameDate { get; set; }
        public int RotNum { get; set; }
        public string Team { get; set; }
        public string Venue { get; set; }
        public double TeamStrength1 { get; set; }
        public double TeamStrengthScored { get; set; }
        public double TeamStrengthAllowed { get; set; }
        public Nullable<double> TeamStrengthBxScAdjPctScored { get; set; }
        public Nullable<double> TeamStrengthBxScAdjPctAllowed { get; set; }
        public Nullable<double> TeamStrengthTMsAdjPctScored { get; set; }
        public Nullable<double> TeamStrengthTMsAdjPctAllowed { get; set; }
        public Nullable<double> Volatility { get; set; }
        public Nullable<double> Pace { get; set; }
        public Nullable<System.DateTime> TS { get; set; }
        public Nullable<int> GB { get; set; }
        public Nullable<int> ActualGB { get; set; }
    }
}
