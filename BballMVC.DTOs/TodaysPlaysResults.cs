using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BballMVC.DTOs
{
   public class TodaysPlaysResults
   {
      public string GameDate { get; set; }
      public string LeagueName { get; set; }
      public int RotNum { get; set; }
      public string GameTime { get; set; }
      public string TeamAway { get; set; }
      public string TeamHome { get; set; }
      public int Result { get; set; }
      public string PlayDirection { get; set; } // 3A - 3+
      public double Line { get; set; }          // 3B - 3+
      public double Score { get; set; }         // 5B+- 4
      public double ScoreAway { get; set; }     // 4A
      public double ScoreHome { get; set; }     // 4B
                                                // Calced props
      public string TimeStatus { get; set; }    // 5A - 5   (4) 6:20 / (OT 1) 6:20
      public string CurrentStatus { get; set; } // 5B       105 (-15)
      public string Info { get; set; }          // 6A
      public string OvUnStatus { get; set; }    // 6B - 6   Ov 10    
   }
}
