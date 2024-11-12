//+------------------------------------------------------------------+
//|                                                         DTOs.mqh |
//|                                                 Dennis Gundersen |
//|                                  https://www.dennisgundersen.com |
//+------------------------------------------------------------------+
#property copyright "Dennis Gundersen"
#property link      "https://www.dennisgundersen.com"
#property strict

#include <CommunicationBase.mqh>

class HourglassAccountRegistrationDTO: public IZmqSerializable
{
	public:
		int accountNumber;                        // 0
		string accountName;                       // 1 NameOfAccount
      string symbol;                            // 2

      double tradingLotSize;                    // 3
      double extremeTopRate;                    // 4
      double normalTopRate;                     // 5
      double centerRate;                        // 6
      double normalBottomRate;                  // 7
      double extremeBottomRate;                 // 8

      int maxPlacementDistance;                 // 9
      double testUpToRate;                      // 10
      double testDownToRate;                    // 11
      int testPipsUp;                           // 12
      int testPipsDown;                         // 13
      int balancerMinPlacementDistanceLongs;    // 14
      int balancerMinPlacementDistanceShorts;   // 15

      int longStabilizerSizeFactor;             // 16
      int shortStabilizerSizeFactor;            // 17
      int longBalancerSizeFactor;               // 18
      int shortBalancerSizeFactor;              // 19
      int primerSizeFactor;                     // 20
      int balancerStopLossPips;                 // 21
      int securePips;                           // 22

      bool autoLotIncrease;                     // 23
      int autoLotSafeEQLevel;                   // 24
      int takeProfit;                           // 25
      bool tradeMidTerm;                        // 26
      int fixedSpread;                          // 27
      int extraLongBuffer;                      // 28
      int extraShortBuffer;                     // 29

      int warningLevel;                         // 30
      int heartbeatMonitorTimer;                // 31
      int snapshotLogTimer;                     // 32
      bool autoCloseExtremes;                   // 33

      bool runBalancers;                        // 34
      bool runStabilizers;                      // 35
      bool runBreakouts;                        // 36
      bool runWhiplash;                         // 37
      bool runPrimers;                          // 38

      int gmtOffset;                            // 39
      double usePoint;                          // 40
      int rateDecimalNumbersToShow;             // 41
      bool isAccountMaster;                     // 42
      bool isSymbolMaster;                      // 43

      int screenshotTimer;                      // 44
      int maxWeight;                            // 45

      string dataFolder;                        // 46
      double accountPercentage;                 // 47
      double ask;                               // 48
      double bid;                               // 49
      double balance;                           // 50
      double equity;                            // 51
      
