namespace Pragmatic.Common.Models.API;
public class AccountRegistrationModel
{
	// Account info set in MT4 for testing purposes
	public int AccountNumber { get; set; }                         // = 1
	public string AccountName { get; set; }                    // = 2
	public string Symbol { get; set; }                       // = 3

	// Variables set in MT4 for trading purposes
	public decimal TradingLotSize { get; set; }                    // = 4
	public decimal ExtremeTopRate { get; set; }                    // = 5
	public decimal NormalTopRate { get; set; }                     // = 6
	public decimal CenterRate { get; set; }                        // = 7
	public decimal NormalBottomRate { get; set; }                  // = 8
	public decimal ExtremeBottomRate { get; set; }                 // = 9 

	public int MaxPlacementDistance { get; set; }                // = 10
	public decimal TestUpToRate { get; set; }                      // = 11
	public decimal TestDownToRate { get; set; }                     // = 12
	public int TestPipsUp { get; set; }                           // = 13
	public int TestPipsDown { get; set; }                         // = 14
	public int BalancerMinPlacementDistanceLongs { get; set; }      // = 15
	public int BalancerMinPlacementDistanceShorts { get; set; }     // = 16

	public int LongStabilizerSizeFactor { get; set; }               // = 17
	public int ShortStabilizerSizeFactor { get; set; }              // = 18
	public int LongBalancerSizeFactor { get; set; }                 // = 19
	public int ShortBalancerSizeFactor { get; set; }                // = 20
	public int PrimerSizeFactor { get; set; }                       // = 21
	public int BalancerStopLossPips { get; set; }                 // = 22
	public int SecurePips { get; set; }                             // = 23

	public bool AutoLotIncrease { get; set; }                 // = 24
	public int AutoLotSafeEQLevel { get; set; }                  // = 25
	public int TakeProfit { get; set; }                            // = 26
	public bool TradeMidTerm { get; set; }                     // = 27
	public int FixedSpread { get; set; }                           // = 28
	public int ExtraLongBuffer { get; set; }                       // = 29
	public int ExtraShortBuffer { get; set; }                      // = 30

	public int WarningLevel { get; set; }                           // = 31
	public int HeartbeatMonitorTimer { get; set; }                 // = 32
	public int SnapshotLogTimer { get; set; }                       // = 33
	public bool AutoCloseExtremes { get; set; }                 // = 34

	public bool RunBalancers { get; set; }                      // = 35
	public bool RunStabilizers { get; set; }                    // = 36
	public bool RunBreakouts { get; set; }                      // = 37
	public bool RunWhiplash { get; set; }                       // = 38
	public bool RunPrimers { get; set; }                        // = 39

	public int GMTOffset { get; set; }                             // = 40
	public decimal UsePoint { get; set; }                         // = 41
	public int RateDecimalNumbersToShow { get; set; }             // = 42
	public bool IsAccountMaster { get; set; }                  // = 43
	public bool IsSymbolMaster { get; set; }                    // = 44

	public int ScreenshotTimer { get; set; }                        // = 45
	public int MaxWeight { get; set; }                         // = 46

	public string DataFolder { get; set; }                      // = 47
	public decimal AccountPercentage { get; set; }              // = 48
	public decimal Ask { get; set; } = 0;                       // = 49
	public decimal Bid { get; set; } = 0;                       // = 50
	public decimal Balance { get; set; } = 0;                   // = 51
	public decimal Equity { get; set; } = 0;                    // = 52

}
