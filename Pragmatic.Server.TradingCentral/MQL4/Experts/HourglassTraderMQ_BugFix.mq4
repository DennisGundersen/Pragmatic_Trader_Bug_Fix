//+------------------------------------------------------------------+
//|                                           HourglassTrader_v1.mq4 |
//|                                              Dennis Gundersen AS |
//|                                  https://www.dennisgundersen.com |
//+------------------------------------------------------------------+
#property copyright "Dennis Gundersen AS"
#property link      "https://www.dennisgundersen.com"
#property version   "1.01"
//uncomment to Print Debug information related to ZeroMQ communication
//#define DBG_ZMQ
//for debugging multiframe receive
//#define DBG_ZMQ_RCV
#define   WIDTH  1920     // Image width to call ChartScreenShot() 
#define   HEIGHT 1080      // Image height to call ChartScreenShot() 

#include <stdlib.mqh>
#include <Tools.mqh>
#include <CommunicationBase.mqh>
#include <DTOs.mqh>

//Address of the server
extern string ConnectionPort = "9999";
string   server="tcp://127.0.0.1:";
//Those give advanced options over socket - could be also not input
int      connectTimeout=1000; 
int      receiveTimeout=3000;
int      sendTimeout=4000; 
int      reconnectInterval=2000;
int      reconnectIntervalMax=30000; 


extern string  TradingVariables = "------------------------------------------";
extern bool    IsTrader = false;                    
extern double  TradingLotSize = 0.01;              
extern bool    TradeMidTerm = false;               

extern string  StatisticsVariables = "------------------------------------------";
extern double  TestUpToRate = 0.0000;              
extern double  TestDownToRate = 0.0000;            
extern int     TestPipsUp = 300;                   
extern int     TestPipsDown = 300;                 
extern int     CrashPips = 400;                    
extern bool    RunStats = true;                    
int            LoginBufferTimer = 10;              
int            rateDecimalNumbersToShow = 4;		   

extern string  StrategyVariables = "------------------------------------------";
extern int	   LongStabilizerSizeFactor = 0;       
extern int	   ShortStabilizerSizeFactor = 0;      
extern int     LongBalancerSizeFactor = 0;        
extern int     ShortBalancerSizeFactor = 0;       
extern int     PrimerSizeFactor = 3;			   
extern int		BalancerMinPlacementDistanceLongs = 100;
extern int		BalancerMinPlacementDistanceShorts = 100;
extern int     BalancerStopLossPips = 100;         
extern int     SecurePips = 0;                    
extern bool    RunBalancers = false;              
extern bool    RunStabilizers = false;             
extern bool    RunBreakouts = false;              
extern bool    RunPrimers = true;                 
extern bool    AutoCloseExtremes = false;          
extern bool    RunWhiplash = false;                 

extern string  SystemVariables = "------------------------------------------";
extern string  NameOfAccount = "DEV";          
extern bool	   IsAccountMaster = true;			   
extern bool    IsSymbolMaster = true;       
extern double  AccountPercentage = 1.00;    
extern int     HeartbeatMonitorTimer = 5;   
extern int     SnapshotLogTimer = 5;        
extern int     UpdateHistoryTimer = 5;            
extern int     WarningLevel = 100;           
extern int     ScreenshotTimer = 5;         
extern double  ExtremeTopRate = 1.5000;     
extern double  NormalTopRate = 1.4000;      
extern double  CenterRate = 1.3000;				  
extern double  NormalBottomRate = 1.2000;
extern double  ExtremeBottomRate = 1.1000;
extern int     MaxPlacementDistance = 300;
extern int     MaxWeight = 20;				   
extern int     TakeProfit = 99;      
extern int     FixedSpread = 1;      
int     ExtraLongBuffer = 1;  
int     ExtraShortBuffer = 1; 
double  Commission = 0.00;    
bool           AutoLotIncrease = false;			  	
int            AutoLotSafeEQLevel = 40;				  
extern int     GMTOffset = 2;

int            magicNumberRegulars = 1;            // MagicNumber Regulars
int            magicNumberBalancers = 2;           // MagicNumber Balancers

double         usePoint;                           // Digit calculation for current account (2/4 or 3/5 decimals)
static int     timeUpdated = 0;                    // Timer for last run of update checks
static int     timeRegistered = 0;                 // Timer for last attempt to register account
static int     timeScreenshot = 0;                 // Timer for last screenshot
static int     timeStatistics = 0;                 // Timer for last UI update
static int     timeHistory = 0;                    // Timer for last history check

//string         brokerName = "";

// Fonts and placement of stats
extern string  LayoutVariables = "------------------------------------------";
extern color   ActiveColor = Navy;
extern color   NormalColor = Black;
extern color   UpwardsColor = Green;
extern color   DownwardsColor = Red;
extern color   CenterColor = Magenta;
extern color	GridColor = Green;
extern int		GridLevelsAside = 10;
extern bool		HideGridLabels = true;
extern string  GoodSound;  
extern string  BadSound;   

extern int     SmallFontSize = 8;
extern int     NormalFontSize = 9;
extern int     LargeFontSize = 10;
extern int     RateFontSize = 12;
extern string  FontName = "Arial";

extern double  Line_1_Vertical = 0.00;
extern double  Line_2_Vertical = 20.00;
extern double  Line_3_Vertical = 40.00;
extern double  Line_4_Vertical = 60.00;
extern double  Line_5_Vertical = 80.00;
extern double  Line_6_Vertical = 100.00;
extern double  Line_7_Vertical = 120.00;

extern int     Grid_1_Horizontal = 10;
extern int     Grid_2_Horizontal = 150;
extern int     Grid_3_Horizontal = 350;
extern int     Grid_4_Horizontal = 650;
extern int     Grid_5_Horizontal = 950;
extern int     Grid_6_Horizontal = 1070;
extern int     Grid_7_Horizontal = 1200;

//int            lastOrderClose = -1;
bool           registrationError = false;
double         currentSpread = 0;
double         maxSpread = 0;
bool           isAccountRegistered = false;

double			top = 0;
double			bottom = 0;
double			gridSize = 0;
double			gridTopRefreshRate = 0;
double			gridBottomRefreshRate = 0;
double         oldAccountbalance;
double         gridTopRate = 0;
double         gridBottomRate = 0;
double         volatilityUpRate = 0;
double         volatilityDownRate = 0;

static HourglassAccountOverviewDTO stats;
static HourglassAccountRegistrationResultDTO account;

int OnInit()
{
   server = server + ConnectionPort;
   
   usePoint = PipPoint(Symbol());
   DeleteAllLabels();
   timeRegistered = 0;
   oldAccountbalance = AccountBalance();
   gridSize = TakeProfit + FixedSpread;
   DeleteAllGridLines();
   CreateGridLines();   
   CreateAllLabels();   
   SetGridPoints();
   timeUpdated = TimeCurrent();                    // Timer for last run of update checks
   timeScreenshot = TimeCurrent();                 // Timer for last screenshot
   timeStatistics = 0;                             // Timer for last UI update
   timeHistory = TimeCurrent();                    // Timer for last history check

   if(ConnectToTradingCentral())
   {
         isAccountRegistered = RegisterHourglassAccountOnServer();
         return(INIT_SUCCEEDED);
   }
   else
   {
      Print("Communication problem: " + CommLastError);
   }
   return INIT_FAILED;
}


void OnDeinit(const int reason)
{
   DeleteAllLabels();
   DeleteAllTradingLines();
   DeleteAllGridLines();  
}

void OnTick()
{
   if(isAccountRegistered && account.accountId > 0)
   {
      RunTrader();
      //UpdateStatistics();
      //SoundFeedback();
      if(IsTrader)
      {
         //UpdateHistory();
         //SaveChart();
      }
   }
   else // If not registered, retry login every 10 seconds
   {
      if(TimeCurrent() >= timeUpdated + LoginBufferTimer)
      {
         isAccountRegistered = RegisterHourglassAccountOnServer();
      }
   }
}



