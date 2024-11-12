using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Common.Models
{
	public class SnapshotModel
	{
		public int Id { get; set; }
		public int AccountId { get; set; }
		public string Symbol { get; set; }
		public decimal Ask { get; set; } = 0;
		public decimal Bid { get; set; } = 0;
		public decimal Balance { get; set; } = 0;
		public decimal Equity { get; set; } = 0;
		public decimal Longs { get; set; } = 0;
		public decimal Shorts { get; set; } = 0;
		public int OrderCount { get; set; } = 0;
		public decimal NextLotSize { get; set; } = 0;
		public decimal NextLotIncrease { get; set; } = 0;
		public int NextLotIncreaseOrders { get; set; } = 0;
		public decimal CurrentLotSize { get; set; } = 0.01M;
		public int CurrentStep { get; set; } = 0;
		public int CurrentTakeProfit { get; set; } = 0;
		public decimal CurrentPipValue { get; set; } = 10;
		public DateTime LastUpdated { get; set; } = DateTime.UtcNow;
		public string YearWeek { get; set; }
		public string YearMonth { get; set; }
	}
}
