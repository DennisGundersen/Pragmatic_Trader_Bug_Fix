using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Common.Models.Hourglass;
public class HourglassKPIModel
{
	public int Id { get; set; }
	public string AccountName { get; set; }
	public bool IsLive { get; set; }
	public decimal CenterRate { get; set; }
	public decimal UsePoint { get; set; }
	public decimal Ask { get; set; }
	public decimal Balance { get; set; }
	public decimal Equity { get; set; }
	public decimal Longs { get; set; }
	public decimal Shorts { get; set; }
	public int OrderCount { get; set; }
	public decimal CurrentLotSize { get; set; }
	public int CurrentStep { get; set; }
	public int GMTOffset { get; set; }
	public int MaxWeight { get; set; }
	public int RateDecimalNumbersToShow { get; set; }
	public DateTime RegisteredTime { get; set; }
	public DateTime LastUpdated { get; set; }
}