		bool Serialize(string &buffer[], int &currentPosition)
		{
			buffer[++currentPosition] = IntegerToString(accountNumber);                         // 1
			buffer[++currentPosition] = accountName;                                            // 2
         buffer[++currentPosition] = symbol;                                                 // 3
         buffer[++currentPosition] = DoubleToString(tradingLotSize, 2);                      // 4
         buffer[++currentPosition] = DoubleToString(extremeTopRate, 4);                      // 5
         buffer[++currentPosition] = DoubleToString(normalTopRate, 4);                       // 6
         buffer[++currentPosition] = DoubleToString(centerRate, 4);                          // 7
         buffer[++currentPosition] = DoubleToString(normalBottomRate, 4);                    // 8
         buffer[++currentPosition] = DoubleToString(extremeBottomRate, 4);                   // 9
         buffer[++currentPosition] = IntegerToString(maxPlacementDistance);                  // 10
         buffer[++currentPosition] = DoubleToString(testUpToRate, 4);                        // 11
         buffer[++currentPosition] = DoubleToString(testDownToRate, 4);                      // 12
         buffer[++currentPosition] = IntegerToString(testPipsUp);                            // 13
         buffer[++currentPosition] = IntegerToString(testPipsDown);                          // 14
         buffer[++currentPosition] = IntegerToString(balancerMinPlacementDistanceLongs);     // 15
         buffer[++currentPosition] = IntegerToString(balancerMinPlacementDistanceShorts);    // 16
         buffer[++currentPosition] = IntegerToString(longStabilizerSizeFactor);              // 17
         buffer[++currentPosition] = IntegerToString(shortStabilizerSizeFactor);             // 18
         buffer[++currentPosition] = IntegerToString(longBalancerSizeFactor);                // 19
         buffer[++currentPosition] = IntegerToString(shortBalancerSizeFactor);               // 20
         buffer[++currentPosition] = IntegerToString(primerSizeFactor);                      // 21
         buffer[++currentPosition] = IntegerToString(balancerStopLossPips);                  // 22
         buffer[++currentPosition] = IntegerToString(securePips);                            // 23
         buffer[++currentPosition] = IntegerToString(autoLotIncrease);                       // 24
         buffer[++currentPosition] = IntegerToString(autoLotSafeEQLevel);                    // 25
         buffer[++currentPosition] = IntegerToString(takeProfit);                            // 26
         buffer[++currentPosition] = IntegerToString(tradeMidTerm);                          // 27
         buffer[++currentPosition] = IntegerToString(fixedSpread);                           // 28
         buffer[++currentPosition] = IntegerToString(extraLongBuffer);                       // 29
         buffer[++currentPosition] = IntegerToString(extraShortBuffer);                      // 30
         buffer[++currentPosition] = IntegerToString(warningLevel);                          // 31
         buffer[++currentPosition] = IntegerToString(heartbeatMonitorTimer);                 // 32
         buffer[++currentPosition] = IntegerToString(snapshotLogTimer);                      // 33
         buffer[++currentPosition] = IntegerToString(autoCloseExtremes);                     // 34
         buffer[++currentPosition] = IntegerToString(runBalancers);                          // 35
         buffer[++currentPosition] = IntegerToString(runStabilizers);                        // 36
         buffer[++currentPosition] = IntegerToString(runBreakouts);                          // 37
         buffer[++currentPosition] = IntegerToString(runWhiplash);                           // 38
         buffer[++currentPosition] = IntegerToString(runPrimers);                            // 39
         buffer[++currentPosition] = IntegerToString(gmtOffset);                             // 40
         buffer[++currentPosition] = DoubleToString(usePoint, 5);                            // 41
         buffer[++currentPosition] = IntegerToString(rateDecimalNumbersToShow);              // 42
         buffer[++currentPosition] = IntegerToString(isAccountMaster);                       // 43
         buffer[++currentPosition] = IntegerToString(isSymbolMaster);                        // 44
         buffer[++currentPosition] = IntegerToString(screenshotTimer);                       // 45
         buffer[++currentPosition] = IntegerToString(maxWeight);                             // 46
         buffer[++currentPosition] = dataFolder;                                             // 47
         buffer[++currentPosition] = DoubleToString(accountPercentage, 2);                   // 48
         buffer[++currentPosition] = DoubleToString(ask, 4);                                 // 49
         buffer[++currentPosition] = DoubleToString(bid, 4);                                 // 50
         buffer[++currentPosition] = DoubleToString(balance, 2);                             // 51
         buffer[++currentPosition] = DoubleToString(equity, 2);                              // 52



			return true;
		}