// Collect all account and trading variables, check account in dbs, and register last closed order
bool RegisterHourglassAccountOnServer()
{
   HourglassAccountRegistrationDTO registrationDTO;      // Instantiation of outgoing variables as class
	FillHourglassAccountRegistrationDTO(registrationDTO); // Collect data and fill in all the variables
	HourglassAccountRegistrationResultDTO resultDTO;      // Instantiation of incoming result as class

	const string commandName = "RegisterHourglassAccount";
	string payload[];    //send buffer
	string response[];   //response buffer
	
	//compute size 
	int bufferSize = 1 + registrationDTO.Length(); //command name
	if(ArrayResize(payload, bufferSize) == bufferSize)
	{
		int i = -1; //last element of buffer
		payload[++i] = commandName;
		registrationDTO.Serialize(payload, i); //serialize the HourglassAccountRegistrationDTO class into the buffer
		
		// Send the payload to the TradingCentral
		bool r = CommSendCommand(response, payload);
		if(r)
		{
			//CommShowResponse(commandName, response); //this is for debugging only - dump received buffer
			if(response[0] == "OK")
			{
				int respSize = ArraySize(response);
				int expSize = 1 + resultDTO.Length();
				
				if(respSize != expSize)
				{
					PrintFormat("%s Error: Expected %d, but received %d", commandName, expSize, respSize);
					return false;
				}
				
				//region Deserialization - convert received strings into right types
				i = 0; //will start after status in response[0]
				//PrintFormat("Response object successfully received from TradingCentral. Trying to deserialize...");
				resultDTO.Deserialize(response, i);

				// Register the variables incoming for the account from dbs into the static HourglassAccountRegistrationResultDTO object for reuse anywhere
				if(resultDTO.accountId > 0)
			   {
				   account.accountId = resultDTO.accountId;
				   account.lastOrderClose = resultDTO.lastOrderClose;
               PrintFormat("Trader successfully registered AccountId %s with server. Last order close at %s.", 
                     IntegerToString(account.accountId), 
                     TimeToString(IntToDateTime(account.lastOrderClose), TIME_DATE|TIME_MINUTES|TIME_SECONDS));
				   account.startFactor = resultDTO.startFactor;
				   account.startingBalance = resultDTO.startingBalance;
				   account.stepGrowthFactor = resultDTO.stepGrowthFactor;
				   return true;
				}
				else
				{
				   PrintFormat("Account registration not accepted by server");
				   return false;   
				}
			}
			else
			{
				PrintFormat("%s Error: `%s`", commandName, response[1]);
			}
		}
		else
		{
			PrintFormat("%s no response - error: `%s`", commandName, CommGetLastError());
		}
	}
	else
	{
		PrintFormat("%s - problem during creating buffer string[%d]", commandName, bufferSize);
	}
	return false;
}


// Sends all market and pending orders to DLL, receives the list of change orders and triggers the changes
int RunTrader()
{
	OrderDTO orders[];
	ChangeOrderDTO changeOrders[];

	int maxOrderCount = OrdersTotal();
   //Print("There are " + IntegerToString(maxOrderCount) + " orders total.");
   // Resize order[] to fit all orders	(market and pending only), see OrdersHistoryTotal() for closed orders
	if(maxOrderCount == ArrayResize(orders, maxOrderCount))
	{
		int j = 0;

		for(int order = OrdersTotal() - 1; order >= 0; order--)
		{
         if(OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol())
         {
            //Print("Found open order");
            orders[j++] = OrderDTO(true, account.accountId); //constructor has option to fill fields using Order*() methods, of course it has to be called after OrderSelect
         }
		}
   
     // PrintFormat("Calling RegisterHourglassTradesOnServer(changeOrders, orders, ask, bid, balance, equity)");
		bool ok = RegisterHourglassTradesOnServer(changeOrders, orders, Ask, Bid, AccountBalance(), AccountEquity());
		if(ok)
		{
			//PrintFormat("RegisterHourglassTradesOnServer has returned result successfully.");
			int changeCount = ArraySize(changeOrders);
         //Print("");
         //Print("changeCount is " + IntegerToString(changeCount));
         //Print("");
         
         if(changeCount > 0 && IsTrader == true)
         {
            //Print("Inside trade placement loop");
            for(int a = 0; a < changeCount; a++)
            {
               int action = changeOrders[a].action;
               int function = changeOrders[a].function;
               
               if(action == 1) // Open a new order
               {
                  if(function == 1 || function == 3 || function == 5 || function == 7 || function == 9 || function == 11 || function == 13)
                  {       
                     //PrintFormat("Adding long order %s, as function %s", changeOrders[a].comment, IntegerToString(changeOrders[a].function));
                     OpenPending(true, changeOrders[a]);    // Long
                  }
                  else
                  {
                     //PrintFormat("Adding short order %s, as function %s", changeOrders[a].comment, IntegerToString(changeOrders[a].function));
                     OpenPending(false, changeOrders[a]);   // Short
                  }

               }
               else if(action == 2) // Modify an existing order
               {
                  ModifyOrder(changeOrders[a]);
               }
               else if(action == 3) // Delete a pending order
               {
                  DeletePendingOrder(changeOrders[a]);
               }
      			else if(action == 4) // Close an open order
               {
      				double closeRate = 0;
      				if(function == 0) // unknown function / manual
      				{
      					// TBD
      				}
      				else if(function == 1 || function == 3 || function == 5) //longs
      				{
      					closeRate = Bid;
      				}
      				else // shorts
      				{
      					closeRate =  Ask;
      				}
      
      				if(closeRate > 0)
      				{
      					CloseOpenOrder(changeOrders[a], closeRate);
      				}
               }
            }
         }
			
			return ArraySize(changeOrders);
		}
		PrintFormat("RegisterHourglassTradesOnServer error");
	} 
	else
	{
		PrintFormat("Couldn't initialize (resize) Orders array to take %d elements", maxOrderCount);
	}
	
	return -1;
}




bool RegisterHourglassTradesOnServer(ChangeOrderDTO& result[], OrderDTO& orders[], double ask, double bid, double balance, double equity)
{
	const string commandName = "RegisterHourglassTrades";
	string payload[]; //send buffer
	string response[]; //response buffer
	
	//compute size 
	int numberOfOrders = ArraySize(orders);
	int bufferSize = 1;  // add space for command name
	bufferSize += 1;     // add space for OrderCount
	
	if(numberOfOrders > 0) 
	{
		bufferSize += numberOfOrders * orders[0].Length(); // # OrderDTO x 15 variables
	}
	
	bufferSize += 4;     // add space for ask, bid, balance, equity
	if(ArrayResize(payload, bufferSize) == bufferSize)
	{
		int i = -1; //last element of buffer
		payload[++i] = commandName;
		payload[++i] = IntegerToString(numberOfOrders);    //serialize the count of elements of type OrderDTO in `orders` array
		
		for(int j = 0; j < numberOfOrders; ++j)
		{
			orders[j].Serialize(payload, i);                //serialize to buffer element #j of `orders` array
		}
		
		payload[++i] = DoubleToString(ask);
		payload[++i] = DoubleToString(bid);
		payload[++i] = DoubleToString(balance);
		payload[++i] = DoubleToString(equity);
		
		//PrintFormat("Now calling TradingCentral with payload and commandName: RegisterHourglassTrades");
		bool r = CommSendCommand(response, payload);
		if(r)
		{
			//CommShowResponse(commandName, response); //this is for debugging only - dump received buffer
			if(response[0] == "OK")
			{
			   //PrintFormat("Response successfully received from TradingCentral");
				int respSize = ArraySize(response);

				//region Deserialization - convert received strings into right types
				i = 0;
				int resultLength = StringToInteger(response[++i]);    //deserialize number of elements
				if(ArrayResize(result, resultLength) != resultLength)
				{
					PrintFormat("%s Error: Result array resize problem (new size %d)", commandName, resultLength);
					return false;
				}
				for(int j = 0; j < resultLength; ++j)
				{
					result[j].Deserialize(response, i);
				}
				return true;
			}
			else
			{
				PrintFormat("%s Error: `%s`", commandName, response[1]);
			}
		}
		else
		{
			PrintFormat("%s no response - error: `%s`", commandName, CommGetLastError());
		}
	}
	else
	{
		PrintFormat("%s - problem during creating buffer string[%d]", commandName, bufferSize);
	}
	return false;
}



// Send any closed orders to the server every "UpdateHistoryTimer" seconds
int UpdateHistory(){
   if((TimeCurrent() >= timeHistory + UpdateHistoryTimer))
   {
      // Loop through all history in order to count any orders newer then account.lastOrderClose
      int closedCount = 0;
      for(int order = OrdersHistoryTotal() - 1; order >= 0; order--)
      {
         if(OrderSelect(order, SELECT_BY_POS, MODE_HISTORY) == true)
         {
            // Check for Deposits (if this is the AccountMaster)
   			if(IsAccountMaster && (OrderType() == 6 || OrderType() == 7) && OrderCloseTime() > account.lastOrderClose)
   			{
   			   closedCount++;
   		   }
   		   // Checks for all other types of orders
   		   else if(IsSymbolMaster == true && OrderSymbol() == Symbol() && OrderType() < 2 && OrderCloseTime() > account.lastOrderClose)
   		   {
               closedCount++;   		   
            }
         }
      } 
      
      // If there is new history > account.lastCloseOrder, register it
      if (closedCount > 0)
      {
         //PrintFormat("Preparing to register latest history");
         OrderDTO history[];
	      ChangeOrderDTO changeOrders[];   // Reply from serv, but will be ignored
         
         // Resize history[] to fit all closed orders
	      if(closedCount == ArrayResize(history, closedCount))
	      {
            int newLastOrderClose = 0;
            int j = 0;   // counter for the history[]
            
            for(int h = OrdersHistoryTotal() - 1; h >= 0; h--)
            {
               if(OrderSelect(h, SELECT_BY_POS, MODE_HISTORY) == true)
               {
                  // Check for Deposits (if this is the AccountMaster)
         			if(IsAccountMaster && (OrderType() == 6 || OrderType() == 7) && OrderCloseTime() > account.lastOrderClose)
         			{
                     PrintFormat("UpdateHistory() found deposit/withdrawal with close %s > lastOrderClose to %s", 
                                 TimeToString(IntToDateTime(OrderCloseTime()), TIME_DATE|TIME_MINUTES||TIME_SECONDS), 
                                 TimeToString(IntToDateTime(account.lastOrderClose), TIME_DATE|TIME_MINUTES||TIME_SECONDS)
                     );

         			   // Add deposits to orders[]
         			   history[j++] = OrderDTO(true, account.accountId); //constructor has option to fill fields using Order*() methods, of course it has to be called after OrderSelect
         			   if(newLastOrderClose < OrderCloseTime()) 
         			   {
         			       //PrintFormat("newLastUpdateTime updated from %s to %s", TimeToString(IntToDateTime(newLastOrderClose)), TimeToString(OrderCloseTime()));
         			       newLastOrderClose = OrderCloseTime();
         			   }
         		   }
         		   // Checks for all other types of orders
         		   else if(IsSymbolMaster == true && OrderSymbol() == Symbol() && OrderType() < 2 && OrderCloseTime() > account.lastOrderClose)
         		   {
                     PrintFormat("UpdateHistory() found order with close %s > lastOrderClose to %s", 
                                 TimeToString(IntToDateTime(OrderCloseTime()), TIME_DATE|TIME_MINUTES||TIME_SECONDS), 
                                 TimeToString(IntToDateTime(account.lastOrderClose), TIME_DATE|TIME_MINUTES||TIME_SECONDS)
                     );

         			   // Add closed order to history[]
                     history[j++] = OrderDTO(true, account.accountId); //constructor has option to fill fields using Order*() methods, of course it has to be called after OrderSelect
         			   if(newLastOrderClose < OrderCloseTime()) 
         			   {
         			      //PrintFormat("newLastUpdateTime updated from %s to %s", TimeToString(IntToDateTime(newLastOrderClose)), TimeToString(OrderCloseTime()));
         				   newLastOrderClose = OrderCloseTime();
         			   }
         		   }
               }
            }
            
            //PrintFormat("Calling RegisterClosedTradesOnServer(orders)");
      		bool ok = RegisterClosedTradesOnServer(history);
      		if(ok)
      		{
      			PrintFormat("RegisterClosedTradesOnServer has returned successfully from History call. Updating lastOrderClose to %s", TimeToString(IntToDateTime(newLastOrderClose), TIME_DATE|TIME_MINUTES||TIME_SECONDS));
               account.lastOrderClose = newLastOrderClose;   
               timeHistory = TimeCurrent();
      			return account.lastOrderClose;
      		}
         }
         else
	      {
      		PrintFormat("Couldn't initialize (resize) History array to take %d elements", closedCount);
	      }
      }
   }

   return account.lastOrderClose;
}

