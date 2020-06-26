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
         //DataDO oData = 
         new DataDO().GetLeagueNames(oBballInfoDTO);
      }

      public void GetLeagueData(IBballInfoDTO oBballInfoDTO)
      {
         //DataDO oData = 
         new DataDO().GetLeagueData(oBballInfoDTO);
      }


      //public void UpdateData(IList<BballMVC.IDTOs.IDataDTO> ocDataDTO)
      //{
      //   DataDO updData = new Bball.DAL.Tables.DataDO();
      //   updData.UpdateDataRow(ocDataDTO);
      //}

   }
}
