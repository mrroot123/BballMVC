using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HtmlParsing.HtmlParsing.Functions;
using HtmlParsing.Common4vb.HtmlParsing;
using System.IO;
using System.Xml.Serialization;
using BballMVC.DTOs;
using Bball.DataBaseFunctions;
using System.Data.SqlClient;

namespace Bball.DAL.Tables
{
   public class AdjustmentsDO
   {
        const string TableName = "Adjustments";
        const string TableColumns = "LeagueName,StartDate,EndDate,Team,AdjustmentType,AdjustmentAmount,Player,Description,TS";

        private string _ConnectionString;
        private LeagueDTO _oLeagueDTO = new LeagueDTO();
        private DateTime _GameDate;
        public AdjustmentsDO()
        { }
        public AdjustmentsDO(DateTime GameDate, string LeagueName, string ConnectionString)
        {
            _ConnectionString = ConnectionString;
            new LeagueInfoDO(LeagueName, _oLeagueDTO, _ConnectionString);  // Init _oLeagueDTO
            _GameDate = GameDate;

        }

        public string GetAdjustments (string leagueName)
        {
            //TO-DO fill out 
            return "";
        }

     //test Version_2 kdtodo
      //string QueryAdjustmentsSql = ""
      //   + "SELECT * FROM Adjustments  "
      //   + $"  WHERE LeagueName = '{LeagueName}' "
      //   + $"    AND ((Type = 'L' AND StartDate <= #{GameDate}#   AND (EndDate IS NULL or EndDate >= #{GameDate}#) ) "
      //   + $"     Or  (StartDate <= #{GameDate}#  AND (EndDate IS NULL or EndDate >= #{GameDate}#) )  AND AdjAmt <> 0 ) "
      //   + "    ORDER BY Type DESC ;"
      //   ;

      //string QueryString = "SqlCommand=Select&SQL=" + VBFunctions.URLEncode(QueryAdjustmentsSql);
      //String url = "http://bball.com.violet.arvixe.com/ExecSql2.aspx";
      //WebPageGet oWebPageGet = new WebPageGet();
      //oWebPageGet.NewWebPagePost(url, QueryString);
      //string xmlString = oWebPageGet.Html;

      //// Simple deserialization of XML to C# object - http://www.janholinka.net/Blog/Article/11

      //StringReader stringReader = new StringReader(xmlString);
      //XmlSerializer serializer = new XmlSerializer(typeof(List<Row>), new XmlRootAttribute("SQLrows"));

      //List<Row> adjList = (List<Row>)serializer.Deserialize(stringReader);
      //List<Row> SortedAdjList = adjList.OrderBy(o => o.Team).ToList();

