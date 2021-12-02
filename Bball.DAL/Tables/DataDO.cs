using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;

using BballMVC.DTOs;
using BballMVC.IDTOs;
using Newtonsoft.Json.Linq;
using System.Linq;
using Newtonsoft.Json;
using SysDAL.Functions;

namespace Bball.DAL.Tables
{
   public class DataDO : BaseTableDO
   {
      #region adjustments     
      #region adjustmentInsert

      public void InsertAdjustmentRow(IBballInfoDTO oBballInfoDTO)
      {
         AdjustmentWrapper oAdjustmentWrapper = oBballInfoDTO.oJObject.ToObject<AdjustmentWrapper>();
         //private readonly 
         //DateTime TS = DateTime.Now;
         if (oAdjustmentWrapper.DescendingAdjustment)
         {
            DateTime StartDate = oAdjustmentWrapper.oAdjustmentDTO.StartDate.Date;
            StartDate = StartDate.AddDays(1);
            oAdjustmentWrapper.oAdjustmentDTO.EndDate = StartDate;
            StartDate = StartDate.AddDays(1);
            double DescendingAmt = (oAdjustmentWrapper.oAdjustmentDTO.AdjustmentAmount ?? 0) / (double)oAdjustmentWrapper.DescendingDays;

            for (int i = oAdjustmentWrapper.DescendingDays; i > 0; i--)
            {
               insertAdjustmentRow(oAdjustmentWrapper.oAdjustmentDTO, oBballInfoDTO.ConnectionString, oBballInfoDTO.TS);
               oAdjustmentWrapper.oAdjustmentDTO.StartDate = StartDate;
               StartDate = StartDate.AddDays(1);
               oAdjustmentWrapper.oAdjustmentDTO.EndDate = StartDate;
               StartDate = StartDate.AddDays(1);
               oAdjustmentWrapper.oAdjustmentDTO.AdjustmentAmount -= DescendingAmt;
            }
        //    oAdjustmentWrapper.oAdjustmentDTO.StartDate = StartDate;
            oAdjustmentWrapper.oAdjustmentDTO.EndDate = null;
            oAdjustmentWrapper.oAdjustmentDTO.AdjustmentAmount = 0.0;
         }

         insertAdjustmentRow(oAdjustmentWrapper.oAdjustmentDTO, oBballInfoDTO.ConnectionString, oBballInfoDTO.TS);

      }
      private void insertAdjustmentRow(AdjustmentDTO oAdjustmentDTO, string ConnectionString, DateTime TS)
      {
         // call uspInsertAdjustments to write Adj row
         List<string> SqlParmNames = new List<string>() { "LeagueName", "StartDate", "EndDate", "TS", "Team", "AdjustmentDesc"
                                                         , "AdjustmentAmount", "Player", "Description" };
         List<object> SqlParmValues = new List<object>()
         { oAdjustmentDTO.LeagueName.ToString(), oAdjustmentDTO.StartDate.ToShortDateString()
            , oAdjustmentDTO.EndDate, TS 
            , oAdjustmentDTO.Team.ToString(), oAdjustmentDTO.AdjustmentType.ToString(),
               oAdjustmentDTO.AdjustmentAmount.ToString(), oAdjustmentDTO.Player.ToString(), oAdjustmentDTO.Description.ToString() };
         DALfunctions.ExecuteStoredProcedureNonQuery(ConnectionString, "uspInsertAdjustments", SqlParmNames, SqlParmValues);
      }
      //public void xInsertAdjustmentRow(IBballInfoDTO oBballInfoDTO)
      //{
      //   // call uspInsertAdjustments to write Adj row
      //   AdjustmentDTO oAdjustmentDTO = oBballInfoDTO.oJObject.ToObject<AdjustmentDTO>();
      //   List<string> SqlParmNames = new List<string>() { "LeagueName", "StartDate", "Team", "AdjustmentDesc"
      //                                                   , "AdjustmentAmount", "Player", "Description" };
      //   List<object> SqlParmValues = new List<object>()
      //   { oAdjustmentDTO.LeagueName.ToString(), oAdjustmentDTO.StartDate.ToShortDateString()
      //      , oAdjustmentDTO.Team.ToString(), oAdjustmentDTO.AdjustmentType.ToString(),
      //         oAdjustmentDTO.AdjustmentAmount.ToString(), oAdjustmentDTO.Player.ToString(), oAdjustmentDTO.Description.ToString() };
      //   DALfunctions.ExecuteStoredProcedureNonQuery(oBballInfoDTO.ConnectionString, "uspInsertAdjustments", SqlParmNames, SqlParmValues);
      //}

      #endregion adjustmentInsert

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

      #region todaysPlays

      public void ProcessPlays(IBballInfoDTO oBballInfoDTO)
      {
         const string TableName = "TodaysPlays";
         const string TodaysPlaysColumnNames = "GameDate,LeagueName,RotNum,GameTime,TeamAway,TeamHome,WeekEndDate,PlayLength,PlayDirection,Line,Info,PlayAmount,PlayWeight,Juice,Out,Author,CreateUser,CreateDate";
         List<string> ocColumnNames = TodaysPlaysColumnNames.Split(',').OfType<string>().ToList();

         //var obj = JsonConvert.DeserializeObject<JArray>(oBballInfoDTO.sJsonString).ToObject<List<JObject>>().FirstOrDefault();
         //JArray oJArray = (JArray)oBballInfoDTO.sJsonString;
         string jsonStr = "[{ \"id\":\"2932675\", \"t\" : \"GNK\" , \"e\" : \"LON\" , \"l\" : \"915.00\" , \"l_fix\" : \"915.00\" , \"l_cur\" : \"GBX915.00\" , \"s\": \"0\" , \"ltt\":\"5:08PM GMT\" , \"lt\" : \"Dec 11 5:08PM GMT\"}]";
         var obj = JsonConvert.DeserializeObject<JArray>(jsonStr).ToObject<List<JObject>>().FirstOrDefault();

         IList<TodaysPlaysDTO> ocAdjustmentDTO = (IList<TodaysPlaysDTO>)oBballInfoDTO.oObject;

         //JValue oJValue = (JValue)oBballInfoDTO.sJsonString;
         //dynamic xx = oJValue.ToObject<dynamic>();
         //JObject oJObject = (JObject)oBballInfoDTO.sJsonString;

         
         foreach (var oAdjustmentDTO in ocAdjustmentDTO)
         {
            List<string> ocValues = new List<string>();

            ocValues.Add(oAdjustmentDTO.GameDate.ToString());
            ocValues.Add(oAdjustmentDTO.LeagueName.ToString());
            ocValues.Add(oAdjustmentDTO.RotNum.ToString());
            ocValues.Add(oAdjustmentDTO.GameTime.ToString());
            ocValues.Add(oAdjustmentDTO.TeamAway.ToString());
            ocValues.Add(oAdjustmentDTO.TeamHome.ToString());
            ocValues.Add(oAdjustmentDTO.WeekEndDate.ToString());
            ocValues.Add(oAdjustmentDTO.PlayLength.ToString());
            ocValues.Add(oAdjustmentDTO.PlayDirection.ToString());
            ocValues.Add(oAdjustmentDTO.Line.ToString());
            ocValues.Add(oAdjustmentDTO.Info.ToString());
            ocValues.Add(oAdjustmentDTO.PlayAmount.ToString());
            ocValues.Add(oAdjustmentDTO.PlayWeight.ToString());
            ocValues.Add(oAdjustmentDTO.Juice.ToString());
            ocValues.Add(oAdjustmentDTO.Out.ToString());
            ocValues.Add(oAdjustmentDTO.Author.ToString());
            ocValues.Add(oAdjustmentDTO.CreateUser.ToString());
            ocValues.Add(oBballInfoDTO.TS.ToString());

            SysDAL.Functions.DALfunctions.InsertTableRow(oBballInfoDTO.ConnectionString, TableName, ocColumnNames, ocValues);
         }


      }
      #endregion todaysPlays

      #region leagueInfo
      public void GetLeagueNames(IBballInfoDTO oBballInfoDTO)
      {
         var strSql = "SELECT Distinct LeagueName, LeagueName  FROM LeagueInfo li ";
                 //    + $" where  dbo.udfIsLeagueOff('{oBballInfoDTO.GameDate}', li.LeagueName) = 0";

         SysDAL.Functions.DALfunctions.ExecuteSqlQuery(oBballInfoDTO.ConnectionString, strSql
            , oBballInfoDTO.oBballDataDTO.ocLeagueNames, Bball.DAL.Functions.DALFunctions.PopulateDropDownDTOFromRdr);
      }
      static void populateDropDownDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         List<IDropDown> ocDD = (List<IDropDown>)oRow;
         ocDD.Add(new DropDown()
            { Value = (string)rdr.GetValue(0).ToString().Trim(), Text = (string)rdr.GetValue(1).ToString().Trim() });
      }

