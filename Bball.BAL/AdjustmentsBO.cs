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
      public List<BballMVC.IDTOs.IAdjustmentDTO> GetTodaysAdjustments(string LeagueName)
      {
         Bball.DAL.Tables.AdjustmentsDO oAdjustments = new Bball.DAL.Tables.AdjustmentsDO();
         return oAdjustments.GetTodaysAdjustments(LeagueName);
      }
      
      public IAdjustmentInitDataDTO GetAdjustmentInfo(string LeagueName)
      { 
         Bball.DAL.Tables.AdjustmentsDO oAdjustments = new Bball.DAL.Tables.AdjustmentsDO();
         return oAdjustments.GetAdjustmentInfo(LeagueName);
      }

      public void InsertNewAdjustment(BballMVC.IDTOs.IAdjustmentDTO oAdjustmentDTO)
      {
         Bball.DAL.Tables.AdjustmentsDO newAdjustment = new Bball.DAL.Tables.AdjustmentsDO();
         newAdjustment.InsertAdjustmentRow(oAdjustmentDTO);
      }

      public void UpdateAdjustments(IList<BballMVC.IDTOs.IAdjustmentDTO> ocAdjustmentDTO)
      {
         AdjustmentsDO updAdjustment = new Bball.DAL.Tables.AdjustmentsDO();
         updAdjustment.UpdateAdjustmentRow(ocAdjustmentDTO);
      }

    }
}
