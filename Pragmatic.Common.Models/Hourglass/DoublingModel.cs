namespace Pragmatic.Common.Models.Hourglass;
public class DoublingModel
{
	public int TakeProfit { get; set; } = 99;
	public int FixedSpread { get; set; } = 1;
	public decimal UsePoint { get; set; } = 0.0001m;
	public decimal TopRate { get; set; } = 1.5000m;
	public decimal BottomRate { get; set; } = 1.3000m;
	public int TotalDistance { get; set; } = 2000;

	public decimal CurrentBalance { get; set; } = 2730;
	public int GridSize { get; set; } = 100;
	public int GridCount { get; set; } = 20;
	public decimal CurrentLotSize { get; set; } = 0.01m;
	public decimal GoalLotSize { get; set; } = 0.01m;
	public decimal Buffer { get; set; } = 0.4m;
	public decimal IncomePerCurrentOrder { get; set; } = 0.0m;
	public  decimal DrawdownPerGrid { get; set; } = 0.0m;
	public decimal FullCoverage { get; set; } = 0.0m;
	public decimal MissingBalance { get; set; } = 0.0m;
	public int NextLotIncreaseOrdersCount { get; set; } = 0;
	public decimal Ask { get; set; } = 1.4000m;
	public string Symbol { get; set; } = "EURUSD";
	public string AccountCurrency { get; set; } = "USD";
	public decimal DrawdownPerPip { 
		get
		{
			decimal result = 0;
			if (DrawdownPerGrid > 0 && GridSize > 0)
			{
				result = DrawdownPerGrid / GridSize;
			}
				
			return result;
		}
	}
}