		bool Deserialize(string &buffer[], int &currentPosition)
		{
		/*
			accountNumber = StringToInteger(buffer[++currentPosition]);                         // 01
			accountName = buffer[++currentPosition];                                            // 02
			symbol = buffer[++currentPosition];                                                 // 03
			tradingLotSize = StringToDouble(buffer[++currentPosition]);                         // 04
			extremeTopRate = StringToDouble(buffer[++currentPosition]);                         // 05
			normalTopRate = StringToDouble(buffer[++currentPosition]);                          // 06
			centerRate = StringToDouble(buffer[++currentPosition]);                             // 07
			normalBottomRate = StringToDouble(buffer[++currentPosition]);                       // 08
			extremeBottomRate = StringToDouble(buffer[++currentPosition]);                      // 09
			maxPlacementDistance = StringToInteger(buffer[++currentPosition]);                  // 10
			testUpToRate = StringToDouble(buffer[++currentPosition]);                           // 11
			testDownToRate = StringToDouble(buffer[++currentPosition]);                         // 12
			testPipsUp = StringToInteger(buffer[++currentPosition]);                            // 13
			testPipsDown = StringToInteger(buffer[++currentPosition]);                          // 14
			balancerMinPlacementDistanceLongs = StringToInteger(buffer[++currentPosition]);     // 15
			balancerMinPlacementDistanceShorts = StringToInteger(buffer[++currentPosition]);    // 16
			longStabilizerSizeFactor = StringToInteger(buffer[++currentPosition]);              // 17
			shortStabilizerSizeFactor = StringToInteger(buffer[++currentPosition]);             // 18
			longBalancerSizeFactor = StringToInteger(buffer[++currentPosition]);                // 19
			shortBalancerSizeFactor = StringToInteger(buffer[++currentPosition]);               // 20
			primerSizeFactor = StringToInteger(buffer[++currentPosition]);                      // 21
			balancerStopLossPips = StringToInteger(buffer[++currentPosition]);                  // 22
			securePips = StringToInteger(buffer[++currentPosition]);                            // 23
			autoLotIncrease = StringToInteger(buffer[++currentPosition]);                       // 24
			autoLotSafeEQLevel = StringToInteger(buffer[++currentPosition]);                    // 25
			takeProfit = StringToInteger(buffer[++currentPosition]);                            // 26
			tradeMidTerm = StringToInteger(buffer[++currentPosition]);                          // 27
			fixedSpread = StringToInteger(buffer[++currentPosition]);                           // 28
			extraLongBuffer = StringToInteger(buffer[++currentPosition]);                       // 29
			extraShortBuffer = StringToInteger(buffer[++currentPosition]);                      // 30
			warningLevel = StringToInteger(buffer[++currentPosition]);                          // 31
			heartbeatMonitorTimer = StringToInteger(buffer[++currentPosition]);                 // 32
			snapshotLogTimer = StringToInteger(buffer[++currentPosition]);                      // 33
			autoCloseExtremes = StringToInteger(buffer[++currentPosition]);                     // 34
			runBalancers = StringToInteger(buffer[++currentPosition]);                          // 35
			runStabilizers = StringToInteger(buffer[++currentPosition]);                        // 36
			runBreakouts = StringToInteger(buffer[++currentPosition]);                          // 37
			runWhiplash = StringToInteger(buffer[++currentPosition]);                           // 38
			runPrimers = StringToInteger(buffer[++currentPosition]);                            // 39
			gmtOffset = StringToInteger(buffer[++currentPosition]);                             // 40
			usePoint = StringToDouble(buffer[++currentPosition]);                               // 41
			rateDecimalNumbersToShow = StringToInteger(buffer[++currentPosition]);              // 42
			isAccountMaster = StringToInteger(buffer[++currentPosition]);                       // 43
			isSymbolMaster = StringToInteger(buffer[++currentPosition]);                        // 44
			screenshotTimer = StringToInteger(buffer[++currentPosition]);                       // 45
			maxWeight = StringToInteger(buffer[++currentPosition]);                             // 46
			dataFolder = buffer[++currentPosition];                                             // 47
			accountPercentage = StringToDouble(buffer[++currentPosition]);                      // 48
			*/
			return true;
		}

		int Length()
		{
			return 52;
		}
		
		
		void Dump()
		{
			PrintFormat("HourglassAccountRegistrationDTO with AccountNumber{Id:%d} and AccountName{Id:%d} was created", accountNumber, accountName);
		}
};

class HourglassAccountRegistrationResultDTO: public IZmqSerializable
{
	public:
		int accountId;
		int strategyId;
		int accountNumber;
		string accountName;
		string brokerName;
		string symbol;
		double stepGrowthFactor; 
		double startingBalance;  
		int startFactor;
		double commission;
		bool isLive;
		string accountCurrency;
		int registeredTime;
		int lastOrderClose;

		bool Serialize(string &buffer[], int &currentPosition)
		{
			buffer[++currentPosition] = IntegerToString(accountId);
			buffer[++currentPosition] = IntegerToString(strategyId);
         buffer[++currentPosition] = IntegerToString(accountNumber);
         buffer[++currentPosition] = accountName;
         buffer[++currentPosition] = brokerName;
	      buffer[++currentPosition] = symbol;
			buffer[++currentPosition] = DoubleToString(stepGrowthFactor);
			buffer[++currentPosition] = DoubleToString(startingBalance);
			buffer[++currentPosition] = IntegerToString(startFactor);
			buffer[++currentPosition] = DoubleToString(commission);
			buffer[++currentPosition] = IntegerToString(isLive);
         buffer[++currentPosition] = accountCurrency;
         buffer[++currentPosition] = IntegerToString(registeredTime);
			buffer[++currentPosition] = IntegerToString(lastOrderClose);
			return true;
		}

