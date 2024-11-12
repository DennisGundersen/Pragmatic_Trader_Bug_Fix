using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Common.Models.Hourglass;
public class ResultsModel
{
	public int RegularCount { get; set; }
	public int TotalCount { get; set; }
	public string TimeCode { get; set; }
	public decimal Costs { get; set; }
	public decimal Profits { get; set; }
	public int Pips { get; set; }
	public decimal NOK { get; set; }
}
