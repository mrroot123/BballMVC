using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BballMVC.DTOs
{
	class TeamStatDTO
	{
		public string UserName { get; set; }
		public string LeagueName { get; set; }
		public DateTime GameDate { get; set; }
		public string Team { get; set; }
		public string Venue { get; set; }
		public string Season { get; set; }
		public string SubSeason { get; set; }
		public int? Games { get; set; }
		public int? LastSeasonHistoryGames { get; set; }
		public DateTime? StartGameDate { get; set; }
		public float ShotsAdjustedMadeUsPt1 { get; set; }
		public float ShotsAdjustedMadeUsPt2 { get; set; }
		public float ShotsAdjustedMadeUsPt3 { get; set; }
		public float ShotsAdjustedMadeOppPt1 { get; set; }
		public float ShotsAdjustedMadeOppPt2 { get; set; }
		public float ShotsAdjustedMadeOppPt3 { get; set; }
		public float? TeamStrengthUs { get; set; }
		public float? TeamStrengthOpp { get; set; }
		public float? TeamStrength { get; set; }
	}
}
