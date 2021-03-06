﻿using System;

namespace BballMVC.DTOs
{
   public class AdjustmentsDailyDTO
   {
      public int AdjustmentsDailyID { get; set; }
      public string LeagueName { get; set; }
      public System.DateTime GameDate { get; set; }
      public int RotNum { get; set; }
      public string Team { get; set; }
      public double AdjustmentAmount { get; set; }
   }
}
