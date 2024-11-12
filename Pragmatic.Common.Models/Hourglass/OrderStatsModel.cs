using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Common.Models.Hourglass;
public class OrderStatsModel
{
	public int AccountId { get; set; }
	public string AccountName { get; set; }
	public int RegularCount { get; set; }
	public int TotalCount { get; set; }
	public string TimeCode { get; set; } // Replacement for YearWeek and YearMonth as both can't be included when rows are partitioned in sql query
	public decimal Costs { get; set; }
	public decimal Profits { get; set; }
	public decimal Pips { get; set; }
	public decimal NOK { get; set; }
	public decimal Lots { get; set; }
	public decimal Result { get; set; }
}
