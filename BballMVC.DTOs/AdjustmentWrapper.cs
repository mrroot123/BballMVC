using System;
using BballMVC.IDTOs;
namespace BballMVC.DTOs
{
   public class AdjustmentWrapper //: IAdjustmentWrapper
   {
      public bool DescendingAdjustment { get; set; }
      public int DescendingDays { get; set; }
      public AdjustmentDTO oAdjustmentDTO { get; set; }
   }
}
