using BballMVC.IDTOs;
namespace BballMVC.IDTOs
{
   public interface IAdjustmentWrapper
   {
      bool DecendingAdjustment { get; set; }
      int DecendingDays { get; set; }
      IAdjustmentDTO oAdjustmentDTO { get; set; }
   }
}