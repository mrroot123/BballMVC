
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
      //  const string TableColumns = "UserName,LeagueName,GameDate,Season,SubSeason,TeamAway,TeamHome,RotNum,GameTime,TV,TmStrAway,TmStrHome,UnAdjTotalAway,UnAdjTotalHome,UnAdjTotal,AdjAmt,AdjAmtAway,AdjAmtHome,AdjDbAway,AdjDbHome,AdjOTwithSide,AdjTV,OurTotalLineAway,OurTotalLineHome,OurTotalLine,SideLine,TotalLine,OpenTotalLine,Play,PlayDiff,OpenPlayDiff,AdjustedDiff,BxScLinePct,TmStrAdjPct,GB1,GB2,GB3,WeightGB1,WeightGB2,WeightGB3,AwayProjectedPt1,AwayProjectedPt2,AwayProjectedPt3,HomeProjectedPt1,HomeProjectedPt2,HomeProjectedPt3,AwayAverageAtmpUsPt1,AwayAverageAtmpUsPt2,AwayAverageAtmpUsPt3,HomeAverageAtmpUsPt1,HomeAverageAtmpUsPt2,HomeAverageAtmpUsPt3,AwayGB1,AwayGB2,AwayGB3,HomeGB1,HomeGB2,HomeGB3,AwayGB1Pt1,AwayGB1Pt2,AwayGB1Pt3,AwayGB2Pt1,AwayGB2Pt2,AwayGB2Pt3,AwayGB3Pt1,AwayGB3Pt2,AwayGB3Pt3,HomeGB1Pt1,HomeGB1Pt2,HomeGB1Pt3,HomeGB2Pt1,HomeGB2Pt2,HomeGB2Pt3,HomeGB3Pt1,HomeGB3Pt2,HomeGB3Pt3,TotalBubbleAway,TotalBubbleHome";

      IBballInfoDTO _oBballInfoDTO;

      // Constructor
      public TodaysMatchupsDO(IBballInfoDTO oBballInfoDTO) => _oBballInfoDTO = oBballInfoDTO;

      #region GetRows
      public void GetTodaysMatchups(IList<ITodaysMatchupsDTO> ocTodaysMatchupsDTO)
      {
         if (ocTodaysMatchupsDTO == null)
            ocTodaysMatchupsDTO = new List<ITodaysMatchupsDTO>();

         int rows = SysDAL.DALfunctions.ExecuteSqlQuery(_oBballInfoDTO.ConnectionString, getRowSql(), ocTodaysMatchupsDTO, populateDTOFromRdr);

      }
      static void populateDTOFromRdr(object oRow, SqlDataReader rdr)
      {
          ITodaysMatchupsDTO oTodaysMatchups = new TodaysMatchupsDTO(); //  (TodaysMatchupsDTO)oRow;

         oTodaysMatchups.TV = rdr["TV"] == DBNull.Value ? null : (string)rdr["TV"];
         oTodaysMatchups.Play = rdr["Play"].ToString().Trim();
         oTodaysMatchups.Season = rdr["Season"].ToString().Trim();
         oTodaysMatchups.SubSeason = rdr["SubSeason"].ToString().Trim();
         oTodaysMatchups.TeamAway = rdr["TeamAway"].ToString().Trim();
         oTodaysMatchups.TeamHome = rdr["TeamHome"].ToString().Trim();
         oTodaysMatchups.UserName = rdr["UserName"].ToString().Trim();
         oTodaysMatchups.LeagueName = rdr["LeagueName"].ToString().Trim();
         oTodaysMatchups.GameDate = (DateTime)rdr["GameDate"];
         oTodaysMatchups.PlayDiff = (double)rdr["PlayDiff"];
         oTodaysMatchups.OpenPlayDiff = rdr["OpenPlayDiff"] == DBNull.Value ? null : (double?)rdr["OpenPlayDiff"];
         oTodaysMatchups.AdjustedDiff = rdr["AdjustedDiff"] == DBNull.Value ? null : (double?)rdr["AdjustedDiff"];
         oTodaysMatchups.BxScLinePct = (double)rdr["BxScLinePct"];
         oTodaysMatchups.TmStrAdjPct = (double)rdr["TmStrAdjPct"];
         oTodaysMatchups.TmStrAway = (double)rdr["TmStrAway"];
         oTodaysMatchups.TmStrHome = (double)rdr["TmStrHome"];
         oTodaysMatchups.UnAdjTotalAway = (double)rdr["UnAdjTotalAway"];
         oTodaysMatchups.UnAdjTotalHome = (double)rdr["UnAdjTotalHome"];
         oTodaysMatchups.UnAdjTotal = (double)rdr["UnAdjTotal"];
         oTodaysMatchups.AdjAmt = (double)rdr["AdjAmt"];
         oTodaysMatchups.AdjAmtAway = (double)rdr["AdjAmtAway"];
         oTodaysMatchups.AdjAmtHome = (double)rdr["AdjAmtHome"];
         oTodaysMatchups.AdjDbAway = (double)rdr["AdjDbAway"];
         oTodaysMatchups.AdjDbHome = (double)rdr["AdjDbHome"];
         oTodaysMatchups.AdjOTwithSide = (double)rdr["AdjOTwithSide"];
         oTodaysMatchups.AdjTV = (double)rdr["AdjTV"];
         oTodaysMatchups.OurTotalLineAway = (double)rdr["OurTotalLineAway"];
         oTodaysMatchups.OurTotalLineHome = (double)rdr["OurTotalLineHome"];
         oTodaysMatchups.OurTotalLine = (double)rdr["OurTotalLine"];
         oTodaysMatchups.SideLine = (double)rdr["SideLine"];
         oTodaysMatchups.TotalLine = (double)rdr["TotalLine"];
         oTodaysMatchups.OpenTotalLine = rdr["OpenTotalLine"] == DBNull.Value ? null : (double?)rdr["OpenTotalLine"];
         oTodaysMatchups.AwayProjectedPt1 = rdr["AwayProjectedPt1"] == DBNull.Value ? null : (double?)rdr["AwayProjectedPt1"];
         oTodaysMatchups.AwayProjectedPt2 = rdr["AwayProjectedPt2"] == DBNull.Value ? null : (double?)rdr["AwayProjectedPt2"];
         oTodaysMatchups.AwayProjectedPt3 = rdr["AwayProjectedPt3"] == DBNull.Value ? null : (double?)rdr["AwayProjectedPt3"];
         oTodaysMatchups.HomeProjectedPt1 = rdr["HomeProjectedPt1"] == DBNull.Value ? null : (double?)rdr["HomeProjectedPt1"];
         oTodaysMatchups.HomeProjectedPt2 = rdr["HomeProjectedPt2"] == DBNull.Value ? null : (double?)rdr["HomeProjectedPt2"];
         oTodaysMatchups.HomeProjectedPt3 = rdr["HomeProjectedPt3"] == DBNull.Value ? null : (double?)rdr["HomeProjectedPt3"];
         oTodaysMatchups.AwayAverageAtmpUsPt1 = (double)rdr["AwayAverageAtmpUsPt1"];
         oTodaysMatchups.AwayAverageAtmpUsPt2 = (double)rdr["AwayAverageAtmpUsPt2"];
         oTodaysMatchups.AwayAverageAtmpUsPt3 = (double)rdr["AwayAverageAtmpUsPt3"];
         oTodaysMatchups.HomeAverageAtmpUsPt1 = (double)rdr["HomeAverageAtmpUsPt1"];
         oTodaysMatchups.HomeAverageAtmpUsPt2 = (double)rdr["HomeAverageAtmpUsPt2"];
         oTodaysMatchups.HomeAverageAtmpUsPt3 = (double)rdr["HomeAverageAtmpUsPt3"];
         oTodaysMatchups.AwayGB1 = (double)rdr["AwayGB1"];
         oTodaysMatchups.AwayGB2 = (double)rdr["AwayGB2"];
         oTodaysMatchups.AwayGB3 = (double)rdr["AwayGB3"];
         oTodaysMatchups.HomeGB1 = (double)rdr["HomeGB1"];
         oTodaysMatchups.HomeGB2 = (double)rdr["HomeGB2"];
         oTodaysMatchups.HomeGB3 = (double)rdr["HomeGB3"];
         oTodaysMatchups.AwayGB1Pt1 = (double)rdr["AwayGB1Pt1"];
         oTodaysMatchups.AwayGB1Pt2 = (double)rdr["AwayGB1Pt2"];
         oTodaysMatchups.AwayGB1Pt3 = (double)rdr["AwayGB1Pt3"];
         oTodaysMatchups.AwayGB2Pt1 = (double)rdr["AwayGB2Pt1"];
         oTodaysMatchups.AwayGB2Pt2 = (double)rdr["AwayGB2Pt2"];
         oTodaysMatchups.AwayGB2Pt3 = (double)rdr["AwayGB2Pt3"];
         oTodaysMatchups.AwayGB3Pt1 = (double)rdr["AwayGB3Pt1"];
         oTodaysMatchups.AwayGB3Pt2 = (double)rdr["AwayGB3Pt2"];
         oTodaysMatchups.AwayGB3Pt3 = (double)rdr["AwayGB3Pt3"];
         oTodaysMatchups.HomeGB1Pt1 = (double)rdr["HomeGB1Pt1"];
         oTodaysMatchups.HomeGB1Pt2 = (double)rdr["HomeGB1Pt2"];
         oTodaysMatchups.HomeGB1Pt3 = (double)rdr["HomeGB1Pt3"];
         oTodaysMatchups.HomeGB2Pt1 = (double)rdr["HomeGB2Pt1"];
         oTodaysMatchups.HomeGB2Pt2 = (double)rdr["HomeGB2Pt2"];
         oTodaysMatchups.HomeGB2Pt3 = (double)rdr["HomeGB2Pt3"];
         oTodaysMatchups.HomeGB3Pt1 = (double)rdr["HomeGB3Pt1"];
         oTodaysMatchups.HomeGB3Pt2 = (double)rdr["HomeGB3Pt2"];
         oTodaysMatchups.HomeGB3Pt3 = (double)rdr["HomeGB3Pt3"];
         oTodaysMatchups.TotalBubbleAway = rdr["TotalBubbleAway"] == DBNull.Value ? null : (double?)rdr["TotalBubbleAway"];
         oTodaysMatchups.TotalBubbleHome = rdr["TotalBubbleHome"] == DBNull.Value ? null : (double?)rdr["TotalBubbleHome"];
         oTodaysMatchups.GB1 = (int)rdr["GB1"];
         oTodaysMatchups.GB2 = (int)rdr["GB2"];
         oTodaysMatchups.GB3 = (int)rdr["GB3"];
         oTodaysMatchups.WeightGB1 = (int)rdr["WeightGB1"];
         oTodaysMatchups.WeightGB2 = (int)rdr["WeightGB2"];
         oTodaysMatchups.WeightGB3 = (int)rdr["WeightGB3"];
         oTodaysMatchups.TodaysMatchupsID = (int)rdr["TodaysMatchupsID"];
         oTodaysMatchups.RotNum = (int)rdr["RotNum"];


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