bool RegisterClosedTradesOnServer(OrderDTO& orders[])
{
	const string commandName = "RegisterClosedTrades";
	string payload[]; //send buffer
	string response[]; //response buffer
	
	//compute size 
	int numberOfOrders = ArraySize(orders);
	int bufferSize = 1;  // add space for command name
	bufferSize += 1;     // add space for OrderCount
	
	if(numberOfOrders > 0) 
	{
		bufferSize += numberOfOrders * orders[0].Length(); // # OrderDTO x 15 variables
	}
	
	if(ArrayResize(payload, bufferSize) == bufferSize)
	{
		int i = -1; //last element of buffer
		payload[++i] = commandName;
		payload[++i] = IntegerToString(numberOfOrders);    //serialize the count of elements of type OrderDTO in `orders` array
		
		for(int j = 0; j < numberOfOrders; ++j)
		{
			orders[j].Serialize(payload, i);                //serialize to buffer element #j of `orders` array
		}
		
		//PrintFormat("Now calling TradingCentral with payload and commandName: RegisterClosedTrades");
		bool r = CommSendCommand(response, payload);
		if(r)
		{
			//CommShowResponse(commandName, response); //this is for debugging only - dump received buffer
			if(response[0] == "OK")
			{
				return true;
			}
			else
			{
				PrintFormat("%s Error: `%s`", commandName, response[1]);
			}
		}
		else
		{
			PrintFormat("%s no response - error: `%s`", commandName, CommGetLastError());
		}
	}
	else
	{
		PrintFormat("%s - problem during creating buffer string[%d]", commandName, bufferSize);
	}
	return false;
}





bool UpdateStatistics()
{
	//Print("Running GetHourglassAccountOverviewOnServer(HourglassAccountOverviewDTO &responseDTO, int accountId).");
   HourglassAccountOverviewDTO responseDTO;
   
	const string commandName = "GetHourglassAccountOverview";
	string payload[];       //send buffer
	string response[];      //response buffer

   //PrintFormat("Running UpdateStatistics for accountId: %d", account.accountId);
	int bufferSize = 2;     // Just sending commandName + accountId, so increase payload[] by two
	if(ArrayResize(payload, bufferSize) == bufferSize)
	{
		int i = 0; 
		payload[i++] = commandName;
		payload[i++] = IntegerToString(account.accountId);
		
		// Send the payload to the TradingCentral
		//PrintFormat("Now calling TradingCentraL with payload and commandName: GetHourglassAccountOverview");
		bool r = CommSendCommand(response, payload);
		if(r)
		{
			//CommShowResponse(commandName, response); //this is for debugging only - dump received buffer
			if(response[0] == "OK")
			{
			   //PrintFormat("TradingCentral has successfully replied to UpdateStatistics(). Trying to deserialize...");
				int respSize = ArraySize(response);
				//optionally check if received expected number of frames - it's mostly possible for static
				int expSize = 1 + responseDTO.Length();
				
				if(respSize != expSize)
				{
					PrintFormat("%s Error: Expected %d, but received %d", commandName, expSize, respSize);
					return false;
				}
				
				i = 0; //will start after status in response[0]
				responseDTO.Deserialize(response, i);
				//PrintFormat("HourglassAccountOverviewDTO test - Bal: %s, Eq: %s, BottomRate: %s", DoubleToString(responseDTO.Balance, 2), DoubleToString(responseDTO.Equity,2), DoubleToString(responseDTO.BottomRate,4));
            
            // Copy the temporary HourglassAccountOverviewDTO into the static stats object for reuse anywhere
            // Now
            stats.Longs = responseDTO.Longs;
            stats.Shorts = responseDTO.Shorts;
				stats.LongBalancers = responseDTO.LongBalancers;
				stats.ShortBalancers = responseDTO.ShortBalancers;
            stats.CurrentStep = responseDTO.CurrentStep;				
            stats.NextLot = responseDTO.NextLot;
            stats.NextLotIncrease = responseDTO.NextLotIncrease;
            stats.NextCountdown = responseDTO.NextCountdown;
            //Upwards
            stats.UpRate = responseDTO.UpRate;
            stats.UpEquity = responseDTO.UpEquity;
            stats.UpBalance = responseDTO.UpBalance;
            stats.UpLongs = responseDTO.UpLongs;
            stats.UpShorts = responseDTO.UpShorts;
            //Top
            stats.TopRate = responseDTO.TopRate;
            stats.TopEquity = responseDTO.TopEquity;
            stats.TopBalance = responseDTO.TopBalance;
            stats.TopLongs = responseDTO.TopLongs;
            stats.TopShorts = responseDTO.TopShorts;
            //Center
            stats.CenterRate = responseDTO.CenterRate;
            stats.CenterEquity = responseDTO.CenterEquity;
            stats.CenterBalance = responseDTO.CenterBalance;
            stats.CenterLongs = responseDTO.CenterLongs;
            stats.CenterShorts = responseDTO.CenterShorts;
            //Downwards
            stats.DownRate = responseDTO.DownRate;
            stats.DownEquity = responseDTO.DownEquity;
            stats.DownBalance = responseDTO.DownBalance;
            stats.DownLongs = responseDTO.DownLongs;
            stats.DownShorts = responseDTO.DownShorts;
            //Bottom
            stats.BottomRate = responseDTO.BottomRate;
            stats.BottomEquity = responseDTO.BottomEquity;
            stats.BottomBalance = responseDTO.BottomBalance;
            stats.BottomLongs = responseDTO.BottomLongs;
            stats.BottomShorts = responseDTO.BottomShorts;
			
				//PrintFormat("HourglassAccountOverviewDTO successfully updated static stats variable.");
            //PrintFormat("HourglassAccountOverviewDTO stats - Longs: %s, Shorts: %s, BottomRate: %s", DoubleToString(stats.Longs, 2), DoubleToString(stats.Shorts, 2), DoubleToString(stats.BottomRate,4));

            // Horizontal grid
            if(Ask >= gridTopRefreshRate || Ask <= gridBottomRefreshRate)
            {
               CreateGridLines();
            }
            currentSpread = (Ask-Bid)/usePoint;
            if(currentSpread > maxSpread) maxSpread = currentSpread;   

            // Update statistics UI
            SetAllTextLabels();
            WindowRedraw();
            timeUpdated = TimeCurrent();
         
				return true;
			}
			else
			{
				PrintFormat("%s Error: `%s`", commandName, response[1]);
			}
		}
		else
		{
			PrintFormat("%s no response - error: `%s`", commandName, CommGetLastError());
		}
		//*/
	}
	else
	{
		PrintFormat("%s - problem during creating buffer string[%d]", commandName, bufferSize);
	}
	return false;
}


