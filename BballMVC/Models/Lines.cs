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
    
    public partial class Lines
    {
        public long LineID { get; set; }
        public string LeagueName { get; set; }
        public System.DateTime GameDate { get; set; }
        public int RotNum { get; set; }
        public string TeamAway { get; set; }
        public string TeamHome { get; set; }
        public double Line { get; set; }
        public string PlayType { get; set; }
        public string PlayDuration { get; set; }
        public System.DateTime CreateDate { get; set; }
        public string LineSource { get; set; }
    }
}
