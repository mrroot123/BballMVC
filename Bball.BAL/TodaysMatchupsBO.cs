using System;
using System.Collections.Generic;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DAL.Tables;
using Bball.IBAL;

namespace Bball.BAL
{
   public class TodaysMatchupsBO : ITodaysMatchupsBO 
   {
      IBballInfoDTO _oBballInfoDTO;

      // Constructor
      public TodaysMatchupsBO(IBballInfoDTO BballInfoDTO) => _oBballInfoDTO = BballInfoDTO;

      public void GetTodaysMatchups(IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO)
      {
         TodaysMatchupsDO oTodaysMatchups = new TodaysMatchupsDO(_oBballInfoDTO);
         oTodaysMatchups.GetTodaysMatchups(ocTodaysMatchupsDTO);
      }



      //public void UpdateTodaysMatchups(IList<BballMVC.IDTOs.ITodaysMatchupsDTO> ocTodaysMatchupsDTO)
      //{
      //   TodaysMatchupsDO updTodaysMatchups = new Bball.DAL.Tables.TodaysMatchupsDO();
      //   updTodaysMatchups.UpdateTodaysMatchupsRow(ocTodaysMatchupsDTO);
      //}

   }
}
