using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Common.Models.Hourglass;
public class OrderStatsPeriodsModel
{
	public int Id { get; set; }
	public decimal Lots { get; set; }
	public int AccountId { get; set; }
	public decimal NOK { get; set; }
	public int DayOfMonth { get; set; }
	public int DayOfWeek { get; set; }
	public int HourOfDay { get; set; }
}