		bool Deserialize(string &buffer[], int &currentPosition)
		{
			accountId = StringToInteger(buffer[++currentPosition]);
			strategyId = StringToInteger(buffer[++currentPosition]);
			accountNumber = StringToInteger(buffer[++currentPosition]);
			accountName = buffer[++currentPosition];
			brokerName = buffer[++currentPosition];
			symbol = buffer[++currentPosition];
			stepGrowthFactor = StringToDouble(buffer[++currentPosition]);
			startingBalance = StringToDouble(buffer[++currentPosition]);
			startFactor = StringToInteger(buffer[++currentPosition]);
			commission = StringToDouble(buffer[++currentPosition]);
			isLive = StringToInteger(buffer[++currentPosition]);
			accountCurrency = buffer[++currentPosition];
			registeredTime = StringToInteger(buffer[++currentPosition]);
			lastOrderClose = StringToInteger(buffer[++currentPosition]);
			return true;
		}

		int Length()
		{
			return 14;
		}
};

class OrderDTO : public IZmqSerializable
{
	public:
		int ticket;                // 1 IntegerToString(OrderTicket())
		int orderType;             // 2 IntegerToString(OrderType())
		double lots;               // 3 DoubleToString(OrderLots(), 2)
		int openTime;              // 4 IntegerToString(OrderOpenTime()) 
		int closeTime;             // 5 IntegerToString(OrderCloseTime())
		string symbol;             // 6 Symbol() 
		double openRate;           // 7 DoubleToString(OrderOpenPrice(), rateDecimalNumbersToShow)
		double closeRate;          // 8 DoubleToString(OrderClosePrice(), rateDecimalNumbersToShow)
		double stopLossRate;       // 9 DoubleToString(OrderStopLoss(), rateDecimalNumbersToShow)
		double takeProfitRate;     // 10 DoubleToString(OrderTakeProfit(), rateDecimalNumbersToShow)
		double swap;               // 11 DoubleToString(OrderSwap(), 2)
		double commission;         // 12 DoubleToString(OrderCommission(), 2)
		double profit;             // 13 DoubleToString(OrderProfit(), 2) 
		string comment;            // 14 OrderComment()  
		int accountId;             // 15 IntegerToString(accountId)

		//#region constructors
		
		OrderDTO(const OrderDTO &that): 
			ticket(that.ticket),                   // 1
			orderType(that.orderType),             // 2
			lots(that.lots),                       // 3
			openTime(that.openTime),               // 4
			closeTime(that.closeTime),             // 5
			symbol(that.symbol),                   // 6
			openRate(that.openRate),               // 7
			closeRate(that.closeRate),             // 8
			stopLossRate(that.stopLossRate),       // 9
			takeProfitRate(that.takeProfitRate),   // 10
			swap(that.swap),                       // 11
			commission(that.commission),           // 12
			profit(that.profit),                   // 13
			comment(that.comment),                 // 14
			accountId(that.accountId)              // 15
		{
		   //Print("OrderDTO constructor hit");
		}

		//this is additional for use in loop with OrderSelect to populate DTO
		OrderDTO(bool fromMQL = false, int Id = 0)
		{
			if(fromMQL)
			{
				//based on RegisterOpenOrder
				//Print("Ticket: "+ IntegerToString(OrderTicket()) + ", OrderType: " + IntegerToString(OrderType())  + ", Comment: " + OrderComment());
				ticket = OrderTicket();
				orderType = OrderType();
				lots = OrderLots();
				openTime = OrderOpenTime();
				closeTime = OrderCloseTime();
				symbol = OrderSymbol();
				openRate = OrderOpenPrice();
				
				// For open orders, OrderClosePrice returns Ask, so need to check if order is actually closed
				if(OrderCloseTime() > 0)
				{
				   closeRate = OrderClosePrice();
				}
				else
				{
				closeRate = 0;
				}
				
				stopLossRate = OrderStopLoss();
				takeProfitRate = OrderTakeProfit();
				swap = OrderSwap();
				commission = OrderCommission();
				profit = OrderProfit();
				comment = OrderComment();
				accountId = Id;
			}
			 //Print("OrderSelect loop function hit");
		}
		//#endregion constructors