void FillHourglassAccountRegistrationDTO (HourglassAccountRegistrationDTO &reg)
{
	reg.accountNumber = AccountNumber();                                          // 1
	reg.accountName = NameOfAccount;                                              // 2 NameOfAccount
	reg.symbol = Symbol();                                                        // 3
   reg.tradingLotSize = TradingLotSize;                                          // 4
   reg.extremeTopRate = ExtremeTopRate;                                          // 5
   reg.normalTopRate = NormalTopRate;                                            // 6
   reg.centerRate = CenterRate;                                                  // 7
   reg.normalBottomRate = NormalBottomRate;                                      // 8
   reg.extremeBottomRate = ExtremeBottomRate;                                    // 9
   reg.maxPlacementDistance = MaxPlacementDistance;                              // 10
   reg.testUpToRate = TestUpToRate;                                              // 11
   reg.testDownToRate = TestDownToRate;                                          // 12
   reg.testPipsUp = TestPipsUp;                                                  // 13
   reg.testPipsDown = TestPipsDown;                                              // 14
   reg.balancerMinPlacementDistanceLongs = BalancerMinPlacementDistanceLongs;    // 15
   reg.balancerMinPlacementDistanceShorts = BalancerMinPlacementDistanceShorts;  // 16
   reg.longStabilizerSizeFactor = LongStabilizerSizeFactor;                      // 17
   reg.shortStabilizerSizeFactor = ShortStabilizerSizeFactor;                    // 18
   reg.longBalancerSizeFactor = LongBalancerSizeFactor;                          // 19
   reg.shortBalancerSizeFactor = ShortBalancerSizeFactor;                        // 20
   reg.primerSizeFactor = PrimerSizeFactor;                                      // 21
   reg.balancerStopLossPips = BalancerStopLossPips;                              // 22
   reg.securePips = SecurePips;                                                  // 23
   reg.autoLotIncrease = AutoLotIncrease;                                        // 24
   reg.autoLotSafeEQLevel = AutoLotSafeEQLevel;                                  // 25
   reg.takeProfit = TakeProfit;                                                  // 26
   reg.tradeMidTerm = TradeMidTerm;                                              // 27
   reg.fixedSpread = FixedSpread;                                                // 28
   reg.extraLongBuffer = ExtraLongBuffer;                                        // 29
   reg.extraShortBuffer = ExtraShortBuffer;                                      // 30
   reg.warningLevel = WarningLevel;                                              // 31
   reg.heartbeatMonitorTimer = HeartbeatMonitorTimer;                            // 32
   reg.snapshotLogTimer = SnapshotLogTimer;                                      // 33
   reg.autoCloseExtremes = AutoCloseExtremes;                                    // 34
   reg.runBalancers = RunBalancers;                                              // 35
   reg.runStabilizers = RunStabilizers;                                          // 36
   reg.runBreakouts = RunBreakouts;                                              // 37
   reg.runWhiplash = RunWhiplash;                                                // 38
   reg.runPrimers = RunPrimers;                                                  // 39
   reg.gmtOffset = GMTOffset;                                                    // 40
   reg.usePoint = usePoint;                                                      // 41
   reg.rateDecimalNumbersToShow = rateDecimalNumbersToShow;                      // 42
   reg.isAccountMaster = IsAccountMaster;                                        // 43
   reg.isSymbolMaster = IsSymbolMaster;                                          // 44
   reg.screenshotTimer = ScreenshotTimer;                                        // 45
   reg.maxWeight = MaxWeight;                                                    // 46
   reg.dataFolder = TerminalInfoString(TERMINAL_DATA_PATH);                      // 47
   reg.accountPercentage = AccountPercentage;                                    // 48
   reg.ask = Ask;                                                                // 49
   reg.bid = Bid;                                                                // 50
   reg.balance = AccountBalance();                                               // 51
   reg.equity = AccountEquity();                                                 // 52
   
   /*
   Print("reg.runBalancers: " + IntegerToString(reg.runBalancers));
   Print("reg.runStabilizers: " + IntegerToString(reg.runStabilizers));
   Print("reg.runBreakouts: " + IntegerToString(reg.runBreakouts));
   Print("reg.runWhiplash: " + IntegerToString(reg.runWhiplash));
   Print("reg.runPrimers: " + IntegerToString(reg.runPrimers));
   */
}



void ModifyOrder(ChangeOrderDTO &dto)
{
   if(OrderSelect(dto.ticket, SELECT_BY_TICKET))
   {
      if(OrderCloseTime() == 0 && OrderSymbol() == Symbol())
      {
         while(IsTradeContextBusy()) 
         {
            Sleep(10);
         }
         
         bool changed = OrderModify(dto.ticket, dto.openRate, dto.stopLossRate, dto.takeProfitRate, 0);
        // Print(DoubleToString(orderTicket, 0) + ", " + DoubleToString(orderOpenPrice, 4) + ", " + DoubleToString(orderStopLoss, 4) + ", " + DoubleToString(orderTakeProfit, 4));
         if(changed == false)
         {
            int errorCode = GetLastError();
            string errDesc = ErrorDescription(errorCode);
            string errAlert = StringConcatenate("Modify order - Error: ", errorCode, ": ", errDesc);
            string errLog = StringConcatenate("Ticket: ", dto.ticket, " Bid: ", MarketInfo(Symbol(), MODE_BID), " Ask: ", MarketInfo(Symbol(), MODE_ASK));
            Print(errLog);
         }
      }
   }
}

void OpenPending(bool isLong, ChangeOrderDTO &dto)
{
   if(isLong)
   {
      int buyTicket = OpenLongPendingOrder(Symbol(), dto.lots, dto.openRate, 0, dto.stopLossRate, dto.takeProfitRate, dto.comment, magicNumberRegulars, 0, Green);
   }
   else
   {
      int sellTicket = OpenShortPendingOrder(Symbol(), dto.lots, dto.openRate, 0, dto.stopLossRate, dto.takeProfitRate, dto.comment, magicNumberRegulars, 0, Red);
   }
}


bool DeletePendingOrder(ChangeOrderDTO &dto)
{
   bool deleted = false;
   if(OrderSelect(dto.ticket, SELECT_BY_TICKET))
   {
      if(OrderCloseTime() == 0 && OrderSymbol() == Symbol())
      {
         while(IsTradeContextBusy()) 
         {
            Sleep(10);
         }

         deleted = OrderDelete(dto.ticket, Red);

         if(deleted == false)
         {
            int errorCode = GetLastError();
            string errDesc = ErrorDescription(errorCode);
            string errAlert = StringConcatenate("Close Pending Order - Error: ", errorCode, ": ", errDesc);
            string errLog = StringConcatenate("Ticket: ", dto.ticket, " Bid: ", MarketInfo(Symbol(), MODE_BID), " Ask: ", MarketInfo(Symbol(), MODE_ASK));
            Print(errLog);
         }
      }
   }
   return(deleted);
}

bool CloseOpenOrder(ChangeOrderDTO &dto, int argCloseRate)
{
   bool closed = false;
   if(OrderSelect(dto.ticket, SELECT_BY_TICKET))
   {
      if(OrderCloseTime() == 0 && OrderSymbol() == Symbol())
      {
         while(IsTradeContextBusy()) 
         {
            Sleep(10);
         }

         closed = OrderClose(dto.ticket, dto.lots, argCloseRate,0);

         if(closed == false)
         {
            int errorCode = GetLastError();
            string errDesc = ErrorDescription(errorCode);
            string errAlert = StringConcatenate("Close Pending Order - Error: ", errorCode, ": ", errDesc);
            string errLog = StringConcatenate("Ticket: ", dto.ticket, " Bid: ", MarketInfo(Symbol(), MODE_BID), " Ask: ", MarketInfo(Symbol(), MODE_ASK));
            Print(errLog);
         }
      }
   }
   return(closed);
}

int OpenLongPendingOrder(string argSymbol, double argLotSize, double argPendingPrice, int argSlippage, double argStopLoss, double argTakeProfit, string argComment = "", int argMagicNumber = 0, datetime argExpiration = 0, color arrow_color = Green)
{
   while(IsTradeContextBusy())
   {
      Sleep(10);
   }

   // Verify lot size against account settings
   double lots = VerifyLotSize(argLotSize);
   
   // Verify Stop loss
   if(argStopLoss > 0) 
   {
      argStopLoss = AdjustBelowStopLevel(argSymbol, argStopLoss, 5, argPendingPrice);
   }
   
   // Verify TakeProfit
   if(argTakeProfit > 0) 
   {
      argTakeProfit = AdjustAboveStopLevel(argSymbol, argTakeProfit, 5, argPendingPrice);
   }

   // Place Buy Pending Order
   int buyTicket = -1;
   if(argPendingPrice > MarketInfo(Symbol(), MODE_ASK))
   {
      buyTicket = OrderSend(argSymbol, OP_BUYSTOP, lots, argPendingPrice, argSlippage, argStopLoss, argTakeProfit, argComment, argMagicNumber, argExpiration, Green);
   }
   else
   {
      buyTicket = OrderSend(argSymbol, OP_BUYLIMIT, lots, argPendingPrice, argSlippage, argStopLoss, argTakeProfit, argComment, argMagicNumber, argExpiration, Green);
   }
   
   // Error Handling
   if(buyTicket == -1)
   {
      int errorCode = GetLastError();
      string errDesc = ErrorDescription(errorCode);
      string errAlert = StringConcatenate("Open Pending Buy Order - Error ", errorCode, ": ", errDesc);
      string errLog = StringConcatenate("Ask: ", MarketInfo(argSymbol, MODE_ASK), " Lots: ", argLotSize, " Price: ", argPendingPrice, " Stop: ", argStopLoss, " Profit: ", argTakeProfit, " Expiration: ", TimeToStr(argExpiration));
     Print(errLog);
   }
   
   return(buyTicket);
}