      public void ProcessDailyAdjustments(DateTime GameDate, string LeagueName)
      {
         DateTime LoadDateTime = DateTime.Now;
         string _strLoadDateTime = LoadDateTime.ToString();

         SortedList<string, CoversDTO> ocRotation = new SortedList<string, CoversDTO>();
         populateRotation(ocRotation, GameDate, _ConnectionString, _strLoadDateTime);
         if (ocRotation.Count == 0)
            return;   // No Games for GameDate

         List<string> Teams = new List<string>();
         foreach (var matchup in ocRotation)
         {
            CoversDTO oCoversDTO = matchup.Value;
            Teams.Add(oCoversDTO.TeamAway);
            Teams.Add(oCoversDTO.TeamHome);
         }

         DeleteAdjustments(GameDate, LeagueName);

         List<Row> SortedAdjList = getAdjustmentsFromWeb(GameDate, LeagueName);
         double ctrLgAdj = 0;
         foreach (Row adjRow in SortedAdjList)
         {
            if (adjRow.Type == "L")
            {
               ctrLgAdj += adjRow.AdjAmt;
            }
            else if (Teams.SingleOrDefault(s => s == adjRow.Team) == null)   // If Team not in list, they don't play today, so bypass
               continue;

            writeAdjustment(adjRow);
         }

         AdjustmentsDailyDO oAdjustmentsDaily = new AdjustmentsDailyDO(_ConnectionString);
         oAdjustmentsDaily.DeleteDailyAdjustments(GameDate, LeagueName);

         foreach (var matchup in ocRotation)
         {
            CoversDTO oCoversDTO = matchup.Value;
            string[] teams = new string[] { oCoversDTO.TeamAway, oCoversDTO.TeamHome };
            int RotNum = oCoversDTO.RotNum;
            for (int ixVenue = 0; ixVenue < 2; ixVenue++)
            {
               double ctrTeamAdj = ctrLgAdj;
               foreach (Row r in SortedAdjList)
               {
                  if (r.Team == teams[ixVenue])
                  {
                     ctrTeamAdj += r.AdjAmt;
                  }
               }  // loop adj rows
               writeAdjustmentDaily(oAdjustmentsDaily, GameDate, LeagueName, RotNum, teams[ixVenue], ctrTeamAdj);
               RotNum++;
            }  // foreach Venue
         }  // foreach matchup

      }  // ProcessDailyAdjustments
      private List<Row> getAdjustmentsFromWeb(DateTime GameDate, string LeagueName)
      {
         string QueryAdjustmentsSql = ""
            + "SELECT * FROM Adjustments  "
            + $"  WHERE LeagueName = '{LeagueName}' "
            + $"    AND ((Type = 'L' AND StartDate <= #{GameDate}#   AND (EndDate IS NULL or EndDate >= #{GameDate}#) ) "
            + $"     Or  (StartDate <= #{GameDate}#  AND (EndDate IS NULL or EndDate >= #{GameDate}#) )  AND AdjAmt <> 0 ) "
            + "    ORDER BY Type DESC ;"
            ;

         string QueryString = "SqlCommand=Select&SQL=" + VBFunctions.URLEncode(QueryAdjustmentsSql);
         String url = "http://bball.com.violet.arvixe.com/ExecSql2.aspx";
         WebPageGet oWebPageGet = new WebPageGet();
         oWebPageGet.NewWebPagePost(url, QueryString);
         if (oWebPageGet.ReturnCode != 0)
         {
            throw new Exception($"Error getting Adjustments from server - RC: {oWebPageGet.ReturnCode} - {oWebPageGet.ErrorMsg}");
         }
         string xmlString = oWebPageGet.Html;

         // Simple deserialization of XML to C# object - http://www.janholinka.net/Blog/Article/11

         StringReader stringReader = new StringReader(xmlString);
         XmlSerializer serializer = new XmlSerializer(typeof(List<Row>), new XmlRootAttribute("SQLrows"));

         List<Row> adjList = (List<Row>)serializer.Deserialize(stringReader);
         List<Row> SortedAdjList = adjList.OrderBy(o => o.Team).ToList();
         return SortedAdjList;
      }
      public void DeleteAdjustments(DateTime GameDate, string LeagueName)
      {

         string strSql = $"DELETE From {TableName} Where LeagueName = '{LeagueName}' AND StartDate = '{GameDate.ToShortDateString()}'";
         int rows = SysDAL.DALfunctions.ExecuteSqlNonQuery(SqlFunctions.GetConnectionString(), strSql);
      }
      private void writeAdjustment(Row oAdjRow)
      {
         AdjustmentDTO oAdjustmentDTO = new AdjustmentDTO()
         {
            LeagueName = _oLeagueDTO.LeagueName
            , StartDate = _GameDate
            , EndDate = _GameDate
            , Team = oAdjRow.Team
            , AdjustmentType = oAdjRow.Type
            , AdjustmentAmount = oAdjRow.AdjAmt
            , Player = oAdjRow.Player
            , Description = oAdjRow.Desc
            , TS = (string.IsNullOrEmpty(oAdjRow.TS) ? _GameDate : Convert.ToDateTime(oAdjRow.TS))
         };
         //                       TableName     ColNames (csv)     DTO       Insert DTO into ocValues Method
         SqlFunctions.DALInsertRow(TableName, TableColumns, oAdjustmentDTO, populate_ocValuesForInsert, _ConnectionString);

      }
      private void populate_ocValuesForInsert(List<string> ocValues, object DTO)
      {
         AdjustmentDTO oAdjustmentDTO = (AdjustmentDTO)DTO;
         ocValues.Add(oAdjustmentDTO.LeagueName.ToString());
         ocValues.Add(oAdjustmentDTO.StartDate.ToString());
         ocValues.Add(oAdjustmentDTO.EndDate.ToString());
         ocValues.Add(oAdjustmentDTO.Team.ToString());
         ocValues.Add(oAdjustmentDTO.AdjustmentType.ToString());
         ocValues.Add(oAdjustmentDTO.AdjustmentAmount.ToString());
         ocValues.Add(oAdjustmentDTO.Player.ToString());
         ocValues.Add(oAdjustmentDTO.Description.ToString());
         ocValues.Add(oAdjustmentDTO.TS.ToString());

      }
      private void writeAdjustmentDaily(AdjustmentsDailyDO oAdjustmentsDaily, DateTime GameDate, string LeagueName, int RotNum, string Team, double AdjustmentAmount)
      {
         AdjustmentsDailyDTO oAdjustmentsDailyDTO = new AdjustmentsDailyDTO()
         {
            LeagueName = LeagueName
            ,
            GameDate = GameDate
            ,
            RotNum = RotNum
            ,
            Team = Team
            ,
            AdjustmentAmount = AdjustmentAmount

         };
         
         oAdjustmentsDaily.InsertRow(oAdjustmentsDailyDTO);
      }
      // kdtodo refactor into rotation class
      void populateRotation(SortedList<string, CoversDTO> ocRotation, DateTime GameDate, string ConnectionString, string strLoadDateTime)
      {
         RotationDO oRotation = new RotationDO(ocRotation, GameDate, _oLeagueDTO, ConnectionString, strLoadDateTime);
         oRotation.GetRotation();
      }