		void Dump()
		{
			PrintFormat("Ticket{Id:%d}", ticket);
		}

		void MockThis(int j)
		{
		   PrintFormat("Running MockThis(%d)", j);
			ticket = 123456;
			orderType = 1;
			lots = 0.01;
			openTime = 321654;
			closeTime = 0;
			symbol = "USDCAD";
			openRate = 1.3501;
			closeRate = 1.3550;
			stopLossRate = 0;
			takeProfitRate = 1.3550;
			swap = 0.37;
			commission = 0.5 + j * 0.1;
			profit = ticket * 2.34;
			comment = StringConcatenate("Mocked #", j);
			accountId = 99;
		}

		//interface implementation
		bool Serialize(string& buffer[], int& currentPosition)
		{
			//optional: we could add check that buffer is enough or even dynamically resize buffer
			//order must be the same as in C# version
			buffer[++currentPosition] = IntegerToString(ticket);
			buffer[++currentPosition] = IntegerToString(orderType);
			buffer[++currentPosition] = DoubleToString(lots);
			buffer[++currentPosition] = IntegerToString(openTime); 
			buffer[++currentPosition] = IntegerToString(closeTime); 
			buffer[++currentPosition] = symbol; 
			buffer[++currentPosition] = DoubleToString(openRate); 
			buffer[++currentPosition] = DoubleToString(closeRate); 
			buffer[++currentPosition] = DoubleToString(stopLossRate);
			buffer[++currentPosition] = DoubleToString(takeProfitRate);
			buffer[++currentPosition] = DoubleToString(swap);
			buffer[++currentPosition] = DoubleToString(commission); 
			buffer[++currentPosition] = DoubleToString(profit); 
			buffer[++currentPosition] = comment;  
			buffer[++currentPosition] = IntegerToString(accountId);
			return true;
		}

		bool Deserialize(string& buffer[], int& currentPosition)
		{
			ticket = StringToInteger(buffer[++currentPosition]);
			orderType = StringToInteger(buffer[++currentPosition]);
			lots = StringToDouble(buffer[++currentPosition]);
			openTime = StringToInteger(buffer[++currentPosition]); 
			closeTime = StringToInteger(buffer[++currentPosition]);
			symbol = buffer[++currentPosition]; 
			openRate = StringToDouble(buffer[++currentPosition]); 
			closeRate = StringToDouble(buffer[++currentPosition]); 
			stopLossRate = StringToDouble(buffer[++currentPosition]);
			takeProfitRate = StringToDouble(buffer[++currentPosition]);
			swap = StringToDouble(buffer[++currentPosition]);
			commission = StringToDouble(buffer[++currentPosition]); 
			profit = StringToDouble(buffer[++currentPosition]); 
			comment = buffer[++currentPosition];  
			accountId = StringToInteger(buffer[++currentPosition]);
			return true;
		}

		//returns number of serialized fields - used for reducing array resized - buffer array size can be computed
		int Length()
		{
			return 15;
		}
};


class ChangeOrderDTO : public IZmqSerializable
{
	public:
		int ticket;             // 1
		int orderType;          // 2
		double lots;            // 3
		double openRate;        // 4
		double stopLossRate;    // 5
		double takeProfitRate;  // 6
		int function;           // 7 None = 0, RegularLong = 1, RegularShort = 2, BalancerLong = 3, BalancerShort = 4, BreakoutLong = 5, BreakoutShort = 6  
		int action;             // 8 None = 0, Add = 1, Modify = 2, Close = 3
      string comment;         // 9

		void Dump()
		{
			PrintFormat("OrderChange{ticket:%d, function:%d, action:%d}", ticket, function, action);
		}

