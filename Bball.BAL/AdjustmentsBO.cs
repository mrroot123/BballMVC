using System;
using System.Collections.Generic;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DAL.Tables;
using Bball.IBAL;

namespace Bball.BAL
{
   public class AdjustmentsBO : IAdjustmentsBO
   {
      public List<IAdjustmentDTO> GetTodaysAdjustments(DateTime GameDate, string LeagueName)
         => new AdjustmentsDO().GetTodaysAdjustments(GameDate, LeagueName);
      
      public IBballDataDTO GetAdjustmentInfo(DateTime GameDate, string LeagueName)
         => new AdjustmentsDO().GetAdjustmentInfo(GameDate, LeagueName);

      public void InsertNewAdjustment(IAdjustmentDTO oAdjustmentDTO) 
         => new AdjustmentsDO().InsertAdjustmentRow(oAdjustmentDTO);

      public void UpdateAdjustments(IList<IAdjustmentDTO> ocAdjustmentDTO)
         => new AdjustmentsDO().UpdateAdjustmentRow(ocAdjustmentDTO);

   } // class AdjustmentsBO
}