      // called by DataDO
      public void GetLeagueData(IBballInfoDTO oBballInfoDTO)
      {
         // Populates: 1) ocAdjustments  2) ocAdjustmentNames  3) ocTeams  4) oLeagueDTO

         IBballDataDTO oBballDataDTO = new AdjustmentsDO(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName, oBballInfoDTO.ConnectionString)
            .GetAdjustmentInfo(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName);
         oBballInfoDTO.oBballDataDTO.ocAdjustments = oBballDataDTO.ocAdjustments;         // 1)
         oBballInfoDTO.oBballDataDTO.ocAdjustmentNames = oBballDataDTO.ocAdjustmentNames; // 2)
         oBballInfoDTO.oBballDataDTO.ocTeams = oBballDataDTO.ocTeams;                     // 3)
         new LeagueInfoDO(oBballInfoDTO);                                                 // 4)

      }
      #endregion leagueInfo

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
         Log("DataDO.GetDailySummaryDTO");
         string getRowSql =
            $"SELECT *  FROM DailySummary Where LeagueName = '{oBballInfoDTO.LeagueName}' AND GameDate = '{oBballInfoDTO.GameDate.ToShortDateString()}' ";
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(oBballInfoDTO.ConnectionString, getRowSql
            , oBballInfoDTO.oBballDataDTO.oDailySummaryDTO, populateDailySummaryDTOFromRdr);