		//interface implementation
		bool Serialize(string& buffer[], int& currentPosition)
		{
			//optional: we could add check that buffer is enough or even dynamically resize buffer
			//order must be the same as in C# version
			buffer[++currentPosition] = IntegerToString(ticket);
			buffer[++currentPosition] = IntegerToString(orderType);
			buffer[++currentPosition] = DoubleToString(lots);
			buffer[++currentPosition] = DoubleToString(openRate); 
			buffer[++currentPosition] = DoubleToString(stopLossRate);
			buffer[++currentPosition] = DoubleToString(takeProfitRate);
			buffer[++currentPosition] = IntegerToString(function);
			buffer[++currentPosition] = IntegerToString(action);
			buffer[++currentPosition] = comment;
			return true;
		}

		bool Deserialize(string& buffer[], int& currentPosition)
		{
			ticket = StringToInteger(buffer[++currentPosition]);
			orderType = StringToInteger(buffer[++currentPosition]);
			lots = StringToDouble(buffer[++currentPosition]);
			openRate = StringToDouble(buffer[++currentPosition]); 
			stopLossRate = StringToDouble(buffer[++currentPosition]);
			takeProfitRate = StringToDouble(buffer[++currentPosition]);
			function = StringToInteger(buffer[++currentPosition]);
			action = StringToInteger(buffer[++currentPosition]);
			comment = buffer[++currentPosition];
			return true;
		}

		//returns number of serialized fields - used for reducing array resized - buffer array size can be computed
		int Length()
		{
			return 9;
		}
};

class HourglassAccountOverviewDTO: public IZmqSerializable
{
	public:
	   int AccountId;             // 1
		double Longs;              // 2 Count of all types of longs (lots)
		double Shorts;             // 3
      double LongBalancers;      // 4 Count of non-regular longs only (lots)
      double ShortBalancers;     // 5
		int CurrentStep;           // 6
		double NextLot;            // 7
		double NextLotIncrease;    // 8
		int NextCountdown;         // 9
		int OrderCount;            // 10
		
		// Upwards
		double UpRate;             // 11
		double UpEquity;           // 12
		double UpBalance;          // 13
		double UpLongs;            // 14
		double UpShorts;           // 15
		
		// Top
		double TopRate;            // 16
		double TopEquity;          // 17
		double TopBalance;         // 18
		double TopLongs;           // 19
		double TopShorts;          // 20
		
      // Center
		double CenterRate;         // 21
		double CenterEquity;       // 22
		double CenterBalance;      // 23
		double CenterLongs;        // 24
		double CenterShorts;       // 25

		// Downwards
		double DownRate;           // 26
		double DownEquity;         // 27
		double DownBalance;        // 28
		double DownLongs;          // 29
		double DownShorts;         // 30

		// Bottom
		double BottomRate;         // 31
		double BottomEquity;       // 32
		double BottomBalance;      // 33
		double BottomLongs;        // 34
		double BottomShorts;       // 35


		bool Serialize(string &buffer[], int &currentPosition)
		{
		/*
			buffer[++currentPosition] = DoubleToString(Longs);             // 1
			buffer[++currentPosition] = DoubleToString(Shorts);            // 2
			buffer[++currentPosition] = DoubleToString(LongBalancers);     // 3
			buffer[++currentPosition] = DoubleToString(ShortBalancers);    // 4 
			buffer[++currentPosition] = IntegerToString(CurrentStep);      // 5
			buffer[++currentPosition] = DoubleToString(NextLot);           // 6 
			buffer[++currentPosition] = DoubleToString(NextLotIncrease);   // 7
			buffer[++currentPosition] = IntegerToString(NextCountdown);       // 8
			// Upwards
			buffer[++currentPosition] = DoubleToString(UpRate);            // 9
			buffer[++currentPosition] = DoubleToString(UpEquity);          // 10
			buffer[++currentPosition] = DoubleToString(UpBalance);         // 11
			buffer[++currentPosition] = DoubleToString(UpLongs);           // 12
			buffer[++currentPosition] = DoubleToString(UpShorts);          // 13
			// Upwards
			buffer[++currentPosition] = DoubleToString(TopRate);           // 14
			buffer[++currentPosition] = DoubleToString(TopEquity);         // 15
			buffer[++currentPosition] = DoubleToString(TopBalance);        // 16
			buffer[++currentPosition] = DoubleToString(TopLongs);          // 17
			buffer[++currentPosition] = DoubleToString(TopShorts);         // 18
			// Upwards
			buffer[++currentPosition] = DoubleToString(CenterRate);        // 19
			buffer[++currentPosition] = DoubleToString(CenterEquity);      // 20
			buffer[++currentPosition] = DoubleToString(CenterBalance);     // 21
			buffer[++currentPosition] = DoubleToString(CenterLongs);       // 22
			buffer[++currentPosition] = DoubleToString(CenterShorts);      // 23
			// Downwards
			buffer[++currentPosition] = DoubleToString(DownRate);          // 24
			buffer[++currentPosition] = DoubleToString(DownEquity);        // 25
			buffer[++currentPosition] = DoubleToString(DownBalance);       // 26
			buffer[++currentPosition] = DoubleToString(DownLongs);         // 27
			buffer[++currentPosition] = DoubleToString(DownShorts);        // 28
			// Bottom
			buffer[++currentPosition] = DoubleToString(BottomRate);        // 29
			buffer[++currentPosition] = DoubleToString(BottomEquity);      // 30
			buffer[++currentPosition] = DoubleToString(BottomBalance);     // 31
			buffer[++currentPosition] = DoubleToString(BottomLongs);       // 32
			buffer[++currentPosition] = DoubleToString(BottomShorts);      // 33
			*/
			return true;
		}

