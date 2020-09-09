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
using Newtonsoft.Json.Linq;
using Bball.DAL.Constants;

namespace Bball.DAL.Tables
{
   public class DataDO
   {
      #region adjustments
      public void InsertAdjustmentRow(IBballInfoDTO oBballInfoDTO)
      {
         // call uspInsertAdjustments to write Adj row
         AdjustmentDTO oAdjustmentDTO = oBballInfoDTO.oJObject.ToObject<AdjustmentDTO>();
         List<string> SqlParmNames = new List<string>() { "LeagueName", "StartDate", "Team", "AdjustmentDesc", "AdjustmentAmount", "Player", "Description" };
         List<object> SqlParmValues = new List<object>()
         { oAdjustmentDTO.LeagueName.ToString(), oAdjustmentDTO.StartDate.ToShortDateString(), oAdjustmentDTO.Team.ToString(), oAdjustmentDTO.AdjustmentType.ToString(),
               oAdjustmentDTO.AdjustmentAmount.ToString(), oAdjustmentDTO.Player.ToString(), oAdjustmentDTO.Description.ToString() };
         SysDAL.Functions.DALfunctions.ExecuteStoredProcedureNonQuery(oBballInfoDTO.ConnectionString, "uspInsertAdjustments", SqlParmNames, SqlParmValues);
      }

      public void UpdateAdjustments(IBballInfoDTO oBballInfoDTO)
      {
         IList<IAdjustmentDTO> ocAdjustmentDTO = oBballInfoDTO.oJObject.ToObject< IList < IAdjustmentDTO >  > ();
         DataTable tblAdjustments = new DataTable();
         tblAdjustments.Columns.Add("AdjustmentID", typeof(int));
         tblAdjustments.Columns.Add("AdjustmentAmount", typeof(string));

         foreach (var oAdjustment in ocAdjustmentDTO)
         {
            tblAdjustments.Rows.Add(oAdjustment.AdjustmentID, oAdjustment.AdjustmentAmount.ToString());
         }

         List<string> SqlParmNames = new List<string>() { "tblAdjustments", "GameDate" };
         List<object> SqlParmValues = new List<object>() { tblAdjustments, oBballInfoDTO.GameDate };
         SysDAL.Functions.DALfunctions.ExecuteStoredProcedureNonQuery(oBballInfoDTO.ConnectionString, "uspUpdateAdjustments", SqlParmNames, SqlParmValues);
      }
      #endregion adjustments

      public void GetLeagueNames(IBballInfoDTO oBballInfoDTO)
      {
         var strSql = "SELECT Distinct LeagueName, LeagueName  FROM LeagueInfo";
         SysDAL.Functions.DALfunctions.ExecuteSqlQuery(oBballInfoDTO.ConnectionString, strSql
            , oBballInfoDTO.oBballDataDTO.ocLeagueNames, Bball.DAL.Functions.DALFunctions.PopulateDropDownDTOFromRdr);
      }
      static void populateDropDownDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         List<IDropDown> ocDD = (List<IDropDown>)oRow;
         ocDD.Add(new DropDown()
            { Value = (string)rdr.GetValue(0).ToString().Trim(), Text = (string)rdr.GetValue(1).ToString().Trim() });
      }


      //public void PostData(string strJObject, string CollectionType)
      //{
      //   JObject jObject = (JObject)strJObject;
      //   switch (CollectionType)
      //   {
      //      case "UpdateAdjustments":
      //         IList<BballMVC.IDTOs.IAdjustmentDTO> ocAdjustmentDTO = jObject.ToObject<IList<BballMVC.IDTOs.IAdjustmentDTO>>();
      //         new AdjustmentsDO().UpdateAdjustmentRow(ocAdjustmentDTO);
      //         break;

      //      default:
      //         throw new Exception("DataDO.PostData - Invalid CollectionType :" + CollectionType);

      //   }

      //}

