using System;

namespace Pragmatic.Common.Models
{
	public class ProgressModel
	{
		public int Id { get; set; }
		public int AccountId { get; set; }
		public decimal Lots { get; set; } = 0.01M;
		public int Step { get; set; } = 0;
		public int MissingSteps { get; set; }
		public decimal Limit { get; set; }
		public decimal MissingCurrency { get; set; }
		public decimal TradeValue { get; set; }
		public int MissingTrades { get; set; }
		public decimal Weekly { get; set; }
		public decimal Monthly { get; set; }
		public int Days { get; set; }
		public int Weeks { get; set; }
		public DateOnly ReachedDate { get; set; }
		public int MissingOrders { get; set; }

	}
}

