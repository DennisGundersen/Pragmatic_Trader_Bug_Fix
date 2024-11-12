using System;

namespace Pragmatic.Common.Models
{
    public class ProjectionModel
    {
        public int AccountId { get; set; }     // AccountId (1-to-1)
        public decimal Longs { get; set; } = 0;
        public decimal Shorts { get; set; } = 0;
        public decimal LongBalancers { get; set; } = 0;
        public decimal ShortBalancers { get; set; } = 0;
        public int CurrentStep { get; set; } = 0;
        public decimal NextLotSize { get; set; } = 0;
        public decimal NextLotIncrease { get; set; } = 0;
        public int NextLotIncreaseOrders { get; set; } = 0;

        public decimal UpRate { get; set; } = 0;
        public decimal UpEquity { get; set; } = 0;
        public decimal UpBalance { get; set; } = 0;
        public decimal UpLongs { get; set; } = 0;
        public decimal UpShorts { get; set; } = 0;

        public decimal TopRate { get; set; } = 0;
        public decimal TopEquity { get; set; } = 0;
        public decimal TopBalance { get; set; } = 0;
        public decimal TopLongs { get; set; } = 0;
        public decimal TopShorts { get; set; } = 0;

        public decimal CenterRate { get; set; } = 0;
        public decimal CenterEquity { get; set; } = 0;
        public decimal CenterBalance { get; set; } = 0;
        public decimal CenterLongs { get; set; } = 0;
        public decimal CenterShorts { get; set; } = 0;

        public decimal DownRate { get; set; } = 0;
        public decimal DownEquity { get; set; } = 0;
        public decimal DownBalance { get; set; } = 0;
        public decimal DownLongs { get; set; } = 0;
        public decimal DownShorts { get; set; } = 0;

        public decimal BottomRate { get; set; } = 0;
        public decimal BottomEquity { get; set; } = 0;
        public decimal BottomBalance { get; set; } = 0;
        public decimal BottomLongs { get; set; } = 0;
        public decimal BottomShorts { get; set; } = 0;
        public DateTime LastUpdated { get; set; } = DateTime.UtcNow;

    }
}
