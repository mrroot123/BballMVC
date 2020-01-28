using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BballMVC.DTOs
{
	class UrlDTO
	{
		public int ID { get; set; }
		public string UrlType { get; set; }
		public string Source { get; set; }
		public bool Index { get; set; }
		public System.DateTime StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public int Sequence { get; set; }
		public string UrlFormula { get; set; }
		public string Url1 { get; set; }
		public string UrlExample { get; set; }
	}
}
