using System;
using BballMVC.IDTOs;
namespace BballMVC.DTOs
{
   public class AdjustmentWrapper : IAdjustmentWrapper
   {
      public bool DecendingAdjustment { get; set; }
      public int DecendingDays { get; set; }
      public IAdjustmentDTO oAdjustmentDTO { get; set; }
   }
}