int OpenShortPendingOrder(string argSymbol, double argLotSize, double argPendingPrice, int argSlippage, double argStopLoss, double argTakeProfit, string argComment = "", int argMagicNumber = 0, datetime argExpiration = 0, color arrow_color = Red)
{
   while(IsTradeContextBusy()) 
   {
      Sleep(10);
   }

   // Verify lot size against account settings
   double lots = VerifyLotSize(argLotSize);
   
   // Verify StopLoss
   if(argStopLoss > 0) 
   {
      argStopLoss = AdjustAboveStopLevel(argSymbol, argStopLoss, 5, argPendingPrice);
   }
   
   // Verify TakeProfit
   if(argTakeProfit > 0) 
   {
      argTakeProfit = AdjustBelowStopLevel(argSymbol, argTakeProfit, 5, argPendingPrice);
   }
   
   // Place Sell Pending Order
   int sellTicket = -1;
   if(argPendingPrice > MarketInfo(Symbol(), MODE_BID))
   {
      sellTicket = OrderSend(argSymbol, OP_SELLLIMIT, argLotSize, argPendingPrice, argSlippage, argStopLoss, argTakeProfit, argComment, argMagicNumber, argExpiration, Red);
   }
   else
   {
      sellTicket = OrderSend(argSymbol, OP_SELLSTOP, argLotSize, argPendingPrice, argSlippage, argStopLoss, argTakeProfit, argComment, argMagicNumber, argExpiration, Red);
   }

   // Error Handling
   if(sellTicket == -1)
   {
      int errorCode = GetLastError();
      string errDesc = ErrorDescription(errorCode);
      string errAlert = StringConcatenate("Open Sell Stop Order - Error ", errorCode,": ", errDesc);
      string errLog = StringConcatenate("Bid: ", MarketInfo(argSymbol,MODE_BID), " Lots: ", argLotSize, " Price: ", argPendingPrice, " Stop: ", argStopLoss, " Profit: ", argTakeProfit, " Expiration: ", TimeToStr(argExpiration));
      Print(errLog);
   }
   
   return(sellTicket);
}


// Verify that requested lot size isn't too large, too small or incorrectly stepped for current account
double VerifyLotSize(double argLotSize)
{
   if(argLotSize < MarketInfo(Symbol(), MODE_MINLOT))
   {
      argLotSize = MarketInfo(Symbol(), MODE_MINLOT);
   }
   else if(argLotSize > MarketInfo(Symbol(), MODE_MAXLOT))
   {
      argLotSize = MarketInfo(Symbol(), MODE_MAXLOT);
   }
   if(MarketInfo(Symbol(), MODE_LOTSTEP) == 0.1)
   {
      argLotSize = NormalizeDouble(argLotSize, 1);
   }
   else 
   {
      argLotSize = NormalizeDouble(argLotSize, 2);
   }
   
   return(argLotSize);
}


// If requested StopLoss or TakeProfit rate is too close to Bid it will be adjusted to avoid error
double AdjustBelowStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0)
{
   double stopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
   double openPrice = 0;
   if(argOpenPrice == 0) 
   {
      openPrice = MarketInfo(argSymbol, MODE_BID);
   }
   else 
   {
      openPrice = argOpenPrice;
   }

   double lowerStopLevel = openPrice - stopLevel;
   double adjustedPrice = 0;
   if(argAdjustPrice >= lowerStopLevel) 
   {
      adjustedPrice = lowerStopLevel - (argAddPips * usePoint);
   }
   else 
   {
      adjustedPrice = argAdjustPrice;
   }
   
   return(adjustedPrice);
}


// If requested Stop loss or Take profit rate is too close to Ask it will be adjusted to avoid error
double AdjustAboveStopLevel(string argSymbol, double argAdjustPrice, int argAddPips = 0, double argOpenPrice = 0)
{
   double openPrice = 0;
   double stopLevel = MarketInfo(argSymbol, MODE_STOPLEVEL) * Point;
   if(argOpenPrice == 0) 
   {
      openPrice = MarketInfo(argSymbol, MODE_ASK);
   }
   else 
   {
      openPrice = argOpenPrice;
   }

   double upperStopLevel = openPrice + stopLevel;
   double adjustedPrice = 0;
   if(argAdjustPrice <= upperStopLevel) 
   {
      adjustedPrice = upperStopLevel + (argAddPips * usePoint);
   }
   else 
   {
      adjustedPrice = argAdjustPrice;
   }
   
   return(adjustedPrice);
}


void SaveChart()
{
   if((TimeCurrent() >= timeScreenshot + (ScreenshotTimer*60)))
   {
      string name = NameOfAccount + ".png"; 
      ChartScreenShot(0,name,WIDTH,HEIGHT,ALIGN_LEFT);
      timeScreenshot = TimeCurrent();
   }
}


void SoundFeedback()
{
   if(oldAccountbalance < AccountBalance() && GoodSound != "")
   {
      PlaySound(GoodSound);
   }
   else if(oldAccountbalance > AccountBalance() && BadSound != "")
   {
      PlaySound(BadSound);
   }
   oldAccountbalance = AccountBalance(); 
}

void DeleteAllLabels()
{
   int obj_total = ObjectsTotal();
   for(int i = obj_total; i >= 0; i--) 
   {
      string name = ObjectName(i);
      if(StringSubstr(name, 0, 6) == "Label_")
      { 
         ObjectDelete(name);
      }
   } 
}

void DeleteAllGridLines()
{
   int obj_total = ObjectsTotal();
   for(int i = obj_total; i >= 0; i--) 
   {
      string name = ObjectName(i);
      if(StringSubstr(name, 0, 5) == "Grid_")
      { 
         ObjectDelete(name);
      }
   } 
}

void CreateGridLines()
{
   DeleteAllGridLines();
   
   double askRoundedUp = 0;
   if(usePoint == 0.0001)
   {
      askRoundedUp = (MathCeil(Ask * 100) / 100);
   }
   else
   {
      askRoundedUp = MathCeil(Ask);
   }
      
   top = askRoundedUp + ((gridSize * GridLevelsAside) * usePoint);
   bottom = askRoundedUp - ((gridSize * GridLevelsAside) * usePoint);
   gridTopRefreshRate = askRoundedUp + (gridSize * 4) * usePoint;
   gridBottomRefreshRate = askRoundedUp - (gridSize * 4) * usePoint;
   
   Print("Resetting grid based on Ask = " + DoubleToString(askRoundedUp, 4));
   //Print("Ask: " + DoubleToString(Ask, 4) + ", bottom: " + DoubleToString(bottom, 4));
   //Print("gridTopRefreshRate: " + DoubleToString(gridTopRefreshRate, 4));  
   //Print("gridBottomRefreshRate: " + DoubleToString(gridBottomRefreshRate, 4));
   double rate = top;

   while(rate >= bottom)
   {
      
      if(rate == ExtremeTopRate || rate == NormalTopRate || rate == CenterRate || rate == NormalBottomRate || rate == ExtremeBottomRate)
      {
         Print("Hit a tradingline at rate " + DoubleToString(rate,4) + ", skipping gridline...");
      }
      else
      {
         //Print("Making gridline " + DoubleToString(rate,4) + "...");     
         DrawGridLine(rate); 
      }
      rate = rate - (gridSize * usePoint);
   }
   //Print("All done!");
}


void DrawGridLine(double rate)
{
   string objName = StringConcatenate("Grid_", DoubleToString(rate, Digits));
   ObjectCreate(objName, OBJ_HLINE, 0, 0, rate, 0, rate);
   //ObjectSet(objName, OBJPROP_TIMEFRAMES, NULL);
   ObjectSet(objName, OBJPROP_COLOR, GridColor);
   ObjectSet(objName,OBJPROP_STYLE, STYLE_DOT);
   ObjectSet(objName,OBJPROP_WIDTH, 1);
   ObjectSet(objName,OBJPROP_BACK, HideGridLabels);
   ObjectSetText(objName, objName, 20, "Times New Roman", GridColor);
}

