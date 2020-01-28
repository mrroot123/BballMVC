using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BballMVC.DTOs
{
	class LeagueAverageDTO
	{
		public string UserName { get; set; }
		public string LeagueName { get; set; }
		public DateTime GameDate { get; set; }
		public string Season { get; set; }
		public string SubSeason { get; set; }
		public Nullable<byte> SubSeasonPeriod { get; set; }
		public Nullable<byte> NumOfMatchups { get; set; }
		public float? LgAvgLast1 { get; set; }
		public float? LgAvgLast2 { get; set; }
		public float? LgAvgLast3 { get; set; }
		public float? LgAvgAwayLast1 { get; set; }
		public float? LgAvgAwayLast2 { get; set; }
		public float? LgAvgAwayLast3 { get; set; }
		public float? LgAvgAwayLast1Pt1 { get; set; }
		public float? LgAvgAwayLast1Pt2 { get; set; }
		public float? LgAvgAwayLast1Pt3 { get; set; }
		public float? LgAvgAwayLast2Pt1 { get; set; }
		public float? LgAvgAwayLast2Pt2 { get; set; }
		public float? LgAvgAwayLast2Pt3 { get; set; }
		public float? LgAvgAwayLast3Pt1 { get; set; }
		public float? LgAvgAwayLast3Pt2 { get; set; }
		public float? LgAvgAwayLast3Pt3 { get; set; }
		public float? LgAvgHomePt1 { get; set; }
		public float? LgAvgHomePt2 { get; set; }
		public float? LgAvgHomePt3 { get; set; }
		public float? LgAvgHomeLast1Pt1 { get; set; }
		public float? LgAvgHomeLast1Pt2 { get; set; }
		public float? LgAvgHomeLast1Pt3 { get; set; }
		public float? LgAvgHomeLast2Pt1 { get; set; }
		public float? LgAvgHomeLast2Pt2 { get; set; }
		public float? LgAvgHomeLast2Pt3 { get; set; }
		public float? LgAvgHomeLast3Pt1 { get; set; }
		public float? LgAvgHomeLast3Pt2 { get; set; }
		public float? LgAvgHomeLast3Pt3 { get; set; }
		public float? LgAvgLastMinPt1 { get; set; }
		public float? LgAvgLastMinPt2 { get; set; }
		public float? LgAvgLastMinPt3 { get; set; }
		public Nullable<byte> CurveAgainstLine { get; set; }
		public Nullable<byte> CurveOSS { get; set; }
		public Nullable<byte> CurveHalfQtrLine { get; set; }
		public Nullable<byte> HistoryWeightLast1 { get; set; }
		public Nullable<byte> HistoryWeightLast2 { get; set; }
		public Nullable<byte> HistoryWeightLast3 { get; set; }
		public Nullable<byte> HistoryGamesBackLast1 { get; set; }
		public Nullable<byte> HistoryGamesBackLast2 { get; set; }
		public Nullable<byte> HistoryGamesBackLast3 { get; set; }
		public float? ThresholdUnder { get; set; }
		public float? ThresholdOver { get; set; }
		public float? ThresholdHalf { get; set; }
		public float? ThresholdHalf2Over { get; set; }
		public float? ThresholdHalf2Under { get; set; }
		public float? ThresholdQtr { get; set; }
		public DateTime? UpdateTS { get; set; }
		public string UpdateUser { get; set; }
		public bool FinalSave { get; set; }
	}
}
