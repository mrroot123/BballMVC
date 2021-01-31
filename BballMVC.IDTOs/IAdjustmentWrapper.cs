using BballMVC.IDTOs;
namespace BballMVC.IDTOs
{
   public interface IAdjustmentWrapper
   {
      bool DescendingAdjustment { get; set; }
      int DescendingDays { get; set; }
      IAdjustmentDTO oAdjustmentDTO { get; set; }
   }
}