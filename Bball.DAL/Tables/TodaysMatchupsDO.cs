
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Bball.DataBaseFunctions;
using BballMVC.DTOs;
using BballMVC.IDTOs;
using System.Data.SqlClient;

namespace Bball.DAL.Tables
{
   // Change TodaysMatchups --> TableName
   public class TodaysMatchupsDO
   {
      const string TableName = "TodaysMatchups";
    //  const string TableColumns = "~cols ...";

      IBballInfoDTO _oBballInfoDTO;

      // Constructor
      public TodaysMatchupsDO(IBballInfoDTO oBballInfoDTO) => _oBballInfoDTO = oBballInfoDTO;

      #region GetRows
      public void GetTodaysMatchups(IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO)
      {
       //  IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO = new List<ITodaysMatchupsDTO>();
         int rows = SysDAL.DALfunctions.ExecuteSqlQuery(_oBballInfoDTO.ConnectionString, getRowSql(), ocTodaysMatchupsDTO, populateDTOFromRdr);
         //return rows;
      }
      static void populateDTOFromRdr(object oRow, SqlDataReader rdr)
      {
          ITodaysMatchupsDTO oTodaysMatchups = new TodaysMatchupsDTO(); //  (TodaysMatchupsDTO)oRow;

         oTodaysMatchups.TodaysMatchupsID = (int)rdr["TodaysMatchupsID"];
         oTodaysMatchups.UserName = rdr["UserName"].ToString().Trim();
         oTodaysMatchups.LeagueName = rdr["LeagueName"].ToString().Trim();
         oTodaysMatchups.GameDate = (DateTime)rdr["GameDate"];
         oTodaysMatchups.Season = rdr["Season"].ToString().Trim();
         oTodaysMatchups.SubSeason = rdr["SubSeason"].ToString().Trim();
         oTodaysMatchups.TeamAway = rdr["TeamAway"].ToString().Trim();
         oTodaysMatchups.TeamHome = rdr["TeamHome"].ToString().Trim();
         oTodaysMatchups.RotNum = (int)rdr["RotNum"];
         oTodaysMatchups.GameTime = rdr["GameTime"] == DBNull.Value ? null : (string)rdr["GameTime"];
         oTodaysMatchups.TV   = rdr["TV"]   == DBNull.Value ? null : (string)rdr["TV"];
         oTodaysMatchups.TmStrAway = rdr["TmStrAway"] == DBNull.Value ? null : (double?)rdr["TmStrAway"];
         oTodaysMatchups.TmStrHome = rdr["TmStrHome"] == DBNull.Value ? null : (double?)rdr["TmStrHome"];
         oTodaysMatchups.UnAdjTotalAway = (double)rdr["UnAdjTotalAway"];
         oTodaysMatchups.UnAdjTotalHome = (double)rdr["UnAdjTotalHome"];
         oTodaysMatchups.UnAdjTotal = (double)rdr["UnAdjTotal"];
         oTodaysMatchups.AdjAmtAway = (double)rdr["AdjAmtAway"];
         oTodaysMatchups.AdjAmtHome = (double)rdr["AdjAmtHome"];
         oTodaysMatchups.AdjAmt = (double)rdr["AdjAmt"];
         oTodaysMatchups.AdjOTwithSide = rdr["AdjOTwithSide"] == DBNull.Value ? null : (double?)rdr["AdjOTwithSide"];
         oTodaysMatchups.OurTotalLineAway = (double)rdr["OurTotalLineAway"];
         oTodaysMatchups.OurTotalLineHome = (double)rdr["OurTotalLineHome"];
         oTodaysMatchups.OurTotalLine = (double)rdr["OurTotalLine"];
         oTodaysMatchups.SideLine = rdr["SideLine"] == DBNull.Value ? null : (double?)rdr["SideLine"];
         oTodaysMatchups.TotalLine = rdr["TotalLine"] == DBNull.Value ? null : (double?)rdr["TotalLine"];
         oTodaysMatchups.OpenTotalLine = rdr["OpenTotalLine"] == DBNull.Value ? null : (double?)rdr["OpenTotalLine"];
         oTodaysMatchups.Play = rdr["Play"] == DBNull.Value ? null : (string)rdr["Play"];
         oTodaysMatchups.LineDiff = rdr["LineDiff"] == DBNull.Value ? null : (double?)rdr["LineDiff"];
         oTodaysMatchups.OpenLineDiff = rdr["OpenLineDiff"] == DBNull.Value ? null : (double?)rdr["OpenLineDiff"];
         oTodaysMatchups.AdjustedDiff = rdr["AdjustedDiff"] == DBNull.Value ? null : (double?)rdr["AdjustedDiff"];
         oTodaysMatchups.BxScLinePct = (double)rdr["BxScLinePct"];
         oTodaysMatchups.TmStrAdjPct = (double)rdr["TmStrAdjPct"];
         oTodaysMatchups.GB1 = (int)rdr["GB1"];
         oTodaysMatchups.GB2 = (int)rdr["GB2"];
         oTodaysMatchups.GB3 = (int)rdr["GB3"];
         oTodaysMatchups.WeightGB1 = (int)rdr["WeightGB1"];
         oTodaysMatchups.WeightGB2 = (int)rdr["WeightGB2"];
         oTodaysMatchups.WeightGB3 = (int)rdr["WeightGB3"];
         oTodaysMatchups.AwayGB1 = rdr["AwayGB1"] == DBNull.Value ? null : (double?)rdr["AwayGB1"];
         oTodaysMatchups.AwayGB2 = rdr["AwayGB2"] == DBNull.Value ? null : (double?)rdr["AwayGB2"];
         oTodaysMatchups.AwayGB3 = rdr["AwayGB3"] == DBNull.Value ? null : (double?)rdr["AwayGB3"];
         oTodaysMatchups.HomeGB1 = rdr["HomeGB1"] == DBNull.Value ? null : (double?)rdr["HomeGB1"];
         oTodaysMatchups.HomeGB2 = rdr["HomeGB2"] == DBNull.Value ? null : (double?)rdr["HomeGB2"];
         oTodaysMatchups.HomeGB3 = rdr["HomeGB3"] == DBNull.Value ? null : (double?)rdr["HomeGB3"];
         oTodaysMatchups.AwayGB1Pt1 = rdr["AwayGB1Pt1"] == DBNull.Value ? null : (double?)rdr["AwayGB1Pt1"];
         oTodaysMatchups.AwayGB1Pt2 = rdr["AwayGB1Pt2"] == DBNull.Value ? null : (double?)rdr["AwayGB1Pt2"];
         oTodaysMatchups.AwayGB1Pt3 = rdr["AwayGB1Pt3"] == DBNull.Value ? null : (double?)rdr["AwayGB1Pt3"];
         oTodaysMatchups.AwayGB2Pt1 = rdr["AwayGB2Pt1"] == DBNull.Value ? null : (double?)rdr["AwayGB2Pt1"];
         oTodaysMatchups.AwayGB2Pt2 = rdr["AwayGB2Pt2"] == DBNull.Value ? null : (double?)rdr["AwayGB2Pt2"];
         oTodaysMatchups.AwayGB2Pt3 = rdr["AwayGB2Pt3"] == DBNull.Value ? null : (double?)rdr["AwayGB2Pt3"];
         oTodaysMatchups.AwayGB3Pt1 = rdr["AwayGB3Pt1"] == DBNull.Value ? null : (double?)rdr["AwayGB3Pt1"];
         oTodaysMatchups.AwayGB3Pt2 = rdr["AwayGB3Pt2"] == DBNull.Value ? null : (double?)rdr["AwayGB3Pt2"];
         oTodaysMatchups.AwayGB3Pt3 = rdr["AwayGB3Pt3"] == DBNull.Value ? null : (double?)rdr["AwayGB3Pt3"];
         oTodaysMatchups.HomeGB1Pt1 = rdr["HomeGB1Pt1"] == DBNull.Value ? null : (double?)rdr["HomeGB1Pt1"];
         oTodaysMatchups.HomeGB1Pt2 = rdr["HomeGB1Pt2"] == DBNull.Value ? null : (double?)rdr["HomeGB1Pt2"];
         oTodaysMatchups.HomeGB1Pt3 = rdr["HomeGB1Pt3"] == DBNull.Value ? null : (double?)rdr["HomeGB1Pt3"];
         oTodaysMatchups.HomeGB2Pt1 = rdr["HomeGB2Pt1"] == DBNull.Value ? null : (double?)rdr["HomeGB2Pt1"];
         oTodaysMatchups.HomeGB2Pt2 = rdr["HomeGB2Pt2"] == DBNull.Value ? null : (double?)rdr["HomeGB2Pt2"];
         oTodaysMatchups.HomeGB2Pt3 = rdr["HomeGB2Pt3"] == DBNull.Value ? null : (double?)rdr["HomeGB2Pt3"];
         oTodaysMatchups.HomeGB3Pt1 = rdr["HomeGB3Pt1"] == DBNull.Value ? null : (double?)rdr["HomeGB3Pt1"];
         oTodaysMatchups.HomeGB3Pt2 = rdr["HomeGB3Pt2"] == DBNull.Value ? null : (double?)rdr["HomeGB3Pt2"];
         oTodaysMatchups.HomeGB3Pt3 = rdr["HomeGB3Pt3"] == DBNull.Value ? null : (double?)rdr["HomeGB3Pt3"];
         oTodaysMatchups.TotalBubbleAway = rdr["TotalBubbleAway"] == DBNull.Value ? null : (double?)rdr["TotalBubbleAway"];
         oTodaysMatchups.TotalBubbleHome = rdr["TotalBubbleHome"] == DBNull.Value ? null : (double?)rdr["TotalBubbleHome"];


         ((List<ITodaysMatchupsDTO>)oRow).Add(oTodaysMatchups);

      }
      private string getRowSql()
      {
         string Sql = ""
            + $"SELECT * FROM {TableName}  "
            + $"  Where UserName = '{_oBballInfoDTO.UserName}'  And LeagueName = '{_oBballInfoDTO.LeagueName}'"
            + $"  And GameDate = '{_oBballInfoDTO.GameDate}'"
            + "   Order By RotNum"
            ;
         return Sql;
      }
      #endregion GetRows

      //#region InsertRow COMMENTED 4 now
      //public void InsertRow()
      //{
      //   TodaysMatchupsDTO oTodaysMatchupsDTO = populateDTO();
      //   //                        TableName  ColNames(csv)  DTO             Insert into DTO Method
      //   SqlFunctions.DALInsertRow(TableName, TableColumns, oTodaysMatchupsDTO, populate_ocValuesForInsert, _ConnectionString);
      //}
      //private TodaysMatchupsDTO populateDTO()
      //{
      //   TodaysMatchupsDTO oTodaysMatchupsDTO = new TodaysMatchupsDTO();
      //   oTodaysMatchupsDTO.LeagueName = _oLeagueDTO.LeagueName;
      //   // ...
      //   return oTodaysMatchupsDTO;
      //}
      //static void populate_ocValuesForInsert(List<string> ocValues, object DTO)
      //{
      //   TodaysMatchupsDTO oTodaysMatchupsDTO = (TodaysMatchupsDTO)DTO;

      //   ocValues.Add(oTodaysMatchupsDTO.GameDate.ToString());
      //   ocValues.Add(oTodaysMatchupsDTO.LeagueName.ToString());
      //}
      //#endregion InsertRow

   }  // class

}