    #region todaysAdjustments
    public List<AdjustmentDTO> GetTodaysAdjustments(string LeagueName)
    {
        string ConnectionString = Bball.DataBaseFunctions.SqlFunctions.GetConnectionString();
        List<AdjustmentDTO> ocAdjustmentDTO = new List<AdjustmentDTO>();

        List<string> SqlParmNames = new List<string>() { "LeagueName" };
        List<object> SqlParmValues = new List<object>() { LeagueName };

        SysDAL.DALfunctions.ExecuteStoredProcedureQuery(ConnectionString, "uspQueryAdjustments"
                            , SqlParmNames, SqlParmValues, ocAdjustmentDTO, populateDTOFromRdr);
        return ocAdjustmentDTO;
    }
    static void populateDTOFromRdr(object oRow, SqlDataReader rdr)
    {

        AdjustmentDTO oAdjustmentDTO = new AdjustmentDTO();

        oAdjustmentDTO.AdjustmentID = (int)rdr["AdjustmentID"];
        oAdjustmentDTO.LeagueName = (string)rdr["LeagueName"];
        oAdjustmentDTO.StartDate = (DateTime)rdr["StartDate"];
        oAdjustmentDTO.EndDate = rdr["EndDate"] == DBNull.Value ? null : (DateTime?)rdr["EndDate"];
        oAdjustmentDTO.Team = (string)rdr["Team"];
        oAdjustmentDTO.AdjustmentType = (string)rdr["AdjustmentType"];
        oAdjustmentDTO.AdjustmentAmount = (float)rdr["AdjustmentAmount"];
        oAdjustmentDTO.Player = (string)rdr["Player"];
        oAdjustmentDTO.Description = (string)rdr["Description"];
        oAdjustmentDTO.TS = (DateTime)rdr["TS"];

        List<AdjustmentDTO> ocAdjustmentDTO = (List<AdjustmentDTO>)oRow;
        ocAdjustmentDTO.Add(oAdjustmentDTO);
    }
    #endregion todaysAdjustments


    }  // class Adjustments


    public class Row
   {
      public string Team { get; set; }
      public string Type { get; set; }
      public float AdjAmt { get; set; }
      public string Player { get; set; }
      public string Desc { get; set; }
      public string TS { get; set; }
   }
}
