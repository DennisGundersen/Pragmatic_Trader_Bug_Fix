using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Common.Models.API;
public class AccountRegistrationResultModel
{
	public int Id { get; set; }
	public int StrategyId { get; set; }
	public int AccountNumber { get; set; }
	public string AccountName { get; set; }
	public string BrokerName { get; set; }
	public string Symbol { get; set; }
	public decimal Security { get; set; }
	public decimal StepGrowthFactor { get; set; }
	public decimal StartingBalance { get; set; }
	public int StartFactor { get; set; }
	public decimal Commission { get; set; }
	public bool IsLive { get; set; }
	public string AccountCurrency { get; set; }
	public DateTime RegisteredTime { get; set; }
	public int LastOrderClose { get; set; }

}
