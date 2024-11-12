using Pragmatic.Common.Enums;

namespace Pragmatic.Common.Models;

public class OrderModel
{
	public int Ticket { get; set; }                 // 1
	public int OrderType { get; set; }              // 2
	public decimal Lots { get; set; }               // 3
	public int OpenTime { get; set; }               // 4
	public int CloseTime { get; set; }              // 5
	public string Symbol { get; set; }              // 6
	public decimal OpenRate { get; set; }           // 7    
	public decimal CloseRate { get; set; }          // 8
	public decimal PlannedOpenRate { get; set; }    // 9
	public OrderFunction OrderFunction { get; set; } // 10
	public decimal StopLossRate { get; set; }       // 11
	public decimal TakeProfitRate { get; set; }     // 12
	public decimal Swap { get; set; }               // 13
	public decimal Commission { get; set; }         // 14
	public decimal Profit { get; set; }             // 15
	public string Comment { get; set; }             // 16
	public int AccountId { get; set; }              // 17
}
