namespace Pragmatic.Common.Models.Hourglass;
public class MonthlyResultModel
{
	public int AccountId { get; set; }
	public int RegularCount { get; set; }
	public int TotalCount { get; set; }
	public string YearMonth { get; set; }
	public decimal Costs { get; set; }
	public decimal Profits { get; set; }
	public int Pips { get; set; }
	public decimal NOK { get; set; }
}
