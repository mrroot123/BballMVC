using System;
using System.Collections.Generic;
using BballMVC.IDTOs;

namespace Bball.IBAL
{
   public interface IAdjustmentsBO
   {
      IBballDataDTO GetAdjustmentInfo(DateTime GameDate, string LeagueName);
      List<IAdjustmentDTO> GetTodaysAdjustments(DateTime GameDate, string LeagueName);
      void InsertNewAdjustment(IAdjustmentDTO oAdjustmentDTO);
      void UpdateAdjustments(IList<IAdjustmentDTO> ocAdjustmentDTO);
   }
}