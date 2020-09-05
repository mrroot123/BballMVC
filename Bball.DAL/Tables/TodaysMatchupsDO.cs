
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

      //IBballInfoDTO _oBballInfoDTO;

      // Constructor
      //public TodaysMatchupsDO(IBballInfoDTO oBballInfoDTO) => _oBballInfoDTO = oBballInfoDTO;

      #region getTodaysMatchups
      public void GetTodaysMatchups(IBballInfoDTO oBballInfoDTO)
      {
         //      if (ocTodaysMatchupsDTO == null)
         oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO = new List<ITodaysMatchupsDTO>();
         string Sql = ""
            + $"SELECT * FROM {TableName}  "
            + $"  Where UserName = '{oBballInfoDTO.UserName}'  And LeagueName = '{oBballInfoDTO.LeagueName}'"
            + $"  And GameDate = '{oBballInfoDTO.GameDate}'"
            + "   Order By RotNum"
            ;
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(
            oBballInfoDTO.ConnectionString, Sql, oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO, populateDTOFromRdr);

      }
      static void populateDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         ITodaysMatchupsDTO o = new TodaysMatchupsDTO(); //  (TodaysMatchupsDTO)oRow;

         o.AdjAmt = (double)rdr["AdjAmt"];
         o.AdjAmtAway = (double)rdr["AdjAmtAway"];
         o.AdjAmtHome = (double)rdr["AdjAmtHome"];
         o.AdjDbAway = (double)rdr["AdjDbAway"];
         o.AdjDbHome = (double)rdr["AdjDbHome"];
         o.AdjOTwithSide = (double)rdr["AdjOTwithSide"];
         o.AdjPace = rdr["AdjPace"] == DBNull.Value ? null : (double?)rdr["AdjPace"];
         o.AdjRecentLeagueHistory = rdr["AdjRecentLeagueHistory"] == DBNull.Value ? null : (double?)rdr["AdjRecentLeagueHistory"];
         o.AdjTV = (double)rdr["AdjTV"];
         o.AdjustedDiff = rdr["AdjustedDiff"] == DBNull.Value ? null : (double?)rdr["AdjustedDiff"];
         o.AllAdjustmentLines = rdr["AllAdjustmentLines"] == DBNull.Value ? null : (string)rdr["AllAdjustmentLines"];
         o.AwayAverageAtmpUsPt1 = (double)rdr["AwayAverageAtmpUsPt1"];
         o.AwayAverageAtmpUsPt2 = (double)rdr["AwayAverageAtmpUsPt2"];
         o.AwayAverageAtmpUsPt3 = (double)rdr["AwayAverageAtmpUsPt3"];
         o.AwayAveragePtsAllowed = rdr["AwayAveragePtsAllowed"] == DBNull.Value ? null : (double?)rdr["AwayAveragePtsAllowed"];
         o.AwayGB1 = (double)rdr["AwayGB1"];
         o.AwayGB1Pt1 = (double)rdr["AwayGB1Pt1"];
         o.AwayGB1Pt2 = (double)rdr["AwayGB1Pt2"];
         o.AwayGB1Pt3 = (double)rdr["AwayGB1Pt3"];
         o.AwayGB2 = (double)rdr["AwayGB2"];
         o.AwayGB2Pt1 = (double)rdr["AwayGB2Pt1"];
         o.AwayGB2Pt2 = (double)rdr["AwayGB2Pt2"];
         o.AwayGB2Pt3 = (double)rdr["AwayGB2Pt3"];
         o.AwayGB3 = (double)rdr["AwayGB3"];
         o.AwayGB3Pt1 = (double)rdr["AwayGB3Pt1"];
         o.AwayGB3Pt2 = (double)rdr["AwayGB3Pt2"];
         o.AwayGB3Pt3 = (double)rdr["AwayGB3Pt3"];
         o.AwayProjectedAtmpPt1 = rdr["AwayProjectedAtmpPt1"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt1"];
         o.AwayProjectedAtmpPt2 = rdr["AwayProjectedAtmpPt2"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt2"];
         o.AwayProjectedAtmpPt3 = rdr["AwayProjectedAtmpPt3"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt3"];
         o.AwayProjectedPt1 = (double)rdr["AwayProjectedPt1"];
         o.AwayProjectedPt2 = (double)rdr["AwayProjectedPt2"];
         o.AwayProjectedPt3 = (double)rdr["AwayProjectedPt3"];
         o.BxScLinePct = (double)rdr["BxScLinePct"];
         o.Canceled = rdr["Canceled"] == DBNull.Value ? null : (bool?)rdr["Canceled"];
         o.GameDate = (DateTime)rdr["GameDate"];
         o.GameTime = rdr["GameTime"] == DBNull.Value ? null : (string)rdr["GameTime"];
         o.GB1 = (int)rdr["GB1"];
         o.GB2 = (int)rdr["GB2"];
         o.GB3 = (int)rdr["GB3"];
         o.HomeAverageAtmpUsPt1 = (double)rdr["HomeAverageAtmpUsPt1"];
         o.HomeAverageAtmpUsPt2 = (double)rdr["HomeAverageAtmpUsPt2"];
         o.HomeAverageAtmpUsPt3 = (double)rdr["HomeAverageAtmpUsPt3"];
         o.HomeAveragePtsAllowed = rdr["HomeAveragePtsAllowed"] == DBNull.Value ? null : (double?)rdr["HomeAveragePtsAllowed"];
         o.HomeGB1 = (double)rdr["HomeGB1"];
         o.HomeGB1Pt1 = (double)rdr["HomeGB1Pt1"];
         o.HomeGB1Pt2 = (double)rdr["HomeGB1Pt2"];
         o.HomeGB1Pt3 = (double)rdr["HomeGB1Pt3"];
         o.HomeGB2 = (double)rdr["HomeGB2"];
         o.HomeGB2Pt1 = (double)rdr["HomeGB2Pt1"];
         o.HomeGB2Pt2 = (double)rdr["HomeGB2Pt2"];
         o.HomeGB2Pt3 = (double)rdr["HomeGB2Pt3"];
         o.HomeGB3 = (double)rdr["HomeGB3"];
         o.HomeGB3Pt1 = (double)rdr["HomeGB3Pt1"];
         o.HomeGB3Pt2 = (double)rdr["HomeGB3Pt2"];
         o.HomeGB3Pt3 = (double)rdr["HomeGB3Pt3"];
         o.HomeProjectedAtmpPt1 = rdr["HomeProjectedAtmpPt1"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt1"];
         o.HomeProjectedAtmpPt2 = rdr["HomeProjectedAtmpPt2"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt2"];
         o.HomeProjectedAtmpPt3 = rdr["HomeProjectedAtmpPt3"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt3"];
         o.HomeProjectedPt1 = (double)rdr["HomeProjectedPt1"];
         o.HomeProjectedPt2 = (double)rdr["HomeProjectedPt2"];
         o.HomeProjectedPt3 = (double)rdr["HomeProjectedPt3"];
         o.LeagueName = rdr["LeagueName"].ToString().Trim();
         o.OpenPlayDiff = rdr["OpenPlayDiff"] == DBNull.Value ? null : (double?)rdr["OpenPlayDiff"];
         o.OpenTotalLine = rdr["OpenTotalLine"] == DBNull.Value ? null : (double?)rdr["OpenTotalLine"];
         o.OurTotalLine = (double)rdr["OurTotalLine"];
         o.OurTotalLineAway = (double)rdr["OurTotalLineAway"];
         o.OurTotalLineHome = (double)rdr["OurTotalLineHome"];
         o.Play = rdr["Play"] == DBNull.Value ? null : (string)rdr["Play"];
         o.PlayDiff = rdr["PlayDiff"] == DBNull.Value ? null : (double?)rdr["PlayDiff"];
         o.RotNum = (int)rdr["RotNum"];
         o.Season = rdr["Season"].ToString().Trim();
         o.SideLine = (double)rdr["SideLine"];
         o.SubSeason = rdr["SubSeason"].ToString().Trim();
         o.TeamAway = rdr["TeamAway"].ToString().Trim();
         o.TeamHome = rdr["TeamHome"].ToString().Trim();
         o.Threshold = (int)rdr["Threshold"];
         o.TmStrAdjPct = (double)rdr["TmStrAdjPct"];
         o.TmStrAway = (double)rdr["TmStrAway"];
         o.TmStrHome = rdr["TmStrHome"] == DBNull.Value ? null : (double?)rdr["TmStrHome"];
         o.TodaysMatchupsID = (int)rdr["TodaysMatchupsID"];
         o.TotalBubbleAway = rdr["TotalBubbleAway"] == DBNull.Value ? null : (double?)rdr["TotalBubbleAway"];
         o.TotalBubbleHome = rdr["TotalBubbleHome"] == DBNull.Value ? null : (double?)rdr["TotalBubbleHome"];
         o.TotalLine = rdr["TotalLine"] == DBNull.Value ? null : (double?)rdr["TotalLine"];
         o.TS = rdr["TS"] == DBNull.Value ? null : (DateTime?)rdr["TS"];
         o.TV = rdr["TV"] == DBNull.Value ? null : (string)rdr["TV"];
         o.UnAdjTotal = (double)rdr["UnAdjTotal"];
         o.UnAdjTotalAway = (double)rdr["UnAdjTotalAway"];
         o.UnAdjTotalHome = (double)rdr["UnAdjTotalHome"];
         o.UserName = rdr["UserName"].ToString().Trim();
         o.Volatility = rdr["Volatility"] == DBNull.Value ? null : (double?)rdr["Volatility"];
         o.VolatilityAway = rdr["VolatilityAway"] == DBNull.Value ? null : (double?)rdr["VolatilityAway"];
         o.VolatilityHome = rdr["VolatilityHome"] == DBNull.Value ? null : (double?)rdr["VolatilityHome"];
         o.WeightGB1 = (int)rdr["WeightGB1"];
         o.WeightGB2 = (int)rdr["WeightGB2"];
         o.WeightGB3 = (int)rdr["WeightGB3"];


         ((List<ITodaysMatchupsDTO>)oRow).Add(o);

      }
      #endregion getTodaysMatchups

   }  // class

}

