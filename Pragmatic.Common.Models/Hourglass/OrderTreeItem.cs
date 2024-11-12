using Pragmatic.Common.Enums;

namespace Pragmatic.Common.Models.Hourglass
{
    public class OrderTreeItem
    {
        public decimal OpenRate { get; set; }
        public decimal TakeProfitRate { get; set; }
        public decimal StopLossRate { get; set; }
        public OrderFunction OrderFunction { get; set; }
    }
}
