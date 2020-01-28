using System;
using System.Collections.Generic;
using System.Linq;
using Bball.VbClasses.Bball.VbClasses;
using Bball.DataBaseFunctions;

using BballMVC.DTOs;
using System.Data.SqlClient;

namespace Bball.DAL.Tables
{
   public class Rotation
   {
      public const string RotationTable = "Rotation";

      private const string ColumnNames = "LeagueName,GameDate,RotNum,Venue,Team,Opp,GameTime,TV,SideLine,TotalLine,TotalLineTeam,TotalLineOpp,OpenTotalLine,BoxScoreSource,BoxScoreUrl,CreateDate,UpdateDate";

      SortedList<string, CoversDTO> _ocRotation;
      DateTime _GameDate;
      LeagueDTO _oLeagueDTO;
      string _ConnectionString;
      string _strLoadDateTime;

      public Rotation(SortedList<string, CoversDTO> ocRotation, DateTime GameDate, LeagueDTO oLeagueDTO, string ConnectionString, string strLoadDateTime)
      {
         _ocRotation = ocRotation;
         _GameDate = GameDate;
         _oLeagueDTO = oLeagueDTO;
         _ConnectionString = ConnectionString;
         _strLoadDateTime = strLoadDateTime;
      }
      public static void PopulateRotation(SortedList<string, CoversDTO> ocRotation, DateTime GameDate, LeagueDTO _oLeagueDTO, string ConnectionString, string strLoadDateTime)
      {
         Rotation oRotation = new Rotation(ocRotation, GameDate, _oLeagueDTO, ConnectionString, strLoadDateTime);
         oRotation.GetRotation();
      }
      #region GetRows
      public void GetRotation()
      {

         if (_GameDate >= DateTime.Today)    // If Today or tomorrow
         {
            refreshRotation();
            return;
         }
         getRotationFromDatabase();    // Populate ocRotation from DB if rows exist

      }

      private int getRotationFromDatabase()
      {
         List<object> oCoversList = new List<object>();

         int rows = SysDAL.DALfunctions.ExecuteSqlQuery(_ConnectionString, RotationRowSql(), oCoversList, null, LoadRotationRows);

         if (oCoversList.Count == 0)
            refreshRotation();
         else
         {
            foreach (CoversDTO oCoversDTO in oCoversList)
               _ocRotation.Add(oCoversDTO.RotNum.ToString(), oCoversDTO);
         }

         return rows;
      }
      static void LoadRotationRows(List<object> ocRows, object oRow, SqlDataReader rdr)
      {
         if (rdr["Venue"].ToString().Trim() == "Away")
         { 
            CoversDTO oCoversDTO = new CoversDTO();    // Populate from Away row

            oCoversDTO.GameDate = (DateTime)rdr["GameDate"];
            oCoversDTO.LeagueName = rdr["LeagueName"].ToString().Trim();;
            oCoversDTO.RotNum = (int)rdr["RotNum"];
            oCoversDTO.GameTime = rdr["GameTime"].ToString().Trim();;
            oCoversDTO.TeamAway = rdr["Team"].ToString().Trim();;
            oCoversDTO.TeamHome = rdr["Opp"].ToString().Trim();;
            oCoversDTO.Url = rdr["BoxScoreUrl"].ToString().Trim();;
            oCoversDTO.BoxscoreNumber = "";
            oCoversDTO.LineTotalOpen = Convert.ToSingle(rdr["OpenTotalLine"]);
            oCoversDTO.LineTotal = Convert.ToSingle(rdr["TotalLine"]);
            oCoversDTO.LineSideOpen = Convert.ToSingle(  (Convert.ToSingle(rdr["SideLine"]) * (-1.0)));
            oCoversDTO.LineSideClose = oCoversDTO.LineSideOpen;
            oCoversDTO.GameStatus = 2;    // Final /// kdtodo if today status = ???
            oCoversDTO.ScoreAway = 0;
            oCoversDTO.ScoreHome = 0;
            oCoversDTO.Period = 0;
            oCoversDTO.SecondsLeftInPeriod = 0;

            ocRows.Add(oCoversDTO);
         }
      }

      string RotationRowSql()
      {
         string Sql = ""
            + $"SELECT * FROM {RotationTable} r "
            + $"  Where r.LeagueName = '{_oLeagueDTO.LeagueName}'  And '{_GameDate}' = r.GameDate"
            + "   Order By r.RotNum"
            ;

         return Sql;
      }
      private void refreshRotation()
      {
         CoversRotation oCoversRotation = new CoversRotation(_ocRotation, _GameDate, _oLeagueDTO);
         oCoversRotation.GetRotation();

         writeRotation();
         insertLines();
      }
      private void insertLines()
      {
         Lines oLines = new Lines(_GameDate, _oLeagueDTO, _ConnectionString, _strLoadDateTime);
         oLines.InsertLinesFromRotation();
      }
      #endregion GetRows

      #region WriteRows
      private void writeRotation()
      {
         DailySummary oDailySummary = new DailySummary(_GameDate, _oLeagueDTO, _ConnectionString, _strLoadDateTime);
         oDailySummary.RefreshRow(_ocRotation.Count);

         deleteRotation();

         List<string> ocColumns = ColumnNames.Split(',').OfType<string>().ToList();

         // write rotation
         foreach (var kvp in _ocRotation)
         {
            CoversDTO oCoversDTO = kvp.Value;
          //  string ConnectionString = SqlFunctions.GetConnectionString();
            string SQL = SysDAL.DALfunctions.GenSql(RotationTable, ocColumns);
            // "LeagueName,GameDate,RotNum, Venue,Team,Opp,
            // GameTime,TV,SideLine,TotalLine,TotalLineTeam,
            // TotalLineOpp,OpenTotalLine,BoxScoreSource,BoxScoreUrl,CreateDate
            // ,UpdateDate";
            List<string> ocValues = new List<string>()
            {
               _oLeagueDTO.LeagueName
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
            };
            // Insert Away Row
            int rc = SysDAL.DALfunctions.InsertRow(_ConnectionString, SQL, ocColumns, ocValues);

            // Populate Home Row
            ocValues = new List<string>()
            {
               _oLeagueDTO.LeagueName
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
               , DateTime.Now.ToString()
               , DateTime.Now.ToString()
            };
            // Insert Away Row
            rc = SysDAL.DALfunctions.InsertRow(_ConnectionString, SQL, ocColumns, ocValues);

         }  // foreach

      }

      public static void DeleteRestOfRotation(DateTime GameDate, string LeagueName)
      {
         string strSql = $"DELETE From {RotationTable} Where LeagueName = '{LeagueName}' AND GameDate >= '{GameDate.ToShortDateString()}'";
         int rows = SysDAL.DALfunctions.ExecuteSqlNonQuery(SqlFunctions.GetConnectionString(), strSql);
      }

      private void deleteRotation()
      {
         string strSql = $"DELETE From {RotationTable} Where LeagueName = '{_oLeagueDTO.LeagueName}' AND GameDate = '{_GameDate.ToShortDateString()}'";
         int rows = SysDAL.DALfunctions.ExecuteSqlNonQuery(SqlFunctions.GetConnectionString(), strSql);
      }
      #endregion WritwRows

   }
}
