using System;
using System.Collections.Generic;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DAL.Tables;
using Bball.IBAL;

namespace Bball.BAL
{
   public class AdjustmentsBO : IAdjustmentsBO // : IAdjustmentsBO
   {
      IBballInfoDTO _oBballInfoDTO;

      public AdjustmentsBO(IBballInfoDTO oBballInfoDTO)
      {
         _oBballInfoDTO = oBballInfoDTO;
      }
      // Gets
      // G1
      public List<IAdjustmentDTO> GetTodaysAdjustments(DateTime GameDate, string LeagueName)
         => new AdjustmentsDO(_oBballInfoDTO).GetTodaysAdjustments(GameDate, LeagueName);

      // G1 new GetTodaysAdjustments
      public void GetTodaysAdjustments(IBballInfoDTO oBballInfoDTO)
         => new AdjustmentsDO().GetTodaysAdjustments(oBballInfoDTO);

      // G1 By Team
      public List<IAdjustmentDTO> GetTodaysAdjustmentsByTeam(DateTime GameDate, string LeagueName, string Team, double SideLine)
         => new AdjustmentsDO(_oBballInfoDTO).GetTodaysAdjustmentsByTeam(GameDate, LeagueName, Team, SideLine);
      // G2
      public IBballDataDTO GetAdjustmentInfo(DateTime GameDate, string LeagueName)
         => new AdjustmentsDO(_oBballInfoDTO).GetAdjustmentInfo(GameDate, LeagueName);

      public void GetAdjustmentInfo(IBballInfoDTO oBballInfoDTO)
         => new AdjustmentsDO().GetAdjustmentInfo(oBballInfoDTO);
      // G3
      public void UpdateYesterdaysAdjustments() 
         => new AdjustmentsDO(_oBballInfoDTO).UpdateYesterdaysAdjustments();

      //public void InsertNewAdjustment(IAdjustmentWrapper oAdjustmentWrapper)
      //   => new AdjustmentsDO(_oBballInfoDTO).InsertAdjustmentRow(oAdjustmentWrapper);

      public void InsertNewAdjustment(IAdjustmentDTO oAdjustmentDTO)
         => new AdjustmentsDO(_oBballInfoDTO).InsertAdjustmentRow(oAdjustmentDTO);


      public void UpdateAdjustments(IList<IAdjustmentDTO> ocAdjustmentDTO)
         => new AdjustmentsDO(_oBballInfoDTO).UpdateAdjustmentRow(ocAdjustmentDTO);

   } // class AdjustmentsBO
}