         GetUserLeagueParmsDTO(oBballInfoDTO);
      }
      static void populateDailySummaryDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         DailySummaryDTO o = (DailySummaryDTO)oRow;

         o.DailySummaryID = (int)rdr["DailySummaryID"];
         o.GameDate = (DateTime)rdr["GameDate"];
         o.LeagueName = rdr["LeagueName"].ToString().Trim();
         o.Season = rdr["Season"].ToString().Trim();
         o.SubSeason = rdr["SubSeason"].ToString().Trim();
         o.SubSeasonPeriod = (int)rdr["SubSeasonPeriod"];
         o.NumOfMatchups = (int)rdr["NumOfMatchups"];
         o.LgAvgStartDate = rdr["LgAvgStartDate"] == DBNull.Value ? null : (DateTime?)rdr["LgAvgStartDate"];
         o.LgAvgStartDateActual = rdr["LgAvgStartDateActual"] == DBNull.Value ? null : (DateTime?)rdr["LgAvgStartDateActual"];
         o.LgAvgGamesBack = (int)rdr["LgAvgGamesBack"];
         o.LgAvgGamesBackActual = rdr["LgAvgGamesBackActual"] == DBNull.Value ? null : (int?)rdr["LgAvgGamesBackActual"];
         o.LgAvgScoreAway = (double)rdr["LgAvgScoreAway"];
         o.LgAvgScoreHome = (double)rdr["LgAvgScoreHome"];
         o.LgAvgScoreFinal = (double)rdr["LgAvgScoreFinal"];
         o.LgAvgTotalLine = rdr["LgAvgTotalLine"] == DBNull.Value ? null : (double?)rdr["LgAvgTotalLine"];
         o.LgAvgOurTotalLine = rdr["LgAvgOurTotalLine"] == DBNull.Value ? null : (double?)rdr["LgAvgOurTotalLine"];
         o.LgAvgShotsMadeAwayPt1 = (double)rdr["LgAvgShotsMadeAwayPt1"];
         o.LgAvgShotsMadeAwayPt2 = (double)rdr["LgAvgShotsMadeAwayPt2"];
         o.LgAvgShotsMadeAwayPt3 = (double)rdr["LgAvgShotsMadeAwayPt3"];
         o.LgAvgShotsMadeHomePt1 = (double)rdr["LgAvgShotsMadeHomePt1"];
         o.LgAvgShotsMadeHomePt2 = rdr["LgAvgShotsMadeHomePt2"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeHomePt2"];
         o.LgAvgShotsMadeHomePt3 = rdr["LgAvgShotsMadeHomePt3"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeHomePt3"];
         o.LgAvgShotsAttemptedAwayPt1 = rdr["LgAvgShotsAttemptedAwayPt1"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsAttemptedAwayPt1"];
         o.LgAvgShotsAttemptedAwayPt2 = rdr["LgAvgShotsAttemptedAwayPt2"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsAttemptedAwayPt2"];
         o.LgAvgShotsAttemptedAwayPt3 = rdr["LgAvgShotsAttemptedAwayPt3"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsAttemptedAwayPt3"];
         o.LgAvgShotsAttemptedHomePt1 = rdr["LgAvgShotsAttemptedHomePt1"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsAttemptedHomePt1"];
         o.LgAvgShotsAttemptedHomePt2 = rdr["LgAvgShotsAttemptedHomePt2"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsAttemptedHomePt2"];
         o.LgAvgShotsAttemptedHomePt3 = rdr["LgAvgShotsAttemptedHomePt3"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsAttemptedHomePt3"];
         o.LgAvgShotPct = rdr["LgAvgShotPct"] == DBNull.Value ? null : (double?)rdr["LgAvgShotPct"];
         o.LgAvgShotPctPt2 = rdr["LgAvgShotPctPt2"] == DBNull.Value ? null : (double?)rdr["LgAvgShotPctPt2"];
         o.LgAvgShotPctPt3 = rdr["LgAvgShotPctPt3"] == DBNull.Value ? null : (double?)rdr["LgAvgShotPctPt3"];
         o.LgAvgLastMinPts = rdr["LgAvgLastMinPts"] == DBNull.Value ? null : (double?)rdr["LgAvgLastMinPts"];
         o.LgAvgLastMinPt1 = rdr["LgAvgLastMinPt1"] == DBNull.Value ? null : (double?)rdr["LgAvgLastMinPt1"];
         o.LgAvgLastMinPt2 = rdr["LgAvgLastMinPt2"] == DBNull.Value ? null : (double?)rdr["LgAvgLastMinPt2"];
         o.LgAvgLastMinPt3 = rdr["LgAvgLastMinPt3"] == DBNull.Value ? null : (double?)rdr["LgAvgLastMinPt3"];
         o.LgAvgTurnOversAway = rdr["LgAvgTurnOversAway"] == DBNull.Value ? null : (double?)rdr["LgAvgTurnOversAway"];
         o.LgAvgTurnOversHome = rdr["LgAvgTurnOversHome"] == DBNull.Value ? null : (double?)rdr["LgAvgTurnOversHome"];
         o.LgAvgOffRBAway = rdr["LgAvgOffRBAway"] == DBNull.Value ? null : (double?)rdr["LgAvgOffRBAway"];
         o.LgAvgOffRBHome = rdr["LgAvgOffRBHome"] == DBNull.Value ? null : (double?)rdr["LgAvgOffRBHome"];
         o.LgAvgAssistsAway = rdr["LgAvgAssistsAway"] == DBNull.Value ? null : (double?)rdr["LgAvgAssistsAway"];
         o.LgAvgAssistsHome = rdr["LgAvgAssistsHome"] == DBNull.Value ? null : (double?)rdr["LgAvgAssistsHome"];
         o.LgAvgPace = rdr["LgAvgPace"] == DBNull.Value ? null : (double?)rdr["LgAvgPace"];
         o.LgAvgVolatilityTeam = rdr["LgAvgVolatilityTeam"] == DBNull.Value ? null : (double?)rdr["LgAvgVolatilityTeam"];
         o.LgAvgVolatilityGame = rdr["LgAvgVolatilityGame"] == DBNull.Value ? null : (double?)rdr["LgAvgVolatilityGame"];
         o.AdjRecentLeagueHistory = rdr["AdjRecentLeagueHistory"] == DBNull.Value ? null : (double?)rdr["AdjRecentLeagueHistory"];
         o.TS = rdr["TS"] == DBNull.Value ? null : (DateTime?)rdr["TS"];


      }

      // kdtodo delete commened InsertDailySummary 3/15/2021
      //public void InsertDailySummary(IBballInfoDTO oBballInfoDTO, int NumOfMatchups)
      //{
      //   SeasonInfoDO oSeasonInfo = new SeasonInfoDO(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName, oBballInfoDTO.ConnectionString);

      //   // Populate Basic columns

      //   // 

      //   List<string> ocColumnNames = new List<string>() { "GameDate", "LeagueName", "Season", "SubSeason", "SubSeasonPeriod", "NumOfMatchups" };
      //   List<string> ocColumnValues = new List<string>()
      //   {
      //      oBballInfoDTO.GameDate.ToShortDateString(),
      //      oBballInfoDTO.LeagueName,
      //      oSeasonInfo.oSeasonInfoDTO.Season,
      //      oSeasonInfo.oSeasonInfoDTO.SubSeason,
      //      SeasonInfoDO.CalcSubSeasonPeriod(oBballInfoDTO.ConnectionString, oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName).ToString(),
      //      NumOfMatchups.ToString()
      //   };

      //   SysDAL.Functions.DALfunctions.InsertTableRow(oBballInfoDTO.ConnectionString, "DailySummary", ocColumnNames, ocColumnValues);

      //}
      #endregion GetDailySummary

      #region todaysMatchups
      public void RefreshTodaysMatchups(IBballInfoDTO oBballInfoDTO)
      {
         Log("DataDO.Exec_uspCalcTodaysMatchups." + oBballInfoDTO.LeagueName);
         List<string> SqlParmNames = new List<string>() { "UserName", "LeagueName", "GameDate", "Display" };
         List<object> SqlParmValues = new List<object>() { oBballInfoDTO.UserName, oBballInfoDTO.LeagueName, oBballInfoDTO.GameDate, 0 };
         SysDAL.Functions.DALfunctions.ExecuteStoredProcedureNonQuery(oBballInfoDTO.ConnectionString, uspCalcTodaysMatchups, SqlParmNames, SqlParmValues);

         GetTodaysMatchups(oBballInfoDTO);

         new DataDO().GetUserLeagueParmsDTO(oBballInfoDTO);
         new LeagueInfoDO(oBballInfoDTO);

      }

      public void GetTodaysMatchups(IBballInfoDTO oBballInfoDTO)
      {
         //      if (ocTodaysMatchupsDTO == null)
         oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO = new List<ITodaysMatchupsDTO>();
         string Sql = ""
            + $"SELECT tp.Played, r.Canceled AS rCanceled, tm.* "
            + $"  FROM TodaysMatchups tm "
            + $"  Join Rotation r ON r.GameDate = tm.GameDate and r.RotNum = tm.RotNum "
            + $"  Left Join "
            + $"   ( SELECT GameDate, RotNum, 'Played' as Played FROM TodaysPlays where GameDate = '{oBballInfoDTO.GameDate.ToShortDateString()}'  Group By GameDate, RotNum )"
            + $"      tp ON tp.GameDate = tm.GameDate AND tp.RotNum = tm.RotNum AND tm.Play <> ''"
            + $"  Where tm.UserName = '{oBballInfoDTO.UserName}'  And tm.LeagueName = '{oBballInfoDTO.LeagueName}'"
            + $"    And tm.GameDate = '{oBballInfoDTO.GameDate.ToShortDateString()}'"
            + "   Order By tm.RotNum"
         ;

         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(
            oBballInfoDTO.ConnectionString, Sql, oBballInfoDTO.oBballDataDTO.ocTodaysMatchupsDTO, populateTodaysMatchupsDTOFromRdr);

         GetDailySummaryDTO(oBballInfoDTO);

         // POC
 //        var ocJObject = new List <JObject>();
   //      DALfunctions.ExecuteDynamicSqlQuery(oBballInfoDTO.ConnectionString, Sql, ocJObject);
      }
      static void populateTodaysMatchupsDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         ITodaysMatchupsDTO o = new TodaysMatchupsDTO(); //  (TodaysMatchupsDTO)oRow;

         o.TodaysMatchupsID = (int)rdr["TodaysMatchupsID"];
         o.UserName = rdr["UserName"].ToString().Trim();
         o.LeagueName = rdr["LeagueName"].ToString().Trim();
         o.GameDate = (DateTime)rdr["GameDate"];
         o.Season = rdr["Season"].ToString().Trim();
         o.SubSeason = rdr["SubSeason"].ToString().Trim();
         o.TeamAway = rdr["TeamAway"].ToString().Trim();
         o.TeamHome = rdr["TeamHome"].ToString().Trim();
         o.RotNum = (int)rdr["RotNum"];
         o.GameTime = rdr["GameTime"] == DBNull.Value ? null : (string)rdr["GameTime"];
         o.Canceled = rdr["Canceled"] == DBNull.Value ? null : (bool?)rdr["Canceled"];
         o.TV = rdr["TV"] == DBNull.Value ? null : (string)rdr["TV"];
         o.TmStrAway = (double)rdr["TmStrAway"];
         o.TmStrHome = rdr["TmStrHome"] == DBNull.Value ? null : (double?)rdr["TmStrHome"];
         o.TeamRecordAway = rdr["TeamRecordAway"] == DBNull.Value ? null : (string)rdr["TeamRecordAway"];
         o.TeamRecordHome = rdr["TeamRecordHome"] == DBNull.Value ? null : (string)rdr["TeamRecordHome"];
         o.UnAdjTotalAway = rdr["UnAdjTotalAway"] == DBNull.Value ? null : (double?)rdr["UnAdjTotalAway"];
         o.UnAdjTotalHome = (double)rdr["UnAdjTotalHome"];
         o.UnAdjTotal = (double)rdr["UnAdjTotal"];
         o.UnAdjTotalAwayPlanB = rdr["UnAdjTotalAwayPlanB"] == DBNull.Value ? null : (double?)rdr["UnAdjTotalAwayPlanB"];
         o.UnAdjTotalHomePlanB = rdr["UnAdjTotalHomePlanB"] == DBNull.Value ? null : (double?)rdr["UnAdjTotalHomePlanB"];
         o.UnAdjTotalPlanB = rdr["UnAdjTotalPlanB"] == DBNull.Value ? null : (double?)rdr["UnAdjTotalPlanB"];
         o.CalcAwayGB1PlanB = rdr["CalcAwayGB1PlanB"] == DBNull.Value ? null : (double?)rdr["CalcAwayGB1PlanB"];
         o.CalcAwayGB2PlanB = rdr["CalcAwayGB2PlanB"] == DBNull.Value ? null : (double?)rdr["CalcAwayGB2PlanB"];
         o.CalcAwayGB3PlanB = rdr["CalcAwayGB3PlanB"] == DBNull.Value ? null : (double?)rdr["CalcAwayGB3PlanB"];
         o.CalcHomeGB1PlanB = rdr["CalcHomeGB1PlanB"] == DBNull.Value ? null : (double?)rdr["CalcHomeGB1PlanB"];
         o.CalcHomeGB2PlanB = rdr["CalcHomeGB2PlanB"] == DBNull.Value ? null : (double?)rdr["CalcHomeGB2PlanB"];
         o.CalcHomeGB3PlanB = rdr["CalcHomeGB3PlanB"] == DBNull.Value ? null : (double?)rdr["CalcHomeGB3PlanB"];
         o.AwayAveragePtsScored = rdr["AwayAveragePtsScored"] == DBNull.Value ? null : (double?)rdr["AwayAveragePtsScored"];
         o.HomeAveragePtsScored = rdr["HomeAveragePtsScored"] == DBNull.Value ? null : (double?)rdr["HomeAveragePtsScored"];
         o.AwayAveragePtsAllowed = rdr["AwayAveragePtsAllowed"] == DBNull.Value ? null : (double?)rdr["AwayAveragePtsAllowed"];
         o.HomeAveragePtsAllowed = rdr["HomeAveragePtsAllowed"] == DBNull.Value ? null : (double?)rdr["HomeAveragePtsAllowed"];
         o.AdjAmt = (double)rdr["AdjAmt"];
         o.AdjAmtAway = (double)rdr["AdjAmtAway"];
         o.AdjAmtHome = (double)rdr["AdjAmtHome"];
         o.AdjDbAway = (double)rdr["AdjDbAway"];
         o.AdjDbHome = (double)rdr["AdjDbHome"];
         o.AdjOTwithSide = (double)rdr["AdjOTwithSide"];
         o.AdjTV = (double)rdr["AdjTV"];
         o.AdjRecentLeagueHistory = rdr["AdjRecentLeagueHistory"] == DBNull.Value ? null : (double?)rdr["AdjRecentLeagueHistory"];
         o.AdjPaceAway = rdr["AdjPaceAway"] == DBNull.Value ? null : (double?)rdr["AdjPaceAway"];
         o.AdjPaceHome = rdr["AdjPaceHome"] == DBNull.Value ? null : (double?)rdr["AdjPaceHome"];
         o.AdjTeamAway = rdr["AdjTeamAway"] == DBNull.Value ? null : (double?)rdr["AdjTeamAway"];
         o.AdjTeamHome = rdr["AdjTeamHome"] == DBNull.Value ? null : (double?)rdr["AdjTeamHome"];
         o.OurTotalLineAway = (double)rdr["OurTotalLineAway"];
         o.OurTotalLineHome = (double)rdr["OurTotalLineHome"];
         o.OurTotalLine = (double)rdr["OurTotalLine"];
         o.SideLine = (double)rdr["SideLine"];
         o.TotalLine = rdr["TotalLine"] == DBNull.Value ? null : (double?)rdr["TotalLine"];
         o.OpenTotalLine = rdr["OpenTotalLine"] == DBNull.Value ? null : (double?)rdr["OpenTotalLine"];
         o.Play = rdr["Play"] == DBNull.Value ? null : (string)rdr["Play"];
         o.Played = rdr["Played"] == DBNull.Value ? null : (string)rdr["Played"];
         o.PlayDiff = rdr["PlayDiff"] == DBNull.Value ? null : (double?)rdr["PlayDiff"];
         o.OpenPlayDiff = rdr["OpenPlayDiff"] == DBNull.Value ? null : (double?)rdr["OpenPlayDiff"];
         o.AdjustedDiff = rdr["AdjustedDiff"] == DBNull.Value ? null : (double?)rdr["AdjustedDiff"];
         o.BxScLinePct = (double)rdr["BxScLinePct"];
         o.TmStrAdjPct = (double)rdr["TmStrAdjPct"];
         o.VolatilityAway = rdr["VolatilityAway"] == DBNull.Value ? null : (double?)rdr["VolatilityAway"];
         o.VolatilityHome = rdr["VolatilityHome"] == DBNull.Value ? null : (double?)rdr["VolatilityHome"];
         o.Volatility = rdr["Volatility"] == DBNull.Value ? null : (double?)rdr["Volatility"];
         o.Threshold = (int)rdr["Threshold"];
         o.GB1 = (int)rdr["GB1"];
         o.GB2 = (int)rdr["GB2"];
         o.GB3 = (int)rdr["GB3"];
         o.WeightGB1 = (int)rdr["WeightGB1"];
         o.WeightGB2 = (int)rdr["WeightGB2"];
         o.WeightGB3 = (int)rdr["WeightGB3"];
         o.AwayProjectedPt1 = (double)rdr["AwayProjectedPt1"];
         o.AwayProjectedPt2 = (double)rdr["AwayProjectedPt2"];
         o.AwayProjectedPt3 = (double)rdr["AwayProjectedPt3"];
         o.HomeProjectedPt1 = (double)rdr["HomeProjectedPt1"];
         o.HomeProjectedPt2 = (double)rdr["HomeProjectedPt2"];
         o.HomeProjectedPt3 = (double)rdr["HomeProjectedPt3"];
         o.AwayProjectedAtmpPt1 = rdr["AwayProjectedAtmpPt1"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt1"];
         o.AwayProjectedAtmpPt2 = rdr["AwayProjectedAtmpPt2"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt2"];
         o.AwayProjectedAtmpPt3 = rdr["AwayProjectedAtmpPt3"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt3"];
         o.HomeProjectedAtmpPt1 = rdr["HomeProjectedAtmpPt1"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt1"];
         o.HomeProjectedAtmpPt2 = rdr["HomeProjectedAtmpPt2"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt2"];
         o.HomeProjectedAtmpPt3 = rdr["HomeProjectedAtmpPt3"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt3"];
         o.AwayAverageAtmpUsPt1 = (double)rdr["AwayAverageAtmpUsPt1"];
         o.AwayAverageAtmpUsPt2 = (double)rdr["AwayAverageAtmpUsPt2"];
         o.AwayAverageAtmpUsPt3 = (double)rdr["AwayAverageAtmpUsPt3"];
         o.HomeAverageAtmpUsPt1 = (double)rdr["HomeAverageAtmpUsPt1"];
         o.HomeAverageAtmpUsPt2 = (double)rdr["HomeAverageAtmpUsPt2"];
         o.HomeAverageAtmpUsPt3 = (double)rdr["HomeAverageAtmpUsPt3"];
         o.AwayGB1 = (double)rdr["AwayGB1"];
         o.AwayGB2 = (double)rdr["AwayGB2"];
         o.AwayGB3 = (double)rdr["AwayGB3"];
         o.HomeGB1 = (double)rdr["HomeGB1"];
         o.HomeGB2 = (double)rdr["HomeGB2"];
         o.HomeGB3 = (double)rdr["HomeGB3"];
         o.AwayGB1Pt1 = (double)rdr["AwayGB1Pt1"];
         o.AwayGB1Pt2 = (double)rdr["AwayGB1Pt2"];
         o.AwayGB1Pt3 = (double)rdr["AwayGB1Pt3"];
         o.AwayGB2Pt1 = (double)rdr["AwayGB2Pt1"];
         o.AwayGB2Pt2 = (double)rdr["AwayGB2Pt2"];
         o.AwayGB2Pt3 = (double)rdr["AwayGB2Pt3"];
         o.AwayGB3Pt1 = (double)rdr["AwayGB3Pt1"];
         o.AwayGB3Pt2 = (double)rdr["AwayGB3Pt2"];
         o.AwayGB3Pt3 = (double)rdr["AwayGB3Pt3"];
         o.HomeGB1Pt1 = (double)rdr["HomeGB1Pt1"];
         o.HomeGB1Pt2 = (double)rdr["HomeGB1Pt2"];
         o.HomeGB1Pt3 = (double)rdr["HomeGB1Pt3"];
         o.HomeGB2Pt1 = (double)rdr["HomeGB2Pt1"];
         o.HomeGB2Pt2 = (double)rdr["HomeGB2Pt2"];
         o.HomeGB2Pt3 = (double)rdr["HomeGB2Pt3"];
         o.HomeGB3Pt1 = (double)rdr["HomeGB3Pt1"];
         o.HomeGB3Pt2 = (double)rdr["HomeGB3Pt2"];
         o.HomeGB3Pt3 = (double)rdr["HomeGB3Pt3"];
         o.AwayAverageMadePt1 = rdr["AwayAverageMadePt1"] == DBNull.Value ? null : (double?)rdr["AwayAverageMadePt1"];
         o.AwayAverageMadePt2 = rdr["AwayAverageMadePt2"] == DBNull.Value ? null : (double?)rdr["AwayAverageMadePt2"];
         o.AwayAverageMadePt3 = rdr["AwayAverageMadePt3"] == DBNull.Value ? null : (double?)rdr["AwayAverageMadePt3"];
         o.HomeAverageMadePt1 = rdr["HomeAverageMadePt1"] == DBNull.Value ? null : (double?)rdr["HomeAverageMadePt1"];
         o.HomeAverageMadePt2 = rdr["HomeAverageMadePt2"] == DBNull.Value ? null : (double?)rdr["HomeAverageMadePt2"];
         o.HomeAverageMadePt3 = rdr["HomeAverageMadePt3"] == DBNull.Value ? null : (double?)rdr["HomeAverageMadePt3"];
         o.AwayAverageAllowedPt1 = rdr["AwayAverageAllowedPt1"] == DBNull.Value ? null : (double?)rdr["AwayAverageAllowedPt1"];
         o.AwayAverageAllowedPt2 = rdr["AwayAverageAllowedPt2"] == DBNull.Value ? null : (double?)rdr["AwayAverageAllowedPt2"];
         o.AwayAverageAllowedPt3 = rdr["AwayAverageAllowedPt3"] == DBNull.Value ? null : (double?)rdr["AwayAverageAllowedPt3"];
         o.HomeAverageAllowedPt1 = rdr["HomeAverageAllowedPt1"] == DBNull.Value ? null : (double?)rdr["HomeAverageAllowedPt1"];
         o.HomeAverageAllowedPt2 = rdr["HomeAverageAllowedPt2"] == DBNull.Value ? null : (double?)rdr["HomeAverageAllowedPt2"];
         o.HomeAverageAllowedPt3 = rdr["HomeAverageAllowedPt3"] == DBNull.Value ? null : (double?)rdr["HomeAverageAllowedPt3"];
         o.LgAvgShotsMadeAwayPt1 = rdr["LgAvgShotsMadeAwayPt1"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeAwayPt1"];
         o.LgAvgShotsMadeAwayPt2 = rdr["LgAvgShotsMadeAwayPt2"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeAwayPt2"];
         o.LgAvgShotsMadeAwayPt3 = rdr["LgAvgShotsMadeAwayPt3"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeAwayPt3"];
         o.LgAvgShotsMadeHomePt1 = rdr["LgAvgShotsMadeHomePt1"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeHomePt1"];
         o.LgAvgShotsMadeHomePt2 = rdr["LgAvgShotsMadeHomePt2"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeHomePt2"];
         o.LgAvgShotsMadeHomePt3 = rdr["LgAvgShotsMadeHomePt3"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeHomePt3"];
         o.AverageMadeAwayGB1Pt1 = rdr["AverageMadeAwayGB1Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB1Pt1"];
         o.AverageMadeAwayGB1Pt2 = rdr["AverageMadeAwayGB1Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB1Pt2"];
         o.AverageMadeAwayGB1Pt3 = rdr["AverageMadeAwayGB1Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB1Pt3"];
         o.AverageMadeAwayGB2Pt1 = rdr["AverageMadeAwayGB2Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB2Pt1"];
         o.AverageMadeAwayGB2Pt2 = rdr["AverageMadeAwayGB2Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB2Pt2"];
         o.AverageMadeAwayGB2Pt3 = rdr["AverageMadeAwayGB2Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB2Pt3"];
         o.AverageMadeAwayGB3Pt1 = rdr["AverageMadeAwayGB3Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB3Pt1"];
         o.AverageMadeAwayGB3Pt2 = rdr["AverageMadeAwayGB3Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB3Pt2"];
         o.AverageMadeAwayGB3Pt3 = rdr["AverageMadeAwayGB3Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB3Pt3"];
         o.AverageMadeHomeGB1Pt1 = rdr["AverageMadeHomeGB1Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB1Pt1"];
         o.AverageMadeHomeGB1Pt2 = rdr["AverageMadeHomeGB1Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB1Pt2"];
         o.AverageMadeHomeGB1Pt3 = rdr["AverageMadeHomeGB1Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB1Pt3"];
         o.AverageMadeHomeGB2Pt1 = rdr["AverageMadeHomeGB2Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB2Pt1"];
         o.AverageMadeHomeGB2Pt2 = rdr["AverageMadeHomeGB2Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB2Pt2"];
         o.AverageMadeHomeGB2Pt3 = rdr["AverageMadeHomeGB2Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB2Pt3"];
         o.AverageMadeHomeGB3Pt1 = rdr["AverageMadeHomeGB3Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB3Pt1"];
         o.AverageMadeHomeGB3Pt2 = rdr["AverageMadeHomeGB3Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB3Pt2"];
         o.AverageMadeHomeGB3Pt3 = rdr["AverageMadeHomeGB3Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB3Pt3"];
         o.TMoppAdjPct = rdr["TMoppAdjPct"] == DBNull.Value ? null : (double?)rdr["TMoppAdjPct"];
         o.TotalBubbleAway = rdr["TotalBubbleAway"] == DBNull.Value ? null : (double?)rdr["TotalBubbleAway"];
         o.TotalBubbleHome = rdr["TotalBubbleHome"] == DBNull.Value ? null : (double?)rdr["TotalBubbleHome"];
         o.TS = rdr["TS"] == DBNull.Value ? null : (DateTime?)rdr["TS"];
         o.AllAdjustmentLines = rdr["AllAdjustmentLines"] == DBNull.Value ? null : (string)rdr["AllAdjustmentLines"];
         o.AwayActualGB1 = rdr["AwayActualGB1"] == DBNull.Value ? null : (int?)rdr["AwayActualGB1"];
         o.AwayActualGB2 = rdr["AwayActualGB2"] == DBNull.Value ? null : (int?)rdr["AwayActualGB2"];
         o.AwayActualGB3 = rdr["AwayActualGB3"] == DBNull.Value ? null : (int?)rdr["AwayActualGB3"];
         o.AwayActualGBTeam = rdr["AwayActualGBTeam"] == DBNull.Value ? null : (int?)rdr["AwayActualGBTeam"];
         o.HomeActualGB1 = rdr["HomeActualGB1"] == DBNull.Value ? null : (int?)rdr["HomeActualGB1"];
         o.HomeActualGB2 = rdr["HomeActualGB2"] == DBNull.Value ? null : (int?)rdr["HomeActualGB2"];
         o.HomeActualGB3 = rdr["HomeActualGB3"] == DBNull.Value ? null : (int?)rdr["HomeActualGB3"];
         o.HomeActualGBTeam = rdr["HomeActualGBTeam"] == DBNull.Value ? null : (int?)rdr["HomeActualGBTeam"];


         ((List<ITodaysMatchupsDTO>)oRow).Add(o);

      }
      #endregion todaysMatchups

      #region boxScoresSeed
      public void GetBoxScoresSeeds(IBballInfoDTO oBballInfoDTO)
      {
         oBballInfoDTO.oBballDataDTO.oSeasonInfoDTO = new SeasonInfoDO(oBballInfoDTO.GameDate, oBballInfoDTO.LeagueName, oBballInfoDTO.ConnectionString).oSeasonInfoDTO;

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
         RefreshPostGameAnalysisJson(oBballInfoDTO); return;

         string getRowSql =
            $"SELECT *  FROM vPostGameAnalysis  Where LeagueName = '{oBballInfoDTO.LeagueName}' AND GameDate = '{oBballInfoDTO.GameDate.ToShortDateString()}' ";
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(oBballInfoDTO.ConnectionString, getRowSql
            , oBballInfoDTO.oBballDataDTO.ocPostGameAnalysisDTO, populatePostGameAnalysisDTOFromRdr);
      }
      public void RefreshPostGameAnalysisJson(IBballInfoDTO oBballInfoDTO) => QueryJson(oBballInfoDTO, "ocPostGameAnalysisDTO");

 
      static void QueryJson(IBballInfoDTO oBballInfoDTO, string ObjName)
      {
         //Log("DataDO.QueryJson");
         string Sql = null;
         // FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER
         // FOR JSON AUTO, INCLUDE_NULL_VALUES
         // FOR JSON PATH, ROOT ('TOP_LEVEL')
         // FOR JSON PATH - no child objects
         switch (ObjName)
         {
            case "ocPostGameAnalysisDTO":
               Sql = $"SELECT *  FROM vPostGameAnalysis  Where LeagueName = '{oBballInfoDTO.LeagueName}' AND GameDate = '{oBballInfoDTO.GameDate.ToShortDateString()}' "
                  + " for JSON Auto ";
               break;
            case "oUserLeagueParmsDTO":
               Sql = $"SELECT TOP (1) *  FROM UserLeagueParms  Where LeagueName = '{oBballInfoDTO.LeagueName}' AND StartDate <= '{oBballInfoDTO.GameDate.ToShortDateString()}'"
               + "Order by StartDate desc    for JSON Auto, WITHOUT_ARRAY_WRAPPER ";
              
               break;

            default:
               throw new Exception("Invalid DataDO.QueryJson Object Name: " + ObjName);
               
         }

         var sJsonString = SysDAL.Functions.DALfunctions.ExecuteSqlQueryReturnJson(oBballInfoDTO.ConnectionString, Sql);
         JsonObjectDTO j = new JsonObjectDTO() { ObjectName = ObjName, JsonString = sJsonString };
         oBballInfoDTO.oBballDataDTO.OcJsonObjectDTO.Add(j);
      }
      static void populatePostGameAnalysisDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         vPostGameAnalysisDTO o = new vPostGameAnalysisDTO();

         o.TodaysMatchupsID = (int)rdr["TodaysMatchupsID"];
         o.UserName = rdr["UserName"].ToString().Trim();
         o.LeagueName = rdr["LeagueName"].ToString().Trim();
         o.GameDate = (DateTime)rdr["GameDate"];
         o.Season = rdr["Season"].ToString().Trim();
         o.SubSeason = rdr["SubSeason"].ToString().Trim();
         o.TeamAway = rdr["TeamAway"].ToString().Trim();
         o.TeamHome = rdr["TeamHome"].ToString().Trim();
         o.RotNum = (int)rdr["RotNum"];
         o.GameTime = rdr["GameTime"] == DBNull.Value ? null : (string)rdr["GameTime"];
         o.Canceled = rdr["Canceled"] == DBNull.Value ? null : (bool?)rdr["Canceled"];
         o.TV = rdr["TV"] == DBNull.Value ? null : (string)rdr["TV"];
         o.TmStrAway = (double)rdr["TmStrAway"];
         o.TmStrHome = rdr["TmStrHome"] == DBNull.Value ? null : (double?)rdr["TmStrHome"];
         o.TeamRecordAway = rdr["TeamRecordAway"] == DBNull.Value ? null : (string)rdr["TeamRecordAway"];
         o.TeamRecordHome = rdr["TeamRecordHome"] == DBNull.Value ? null : (string)rdr["TeamRecordHome"];
         o.UnAdjTotalAway = rdr["UnAdjTotalAway"] == DBNull.Value ? null : (double?)rdr["UnAdjTotalAway"];
         o.UnAdjTotalHome = (double)rdr["UnAdjTotalHome"];
         o.UnAdjTotal = (double)rdr["UnAdjTotal"];
         o.UnAdjTotalAwayPlanB = rdr["UnAdjTotalAwayPlanB"] == DBNull.Value ? null : (double?)rdr["UnAdjTotalAwayPlanB"];
         o.UnAdjTotalHomePlanB = rdr["UnAdjTotalHomePlanB"] == DBNull.Value ? null : (double?)rdr["UnAdjTotalHomePlanB"];
         o.UnAdjTotalPlanB = rdr["UnAdjTotalPlanB"] == DBNull.Value ? null : (double?)rdr["UnAdjTotalPlanB"];
         o.CalcAwayGB1PlanB = rdr["CalcAwayGB1PlanB"] == DBNull.Value ? null : (double?)rdr["CalcAwayGB1PlanB"];
         o.CalcAwayGB2PlanB = rdr["CalcAwayGB2PlanB"] == DBNull.Value ? null : (double?)rdr["CalcAwayGB2PlanB"];
         o.CalcAwayGB3PlanB = rdr["CalcAwayGB3PlanB"] == DBNull.Value ? null : (double?)rdr["CalcAwayGB3PlanB"];
         o.CalcHomeGB1PlanB = rdr["CalcHomeGB1PlanB"] == DBNull.Value ? null : (double?)rdr["CalcHomeGB1PlanB"];
         o.CalcHomeGB2PlanB = rdr["CalcHomeGB2PlanB"] == DBNull.Value ? null : (double?)rdr["CalcHomeGB2PlanB"];
         o.CalcHomeGB3PlanB = rdr["CalcHomeGB3PlanB"] == DBNull.Value ? null : (double?)rdr["CalcHomeGB3PlanB"];
         o.AwayAveragePtsScored = rdr["AwayAveragePtsScored"] == DBNull.Value ? null : (double?)rdr["AwayAveragePtsScored"];
         o.HomeAveragePtsScored = rdr["HomeAveragePtsScored"] == DBNull.Value ? null : (double?)rdr["HomeAveragePtsScored"];
         o.AwayAveragePtsAllowed = rdr["AwayAveragePtsAllowed"] == DBNull.Value ? null : (double?)rdr["AwayAveragePtsAllowed"];
         o.HomeAveragePtsAllowed = rdr["HomeAveragePtsAllowed"] == DBNull.Value ? null : (double?)rdr["HomeAveragePtsAllowed"];
         o.AdjAmt = (double)rdr["AdjAmt"];
         o.AdjAmtAway = (double)rdr["AdjAmtAway"];
         o.AdjAmtHome = (double)rdr["AdjAmtHome"];
         o.AdjDbAway = (double)rdr["AdjDbAway"];
         o.AdjDbHome = (double)rdr["AdjDbHome"];
         o.AdjOTwithSide = (double)rdr["AdjOTwithSide"];
         o.AdjTV = (double)rdr["AdjTV"];
         o.AdjRecentLeagueHistory = rdr["AdjRecentLeagueHistory"] == DBNull.Value ? null : (double?)rdr["AdjRecentLeagueHistory"];
         o.AdjPaceAway = rdr["AdjPaceAway"] == DBNull.Value ? null : (double?)rdr["AdjPaceAway"];
         o.AdjPaceHome = rdr["AdjPaceHome"] == DBNull.Value ? null : (double?)rdr["AdjPaceHome"];
         o.AdjTeamAway = rdr["AdjTeamAway"] == DBNull.Value ? null : (double?)rdr["AdjTeamAway"];
         o.AdjTeamHome = rdr["AdjTeamHome"] == DBNull.Value ? null : (double?)rdr["AdjTeamHome"];
         o.OurTotalLineAway = (double)rdr["OurTotalLineAway"];
         o.OurTotalLineHome = (double)rdr["OurTotalLineHome"];
         o.OurTotalLine = (double)rdr["OurTotalLine"];
         o.SideLine = (double)rdr["SideLine"];
         o.TotalLine = rdr["TotalLine"] == DBNull.Value ? null : (double?)rdr["TotalLine"];
         o.OpenTotalLine = rdr["OpenTotalLine"] == DBNull.Value ? null : (double?)rdr["OpenTotalLine"];
         o.Play = rdr["Play"] == DBNull.Value ? null : (string)rdr["Play"];
         o.Played = rdr["Played"] == DBNull.Value ? null : (string)rdr["Played"];
         o.PlayDiff = rdr["PlayDiff"] == DBNull.Value ? null : (double?)rdr["PlayDiff"];
         o.OpenPlayDiff = rdr["OpenPlayDiff"] == DBNull.Value ? null : (double?)rdr["OpenPlayDiff"];
         o.AdjustedDiff = rdr["AdjustedDiff"] == DBNull.Value ? null : (double?)rdr["AdjustedDiff"];
         o.BxScLinePct = (double)rdr["BxScLinePct"];
         o.TmStrAdjPct = (double)rdr["TmStrAdjPct"];
         o.VolatilityAway = rdr["VolatilityAway"] == DBNull.Value ? null : (double?)rdr["VolatilityAway"];
         o.VolatilityHome = rdr["VolatilityHome"] == DBNull.Value ? null : (double?)rdr["VolatilityHome"];
         o.Volatility = rdr["Volatility"] == DBNull.Value ? null : (double?)rdr["Volatility"];
         o.Threshold = (int)rdr["Threshold"];
         o.GB1 = (int)rdr["GB1"];
         o.GB2 = (int)rdr["GB2"];
         o.GB3 = (int)rdr["GB3"];
         o.WeightGB1 = (int)rdr["WeightGB1"];
         o.WeightGB2 = (int)rdr["WeightGB2"];
         o.WeightGB3 = (int)rdr["WeightGB3"];
         o.AwayProjectedPt1 = (double)rdr["AwayProjectedPt1"];
         o.AwayProjectedPt2 = (double)rdr["AwayProjectedPt2"];
         o.AwayProjectedPt3 = (double)rdr["AwayProjectedPt3"];
         o.HomeProjectedPt1 = (double)rdr["HomeProjectedPt1"];
         o.HomeProjectedPt2 = (double)rdr["HomeProjectedPt2"];
         o.HomeProjectedPt3 = (double)rdr["HomeProjectedPt3"];
         o.AwayProjectedAtmpPt1 = rdr["AwayProjectedAtmpPt1"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt1"];
         o.AwayProjectedAtmpPt2 = rdr["AwayProjectedAtmpPt2"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt2"];
         o.AwayProjectedAtmpPt3 = rdr["AwayProjectedAtmpPt3"] == DBNull.Value ? null : (double?)rdr["AwayProjectedAtmpPt3"];
         o.HomeProjectedAtmpPt1 = rdr["HomeProjectedAtmpPt1"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt1"];
         o.HomeProjectedAtmpPt2 = rdr["HomeProjectedAtmpPt2"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt2"];
         o.HomeProjectedAtmpPt3 = rdr["HomeProjectedAtmpPt3"] == DBNull.Value ? null : (double?)rdr["HomeProjectedAtmpPt3"];
         o.AwayAverageAtmpUsPt1 = (double)rdr["AwayAverageAtmpUsPt1"];
         o.AwayAverageAtmpUsPt2 = (double)rdr["AwayAverageAtmpUsPt2"];
         o.AwayAverageAtmpUsPt3 = (double)rdr["AwayAverageAtmpUsPt3"];
         o.HomeAverageAtmpUsPt1 = (double)rdr["HomeAverageAtmpUsPt1"];
         o.HomeAverageAtmpUsPt2 = (double)rdr["HomeAverageAtmpUsPt2"];
         o.HomeAverageAtmpUsPt3 = (double)rdr["HomeAverageAtmpUsPt3"];
         o.AwayGB1 = (double)rdr["AwayGB1"];
         o.AwayGB2 = (double)rdr["AwayGB2"];
         o.AwayGB3 = (double)rdr["AwayGB3"];
         o.HomeGB1 = (double)rdr["HomeGB1"];
         o.HomeGB2 = (double)rdr["HomeGB2"];
         o.HomeGB3 = (double)rdr["HomeGB3"];
         o.AwayGB1Pt1 = (double)rdr["AwayGB1Pt1"];
         o.AwayGB1Pt2 = (double)rdr["AwayGB1Pt2"];
         o.AwayGB1Pt3 = (double)rdr["AwayGB1Pt3"];
         o.AwayGB2Pt1 = (double)rdr["AwayGB2Pt1"];
         o.AwayGB2Pt2 = (double)rdr["AwayGB2Pt2"];
         o.AwayGB2Pt3 = (double)rdr["AwayGB2Pt3"];
         o.AwayGB3Pt1 = (double)rdr["AwayGB3Pt1"];
         o.AwayGB3Pt2 = (double)rdr["AwayGB3Pt2"];
         o.AwayGB3Pt3 = (double)rdr["AwayGB3Pt3"];
         o.HomeGB1Pt1 = (double)rdr["HomeGB1Pt1"];
         o.HomeGB1Pt2 = (double)rdr["HomeGB1Pt2"];
         o.HomeGB1Pt3 = (double)rdr["HomeGB1Pt3"];
         o.HomeGB2Pt1 = (double)rdr["HomeGB2Pt1"];
         o.HomeGB2Pt2 = (double)rdr["HomeGB2Pt2"];
         o.HomeGB2Pt3 = (double)rdr["HomeGB2Pt3"];
         o.HomeGB3Pt1 = (double)rdr["HomeGB3Pt1"];
         o.HomeGB3Pt2 = (double)rdr["HomeGB3Pt2"];
         o.HomeGB3Pt3 = (double)rdr["HomeGB3Pt3"];
         o.AwayAverageMadePt1 = rdr["AwayAverageMadePt1"] == DBNull.Value ? null : (double?)rdr["AwayAverageMadePt1"];
         o.AwayAverageMadePt2 = rdr["AwayAverageMadePt2"] == DBNull.Value ? null : (double?)rdr["AwayAverageMadePt2"];
         o.AwayAverageMadePt3 = rdr["AwayAverageMadePt3"] == DBNull.Value ? null : (double?)rdr["AwayAverageMadePt3"];
         o.HomeAverageMadePt1 = rdr["HomeAverageMadePt1"] == DBNull.Value ? null : (double?)rdr["HomeAverageMadePt1"];
         o.HomeAverageMadePt2 = rdr["HomeAverageMadePt2"] == DBNull.Value ? null : (double?)rdr["HomeAverageMadePt2"];
         o.HomeAverageMadePt3 = rdr["HomeAverageMadePt3"] == DBNull.Value ? null : (double?)rdr["HomeAverageMadePt3"];
         o.AwayAverageAllowedPt1 = rdr["AwayAverageAllowedPt1"] == DBNull.Value ? null : (double?)rdr["AwayAverageAllowedPt1"];
         o.AwayAverageAllowedPt2 = rdr["AwayAverageAllowedPt2"] == DBNull.Value ? null : (double?)rdr["AwayAverageAllowedPt2"];
         o.AwayAverageAllowedPt3 = rdr["AwayAverageAllowedPt3"] == DBNull.Value ? null : (double?)rdr["AwayAverageAllowedPt3"];
         o.HomeAverageAllowedPt1 = rdr["HomeAverageAllowedPt1"] == DBNull.Value ? null : (double?)rdr["HomeAverageAllowedPt1"];
         o.HomeAverageAllowedPt2 = rdr["HomeAverageAllowedPt2"] == DBNull.Value ? null : (double?)rdr["HomeAverageAllowedPt2"];
         o.HomeAverageAllowedPt3 = rdr["HomeAverageAllowedPt3"] == DBNull.Value ? null : (double?)rdr["HomeAverageAllowedPt3"];
         o.LgAvgShotsMadeAwayPt1 = rdr["LgAvgShotsMadeAwayPt1"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeAwayPt1"];
         o.LgAvgShotsMadeAwayPt2 = rdr["LgAvgShotsMadeAwayPt2"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeAwayPt2"];
         o.LgAvgShotsMadeAwayPt3 = rdr["LgAvgShotsMadeAwayPt3"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeAwayPt3"];
         o.LgAvgShotsMadeHomePt1 = rdr["LgAvgShotsMadeHomePt1"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeHomePt1"];
         o.LgAvgShotsMadeHomePt2 = rdr["LgAvgShotsMadeHomePt2"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeHomePt2"];
         o.LgAvgShotsMadeHomePt3 = rdr["LgAvgShotsMadeHomePt3"] == DBNull.Value ? null : (double?)rdr["LgAvgShotsMadeHomePt3"];
         o.AverageMadeAwayGB1Pt1 = rdr["AverageMadeAwayGB1Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB1Pt1"];
         o.AverageMadeAwayGB1Pt2 = rdr["AverageMadeAwayGB1Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB1Pt2"];
         o.AverageMadeAwayGB1Pt3 = rdr["AverageMadeAwayGB1Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB1Pt3"];
         o.AverageMadeAwayGB2Pt1 = rdr["AverageMadeAwayGB2Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB2Pt1"];
         o.AverageMadeAwayGB2Pt2 = rdr["AverageMadeAwayGB2Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB2Pt2"];
         o.AverageMadeAwayGB2Pt3 = rdr["AverageMadeAwayGB2Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB2Pt3"];
         o.AverageMadeAwayGB3Pt1 = rdr["AverageMadeAwayGB3Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB3Pt1"];
         o.AverageMadeAwayGB3Pt2 = rdr["AverageMadeAwayGB3Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB3Pt2"];
         o.AverageMadeAwayGB3Pt3 = rdr["AverageMadeAwayGB3Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeAwayGB3Pt3"];
         o.AverageMadeHomeGB1Pt1 = rdr["AverageMadeHomeGB1Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB1Pt1"];
         o.AverageMadeHomeGB1Pt2 = rdr["AverageMadeHomeGB1Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB1Pt2"];
         o.AverageMadeHomeGB1Pt3 = rdr["AverageMadeHomeGB1Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB1Pt3"];
         o.AverageMadeHomeGB2Pt1 = rdr["AverageMadeHomeGB2Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB2Pt1"];
         o.AverageMadeHomeGB2Pt2 = rdr["AverageMadeHomeGB2Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB2Pt2"];
         o.AverageMadeHomeGB2Pt3 = rdr["AverageMadeHomeGB2Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB2Pt3"];
         o.AverageMadeHomeGB3Pt1 = rdr["AverageMadeHomeGB3Pt1"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB3Pt1"];
         o.AverageMadeHomeGB3Pt2 = rdr["AverageMadeHomeGB3Pt2"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB3Pt2"];
         o.AverageMadeHomeGB3Pt3 = rdr["AverageMadeHomeGB3Pt3"] == DBNull.Value ? null : (double?)rdr["AverageMadeHomeGB3Pt3"];
         o.TMoppAdjPct = rdr["TMoppAdjPct"] == DBNull.Value ? null : (double?)rdr["TMoppAdjPct"];
         o.TotalBubbleAway = rdr["TotalBubbleAway"] == DBNull.Value ? null : (double?)rdr["TotalBubbleAway"];
         o.TotalBubbleHome = rdr["TotalBubbleHome"] == DBNull.Value ? null : (double?)rdr["TotalBubbleHome"];
         o.TS = rdr["TS"] == DBNull.Value ? null : (DateTime?)rdr["TS"];
         o.AllAdjustmentLines = rdr["AllAdjustmentLines"] == DBNull.Value ? null : (string)rdr["AllAdjustmentLines"];
         o.PlayResult = rdr["PlayResult"] == DBNull.Value ? null : rdr["PlayResult"].ToString();
         o.OtPeriods = (int)rdr["OtPeriods"];
         o.ScoreReg = (double)rdr["ScoreReg"];
         o.ScoreOT = (double)rdr["ScoreOT"];
         o.ScoreRegUs = (double)rdr["ScoreRegUs"];
         o.ScoreRegOp = (double)rdr["ScoreRegOp"];
         o.ScoreOTUs = (double)rdr["ScoreOTUs"];
         o.ScoreOTOp = (double)rdr["ScoreOTOp"];
         o.ScoreQ1Us = (double)rdr["ScoreQ1Us"];
         o.ScoreQ1Op = (double)rdr["ScoreQ1Op"];
         o.ScoreQ2Us = (double)rdr["ScoreQ2Us"];
         o.ScoreQ2Op = (double)rdr["ScoreQ2Op"];
         o.ScoreQ3Us = (double)rdr["ScoreQ3Us"];
         o.ScoreQ3Op = (double)rdr["ScoreQ3Op"];
         o.ScoreQ4Us = (double)rdr["ScoreQ4Us"];
         o.ScoreQ4Op = (double)rdr["ScoreQ4Op"];
         o.ShotsActualMadeUsPt1 = (double)rdr["ShotsActualMadeUsPt1"];
         o.ShotsActualMadeUsPt2 = (double)rdr["ShotsActualMadeUsPt2"];
         o.ShotsActualMadeUsPt3 = (double)rdr["ShotsActualMadeUsPt3"];
         o.ShotsActualMadeOpPt1 = (double)rdr["ShotsActualMadeOpPt1"];
         o.ShotsActualMadeOpPt2 = (double)rdr["ShotsActualMadeOpPt2"];
         o.ShotsActualMadeOpPt3 = (double)rdr["ShotsActualMadeOpPt3"];
         o.ShotsActualAttemptedUsPt1 = (double)rdr["ShotsActualAttemptedUsPt1"];
         o.ShotsActualAttemptedUsPt2 = (double)rdr["ShotsActualAttemptedUsPt2"];
         o.ShotsActualAttemptedUsPt3 = (double)rdr["ShotsActualAttemptedUsPt3"];
         o.ShotsActualAttemptedOpPt1 = (double)rdr["ShotsActualAttemptedOpPt1"];
         o.ShotsActualAttemptedOpPt2 = (double)rdr["ShotsActualAttemptedOpPt2"];
         o.ShotsActualAttemptedOpPt3 = (double)rdr["ShotsActualAttemptedOpPt3"];
         o.ShotsMadeUsRegPt1 = (double)rdr["ShotsMadeUsRegPt1"];
         o.ShotsMadeUsRegPt2 = (double)rdr["ShotsMadeUsRegPt2"];
         o.ShotsMadeUsRegPt3 = (double)rdr["ShotsMadeUsRegPt3"];
         o.ShotsMadeOpRegPt1 = (double)rdr["ShotsMadeOpRegPt1"];
         o.ShotsMadeOpRegPt2 = (double)rdr["ShotsMadeOpRegPt2"];
         o.ShotsMadeOpRegPt3 = (double)rdr["ShotsMadeOpRegPt3"];
         o.ShotsAttemptedUsRegPt1 = (double)rdr["ShotsAttemptedUsRegPt1"];
         o.ShotsAttemptedUsRegPt2 = (double)rdr["ShotsAttemptedUsRegPt2"];
         o.ShotsAttemptedUsRegPt3 = (double)rdr["ShotsAttemptedUsRegPt3"];
         o.ShotsAttemptedOpRegPt1 = (double)rdr["ShotsAttemptedOpRegPt1"];
         o.ShotsAttemptedOpRegPt2 = (double)rdr["ShotsAttemptedOpRegPt2"];
         o.ShotsAttemptedOpRegPt3 = (double)rdr["ShotsAttemptedOpRegPt3"];
         o.TurnOversUs = (double)rdr["TurnOversUs"];
         o.TurnOversOp = (double)rdr["TurnOversOp"];
         o.OffRBUs = (double)rdr["OffRBUs"];
         o.OffRBOp = (double)rdr["OffRBOp"];
         o.AssistsUs = (double)rdr["AssistsUs"];
         o.AssistsOp = (double)rdr["AssistsOp"];
         o.Pace = rdr["Pace"] == DBNull.Value ? null : (double?)rdr["Pace"];

         ((List<IvPostGameAnalysisDTO>)oRow).Add(o);
      }
      #endregion postGameAnalysis

      #region userLeagueParms
      public void GetUserLeagueParmsJson(IBballInfoDTO oBballInfoDTO)
      {
         QueryJson(oBballInfoDTO, "oUserLeagueParmsDTO");
      }
      public void GetUserLeagueParmsDTO(IBballInfoDTO oBballInfoDTO)
      {
         Log("DataDO.GetUserLeagueParmsDTO");
         string getRowSql =
            $"SELECT TOP (1) *  FROM UserLeagueParms  Where LeagueName = '{oBballInfoDTO.LeagueName}' AND StartDate <= '{oBballInfoDTO.GameDate.ToShortDateString()}' Order by StartDate desc ";
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(oBballInfoDTO.ConnectionString, getRowSql
            , oBballInfoDTO.oBballDataDTO.oUserLeagueParmsDTO, populateUserLeagueParmsDTOFromRdr);

         GetUserLeagueParmsJson(oBballInfoDTO);
      }
      static void populateUserLeagueParmsDTOFromRdr(object oRow, SqlDataReader rdr)
      {
         UserLeagueParmsDTO O = (UserLeagueParmsDTO)oRow;

         O.UserLeagueParmsID = (int)rdr["UserLeagueParmsID"];
         O.UserName = rdr["UserName"].ToString().Trim();
         O.LeagueName = rdr["LeagueName"].ToString().Trim();
         O.StartDate = (DateTime)rdr["StartDate"];
         O.TempRow = (bool)rdr["TempRow"];
         O.LgAvgStartDate = (DateTime)rdr["LgAvgStartDate"];
         O.LgAvgGamesBack = (int)rdr["LgAvgGamesBack"];
         O.TeamAvgGamesBack = (int)rdr["TeamAvgGamesBack"];
         O.TeamPaceGamesBack = (int)rdr["TeamPaceGamesBack"];
         O.TeamStrengthGamesBack = (int)rdr["TeamStrengthGamesBack"];
         O.VolatilityGamesBack = (int)rdr["VolatilityGamesBack"];
         O.TeamSeedGames = (int)rdr["TeamSeedGames"];
         O.LoadRotationDaysAhead = (int)rdr["LoadRotationDaysAhead"];
         O.GB1 = (int)rdr["GB1"];
         O.GB2 = (int)rdr["GB2"];
         O.GB3 = (int)rdr["GB3"];
         O.WeightGB1 = (double)rdr["WeightGB1"];
         O.WeightGB2 = (double)rdr["WeightGB2"];
         O.WeightGB3 = (double)rdr["WeightGB3"];
         O.Threshold = (double)rdr["Threshold"];
         O.BxScLinePct = (double)rdr["BxScLinePct"];
         O.BxScTmStrPct = (double)rdr["BxScTmStrPct"];
         O.TmStrAdjPct = (double)rdr["TmStrAdjPct"];
         O.TodaysMUPsOppAdjPctPt1 = (double)rdr["TodaysMUPsOppAdjPctPt1"];
         O.TodaysMUPsOppAdjPctPt2 = (double)rdr["TodaysMUPsOppAdjPctPt2"];
         O.TodaysMUPsOppAdjPctPt3 = (double)rdr["TodaysMUPsOppAdjPctPt3"];
         O.RecentLgHistoryAdjPct = (double)rdr["RecentLgHistoryAdjPct"];
         O.TeamPaceAdjPct = (double)rdr["TeamPaceAdjPct"];
         O.TeamAdjPct = (double)rdr["TeamAdjPct"];
         O.BothHome_Away = (bool)rdr["BothHome_Away"];
         O.BoxscoresSpanSeasons = (bool)rdr["BoxscoresSpanSeasons"];

      }
      #endregion

      public void VerifyTables(IBballInfoDTO oBballInfoDTO)
      {
         new SeasonInfoDO(oBballInfoDTO);
         oBballInfoDTO.oBballDataDTO.MessageNumber = 0;
         List<string> SqlParmNames = new List<string>() { "LeagueName", "Season" };
         List<object> SqlParmValues = new List<object>() { oBballInfoDTO.LeagueName, oBballInfoDTO.oSeasonInfoDTO.Season };
         try
         {
            SysDAL.Functions.DALfunctions.ExecuteStoredProcedureNonQuery(oBballInfoDTO.ConnectionString, "uspVerifyTables", SqlParmNames, SqlParmValues);
         }
         catch (Exception ex)
         {
            oBballInfoDTO.oBballDataDTO.MessageNumber = 1;
            oBballInfoDTO.oBballDataDTO.Message = ex.Message;
         }
         
      }

   }  // class
}  // namespace
