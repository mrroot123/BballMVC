using System;
using System.Collections.Generic;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DAL.Tables;
using Bball.IBAL;

namespace Bball.BAL
{
   
   public class DataBO : IDataBO 
   {
     // IBballInfoDTO _oBballInfoDTO;

      // Constructor
   //   public DataBO(IBballInfoDTO BballInfoDTO) => _oBballInfoDTO = BballInfoDTO;

      public void GetLeagueNames(IBballInfoDTO oBballInfoDTO)
      {
         new DataDO().GetLeagueNames(oBballInfoDTO);
      }

      public void GetLeagueData(IBballInfoDTO oBballInfoDTO)
      {
         new DataDO().GetLeagueData(oBballInfoDTO);
      }

      public void RefreshTodaysMatchups(IBballInfoDTO oBballInfoDTO)
      {
         new DataDO().RefreshTodaysMatchups(oBballInfoDTO);
      }
      public void GetBoxScoresSeeds(IBballInfoDTO oBballInfoDTO)
      {
         new DataDO().GetBoxScoresSeeds(oBballInfoDTO);
      }
      public void PostBoxScoresSeeds(IBballInfoDTO oBballInfoDTO)
      {
         new DataDO().PostBoxScoresSeeds(oBballInfoDTO);
      }


      //public void UpdateData(IList<BballMVC.IDTOs.IDataDTO> ocDataDTO)
      //{
      //   DataDO updData = new Bball.DAL.Tables.DataDO();
      //   updData.UpdateDataRow(ocDataDTO);
      //}

   }
}