		bool Deserialize(string &buffer[], int &currentPosition)
		{
		   AccountId = StringToInteger(buffer[++currentPosition]);        // 1
			Longs = StringToDouble(buffer[++currentPosition]);             // 2
			Shorts = StringToDouble(buffer[++currentPosition]);            // 3
			LongBalancers = StringToDouble(buffer[++currentPosition]);     // 4
			ShortBalancers = StringToDouble(buffer[++currentPosition]);    // 5
			CurrentStep = StringToInteger(buffer[++currentPosition]);      // 6
			NextLot = StringToDouble(buffer[++currentPosition]);           // 7
			NextLotIncrease = StringToDouble(buffer[++currentPosition]);   // 8
			NextCountdown = StringToInteger(buffer[++currentPosition]);    // 9
         OrderCount = StringToInteger(buffer[++currentPosition]);       // 10
			
			// Upwards
			UpRate = StringToDouble(buffer[++currentPosition]);            // 11
			UpEquity = StringToDouble(buffer[++currentPosition]);          // 12
			UpBalance = StringToDouble(buffer[++currentPosition]);         // 13
			UpLongs = StringToDouble(buffer[++currentPosition]);           // 14
			UpShorts = StringToDouble(buffer[++currentPosition]);          // 15
			
			// Top
			TopRate = StringToDouble(buffer[++currentPosition]);           // 16
			TopEquity = StringToDouble(buffer[++currentPosition]);         // 17
			TopBalance = StringToDouble(buffer[++currentPosition]);        // 18
			TopLongs = StringToDouble(buffer[++currentPosition]);          // 19
			TopShorts = StringToDouble(buffer[++currentPosition]);         // 20
			// Center
			CenterRate = StringToDouble(buffer[++currentPosition]);        // 21
			CenterEquity = StringToDouble(buffer[++currentPosition]);      // 22
			CenterBalance = StringToDouble(buffer[++currentPosition]);     // 23
			CenterLongs = StringToDouble(buffer[++currentPosition]);       // 24
			CenterShorts = StringToDouble(buffer[++currentPosition]);      // 25
			// Down
			DownRate = StringToDouble(buffer[++currentPosition]);          // 26
			DownEquity = StringToDouble(buffer[++currentPosition]);        // 27
			DownBalance = StringToDouble(buffer[++currentPosition]);       // 28
			DownLongs = StringToDouble(buffer[++currentPosition]);         // 29
			DownShorts = StringToDouble(buffer[++currentPosition]);        // 30
			// Bottom
			BottomRate = StringToDouble(buffer[++currentPosition]);        // 31
			BottomEquity = StringToDouble(buffer[++currentPosition]);      // 32
			BottomBalance = StringToDouble(buffer[++currentPosition]);     // 33
			BottomLongs = StringToDouble(buffer[++currentPosition]);       // 34
			BottomShorts = StringToDouble(buffer[++currentPosition]);      // 35
			
			return true;
		}

		int Length()
		{
			return 35;
		}
};