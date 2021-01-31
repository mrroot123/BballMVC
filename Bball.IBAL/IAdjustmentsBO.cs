using System;
using System.Collections.Generic;
using BballMVC.IDTOs;
using BballMVC.DTOs;

namespace Bball.IBAL
{
   public interface IAdjustmentsBO
   {
      IBballDataDTO GetAdjustmentInfo(DateTime GameDate, string LeagueName);  //G2
      void GetAdjustmentInfo(IBballInfoDTO oBballInfoDTO);  //G2
      List<IAdjustmentDTO> GetTodaysAdjustments(DateTime GameDate, string LeagueName); // G1
      List<IAdjustmentDTO> GetTodaysAdjustmentsByTeam(DateTime GameDate, string LeagueName, string Team, double SideLine); // G1 by Team
      void InsertNewAdjustment(IAdjustmentDTO oAdjustmentDTO);
    //  void InsertNewAdjustment(IAdjustmentWrapper oAdjustmentWrapper);
      void UpdateAdjustments(IList<IAdjustmentDTO> ocAdjustmentDTO);
      void UpdateYesterdaysAdjustments();
   }
}