void CreateAllLabels()
{
   // Line 1
   ObjectCreate("Label_1_1", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_1_1", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_1_1", OBJPROP_XDISTANCE, Grid_1_Horizontal);// X coordinate
   ObjectSet("Label_1_1", OBJPROP_YDISTANCE, Line_1_Vertical);// Y coordinate

   ObjectCreate("Label_1_2", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_1_2", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_1_2", OBJPROP_XDISTANCE, Grid_2_Horizontal);// X coordinate
   ObjectSet("Label_1_2", OBJPROP_YDISTANCE, Line_1_Vertical);// Y coordinate

   ObjectCreate("Label_1_3", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_1_3", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_1_3", OBJPROP_XDISTANCE, Grid_3_Horizontal);// X coordinate
   ObjectSet("Label_1_3", OBJPROP_YDISTANCE, Line_1_Vertical);// Y coordinate

   ObjectCreate("Label_1_4", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_1_4", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_1_4", OBJPROP_XDISTANCE, Grid_4_Horizontal);// X coordinate
   ObjectSet("Label_1_4", OBJPROP_YDISTANCE, Line_1_Vertical);// Y coordinate

   ObjectCreate("Label_1_5", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_1_5", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_1_5", OBJPROP_XDISTANCE, Grid_5_Horizontal);// X coordinate
   ObjectSet("Label_1_5", OBJPROP_YDISTANCE, Line_1_Vertical);// Y coordinate

   ObjectCreate("Label_1_6", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_1_6", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_1_6", OBJPROP_XDISTANCE, Grid_6_Horizontal);// X coordinate
   ObjectSet("Label_1_6", OBJPROP_YDISTANCE, Line_1_Vertical);// Y coordinate

   ObjectCreate("Label_1_7", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_1_7", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_1_7", OBJPROP_XDISTANCE, Grid_7_Horizontal);// X coordinate
   ObjectSet("Label_1_7", OBJPROP_YDISTANCE, Line_1_Vertical);// Y coordinate
 
   // Line 2
   ObjectCreate("Label_2_1", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_2_1", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_2_1", OBJPROP_XDISTANCE, Grid_1_Horizontal);// X coordinate
   ObjectSet("Label_2_1", OBJPROP_YDISTANCE, Line_2_Vertical);// Y coordinate

   ObjectCreate("Label_2_2", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_2_2", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_2_2", OBJPROP_XDISTANCE, Grid_2_Horizontal);// X coordinate
   ObjectSet("Label_2_2", OBJPROP_YDISTANCE, Line_2_Vertical);// Y coordinate

   ObjectCreate("Label_2_3", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_2_3", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_2_3", OBJPROP_XDISTANCE, Grid_3_Horizontal);// X coordinate
   ObjectSet("Label_2_3", OBJPROP_YDISTANCE, Line_2_Vertical);// Y coordinate

   ObjectCreate("Label_2_4", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_2_4", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_2_4", OBJPROP_XDISTANCE, Grid_4_Horizontal);// X coordinate
   ObjectSet("Label_2_4", OBJPROP_YDISTANCE, Line_2_Vertical);// Y coordinate

   ObjectCreate("Label_2_5", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_2_5", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_2_5", OBJPROP_XDISTANCE, Grid_5_Horizontal);// X coordinate
   ObjectSet("Label_2_5", OBJPROP_YDISTANCE, Line_2_Vertical);// Y coordinate

   ObjectCreate("Label_2_6", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_2_6", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_2_6", OBJPROP_XDISTANCE, Grid_6_Horizontal);// X coordinate
   ObjectSet("Label_2_6", OBJPROP_YDISTANCE, Line_2_Vertical);// Y coordinate

   ObjectCreate("Label_2_7", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_2_7", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_2_7", OBJPROP_XDISTANCE, Grid_7_Horizontal);// X coordinate
   ObjectSet("Label_2_7", OBJPROP_YDISTANCE, Line_2_Vertical);// Y coordinate


   // Line 3
   ObjectCreate("Label_3_1", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_3_1", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_3_1", OBJPROP_XDISTANCE, Grid_1_Horizontal);// X coordinate
   ObjectSet("Label_3_1", OBJPROP_YDISTANCE, Line_3_Vertical);// Y coordinate

   ObjectCreate("Label_3_2", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_3_2", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_3_2", OBJPROP_XDISTANCE, Grid_2_Horizontal);// X coordinate
   ObjectSet("Label_3_2", OBJPROP_YDISTANCE, Line_3_Vertical);// Y coordinate

   ObjectCreate("Label_3_3", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_3_3", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_3_3", OBJPROP_XDISTANCE, Grid_3_Horizontal);// X coordinate
   ObjectSet("Label_3_3", OBJPROP_YDISTANCE, Line_3_Vertical);// Y coordinate

   ObjectCreate("Label_3_4", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_3_4", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_3_4", OBJPROP_XDISTANCE, Grid_4_Horizontal);// X coordinate
   ObjectSet("Label_3_4", OBJPROP_YDISTANCE, Line_3_Vertical);// Y coordinate

   ObjectCreate("Label_3_5", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_3_5", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_3_5", OBJPROP_XDISTANCE, Grid_5_Horizontal);// X coordinate
   ObjectSet("Label_3_5", OBJPROP_YDISTANCE, Line_3_Vertical);// Y coordinate

   // Line 4
   ObjectCreate("Label_4_1", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_4_1", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_4_1", OBJPROP_XDISTANCE, Grid_1_Horizontal);// X coordinate
   ObjectSet("Label_4_1", OBJPROP_YDISTANCE, Line_4_Vertical);// Y coordinate

   ObjectCreate("Label_4_2", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_4_2", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_4_2", OBJPROP_XDISTANCE, Grid_2_Horizontal);// X coordinate
   ObjectSet("Label_4_2", OBJPROP_YDISTANCE, Line_4_Vertical);// Y coordinate

   ObjectCreate("Label_4_3", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_4_3", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_4_3", OBJPROP_XDISTANCE, Grid_3_Horizontal);// X coordinate
   ObjectSet("Label_4_3", OBJPROP_YDISTANCE, Line_4_Vertical);// Y coordinate

   ObjectCreate("Label_4_4", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_4_4", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_4_4", OBJPROP_XDISTANCE, Grid_4_Horizontal);// X coordinate
   ObjectSet("Label_4_4", OBJPROP_YDISTANCE, Line_4_Vertical);// Y coordinate

   ObjectCreate("Label_4_5", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_4_5", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_4_5", OBJPROP_XDISTANCE, Grid_5_Horizontal);// X coordinate
   ObjectSet("Label_4_5", OBJPROP_YDISTANCE, Line_4_Vertical);// Y coordinate

   // Trailing borders labels
   ObjectCreate("Label_4_6", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_4_6", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_4_6", OBJPROP_XDISTANCE, Grid_7_Horizontal);// X coordinate
   ObjectSet("Label_4_6", OBJPROP_YDISTANCE, Line_4_Vertical);// Y coordinate

   // Line 5
   ObjectCreate("Label_5_1", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_5_1", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_5_1", OBJPROP_XDISTANCE, Grid_1_Horizontal);// X coordinate
   ObjectSet("Label_5_1", OBJPROP_YDISTANCE, Line_5_Vertical);// Y coordinate

   ObjectCreate("Label_5_2", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_5_2", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_5_2", OBJPROP_XDISTANCE, Grid_2_Horizontal);// X coordinate
   ObjectSet("Label_5_2", OBJPROP_YDISTANCE, Line_5_Vertical);// Y coordinate

   ObjectCreate("Label_5_3", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_5_3", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_5_3", OBJPROP_XDISTANCE, Grid_3_Horizontal);// X coordinate
   ObjectSet("Label_5_3", OBJPROP_YDISTANCE, Line_5_Vertical);// Y coordinate

   ObjectCreate("Label_5_4", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_5_4", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_5_4", OBJPROP_XDISTANCE, Grid_4_Horizontal);// X coordinate
   ObjectSet("Label_5_4", OBJPROP_YDISTANCE, Line_5_Vertical);// Y coordinate

   ObjectCreate("Label_5_5", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_5_5", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_5_5", OBJPROP_XDISTANCE, Grid_5_Horizontal);// X coordinate
   ObjectSet("Label_5_5", OBJPROP_YDISTANCE, Line_5_Vertical);// Y coordinate

   ObjectCreate("Label_5_6", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_5_6", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_5_6", OBJPROP_XDISTANCE, Grid_6_Horizontal);// X coordinate
   ObjectSet("Label_5_6", OBJPROP_YDISTANCE, Line_5_Vertical);// Y coordinate

   ObjectCreate("Label_5_7", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_5_7", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_5_7", OBJPROP_XDISTANCE, Grid_7_Horizontal);// X coordinate
   ObjectSet("Label_5_7", OBJPROP_YDISTANCE, Line_5_Vertical);// Y coordinate
   
    // Line 6
   ObjectCreate("Label_6_1", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_6_1", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_6_1", OBJPROP_XDISTANCE, Grid_1_Horizontal);// X coordinate
   ObjectSet("Label_6_1", OBJPROP_YDISTANCE, Line_6_Vertical);// Y coordinate

   ObjectCreate("Label_6_2", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_6_2", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_6_2", OBJPROP_XDISTANCE, Grid_2_Horizontal);// X coordinate
   ObjectSet("Label_6_2", OBJPROP_YDISTANCE, Line_6_Vertical);// Y coordinate

   ObjectCreate("Label_6_3", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_6_3", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_6_3", OBJPROP_XDISTANCE, Grid_3_Horizontal);// X coordinate
   ObjectSet("Label_6_3", OBJPROP_YDISTANCE, Line_6_Vertical);// Y coordinate

   ObjectCreate("Label_6_4", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_6_4", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_6_4", OBJPROP_XDISTANCE, Grid_4_Horizontal);// X coordinate
   ObjectSet("Label_6_4", OBJPROP_YDISTANCE, Line_6_Vertical);// Y coordinate

   ObjectCreate("Label_6_5", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_6_5", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_6_5", OBJPROP_XDISTANCE, Grid_5_Horizontal);// X coordinate
   ObjectSet("Label_6_5", OBJPROP_YDISTANCE, Line_6_Vertical);// Y coordinate

   ObjectCreate("Label_6_6", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_6_6", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_6_6", OBJPROP_XDISTANCE, Grid_7_Horizontal);// X coordinate
   ObjectSet("Label_6_6", OBJPROP_YDISTANCE, Line_6_Vertical);// Y coordinate
   
   ObjectCreate("Label_6_7", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_6_7", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_6_7", OBJPROP_XDISTANCE, Grid_7_Horizontal);// X coordinate
   ObjectSet("Label_6_7", OBJPROP_YDISTANCE, Line_6_Vertical);// Y coordinate

   // Line 7
   ObjectCreate("Label_7_1", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_7_1", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_7_1", OBJPROP_XDISTANCE, Grid_1_Horizontal);// X coordinate
   ObjectSet("Label_7_1", OBJPROP_YDISTANCE, Line_7_Vertical);// Y coordinate

   ObjectCreate("Label_7_2", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_7_2", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_7_2", OBJPROP_XDISTANCE, Grid_2_Horizontal);// X coordinate
   ObjectSet("Label_7_2", OBJPROP_YDISTANCE, Line_7_Vertical);// Y coordinate

   ObjectCreate("Label_7_3", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_7_3", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_7_3", OBJPROP_XDISTANCE, Grid_3_Horizontal);// X coordinate
   ObjectSet("Label_7_3", OBJPROP_YDISTANCE, Line_7_Vertical);// Y coordinate

   ObjectCreate("Label_7_4", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_7_4", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_7_4", OBJPROP_XDISTANCE, Grid_4_Horizontal);// X coordinate
   ObjectSet("Label_7_4", OBJPROP_YDISTANCE, Line_7_Vertical);// Y coordinate

   ObjectCreate("Label_7_5", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_7_5", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_7_5", OBJPROP_XDISTANCE, Grid_5_Horizontal);// X coordinate
   ObjectSet("Label_7_5", OBJPROP_YDISTANCE, Line_7_Vertical);// Y coordinate

   ObjectCreate("Label_7_6", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_7_6", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_7_6", OBJPROP_XDISTANCE, Grid_7_Horizontal);// X coordinate
   ObjectSet("Label_7_6", OBJPROP_YDISTANCE, Line_7_Vertical);// Y coordinate
   
   ObjectCreate("Label_7_7", OBJ_LABEL, 0, 0, 0);// Creating obj.
   ObjectSet("Label_7_7", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_7_7", OBJPROP_XDISTANCE, Grid_7_Horizontal);// X coordinate
   ObjectSet("Label_7_7", OBJPROP_YDISTANCE, Line_7_Vertical);// Y coordinate
}

void SetGridPoints()
{
   if(usePoint == 0.0001)
   {
      gridTopRate = (MathCeil(Ask * 100) / 100);
      gridBottomRate = (MathFloor(Ask * 100) / 100);
   }
   else
   {
      gridTopRate = MathCeil(Ask);
      gridBottomRate = MathFloor(Ask);
   }
   Print("gridTopRate = " + DoubleToString(gridTopRate, rateDecimalNumbersToShow));
   Print("gridBottomRate = " + DoubleToString(gridBottomRate, rateDecimalNumbersToShow));
}

void DeleteAllTradingLines()
{
   ObjectDelete("ExtremeTopRateLine");
   ObjectDelete("NormalTopRateLine");
   ObjectDelete("CenterRateLine");
   ObjectDelete("NormalBottomRateLine");
   ObjectDelete("ExtremeBottomRateLine");
}


// Print collected data to screen
void SetAllTextLabels()
{
   double equity = AccountEquity() * AccountPercentage;
   double bal = AccountBalance() * AccountPercentage;
  //Print(DoubleToString(AccountPercentage, 2));
  
   // Line 1
   ObjectSetText("Label_1_1", "", NormalFontSize, FontName, ActiveColor);
   ObjectSetText("Label_1_2", "", NormalFontSize, FontName, ActiveColor);
   double equityPerc = 0;
   if(equity > 0 && bal > 0)
   {
      equityPerc = (equity / bal) * 100;
   }
   ObjectSetText("Label_1_3", "EQ: " + DoubleToString(equityPerc, 2) + "% (" + FormatDouble(equity, 0) + " / " + FormatDouble(bal, 0) + " " + AccountCurrency()+ ")", NormalFontSize, FontName, ActiveColor);
   ObjectSetText("Label_1_4", "L: " + DoubleToString(stats.Longs, 2) + " - " + "S: " + DoubleToString(stats.Shorts, 2) + " = " + DoubleToString(stats.Longs - stats.Shorts, 2) + " (" + DoubleToString(((stats.Longs - stats.Shorts) / TradingLotSize), 2) + ")", NormalFontSize, FontName, ActiveColor);
   ObjectSetText("Label_1_5", "#: " + DoubleToString(stats.NextCountdown, 0) + " orders open", NormalFontSize, FontName, ActiveColor);
   ObjectSetText("Label_1_6", "", NormalFontSize, FontName, ActiveColor);
   ObjectSetText("Label_1_7", "Step: " + DoubleToString(stats.CurrentStep, 0) + "      Size: " + FormatDouble(TradingLotSize, 2) + " (" + FormatDouble(stats.NextLot, 2) + " in: " + FormatDouble(stats.NextLotIncrease, 0) + " " + AccountCurrency() + " / #" + DoubleToString(stats.NextCountdown, 0) + ")", NormalFontSize, FontName, ActiveColor);

   // Line 2
   ObjectSetText("Label_2_1", "Projection up", NormalFontSize, FontName, UpwardsColor);
   ObjectSetText("Label_2_2", "@ " + DoubleToString(stats.UpRate, rateDecimalNumbersToShow) + " (in " + DoubleToString(CalcPips(Symbol(), stats.UpRate, Ask), 0) + " pips)", NormalFontSize, FontName, UpwardsColor);
   
   double upwardsEquityPerc = 0;
   if(stats.UpEquity > 0 && stats.UpBalance > 0)
   {
      upwardsEquityPerc = (stats.UpEquity / stats.UpBalance) * 100;
   }
   ObjectSetText("Label_2_3", "EQ: " + FormatDouble(upwardsEquityPerc, 2) + "% (" + FormatDouble(stats.UpEquity, 0) + " / " + FormatDouble(stats.UpBalance, 0) + " " + AccountCurrency()+ ")", NormalFontSize, FontName, UpwardsColor);
   ObjectSetText("Label_2_4", "L: " + DoubleToString(stats.UpLongs, 2) + " - S: " + DoubleToString(stats.UpShorts, 2) + " = " + DoubleToString(stats.UpLongs - stats.UpShorts, 2) + " (" + DoubleToString(((stats.UpLongs - stats.UpShorts) / TradingLotSize), 2) + ")", NormalFontSize, FontName, UpwardsColor);
   ObjectSetText("Label_2_5", DoubleToString(Ask, rateDecimalNumbersToShow), RateFontSize, FontName, UpwardsColor);
   ObjectSetText("Label_2_6", DoubleToString(Bid, rateDecimalNumbersToShow), RateFontSize, FontName, DownwardsColor);
   ObjectSetText("Label_2_7", "(now: " + DoubleToString(((Ask-Bid)/usePoint), 2) + "    max: " + DoubleToString(maxSpread, 2) + ")" , RateFontSize, FontName, NormalColor);

   // Line 3
   ObjectSetText("Label_3_1", "Projection down", NormalFontSize, FontName,DownwardsColor);
   ObjectSetText("Label_3_2", "@ " + DoubleToString(stats.DownRate, rateDecimalNumbersToShow) + " (in " + DoubleToString(CalcPips(Symbol(), Bid, stats.DownRate), 0) + " pips)", NormalFontSize, FontName, DownwardsColor);
   double downwardsEquityPerc = 0;
   if(stats.DownEquity > 0 && stats.DownBalance > 0)
   {
      downwardsEquityPerc = (stats.DownEquity / stats.DownBalance) * 100;
   }
   ObjectSetText("Label_3_3", "EQ: " + FormatDouble(downwardsEquityPerc, 2) + "% (" + FormatDouble(stats.DownEquity, 0) + " / " + FormatDouble(stats.DownBalance, 0) + " " + AccountCurrency()+ ")", NormalFontSize, FontName, DownwardsColor);
   ObjectSetText("Label_3_4", "L: " + DoubleToString(stats.DownLongs, 2) + " - S: " + DoubleToString(stats.DownShorts, 2) + " = " + DoubleToString(stats.DownLongs - stats.DownShorts, 2) + " (" + DoubleToString(((stats.DownLongs - stats.DownShorts) / TradingLotSize), 2) + ")", NormalFontSize, FontName, DownwardsColor);
   ObjectSetText("Label_3_5", "", NormalFontSize, FontName, DownwardsColor);

   // Line 4
   ObjectSetText("Label_4_1", "Top border", NormalFontSize, FontName, NormalColor);
   ObjectSetText("Label_4_2", "@ " + DoubleToString(stats.TopRate, rateDecimalNumbersToShow) + " (in " + DoubleToString(CalcPips(Symbol(), stats.TopRate, Ask), 0) + " pips)", NormalFontSize, FontName, NormalColor);
   double topBorderEquityPerc = 0;
   if(stats.TopEquity > 0 && stats.TopBalance > 0)
   {
      topBorderEquityPerc = (stats.TopEquity / stats.TopBalance) * 100;
   }
   ObjectSetText("Label_4_3", "EQ: " + DoubleToString(topBorderEquityPerc, 2) + "%" + " (" + FormatDouble(stats.TopEquity, 0) + " / " + FormatDouble(stats.TopBalance, 0) + " " + AccountCurrency()+ ")", NormalFontSize, FontName, NormalColor);
   ObjectSetText("Label_4_4", "L: " + DoubleToString(stats.TopLongs, 2) + " - S: " + DoubleToString(stats.TopShorts, 2) + " = " + DoubleToString(stats.TopLongs - stats.TopShorts, 2) + " (" + DoubleToString(((stats.TopLongs - stats.TopShorts) / TradingLotSize), 2) + ")", NormalFontSize, FontName, NormalColor);
   if(IsTrader == true)
   {
      ObjectSetText("Label_4_5", NameOfAccount + " trader (" + Period() + ")", RateFontSize, FontName, ActiveColor);	
   }
   else
   {
      ObjectSetText("Label_4_5", NameOfAccount + " viewer (" + Period() + ")", RateFontSize, FontName, NormalColor);	
      
   }
   
   ObjectSetText("Label_4_6", "", NormalFontSize, FontName, NormalColor);

   // Line 5
   ObjectSetText("Label_5_1", "Center", LargeFontSize, FontName, CenterColor);
   ObjectSetText("Label_5_2", "@ " + DoubleToString(stats.CenterRate, rateDecimalNumbersToShow) + " (in " + DoubleToString(CalcPips(Symbol(), stats.CenterRate, Ask), 0) + " pips)", LargeFontSize, FontName, CenterColor);
   double centerEquityPerc = 0;
   if(stats.CenterEquity > 0 && stats.CenterBalance > 0)
   {
      centerEquityPerc = (stats.CenterEquity / stats.CenterBalance) * 100;
   }
   ObjectSetText("Label_5_3", "EQ: " + FormatDouble(centerEquityPerc, 2) + "% (" + FormatDouble(stats.CenterEquity, 0) + " / " + FormatDouble(stats.CenterBalance, 0) + " " + AccountCurrency()+ ")", LargeFontSize, FontName, CenterColor);
   ObjectSetText("Label_5_4", "L: " + DoubleToString(stats.CenterLongs, 2) + " - S: " + DoubleToString(stats.CenterShorts, 2) + " = " + DoubleToString(stats.CenterLongs - stats.CenterShorts, 2) + " (" + DoubleToString(((stats.CenterLongs - stats.CenterShorts) / TradingLotSize), 2) + ")", LargeFontSize, FontName, CenterColor);
   ObjectSetText("Label_5_5", "NT: " + DoubleToString(NormalTopRate, rateDecimalNumbersToShow) + " / NB: " + DoubleToString(NormalBottomRate, rateDecimalNumbersToShow), SmallFontSize, FontName, NormalColor);
   ObjectSetText("Label_5_6", "", SmallFontSize, FontName, NormalColor);
   ObjectSetText("Label_5_7", TimeToString(TimeGMT(),TIME_DATE|TIME_SECONDS), NormalFontSize, FontName, NormalColor);

  
   // Line 6
   ObjectSetText("Label_6_1", "Bottom border", NormalFontSize, FontName, NormalColor);
   ObjectSetText("Label_6_2", "@ " + DoubleToString(stats.BottomRate, rateDecimalNumbersToShow) + " (in " + DoubleToString(CalcPips(Symbol(), stats.BottomRate, Bid), 0) + " pips)", NormalFontSize, FontName, NormalColor);
   double bottomBorderEquityPerc = 0;
   if(stats.BottomEquity > 0 && stats.BottomBalance > 0)
   {
      bottomBorderEquityPerc = (stats.BottomEquity / stats.BottomBalance) * 100;
   }
   ObjectSetText("Label_6_3", "EQ: " + DoubleToString(bottomBorderEquityPerc, 2) + "%" + " (" + FormatDouble(stats.BottomEquity, 0) + " / " + FormatDouble(stats.BottomBalance, 0) + " " + AccountCurrency()+ ")", NormalFontSize, FontName, NormalColor);
   ObjectSetText("Label_6_4", "L: " + DoubleToString(stats.BottomLongs, 2) + " - S: " + DoubleToString(stats.BottomShorts, 2) + " = " + DoubleToString(stats.BottomLongs - stats.BottomShorts, 2) + " (" + DoubleToString(((stats.BottomLongs - stats.BottomShorts) / TradingLotSize), 2) + ")", NormalFontSize, FontName, NormalColor);
   ObjectSetText("Label_6_5", "XT: " + DoubleToString(ExtremeTopRate, rateDecimalNumbersToShow) + " / XB: " + DoubleToString(ExtremeBottomRate, rateDecimalNumbersToShow), SmallFontSize, FontName, NormalColor);
   ObjectSetText("Label_6_6", "", SmallFontSize, FontName, NormalColor);
   ObjectSetText("Label_6_7", "", SmallFontSize, FontName, NormalColor);

   // Line 7
   ObjectSetText("Label_7_1", "Account percentage", NormalFontSize, FontName, NormalColor);
   ObjectSetText("Label_7_2", DoubleToString(AccountPercentage * 100, 2) + "%", NormalFontSize, FontName, NormalColor);
   ObjectSetText("Label_7_3", "Running addin lots: ", NormalFontSize, FontName, NormalColor);
   ObjectSetText("Label_7_4", "L: " + FormatDouble(stats.LongBalancers, 2) + " - S: " + FormatDouble(stats.ShortBalancers, 2) + " = " + FormatDouble(stats.LongBalancers - stats.ShortBalancers, 2) + " (" + FormatDouble((stats.LongBalancers - stats.ShortBalancers)/TradingLotSize,2) + ")", NormalFontSize, FontName, NormalColor);
   ObjectSetText("Label_7_5", "", SmallFontSize, FontName, NormalColor);
   double crashEquity = (AccountEquity() * AccountPercentage) - (MathAbs(stats.Longs - stats.Shorts) * 10 * CrashPips);
      if(crashEquity <= 0)
      {
         ObjectSetText("Label_7_6", DoubleToString(CrashPips, 0) + " pips crash: " + FormatDouble(crashEquity, 2), LargeFontSize, FontName, Red);
      }
      else
      {
         ObjectSetText("Label_7_6", DoubleToString(CrashPips, 0) + " pips crash: " + FormatDouble(crashEquity, 2), NormalFontSize, FontName, NormalColor);
      }
   ObjectSetText("Label_7_7", "", SmallFontSize, FontName, NormalColor);
}


/*
void DrawTradingLines(double extremeTopRate, double normalTop, double preferredCenterRate, double normalBottom, double extremeBottomRate)
{
   ObjectDelete("ExtremeTopRateLine");
   string objtext = StringConcatenate("Extreme top: ", DoubleToStr(extremeTopRate, Digits));
   ObjectCreate("ExtremeTopRateLine", OBJ_HLINE, 0, 0, extremeTopRate, 0, extremeTopRate);
   ObjectSet("ExtremeTopRateLine", OBJPROP_TIMEFRAMES, NULL);
   ObjectSet("ExtremeTopRateLine", OBJPROP_COLOR, Red);
   ObjectSetText("ExtremeTopRateLine", objtext, 20, "Times New Roman", Red);

   ObjectDelete("NormalTopRateLine");
   objtext = StringConcatenate("Normal top: ", DoubleToStr(normalTop, Digits));
   ObjectCreate("NormalTopRateLine", OBJ_HLINE, 0, 0, normalTop, 0, normalTop);
   ObjectSet("NormalTopRateLine", OBJPROP_TIMEFRAMES, NULL);
   ObjectSet("NormalTopRateLine", OBJPROP_COLOR, Green);
   ObjectSetText("NormalTopRateLine", objtext, 20, "Times New Roman", Green);

   ObjectDelete("CenterRateLine");
   objtext = StringConcatenate("Preferred center: ", DoubleToStr(preferredCenterRate, Digits));
   ObjectCreate("CenterRateLine", OBJ_HLINE, 0, 0, preferredCenterRate, 0, preferredCenterRate);
   ObjectSet("CenterRateLine", OBJPROP_TIMEFRAMES, NULL);
   ObjectSet("CenterRateLine", OBJPROP_COLOR, Magenta);
   ObjectSetText("CenterRateLine", objtext, 20, "Times New Roman", Magenta);
   
   ObjectDelete("NormalBottomRateLine");
   objtext = StringConcatenate("Normal bottom: ", DoubleToStr(normalBottom, Digits));
   ObjectCreate("NormalBottomRateLine", OBJ_HLINE, 0, 0, normalBottom, 0, normalBottom);
   ObjectSet("NormalBottomRateLine", OBJPROP_TIMEFRAMES, NULL);
   ObjectSet("NormalBottomRateLine", OBJPROP_COLOR, Green);
   ObjectSetText("NormalBottomRateLine", normalBottom, 20, "Times New Roman", Green);

   ObjectDelete("ExtremeBottomRateLine");
   objtext = StringConcatenate("Extreme bottom: ", DoubleToStr(extremeBottomRate, Digits));
   ObjectCreate("ExtremeBottomRateLine", OBJ_HLINE, 0, 0, extremeBottomRate, 0, extremeBottomRate);
   ObjectSet("ExtremeBottomRateLine", OBJPROP_TIMEFRAMES, NULL);
   ObjectSet("ExtremeBottomRateLine", OBJPROP_COLOR, Red);
   ObjectSetText("ExtremeBottomRateLine", objtext, 20, "Times New Roman", Red);
}

*/