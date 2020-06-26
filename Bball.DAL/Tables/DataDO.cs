using System;
using System.Collections.Generic;
using System.Linq;
using HtmlParsing.HtmlParsing.Functions;
using HtmlParsing.Common4vb.HtmlParsing;
using System.IO;
using System.Xml.Serialization;
using System.Data.SqlClient;
using System.Data;

using BballMVC.DTOs;
using BballMVC.IDTOs;
using Bball.DataBaseFunctions;
using Bball.DAL.Functions;

namespace Bball.DAL.Tables
{
   public class DataDO
   {
      public void GetLeagueNames(IBballInfoDTO oBballInfoDTO)
      {

         oBballInfoDTO.oBballDataDTO = new BballDataDTO();
         oBballInfoDTO.oBballDataDTO.ocLeagueNames = new List<IDropDown>();
         var strSql = "SELECT Distinct LeagueName, LeagueName  FROM LeagueInfo";
         SysDAL.DALfunctions.ExecuteSqlQuery(oBballInfoDTO.ConnectionString, strSql
            , oBballInfoDTO.oBballDataDTO.ocLeagueNames, Bball.DAL.Functions.DALFunctions.PopulateDropDownDTOFromRdr);

      }
      public void GetLeagueData(IBballInfoDTO oBballInfoDTO)
      {
         if (oBballInfoDTO.oBballDataDTO == null)
            oBballInfoDTO.oBballDataDTO = new BballDataDTO();

         IBballDataDTO oBballDataDTO = new AdjustmentsDO().GetAdjustmentInfo(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName);
         oBballInfoDTO.oBballDataDTO.ocAdjustments = oBballDataDTO.ocAdjustments;
         oBballInfoDTO.oBballDataDTO.ocAdjustmentNames = oBballDataDTO.ocAdjustmentNames;
         oBballInfoDTO.oBballDataDTO.ocTeams = oBballDataDTO.ocTeams;

         new TodaysMatchupsDO(oBballInfoDTO).GetTodaysMatchups(oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO);


      //   //  oBballInfoDTO.oBballDataDTO.ocLeagueNames = new List<IDropDown>();

      //   List<object> ocDTOs = new List<object>();
      ////   ocDTOs.Add(oBballInfoDTO.oBballDataDTO.ocLeagueNames);


      //   List<SysDAL.DALfunctions.PopulateDTO> ocDelegates = new List<SysDAL.DALfunctions.PopulateDTO>();
      //   ocDelegates.Add(Bball.DAL.Functions.DALFunctions.PopulateDropDownDTOFromRdr);

      //   List<string> SqlParmNames = new List<string>() { "GameDate", "LeagueName" };
      //   List<object> SqlParmValues = new List<object>() { oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName };
      //   SysDAL.DALfunctions.ExecuteStoredProcedureQueries(oBballInfoDTO.ConnectionString, "uspQueryAdjustmentInfo"
      //                     , SqlParmNames, SqlParmValues, ocDTOs, ocDelegates);

      }
      static void populateDropDownDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         List<IDropDown> ocDD = (List<IDropDown>)oRow;
         ocDD.Add(new DropDown() { Value = (string)rdr.GetValue(0).ToString().Trim(), Text = (string)rdr.GetValue(1).ToString().Trim() });
      }

   }
}
