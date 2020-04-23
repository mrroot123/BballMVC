using System.Collections.Generic;
//using BballMVC.DTOs;
using BballMVC.IDTOs;

namespace Bball.IBAL
{
   public interface IAdjustmentsBO
   {
      IAdjustmentInitDataDTO GetAdjustmentInfo(string LeagueName);
      List<IAdjustmentDTO> GetTodaysAdjustments(string LeagueName);
      void InsertNewAdjustment(IAdjustmentDTO oAdjustmentDTO);
      void UpdateAdjustments(IList<IAdjustmentDTO> ocAdjustmentDTO);
   }
}