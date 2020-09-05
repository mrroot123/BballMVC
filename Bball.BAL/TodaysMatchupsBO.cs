using System;
using System.Collections.Generic;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DAL.Tables;
using Bball.IBAL;

namespace Bball.BAL
{
   public class TodaysMatchupsBO // : ITodaysMatchupsBO 
   {
      IBballInfoDTO _oBballInfoDTO;

      // Constructor
      public TodaysMatchupsBO(IBballInfoDTO BballInfoDTO) => _oBballInfoDTO = BballInfoDTO;

      //public void GetTodaysMatchups(IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO)
      //   => new TodaysMatchupsDO(_oBballInfoDTO).GetTodaysMatchups(ocTodaysMatchupsDTO);

   }
}
