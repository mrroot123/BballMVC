//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;

public partial class Adjustment
{
    public int AdjustmentID { get; set; }
    public string LeagueName { get; set; }
    public System.DateTime StartDate { get; set; }
    public Nullable<System.DateTime> EndDate { get; set; }
    public string Team { get; set; }
    public string AdjustmentType { get; set; }
    public Nullable<float> AdjustmentAmount { get; set; }
    public string Player { get; set; }
    public string Desc { get; set; }
}
