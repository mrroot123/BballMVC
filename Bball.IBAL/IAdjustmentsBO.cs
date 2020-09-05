using System;
using System.Collections.Generic;
using BballMVC.IDTOs;

namespace Bball.IBAL
{
   public interface IAdjustmentsBO
   {
      IBballDataDTO GetAdjustmentInfo(DateTime GameDate, string LeagueName);  //G2
      void GetAdjustmentInfo(IBballInfoDTO oBballInfoDTO);  //G2
      List<IAdjustmentDTO> GetTodaysAdjustments(DateTime GameDate, string LeagueName); // G1
      void InsertNewAdjustment(IAdjustmentDTO oAdjustmentDTO);
      void UpdateAdjustments(IList<IAdjustmentDTO> ocAdjustmentDTO);
      void UpdateYesterdaysAdjustments();
   }
}