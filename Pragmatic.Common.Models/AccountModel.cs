using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Pragmatic.Common.Models
{
	public class AccountModel
	{
		public AccountModel()
		{
			Alerts = new HashSet<AlertModel>();
			Progresses = new HashSet<ProgressModel>();
		}

		[Display(Name = "Id")]
		public int Id { get; set; }


		[Required, Display(Name = "Strategy")]
		public int StrategyId { get; set; } = 1;


		[Required, Display(Name = "Account #")]
		public int AccountNumber { get; set; }


		[Required, Display(Name = "Name")]
		[StringLength(50, MinimumLength = 3)]
		public string AccountName { get; set; } = "DEV";


		[Required, Display(Name = "Broker")]
		public string BrokerName { get; set; } = "ICMarkets";


		[Required, Display(Name = "Symbol")]
		[StringLength(6, MinimumLength = 6)]
		public string Symbol { get; set; } = "USDCAD";

		[Required, Display(Name = "Security")]
		[DisplayFormat(DataFormatString = "{0:#.##}", ApplyFormatInEditMode = true)]
		[Column(TypeName = "decimal(18, 2)")]
		public decimal Security { get; set; } = 0.0M;

		[Required, Display(Name = "Growth factor")]
		[DisplayFormat(DataFormatString = "{0:#.####}", ApplyFormatInEditMode = true)]
		[Column(TypeName = "decimal(18, 4)")]
		public decimal StepGrowthFactor { get; set; } = 1.0075M;


		[Required, Display(Name = "Start balance")]
		[DisplayFormat(DataFormatString = "{0:#.##}", ApplyFormatInEditMode = true)]
		[Column(TypeName = "decimal(18, 2)")]
		public decimal StartingBalance { get; set; } = 2000;


		[Required, Display(Name = "Start factor")]
		[RegularExpression("(1|5|10)$", ErrorMessage = "Start factor must be 1, 5 or 10")]
		public int StartFactor { get; set; } = 1;


		[Required, Display(Name = "Commission")]
		[Column(TypeName = "decimal(18, 2)")]
		public decimal Commission { get; set; } = 10;


		[Required, Display(Name = "Live?")]
		public bool IsLive { get; set; } = false;


		[Required, Display(Name = "Base currency")]
		[StringLength(3, MinimumLength = 1)]
		public string AccountCurrency { get; set; } = "USD";


		[Required, Display(Name = "Registered")]
		public DateTime RegisteredTime { get; set; } = DateTime.UtcNow;


		[Required, Display(Name = "Updated")]
		public DateTime LastUpdated { get; set; } = DateTime.UtcNow;


		public virtual ICollection<AlertModel> Alerts { get; set; }


		public virtual ICollection<ProgressModel> Progresses { get; set; }

		public virtual SnapshotModel Snapshot { get; set; }
		public virtual ProjectionModel Projection { get; set; } = new();


		public virtual VariablesModel Variables { get; set; } = new();
	}
}
