namespace Pragmatic.Common.Models.Hourglass
{
    public class Next
    {
        public decimal ExpectedLotSize { get; set; }
        public decimal NextLotSize { get; set; }
        public decimal NextLotIncrease { get; set; }
        public int CurrentStep { get; set; }
        public int NextLotIncreaseOrders { get; set; }
    }
}
