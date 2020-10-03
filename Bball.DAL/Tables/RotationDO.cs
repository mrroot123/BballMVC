using System;
using System.Collections.Generic;
using System.Linq;
using Bball.VbClasses.Bball.VbClasses;
using Bball.DataBaseFunctions;

using BballMVC.DTOs;
using BballMVC.IDTOs;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace Bball.DAL.Tables
{
   public class RotationDO
   {
      public const string RotationTable = "Rotation";

      private const string ColumnNames = "LeagueName,Season,SubSeason,SubSeasonPeriod,GameDate,RotNum,Venue,Team,Opp,GameTime,TV,SideLine,TotalLine,TotalLineTeam,TotalLineOpp,OpenTotalLine,BoxScoreSource,BoxScoreUrl,CreateDate,UpdateDate,Canceled";

      SortedList<string, CoversDTO> _ocRotation;
      DateTime _GameDate;
      ILeagueDTO _oLeagueDTO;
      string _ConnectionString;
      string _strLoadDateTime;
      IBballInfoDTO _oBballInfoDTO;

      public RotationDO(SortedList<string, CoversDTO> ocRotation, DateTime GameDate, ILeagueDTO oLeagueDTO, string ConnectionString, string strLoadDateTime)
      {
         _ocRotation = ocRotation;
         _GameDate = GameDate;
         _oLeagueDTO = oLeagueDTO;
         _ConnectionString = ConnectionString;
         _strLoadDateTime = strLoadDateTime;
      }
      public static void PopulateRotation(SortedList<string, CoversDTO> ocRotation, IBballInfoDTO oBballInfoDTO, ILeagueDTO _oLeagueDTO)
      {
         RotationDO oRotationDO = new RotationDO(ocRotation, oBballInfoDTO.GameDate, _oLeagueDTO, oBballInfoDTO.ConnectionString, oBballInfoDTO.GameDate.ToString());
         oRotationDO.GetRotation(oBballInfoDTO);
      }
      #region GetRows
      public void GetRotation(IBballInfoDTO oBballInfoDTO)
      {
         _oBballInfoDTO = oBballInfoDTO;
         if (_GameDate >= DateTime.Today)    // If Today or tomorrow
         {
            refreshRotation();
            return;
         }
         getRotationFromDatabase();    // Populate ocRotation from DB if rows exist

      }

      private int getRotationFromDatabase()
      {
         List<CoversDTO> oCoversList = new List<CoversDTO>();

         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(_ConnectionString, RotationRowSql(), oCoversList,  LoadRotationRows);

         if (oCoversList.Count == 0)
            refreshRotation();
         else
         {
            foreach (CoversDTO oCoversDTO in oCoversList)
               _ocRotation.Add(oCoversDTO.RotNum.ToString(), oCoversDTO);
         }

         return rows;
      }
      static void LoadRotationRows(object ocRows, SqlDataReader rdr)
      {
         if (rdr["Venue"].ToString().Trim() == "Away")
         { 
            CoversDTO oCoversDTO = new CoversDTO();    // Populate from Away row

            oCoversDTO.GameDate = (DateTime)rdr["GameDate"];
            oCoversDTO.LeagueName = rdr["LeagueName"].ToString().Trim();
            oCoversDTO.RotNum = (int)rdr["RotNum"];
            oCoversDTO.GameTime = rdr["GameTime"].ToString().Trim();
            oCoversDTO.TeamAway = rdr["Team"].ToString().Trim();
            oCoversDTO.TeamHome = rdr["Opp"].ToString().Trim();
            oCoversDTO.Url = rdr["BoxScoreUrl"].ToString().Trim();
            oCoversDTO.BoxscoreNumber = "";
            oCoversDTO.LineTotalOpen = Convert.ToSingle(rdr["OpenTotalLine"]);
            oCoversDTO.LineTotal = Convert.ToSingle(rdr["TotalLine"]);
            oCoversDTO.LineSideOpen = Convert.ToSingle(  (Convert.ToSingle(rdr["SideLine"]) * (-1.0)));
            oCoversDTO.LineSideClose = oCoversDTO.LineSideOpen;
            oCoversDTO.GameStatus = Convert.ToBoolean(rdr["Canceled"]) == true ? -1 : 2;
            oCoversDTO.Canceled = Convert.ToBoolean(rdr["Canceled"]);
            oCoversDTO.ScoreAway = 0;
            oCoversDTO.ScoreHome = 0;
            oCoversDTO.Period = 0;
            oCoversDTO.SecondsLeftInPeriod = 0;

            List<CoversDTO> ocCoversDTO = (List<CoversDTO>)ocRows;
            ocCoversDTO.Add(oCoversDTO);
         }
      }

      string RotationRowSql()
      {
         string Sql = ""
            + $"SELECT * FROM {RotationTable} r "
            + $"  Where r.LeagueName = '{_oBballInfoDTO.LeagueName}'  And '{_GameDate}' = r.GameDate"
            + "   Order By r.RotNum"
            ;

         return Sql;
      }
      private void refreshRotation()
      {
         CoversRotation oCoversRotation = new CoversRotation(_ocRotation, _GameDate, _oLeagueDTO);
         oCoversRotation.GetRotationFromWeb();

         writeRotation();
         insertLines();
      }
      private async Task insertLines()
      {
         await Task.Run(() =>
         {
            new LinesDO(_GameDate, _oLeagueDTO, _ConnectionString, _strLoadDateTime).InsertLinesFromRotation();
         });

      }
      #endregion GetRows

      #region WriteRows
      private void writeRotation()
      {
         // kd 06/16/2020 - Eliminated write DailySummary row - will now be written in Calc TMs stroed proc
         //DailySummaryDO oDailySummary = new DailySummaryDO(_GameDate, _oLeagueDTO, _ConnectionString, _strLoadDateTime);
         //oDailySummary.RefreshRow(_ocRotation.Count);

         deleteRotation();

         List<string> ocColumns = ColumnNames.Split(',').OfType<string>().ToList();

         // write rotation
         foreach (var kvp in _ocRotation)
         {
            CoversDTO oCoversDTO = kvp.Value;
            //  string ConnectionString = SqlFunctions.GetConnectionString();
            //string SQL = SysDAL.Functions.DALfunctions.GenSql(RotationTable, ocColumns);
            // "LeagueName,
            // Season, SubSeason, SubSeasonPeriod,    kd 06/14/2020 added 3 columns to Rotation Table
            // GameDate,RotNum, Venue,Team,Opp,
            // GameTime,TV,SideLine,TotalLine,TotalLineTeam,
            // TotalLineOpp,OpenTotalLine,BoxScoreSource,BoxScoreUrl,CreateDate
            // ,UpdateDate";
            List<string> ocValues = new List<string>()
            {
               _oLeagueDTO.LeagueName

               , _oBballInfoDTO.oSeasonInfoDTO.Season
               , _oBballInfoDTO.oSeasonInfoDTO.SubSeason
               , _oBballInfoDTO.oSeasonInfoDTO.SubSeasonPeriod.ToString()

               , _GameDate.ToShortDateString()
               , oCoversDTO.RotNum.ToString()
               , "Away"
               , oCoversDTO.TeamAway
               , oCoversDTO.TeamHome

               , oCoversDTO.GameTime
               , ""
               , (oCoversDTO.LineSideClose * (-1)).ToString()
               , oCoversDTO.LineTotal.ToString()
               , ((oCoversDTO.LineTotal + oCoversDTO.LineSideOpen) / 2).ToString()

               , ((oCoversDTO.LineTotal - oCoversDTO.LineSideOpen) / 2).ToString()
               , oCoversDTO.LineTotalOpen.ToString()
               , "Covers"
               , oCoversDTO.Url
               , _strLoadDateTime
               , _strLoadDateTime
               , oCoversDTO.Canceled.ToString()
            };
            // Insert Away Row
            string rc = SysDAL.Functions.DALfunctions.InsertTableRow(_ConnectionString, RotationTable, ocColumns, ocValues);

            // Populate Home Row
            ocValues = new List<string>()
            {
               _oLeagueDTO.LeagueName

               , _oBballInfoDTO.oSeasonInfoDTO.Season
               , _oBballInfoDTO.oSeasonInfoDTO.SubSeason
               , _oBballInfoDTO.oSeasonInfoDTO.SubSeasonPeriod.ToString()

               , _GameDate.ToShortDateString()
               , (oCoversDTO.RotNum + 1).ToString()
               , "Home"
               , oCoversDTO.TeamHome
               , oCoversDTO.TeamAway

               , oCoversDTO.GameTime
               , ""
               , (oCoversDTO.LineSideClose).ToString()
               , oCoversDTO.LineTotal.ToString()
               , ((oCoversDTO.LineTotal - oCoversDTO.LineSideOpen) / 2).ToString()

               , ((oCoversDTO.LineTotal + oCoversDTO.LineSideOpen) / 2).ToString()
               , oCoversDTO.LineTotalOpen.ToString()
               , "Covers"
               , oCoversDTO.Url
               , _strLoadDateTime
               , _strLoadDateTime
               , oCoversDTO.Canceled.ToString()
            };
            // Insert Away Row
            rc = SysDAL.Functions.DALfunctions.InsertTableRow(_ConnectionString, RotationTable, ocColumns, ocValues);

         }  // foreach

      }

      //public static void DeleteRestOfRotation(DateTime GameDate, string LeagueName)
      //{
      //   string strSql = $"DELETE From {RotationTable} Where LeagueName = '{LeagueName}' AND GameDate >= '{GameDate.ToShortDateString()}'";
      //   int rows = SysDAL.Functions.DALfunctions.ExecuteSqlNonQuery(SqlFunctions.GetConnectionString(), strSql);
      //}

      private void deleteRotation()
      {
         //kdtest
         string strSql = $"DELETE From {RotationTable} Where LeagueName = '{_oLeagueDTO.LeagueName}' AND GameDate = '{_GameDate.ToShortDateString()}'";
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlNonQuery(_ConnectionString, strSql);
      }
      #endregion WritwRows

   }
}
