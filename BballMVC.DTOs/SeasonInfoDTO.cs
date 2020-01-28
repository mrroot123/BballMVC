using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BballMVC.DTOs
{
   public class SeasonInfoDTO
   {
      public string LeagueName { get; set; }
      public System.DateTime StartDate { get; set; }
      public System.DateTime EndDate { get; set; }
      public string Season { get; set; }
      public string SubSeason { get; set; }
      public bool Bypass { get; set; }
      public bool IncludePre { get; set; }
      public bool IncludePost { get; set; }
      public string BoxscoreSource { get; set; }
   }
}
