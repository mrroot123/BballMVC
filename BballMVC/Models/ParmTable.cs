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
    
    public partial class ParmTable
    {
        public int ParmTableID { get; set; }
        public string ParmName { get; set; }
        public string ParmValue { get; set; }
        public string DotNetType { get; set; }
        public string Description { get; set; }
        public string Scope { get; set; }
        public string CreateUser { get; set; }
        public System.DateTime CreateDate { get; set; }
        public string UpdateUser { get; set; }
        public Nullable<System.DateTime> UpdateDate { get; set; }
    }
}
