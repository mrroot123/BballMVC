
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
   // Change TodaysPlays --> TableName
   //public 
   public class TodaysPlaysDO
   {
      const string TableName = "TodaysPlays";
      const string TableColumns = "GameDate,LeagueName,RotNum,GameTime,TeamAway,TeamHome,WeekEndDate,PlayLength,PlayType,Line,Info,PlayAmount,PlayWeight,Juice,Out,Author,Result,OT,Score,ResultAmount,CreateUser,CreateDate";

      IBballInfoDTO _oBballInfoDTO;


      // Constructor

      public TodaysPlaysDO(IBballInfoDTO oBballInfoDTO)
      {
         _oBballInfoDTO = oBballInfoDTO;
      }
      public TodaysPlaysDO(DateTime GameDate)
      {
         _oBballInfoDTO = new BballInfoDTO() { GameDate = GameDate };
      }


      #region GetRows
      public int GetTodaysPlays(IList<ITodaysPlaysDTO>  ocTodaysPlaysDTO)
      {
         int rows = SysDAL.Functions.DALfunctions.ExecuteSqlQuery(_oBballInfoDTO.ConnectionString, getRowSql(_oBballInfoDTO.GameDate), ocTodaysPlaysDTO, populateDTOFromRdr);
         return rows;
      }
      static void populateDTOFromRdr(object oRow, SqlDataReader rdr)
      {

         ITodaysPlaysDTO o = new BballMVC.DTOs.TodaysPlaysDTO();

         o.GameDate = (DateTime)rdr["GameDate"];
         o.GameTime = (TimeSpan)rdr["GameTime"];
         o.WeekEndDate = (DateTime)rdr["WeekEndDate"];
         o.CreateDate = (DateTime)rdr["CreateDate"];
         o.OtAffacted = rdr["OtAffacted"] == DBNull.Value ? null : (decimal?)rdr["OtAffacted"];
         o.ResultAmount = rdr["ResultAmount"] == DBNull.Value ? null : (double?)rdr["ResultAmount"];
         o.Line = (double)rdr["Line"];
         o.PlayAmount = (double)rdr["PlayAmount"];
         o.PlayWeight = (double)rdr["PlayWeight"];
         o.Juice = (double)rdr["Juice"];
         o.TodaysPlaysID = (int)rdr["TodaysPlaysID"];
         o.TranType = rdr["TranType"] == DBNull.Value ? null : (int?)rdr["TranType"];
         o.RotNum = (int)rdr["RotNum"];

         o.ScoreAway = rdr["ScoreAway"] == DBNull.Value ? null : (int?)rdr["ScoreAway"];
         o.ScoreHome = rdr["ScoreHome"] == DBNull.Value ? null : (int?)rdr["ScoreHome"];
         o.FinalScore = rdr["FinalScore"] == DBNull.Value ? null : (int?)rdr["FinalScore"];
         o.Result = rdr["Result"] == DBNull.Value ? null : (int?)rdr["Result"];
         o.CreateUser = rdr["CreateUser"].ToString().Trim();
         o.TeamAway = rdr["TeamAway"].ToString().Trim();
         o.TeamHome = rdr["TeamHome"].ToString().Trim();
         o.LeagueName = rdr["LeagueName"].ToString().Trim();
         o.Out = rdr["Out"].ToString().Trim();
         o.Author = rdr["Author"].ToString().Trim();
         o.Info = rdr["Info"].ToString().Trim();
         o.PlayLength = rdr["PlayLength"].ToString().Trim();
         o.PlayDirection = rdr["PlayDirection"].ToString().Trim();

         ((List<ITodaysPlaysDTO>)oRow).Add(o);
      }
      private string getRowSql(DateTime GameDate)
      {
         string Sql = ""
            + $"SELECT Convert(int, b.ScoreRegOp) as ScoreAway, Convert(int, b.ScoreRegUs) as ScoreHome, tp.*  "
            + $"  FROM TodaysPlays tp  "
            + $"  Left JOIN BoxScores b ON b.GameDate = tp.GameDate AND b.RotNum = tp.RotNum  "
            + $"  Where  tp.GameDate = '{GameDate.ToShortDateString()}'"
            + "   Order By tp.LeagueName, tp.GameTime, tp.RotNum"
            ;
         return Sql;
      }
      #endregion GetRows

      #region InsertRow
      public void InsertRow()
      {
         BballMVC.DTOs.TodaysPlaysDTO oThisDTO = populateDTO();
         //                        TableName  ColNames(csv)  DTO             Insert into DTO Method
         SqlFunctions.DALInsertRow(TableName, TableColumns, oThisDTO, populate_ocValuesForInsert, _oBballInfoDTO.ConnectionString);
      }
      private TodaysPlaysDTO populateDTO()
      {
         BballMVC.DTOs.TodaysPlaysDTO oThisDTO = new BballMVC.DTOs.TodaysPlaysDTO();
         oThisDTO.LeagueName = _oBballInfoDTO.LeagueName;
         // ...
         return oThisDTO;
      }
      static void populate_ocValuesForInsert(List<string> ocValues, object DTO)
      {
         BballMVC.DTOs.TodaysPlaysDTO oTodaysPlaysDTO = (BballMVC.DTOs.TodaysPlaysDTO)DTO;

         ocValues.Add(oTodaysPlaysDTO.GameDate.ToString());
         ocValues.Add(oTodaysPlaysDTO.LeagueName.ToString());
         ocValues.Add(oTodaysPlaysDTO.RotNum.ToString());
         ocValues.Add(oTodaysPlaysDTO.GameTime.ToString());
         ocValues.Add(oTodaysPlaysDTO.TeamAway.ToString());
         ocValues.Add(oTodaysPlaysDTO.TeamHome.ToString());
         ocValues.Add(oTodaysPlaysDTO.WeekEndDate.ToString());
         ocValues.Add(oTodaysPlaysDTO.PlayLength.ToString());
         ocValues.Add(oTodaysPlaysDTO.PlayDirection.ToString());
         ocValues.Add(oTodaysPlaysDTO.Line.ToString());
         ocValues.Add(oTodaysPlaysDTO.Info.ToString());
         ocValues.Add(oTodaysPlaysDTO.PlayAmount.ToString());
         ocValues.Add(oTodaysPlaysDTO.PlayWeight.ToString());
         ocValues.Add(oTodaysPlaysDTO.Juice.ToString());
         ocValues.Add(oTodaysPlaysDTO.Out.ToString());
         ocValues.Add(oTodaysPlaysDTO.Author.ToString());
         //ocValues.Add(oTodaysPlaysDTO.Result.ToString());
         //ocValues.Add(oTodaysPlaysDTO.OT.ToString());
         //ocValues.Add(oTodaysPlaysDTO.Score.ToString());
         //ocValues.Add(oTodaysPlaysDTO.ResultAmount.ToString());
         ocValues.Add(oTodaysPlaysDTO.CreateUser.ToString());
         ocValues.Add(oTodaysPlaysDTO.CreateDate.ToString());

      }
      #endregion InsertRow

   }  // class

}

