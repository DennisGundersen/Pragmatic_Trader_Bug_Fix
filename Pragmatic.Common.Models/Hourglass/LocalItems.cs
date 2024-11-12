using System;

namespace Pragmatic.Common.Models.Hourglass
{
	public static class LocalItems
	{
		public static decimal MaxTradingLotSize { get; set; } = 10.00M;
		//public static DateTime UnixEpoch { get; set; } = new DateTime(1970, 1, 1, 0, 0, 0);
		//public static string baseURL { get; set; } = "https://pragmatic.azurewebsites.net";
		//public static string chartsURL { get; set; } = "/api/Charts/Register";
		//public static string FtpURI { get; set; } = "ftp://waws-prod-bn1-021.ftp.azurewebsites.windows.net/site/wwwroot/wwwroot/Charts/";
		//ftps://waws-prod-bn1-021.ftp.azurewebsites.windows.net/site/wwwroot
		//public static string FtpLogin { get; set; } = "Pragmatic\\appwriter";
		//public static string FtpPassword { get; set; } = "********";
		public static int KillSwitch { get; set; } = 3000;
		public static bool IsSymbolMaster { get; set; } = false;
		public static decimal AccountPercentage { get; set; } = 1;
		public static string DataFolder { get; set; }
		public static decimal CurrentTopShortBreakout { get; set; } = 0;
		public static decimal CurrentBottomLongBreakout { get; set; } = 0;
		public static decimal CurrentTopShortPrimer { get; set; } = 0;
		public static decimal CurrentBottomLongPrimer { get; set; } = 0;
		public static decimal CurrentTopShortWhiplash { get; set; } = 0;
		public static decimal CurrentBottomLongWhiplash { get; set; } = 0;
		public static int MidTermRangeASide { get; set; } = 275;
		public static decimal MidTermTopRate { get; set; } = 0;
		public static decimal MidTermBottomRate { get; set; } = 0;
		public static int MaxStabilizerSizeFactor { get; set; } = 6;
		public static int MinStabilizerSizeFactorForClosings { get; set; } = 3;
		public static int SLversusTPBuffer = 5;
		public static decimal MaxAcceptedWeightDifferance = 5.0M;
		public static int BalancerMinPlacementDistanceLongs { get; set; } = 100;
		public static int BalancerMinPlacementDistanceShorts { get; set; } = 100;
		public static decimal AccountToNOK { get; set; }
		public static string FreecurrencyapiKey { get; set; } = "fca_live_tpYXG8Wh0nARpobRRtyVTEVaCsJhPiSIYUTYhcDH";

		public static string BlobStorageConnectionString { get; set; } = "DefaultEndpointsProtocol=https;AccountName=pragmaticsa;AccountKey=DJhxuFV4T6r9QLqis6NMYW6TlO11FOzlK+9X8uktoFj4Y7vvowuGzDuqiw6unemsuCfn1BBUIlVh+ASt66kkxg==;EndpointSuffix=core.windows.net";
		public static string BlobStorageContainerName { get; set; } = "charts";
	}
}
