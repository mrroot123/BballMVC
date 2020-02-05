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
    }
}