      #region GetDailySummary
      public void GetDailySummaryDTO(IBballInfoDTO oBballInfoDTO)
      {
         string getRowSql =
            $"SELECT *  FROM DailySummary Where LeagueName = '{oBballInfoDTO.LeagueName}' AND GameDate = '{oBballInfoDTO.GameDate.ToShortDateString()}' ";
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(oBballInfoDTO.ConnectionString, getRowSql
            , oBballInfoDTO.oBballDataDTO.oDailySummaryDTO, populateDailySummaryDTOFromRdr);
      }
      static void populateDailySummaryDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         DailySummaryDTO o = (DailySummaryDTO)oRow;

         o.AdjRecentLeagueHistory = rdr["AdjRecentLeagueHistory"] == DBNull.Value ? null : (double?)rdr["AdjRecentLeagueHistory"];
         o.DailySummaryID = (int)rdr["DailySummaryID"];
         o.GameDate = (DateTime)rdr["GameDate"];
         o.LeagueName = rdr["LeagueName"].ToString().Trim();
         o.LgAvgAssistsAway = rdr["LgAvgAssistsAway"] == DBNull.Value ? null : (double?)rdr["LgAvgAssistsAway"];
         o.LgAvgAssistsHome = rdr["LgAvgAssistsHome"] == DBNull.Value ? null : (double?)rdr["LgAvgAssistsHome"];
         o.LgAvgGamesBack = rdr["LgAvgGamesBack"] == DBNull.Value ? null : (int?)rdr["LgAvgGamesBack"];
         o.LgAvgLastMinPt1 = (double)rdr["LgAvgLastMinPt1"];
         o.LgAvgLastMinPt2 = (double)rdr["LgAvgLastMinPt2"];
         o.LgAvgLastMinPt3 = (double)rdr["LgAvgLastMinPt3"];
         o.LgAvgLastMinPts = (double)rdr["LgAvgLastMinPts"];
         o.LgAvgOffRBAway = rdr["LgAvgOffRBAway"] == DBNull.Value ? null : (double?)rdr["LgAvgOffRBAway"];
         o.LgAvgOffRBHome = rdr["LgAvgOffRBHome"] == DBNull.Value ? null : (double?)rdr["LgAvgOffRBHome"];
         o.LgAvgPace = rdr["LgAvgPace"] == DBNull.Value ? null : (double?)rdr["LgAvgPace"];
         o.LgAvgScoreAway = (double)rdr["LgAvgScoreAway"];
         o.LgAvgScoreFinal = (double)rdr["LgAvgScoreFinal"];
         o.LgAvgScoreHome = (double)rdr["LgAvgScoreHome"];
         o.LgAvgShotsMadeAwayPt1 = (double)rdr["LgAvgShotsMadeAwayPt1"];
         o.LgAvgShotsMadeAwayPt2 = (double)rdr["LgAvgShotsMadeAwayPt2"];
         o.LgAvgShotsMadeAwayPt3 = (double)rdr["LgAvgShotsMadeAwayPt3"];
         o.LgAvgShotsMadeHomePt1 = (double)rdr["LgAvgShotsMadeHomePt1"];
         o.LgAvgShotsMadeHomePt2 = (double)rdr["LgAvgShotsMadeHomePt2"];
         o.LgAvgShotsMadeHomePt3 = (double)rdr["LgAvgShotsMadeHomePt3"];
         o.LgAvgStartDate = rdr["LgAvgStartDate"] == DBNull.Value ? null : (DateTime?)rdr["LgAvgStartDate"];
         o.LgAvgTurnOversAway = rdr["LgAvgTurnOversAway"] == DBNull.Value ? null : (double?)rdr["LgAvgTurnOversAway"];
         o.LgAvgTurnOversHome = rdr["LgAvgTurnOversHome"] == DBNull.Value ? null : (double?)rdr["LgAvgTurnOversHome"];
         o.LgAvgVolatilityGame = rdr["LgAvgVolatilityGame"] == DBNull.Value ? null : (double?)rdr["LgAvgVolatilityGame"];
         o.LgAvgVolatilityTeam = rdr["LgAvgVolatilityTeam"] == DBNull.Value ? null : (double?)rdr["LgAvgVolatilityTeam"];
         o.NumOfMatchups = (int)rdr["NumOfMatchups"];
         o.Season = rdr["Season"].ToString().Trim();
         o.SubSeason = rdr["SubSeason"].ToString().Trim();
         o.SubSeasonPeriod = (int)rdr["SubSeasonPeriod"];
         o.TS = rdr["TS"] == DBNull.Value ? null : (DateTime?)rdr["TS"];

      }
      #endregion GetDailySummary

      public void RefreshTodaysMatchups(IBballInfoDTO oBballInfoDTO)
      {
         Exec_uspCalcTodaysMatchups(oBballInfoDTO);
         GetTodaysMatchups(oBballInfoDTO);
      }
      public void Exec_uspCalcTodaysMatchups(IBballInfoDTO oBballInfoDTO)
      {
         List<string> SqlParmNames = new List<string>() { "UserName", "LeagueName", "GameDate", "Display" };
         List<object> SqlParmValues = new List<object>() { oBballInfoDTO.UserName, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate, 0 };
         SysDAL.Functions.DALfunctions.ExecuteStoredProcedureNonQuery(oBballInfoDTO.ConnectionString, "uspCalcTodaysMatchups", SqlParmNames, SqlParmValues);
      }

      public void GetLeagueData(IBballInfoDTO oBballInfoDTO)
      {
         // Populates: 1) ocAdjustments  2) ocAdjustmentNames  3) ocTeams  
         //            4) RefreshTodaysMatchups (Exec_uspCalcTodaysMatchups, ocTodaysMatchupsDTO)  5) ocPostGameAnalysisDTO
         IBballDataDTO oBballDataDTO = new AdjustmentsDO(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName, oBballInfoDTO.ConnectionString).GetAdjustmentInfo(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName);
         oBballInfoDTO.oBballDataDTO.ocAdjustments = oBballDataDTO.ocAdjustments;
         oBballInfoDTO.oBballDataDTO.ocAdjustmentNames = oBballDataDTO.ocAdjustmentNames;
         oBballInfoDTO.oBballDataDTO.ocTeams = oBballDataDTO.ocTeams;

         RefreshTodaysMatchups(oBballInfoDTO);

         if (oBballInfoDTO.GameDate < DateTime.Today.Date)
         {
            RefreshPostGameAnalysis(oBballInfoDTO);
         }

      }
      #region getTodaysMatchups
      public void GetTodaysMatchups(IBballInfoDTO oBballInfoDTO)
      {
         //      if (ocTodaysMatchupsDTO == null)
         oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO = new List<ITodaysMatchupsDTO>();
         string Sql = ""
            + $"SELECT * FROM TodaysMatchups  "
            + $"  Where UserName = '{oBballInfoDTO.UserName}'  And LeagueName = '{oBballInfoDTO.LeagueName}'"
            + $"  And GameDate = '{oBballInfoDTO.GameDate}'"
            + "   Order By RotNum"
         ;
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(
            oBballInfoDTO.ConnectionString, Sql, oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO, populateTodaysMatchupsDTOFromRdr);

      }
      static void populateTodaysMatchupsDTOFromRdr(object oRow, SqlDataReader rdr)
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

      #region boxScoresSeed
      public void GetBoxScoresSeeds(IBballInfoDTO oBballInfoDTO)
      {
         oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO = new SeasonInfoDO(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName).oSeasonInfoDTO;

         var strSql = "SELECT * FROM BoxScoresSeeds "
                    + $" Where LeagueName = '{oBballInfoDTO.LeagueName}' AND Season = '{oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO.Season}'"
                    + " Order By Team";
         SysDAL.Functions.DALfunctions.ExecuteSqlQuery(oBballInfoDTO.ConnectionString, strSql
            , oBballInfoDTO.oBballDataDTO.ocBoxScoresSeedsDTO, populateBoxScoresSeedsDTOFromRdr);
      }
      static void populateBoxScoresSeedsDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         BoxScoresSeedsDTO dto = new BoxScoresSeedsDTO();

         dto.AdjustmentAmountAllowed = (double) rdr["AdjustmentAmountAllowed"];
         dto.AdjustmentAmountMade = (double) rdr["AdjustmentAmountMade"];
         dto.AwayShotsAdjustedAllowedPt1 = (double) rdr["AwayShotsAdjustedAllowedPt1"];
         dto.AwayShotsAdjustedAllowedPt2 = (double) rdr["AwayShotsAdjustedAllowedPt2"];
         dto.AwayShotsAdjustedAllowedPt3 = (double) rdr["AwayShotsAdjustedAllowedPt3"];
         dto.AwayShotsAdjustedMadePt1 = (double) rdr["AwayShotsAdjustedMadePt1"];
         dto.AwayShotsAdjustedMadePt2 = (double) rdr["AwayShotsAdjustedMadePt2"];
         dto.AwayShotsAdjustedMadePt3 = (double) rdr["AwayShotsAdjustedMadePt3"];
         dto.AwayShotsAllowedPt1 = (double) rdr["AwayShotsAllowedPt1"];
         dto.AwayShotsAllowedPt2 = (double) rdr["AwayShotsAllowedPt2"];
         dto.AwayShotsAllowedPt3 = (double) rdr["AwayShotsAllowedPt3"];
         dto.AwayShotsMadePt1 = (double) rdr["AwayShotsMadePt1"];
         dto.AwayShotsMadePt2 = (double) rdr["AwayShotsMadePt2"];
         dto.AwayShotsMadePt3 = (double) rdr["AwayShotsMadePt3"];
         dto.BoxScoresSeedID = (int) rdr["BoxScoresSeedID"];
         dto.CreateDate = (DateTime) rdr["CreateDate"];
         dto.GamesBack = (int) rdr["GamesBack"];
         dto.HomeShotsAdjustedAllowedPt1 = (double) rdr["HomeShotsAdjustedAllowedPt1"];
         dto.HomeShotsAdjustedAllowedPt2 = (double) rdr["HomeShotsAdjustedAllowedPt2"];
         dto.HomeShotsAdjustedAllowedPt3 = (double) rdr["HomeShotsAdjustedAllowedPt3"];
         dto.HomeShotsAdjustedMadePt1 = (double) rdr["HomeShotsAdjustedMadePt1"];
         dto.HomeShotsAdjustedMadePt2 = (double) rdr["HomeShotsAdjustedMadePt2"];
         dto.HomeShotsAdjustedMadePt3 = (double) rdr["HomeShotsAdjustedMadePt3"];
         dto.HomeShotsAllowedPt1 = (double) rdr["HomeShotsAllowedPt1"];
         dto.HomeShotsAllowedPt2 = (double) rdr["HomeShotsAllowedPt2"];
         dto.HomeShotsAllowedPt3 = (double) rdr["HomeShotsAllowedPt3"];
         dto.HomeShotsMadePt1 = (double) rdr["HomeShotsMadePt1"];
         dto.HomeShotsMadePt2 = (double) rdr["HomeShotsMadePt2"];
         dto.HomeShotsMadePt3 = (double) rdr["HomeShotsMadePt3"];
         dto.LeagueName = rdr["LeagueName"].ToString().Trim();
         dto.Season = rdr["Season"].ToString().Trim();
         dto.Team = rdr["Team"].ToString().Trim();
         dto.UpdateDate = (DateTime) rdr["UpdateDate"];
         dto.UserName = rdr["UserName"].ToString().Trim();

         ((List<IBoxScoresSeedsDTO>)oRow).Add(dto);
      }
      #endregion boxScoresSeed
      #region postGameAnalysis
      public void RefreshPostGameAnalysis(IBballInfoDTO oBballInfoDTO)
      {
         string getRowSql =
            $"SELECT *  FROM vPostGameAnalysis  Where LeagueName = '{oBballInfoDTO.LeagueName}' AND GameDate = '{oBballInfoDTO.GameDate.ToShortDateString()}' ";
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(oBballInfoDTO.ConnectionString, getRowSql
            , oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO, populatePostGameAnalysisDTOFromRdr);
      }
      static void populatePostGameAnalysisDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         vPostGameAnalysisDTO vPostGameAnalysis = new vPostGameAnalysisDTO();

         vPostGameAnalysis.TodaysMatchupsID = (int)rdr["TodaysMatchupsID"];
         vPostGameAnalysis.UserName = rdr["UserName"].ToString().Trim();
         vPostGameAnalysis.LeagueName = rdr["LeagueName"].ToString().Trim();
         vPostGameAnalysis.GameDate = (DateTime)rdr["GameDate"];
         vPostGameAnalysis.Season = rdr["Season"].ToString().Trim();
         vPostGameAnalysis.SubSeason = rdr["SubSeason"].ToString().Trim();
         vPostGameAnalysis.TeamAway = rdr["TeamAway"].ToString().Trim();
         vPostGameAnalysis.TeamHome = rdr["TeamHome"].ToString().Trim();
         vPostGameAnalysis.RotNum = (int)rdr["RotNum"];
         vPostGameAnalysis.GameTime = rdr["GameTime"] == DBNull.Value ? null : (string)rdr["GameTime"];
         vPostGameAnalysis.TV = rdr["TV"] == DBNull.Value ? null : (string)rdr["TV"];
         vPostGameAnalysis.TmStrAway = (double)rdr["TmStrAway"];
         vPostGameAnalysis.TmStrHome = rdr["TmStrHome"] == DBNull.Value ? null : (double?)rdr["TmStrHome"];
         vPostGameAnalysis.UnAdjTotalAway = (double)rdr["UnAdjTotalAway"];
         vPostGameAnalysis.UnAdjTotalHome = (double)rdr["UnAdjTotalHome"];
         vPostGameAnalysis.UnAdjTotal = (double)rdr["UnAdjTotal"];
         vPostGameAnalysis.AdjAmt = (double)rdr["AdjAmt"];
         vPostGameAnalysis.AdjAmtAway = (double)rdr["AdjAmtAway"];
         vPostGameAnalysis.AdjAmtHome = (double)rdr["AdjAmtHome"];
         vPostGameAnalysis.AdjDbAway = (double)rdr["AdjDbAway"];
         vPostGameAnalysis.AdjDbHome = (double)rdr["AdjDbHome"];
         vPostGameAnalysis.AdjOTwithSide = (double)rdr["AdjOTwithSide"];
         vPostGameAnalysis.AdjTV = (double)rdr["AdjTV"];
         vPostGameAnalysis.AdjRecentLeagueHistory = rdr["AdjRecentLeagueHistory"] == DBNull.Value ? null : (double?)rdr["AdjRecentLeagueHistory"];
         vPostGameAnalysis.AdjPace = rdr["AdjPace"] == DBNull.Value ? null : (double?)rdr["AdjPace"];
         vPostGameAnalysis.OurTotalLineAway = (double)rdr["OurTotalLineAway"];
         vPostGameAnalysis.OurTotalLineHome = (double)rdr["OurTotalLineHome"];
         vPostGameAnalysis.OurTotalLine = (double)rdr["OurTotalLine"];
         vPostGameAnalysis.SideLine = (double)rdr["SideLine"];
         vPostGameAnalysis.TotalLine = rdr["TotalLine"] == DBNull.Value ? null : (double?)rdr["TotalLine"];
         vPostGameAnalysis.OpenTotalLine = rdr["OpenTotalLine"] == DBNull.Value ? null : (double?)rdr["OpenTotalLine"];
         vPostGameAnalysis.Play = rdr["Play"].ToString().Trim();
         vPostGameAnalysis.PlayDiff = rdr["PlayDiff"] == DBNull.Value ? null : (double?)rdr["PlayDiff"];
         vPostGameAnalysis.OpenPlayDiff = rdr["OpenPlayDiff"] == DBNull.Value ? null : (double?)rdr["OpenPlayDiff"];
         vPostGameAnalysis.AdjustedDiff = rdr["AdjustedDiff"] == DBNull.Value ? null : (double?)rdr["AdjustedDiff"];
         vPostGameAnalysis.BxScLinePct = (double)rdr["BxScLinePct"];
         vPostGameAnalysis.TmStrAdjPct = (double)rdr["TmStrAdjPct"];
         vPostGameAnalysis.VolatilityAway = rdr["VolatilityAway"] == DBNull.Value ? null : (double?)rdr["VolatilityAway"];
         vPostGameAnalysis.VolatilityHome = rdr["VolatilityHome"] == DBNull.Value ? null : (double?)rdr["VolatilityHome"];
         vPostGameAnalysis.Volatility = rdr["Volatility"] == DBNull.Value ? null : (double?)rdr["Volatility"];
         vPostGameAnalysis.Threshold = (int)rdr["Threshold"];
         vPostGameAnalysis.GB1 = (int)rdr["GB1"];
         vPostGameAnalysis.GB2 = (int)rdr["GB2"];
         vPostGameAnalysis.GB3 = (int)rdr["GB3"];
         vPostGameAnalysis.WeightGB1 = (int)rdr["WeightGB1"];
         vPostGameAnalysis.WeightGB2 = (int)rdr["WeightGB2"];
         vPostGameAnalysis.WeightGB3 = (int)rdr["WeightGB3"];
         vPostGameAnalysis.AwayProjectedPt1 = (double)rdr["AwayProjectedPt1"];
         vPostGameAnalysis.AwayProjectedPt2 = (double)rdr["AwayProjectedPt2"];
         vPostGameAnalysis.AwayProjectedPt3 = (double)rdr["AwayProjectedPt3"];
         vPostGameAnalysis.HomeProjectedPt1 = (double)rdr["HomeProjectedPt1"];
         vPostGameAnalysis.HomeProjectedPt2 = (double)rdr["HomeProjectedPt2"];
         vPostGameAnalysis.HomeProjectedPt3 = (double)rdr["HomeProjectedPt3"];
         vPostGameAnalysis.AwayProjectedAtmpPt1 = rdr["AwayProjectedAtmpPt1"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt1"];
         vPostGameAnalysis.AwayProjectedAtmpPt2 = rdr["AwayProjectedAtmpPt2"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt2"];
         vPostGameAnalysis.AwayProjectedAtmpPt3 = rdr["AwayProjectedAtmpPt3"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt3"];
         vPostGameAnalysis.HomeProjectedAtmpPt1 = rdr["HomeProjectedAtmpPt1"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt1"];
         vPostGameAnalysis.HomeProjectedAtmpPt2 = rdr["HomeProjectedAtmpPt2"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt2"];
         vPostGameAnalysis.HomeProjectedAtmpPt3 = rdr["HomeProjectedAtmpPt3"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt3"];
         vPostGameAnalysis.AwayAverageAtmpUsPt1 = (double)rdr["AwayAverageAtmpUsPt1"];
         vPostGameAnalysis.AwayAverageAtmpUsPt2 = (double)rdr["AwayAverageAtmpUsPt2"];
         vPostGameAnalysis.AwayAverageAtmpUsPt3 = (double)rdr["AwayAverageAtmpUsPt3"];
         vPostGameAnalysis.HomeAverageAtmpUsPt1 = (double)rdr["HomeAverageAtmpUsPt1"];
         vPostGameAnalysis.HomeAverageAtmpUsPt2 = (double)rdr["HomeAverageAtmpUsPt2"];
         vPostGameAnalysis.HomeAverageAtmpUsPt3 = (double)rdr["HomeAverageAtmpUsPt3"];
         vPostGameAnalysis.AwayGB1 = (double)rdr["AwayGB1"];
         vPostGameAnalysis.AwayGB2 = (double)rdr["AwayGB2"];
         vPostGameAnalysis.AwayGB3 = (double)rdr["AwayGB3"];
         vPostGameAnalysis.HomeGB1 = (double)rdr["HomeGB1"];
         vPostGameAnalysis.HomeGB2 = (double)rdr["HomeGB2"];
         vPostGameAnalysis.HomeGB3 = (double)rdr["HomeGB3"];
         vPostGameAnalysis.AwayGB1Pt1 = (double)rdr["AwayGB1Pt1"];
         vPostGameAnalysis.AwayGB1Pt2 = (double)rdr["AwayGB1Pt2"];
         vPostGameAnalysis.AwayGB1Pt3 = (double)rdr["AwayGB1Pt3"];
         vPostGameAnalysis.AwayGB2Pt1 = (double)rdr["AwayGB2Pt1"];
         vPostGameAnalysis.AwayGB2Pt2 = (double)rdr["AwayGB2Pt2"];
         vPostGameAnalysis.AwayGB2Pt3 = (double)rdr["AwayGB2Pt3"];
         vPostGameAnalysis.AwayGB3Pt1 = (double)rdr["AwayGB3Pt1"];
         vPostGameAnalysis.AwayGB3Pt2 = (double)rdr["AwayGB3Pt2"];
         vPostGameAnalysis.AwayGB3Pt3 = (double)rdr["AwayGB3Pt3"];
         vPostGameAnalysis.HomeGB1Pt1 = (double)rdr["HomeGB1Pt1"];
         vPostGameAnalysis.HomeGB1Pt2 = (double)rdr["HomeGB1Pt2"];
         vPostGameAnalysis.HomeGB1Pt3 = (double)rdr["HomeGB1Pt3"];
         vPostGameAnalysis.HomeGB2Pt1 = (double)rdr["HomeGB2Pt1"];
         vPostGameAnalysis.HomeGB2Pt2 = (double)rdr["HomeGB2Pt2"];
         vPostGameAnalysis.HomeGB2Pt3 = (double)rdr["HomeGB2Pt3"];
         vPostGameAnalysis.HomeGB3Pt1 = (double)rdr["HomeGB3Pt1"];
         vPostGameAnalysis.HomeGB3Pt2 = (double)rdr["HomeGB3Pt2"];
         vPostGameAnalysis.HomeGB3Pt3 = (double)rdr["HomeGB3Pt3"];
         vPostGameAnalysis.TotalBubbleAway = rdr["TotalBubbleAway"] == DBNull.Value ? null : (double?)rdr["TotalBubbleAway"];
         vPostGameAnalysis.TotalBubbleHome = rdr["TotalBubbleHome"] == DBNull.Value ? null : (double?)rdr["TotalBubbleHome"];
         vPostGameAnalysis.TS = rdr["TS"] == DBNull.Value ? null : (DateTime?)rdr["TS"];
         vPostGameAnalysis.OtPeriods = (int)rdr["OtPeriods"];
         vPostGameAnalysis.ScoreReg = (double)rdr["ScoreReg"];
         vPostGameAnalysis.ScoreOT = (double)rdr["ScoreOT"];
         vPostGameAnalysis.ScoreRegUs = (double)rdr["ScoreRegUs"];
         vPostGameAnalysis.ScoreRegOp = (double)rdr["ScoreRegOp"];
         vPostGameAnalysis.ScoreOTUs = (double)rdr["ScoreOTUs"];
         vPostGameAnalysis.ScoreOTOp = (double)rdr["ScoreOTOp"];
         vPostGameAnalysis.ScoreQ1Us = (double)rdr["ScoreQ1Us"];
         vPostGameAnalysis.ScoreQ1Op = (double)rdr["ScoreQ1Op"];
         vPostGameAnalysis.ScoreQ2Us = (double)rdr["ScoreQ2Us"];
         vPostGameAnalysis.ScoreQ2Op = (double)rdr["ScoreQ2Op"];
         vPostGameAnalysis.ScoreQ3Us = (double)rdr["ScoreQ3Us"];
         vPostGameAnalysis.ScoreQ3Op = (double)rdr["ScoreQ3Op"];
         vPostGameAnalysis.ScoreQ4Us = (double)rdr["ScoreQ4Us"];
         vPostGameAnalysis.ScoreQ4Op = (double)rdr["ScoreQ4Op"];
         vPostGameAnalysis.ShotsActualMadeUsPt1 = (double)rdr["ShotsActualMadeUsPt1"];
         vPostGameAnalysis.ShotsActualMadeUsPt2 = (double)rdr["ShotsActualMadeUsPt2"];
         vPostGameAnalysis.ShotsActualMadeUsPt3 = (double)rdr["ShotsActualMadeUsPt3"];
         vPostGameAnalysis.ShotsActualMadeOpPt1 = (double)rdr["ShotsActualMadeOpPt1"];
         vPostGameAnalysis.ShotsActualMadeOpPt2 = (double)rdr["ShotsActualMadeOpPt2"];
         vPostGameAnalysis.ShotsActualMadeOpPt3 = (double)rdr["ShotsActualMadeOpPt3"];
         vPostGameAnalysis.ShotsActualAttemptedUsPt1 = (double)rdr["ShotsActualAttemptedUsPt1"];
         vPostGameAnalysis.ShotsActualAttemptedUsPt2 = (double)rdr["ShotsActualAttemptedUsPt2"];
         vPostGameAnalysis.ShotsActualAttemptedUsPt3 = (double)rdr["ShotsActualAttemptedUsPt3"];
         vPostGameAnalysis.ShotsActualAttemptedOpPt1 = (double)rdr["ShotsActualAttemptedOpPt1"];
         vPostGameAnalysis.ShotsActualAttemptedOpPt2 = (double)rdr["ShotsActualAttemptedOpPt2"];
         vPostGameAnalysis.ShotsActualAttemptedOpPt3 = (double)rdr["ShotsActualAttemptedOpPt3"];
         vPostGameAnalysis.ShotsMadeUsRegPt1 = (double)rdr["ShotsMadeUsRegPt1"];
         vPostGameAnalysis.ShotsMadeUsRegPt2 = (double)rdr["ShotsMadeUsRegPt2"];
         vPostGameAnalysis.ShotsMadeUsRegPt3 = (double)rdr["ShotsMadeUsRegPt3"];
         vPostGameAnalysis.ShotsMadeOpRegPt1 = (double)rdr["ShotsMadeOpRegPt1"];
         vPostGameAnalysis.ShotsMadeOpRegPt2 = (double)rdr["ShotsMadeOpRegPt2"];
         vPostGameAnalysis.ShotsMadeOpRegPt3 = (double)rdr["ShotsMadeOpRegPt3"];
         vPostGameAnalysis.ShotsAttemptedUsRegPt1 = (double)rdr["ShotsAttemptedUsRegPt1"];
         vPostGameAnalysis.ShotsAttemptedUsRegPt2 = (double)rdr["ShotsAttemptedUsRegPt2"];
         vPostGameAnalysis.ShotsAttemptedUsRegPt3 = (double)rdr["ShotsAttemptedUsRegPt3"];
         vPostGameAnalysis.ShotsAttemptedOpRegPt1 = (double)rdr["ShotsAttemptedOpRegPt1"];
         vPostGameAnalysis.ShotsAttemptedOpRegPt2 = (double)rdr["ShotsAttemptedOpRegPt2"];
         vPostGameAnalysis.ShotsAttemptedOpRegPt3 = (double)rdr["ShotsAttemptedOpRegPt3"];
         vPostGameAnalysis.TurnOversUs = (double)rdr["TurnOversUs"];
         vPostGameAnalysis.TurnOversOp = (double)rdr["TurnOversOp"];
         vPostGameAnalysis.OffRBUs = (double)rdr["OffRBUs"];
         vPostGameAnalysis.OffRBOp = (double)rdr["OffRBOp"];
         vPostGameAnalysis.AssistsUs = (double)rdr["AssistsUs"];
         vPostGameAnalysis.AssistsOp = (double)rdr["AssistsOp"];
         vPostGameAnalysis.Pace = rdr["Pace"] == DBNull.Value ? null : (double?)rdr["Pace"];

         ((List<IvPostGameAnalysisDTO>)oRow).Add(vPostGameAnalysis);
      }
      #endregion postGameAnalysis


   }
}
