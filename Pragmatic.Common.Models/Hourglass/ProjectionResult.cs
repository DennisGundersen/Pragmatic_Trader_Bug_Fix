namespace Pragmatic.Common.Models.Hourglass
{
    public class ProjectionResult
    {
        public decimal Rate { get; set; }
        public decimal Equity { get; set; }
        public decimal Balance { get; set; }
        public decimal Longs { get; set; }
        public decimal Shorts { get; set; }

        public ProjectionResult()
        {
            Rate = 0;
            Equity = 0;
            Balance = 0;
            Longs = 0;
            Shorts = 0;
        }
    }
}
