using System;
using System.Collections.Generic;
using BballMVC.DTOs;
using Bball.DAL.Tables;

namespace Bball.BAL
{
   public class AdjustmentsBO
   {
      public List<AdjustmentDTO> GetTodaysAdjustments(string LeagueName)
      {
         Bball.DAL.Tables.AdjustmentsDO oAdjustments = new Bball.DAL.Tables.AdjustmentsDO();
         return oAdjustments.GetTodaysAdjustments(LeagueName);
      }
      
      public AdjustmentInitDataDTO GetAdjustmentInfo(string LeagueName)
      { 
         Bball.DAL.Tables.AdjustmentsDO oAdjustments = new Bball.DAL.Tables.AdjustmentsDO();
         return oAdjustments.GetAdjustmentInfo(LeagueName);
      }

      public void InsertNewAdjustment(AdjustmentDTO oAdjustmentDTO)
      {
         Bball.DAL.Tables.AdjustmentsDO newAdjustment = new Bball.DAL.Tables.AdjustmentsDO();
         newAdjustment.InsertAdjustmentRow(oAdjustmentDTO);
      }

      public void UpdateAdjustments(List<AdjustmentDTO> ocAdjustmentDTO)
      {
         Bball.DAL.Tables.AdjustmentsDO updAdjustment = new Bball.DAL.Tables.AdjustmentsDO();
         updAdjustment.UpdateAdjustmentRow(ocAdjustmentDTO);
      }
   }
}
