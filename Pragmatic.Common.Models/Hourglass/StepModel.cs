namespace Pragmatic.Common.Models.Hourglass;
public class StepModel
{
	public decimal StartBalance { get; set; } = 2000m;
	public decimal CurrentBalance { get; set; } = 2000m;
	public decimal  StepGrowthFactor { get; set; } = 1.0075m;
	public int CurrentStep { get; set; }
}
