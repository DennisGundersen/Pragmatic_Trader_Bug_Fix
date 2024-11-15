using Microsoft.Extensions.Logging;
//using Pragmatic.Common.Entities;
using Pragmatic.Common.Models;
using Pragmatic.Common.Models.API;
using Pragmatic.Common.Models.Hourglass;
//using Pragmatic.Core.Services;
//using Pragmatic.Core.Services.Interfaces;
using Pragmatic.Server.TradingCentral.Interfaces;
using Pragmatic.Server.TradingCentral.ZMQ;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;

namespace Pragmatic.Server.TradingCentral
{
	internal class MethodAdapters(/*ITrader trader, */IMQL4ConverterService conv, ILogger<MethodAdapters> logger)
	{
		protected CultureInfo culture = CultureInfo.InvariantCulture;
		protected string[] PrepareError(string message)
		{
			return new string[] { Base.RESP_ERROR, message };
		}

		protected string[] PrepareResponse(params string[] data)
		{
			return data.Prepend(Base.RESP_OK).ToArray();
		}

		/*
			 Register all of TradingCentral's public methods here (functions as adapters as listed in the AvailableCommands() dictionary)
			 Adapters should call the methods in the BusinessLogic of any strategy.
			 Incoming data should be deserialized into classes here, and only then passed on to the business logic methods as entities. 
			 The results from BusinessLogic should be serialized and returned to the calling client as string[] for safe transfers.
		 */
		public string[] RegisterHourglassAccount(string[] args)
		{
			try
			{
				bool success = false;
				int currentPosition = 0;

				// Create blank DTO objects that will be filled with the incoming string[] args as well as the resulting DTO
				AccountRegistrationModel registrationModel = new();
				AccountRegistrationResultModel resultModel = new();

				/* Dummy code for bug fix project 
				
				// Deserialize the incoming string[] args into the blank HourglassAccountRegistrationDTO object
				success = conv.ArrayToHourglassAccountRegistrationModel(args, ref currentPosition, registrationModel);

				if (!success)
				{
					return PrepareError(string.Format("Argument 0 ({0}) couldn't be parsed as {1}", args[0], "Pragmatic.Common.Entities.DTOs.HourglassAccountRegistrationDTO"));
				}

				Task<AccountRegistrationResultModel> task = Task.Run(async () => await trader.RegisterAccount(registrationModel));
				resultModel = task.Result;
				
				 */

				// Dummy code to test the RegisterAccount method without giving out the code or needing to run the whole system
				resultModel.Id = 1;
				resultModel.StrategyId = 1;
				resultModel.AccountNumber = 123456;
				resultModel.AccountName = "TestAccount";
				resultModel.BrokerName = "TestBroker";
				resultModel.Symbol = "EURUSD";
				resultModel.Security = 0.4m;
				resultModel.StepGrowthFactor = 0m;
				resultModel.StartingBalance = 0m;
				resultModel.StartFactor = 1;
				resultModel.Commission = 0.0m;
				resultModel.IsLive = false;
				resultModel.AccountCurrency = "USD";
				resultModel.RegisteredTime = DateTime.Now;
				resultModel.LastOrderClose = 0;
				// Dummy code ends

				// Serialize the HourglassAccountRegistrationResultModel into a string[], including a prepended "OK" status code, then return it
				string[] retSerialized = PrepareResponse(conv.HourglassAccountRegistrationResultModelToListOfString(resultModel).ToArray());

				return retSerialized;
			}
			catch (Exception ex)
			{
				logger?.LogError(ex, $"MethodAdapters.RegisterHourglassAccount exception: {0}", ex.Message);
				throw new Exception("MethodAdapters.RegisterHourglassAccount exception", ex);
			}
		}

		public string[] RegisterHourglassTrades(string[] args)
		{
			try
			{
				bool success = false;
				int currentPosition = 0;

				// Deserialize the incoming string[] args into a List<OrderModel>
				List<OrderModel> ordersList = new();

				// Moving OrderFunction and PlannedOpenRate setting to the business logic as Account instance is needed
				success = conv.ArrayToListOfOrderModel(args, ref currentPosition, ref ordersList);

				// If the incoming string object couldn't be deserialized, return an error
				if (!success)
				{
					return PrepareError(string.Format("Argument 0 ordersList({0}) couldn't be parsed as {1}", args[0], "Pragmatic.Common.ZMQTypes.DynamicArray<Pragmatic.Common.Entities.OrderDTO>"));
				}

				// Ask
				decimal ask;
				success = decimal.TryParse(args[currentPosition++], out ask);
				if (!success)
				{
					return PrepareError(string.Format("Argument 1 Ask ({0}) couldn't be parsed as {1}", args[1], "System.Decimal"));
				}

				// Bid
				decimal bid;
				success = decimal.TryParse(args[currentPosition++], out bid);
				if (!success)
				{
					return PrepareError(string.Format("Argument 2 Bid ({0}) couldn't be parsed as {1}", args[2], "System.Decimal"));
				}

				// Balance
				decimal balance;
				success = decimal.TryParse(args[currentPosition++], out balance);
				if (!success)
				{
					return PrepareError(string.Format("Argument 3 Balance ({0}) couldn't be parsed as {1}", args[3], "System.Decimal"));
				}

				// Equity
				decimal equity;
				success = decimal.TryParse(args[currentPosition++], out equity);
				if (!success)
				{
					return PrepareError(string.Format("Argument 4 Equity ({0}) couldn't be parsed as {1}", args[4], "System.Decimal"));
				}

				/* Replaced by dummy code for bug fix project */
				// Call the method on the BusinessLogic class, passing the deserialized string[] as a List<OrderDTO>, and receive the resulting List<ChangeOrderDTO>
				//List<ChangeOrderModel> changeOrderItems = trader.RegisterTrades(ordersList, ask, bid, balance, equity);

				/* Dummy code for bug fix project */
				//List<ChangeOrderModel> changeOrderItems = trader.RegisterTrades(ordersList, ask, bid, balance, equity);
				// Serialize the resulting List<ChangeOrderDTO> to a string[], including a prepended "OK" status code, then return it
				List<ChangeOrderModel> changeOrderItems = new();
				//changeOrderItems.Add(new ChangeOrderModel { Ticket = 1, OrderType = 1, Lots = 0.1, OpenRate = 1.2, StopLossRate = 0, TakeProfitRate = 0, OrderFunction = 1, Action = 1, Comment = "Test" });

				string[] results = PrepareResponse(conv.HourglassChangeOrderModelToListOfString(changeOrderItems).ToArray());

				return results;
			}
			catch (Exception ex)
			{
				logger?.LogError(ex, $"MethodAdapters.RegisterHourglassTrades exception: {0}", ex.Message);
				throw new Exception("MethodAdapters.RegisterHourglassTrades exception", ex);
			}
		}

		public string[] RegisterClosedTrades(string[] args)
		{

			try
			{
				bool success = false;
				int currentPosition = 0;
				//Console.WriteLine("RegisterClosedTrades() called");

				// Deserialize the incoming string[] args into a List<OrderDTO>
				List<OrderModel> ordersList = new();
				success = conv.ArrayToListOfOrderModel(args, ref currentPosition, ref ordersList);

				// If the incoming string object couldn't be deserialized, return an error
				if (!success)
				{
					return PrepareError(string.Format("Argument 0 ordersList({0}) couldn't be parsed as {1}", args[0], "Pragmatic.Common.ZMQTypes.DynamicArray<Pragmatic.Common.Entities.OrderDTO>"));
				}

				// Call the method on the BusinessLogic class, passing the deserialized string[] as a List<OrderDTO>, and receive the resulting ApiResultDTO
				//Task<bool> task = Task.Run(async () => await trader.RegisterClosedTrades(ordersList));

				// Serialize the resulting List<ChangeOrderModel> to a string[], including a prepended "OK" status code, then return it
				//string[] results = PrepareResponse(conv.BoolToListOfString(task.Result).ToArray());

				// Dummy data
				string[] results = PrepareResponse(conv.BoolToListOfString(true).ToArray());

				return results;
			}
			catch (Exception ex)
			{
				logger?.LogError(ex, $"MethodAdapters.RegisterClosedTrades exception: {0}", ex.Message);
				throw new Exception("MethodAdapters.RegisterClosedTrades exception", ex);
			}

			//return new string[] { "OK", "true" };
		}

		public string[] GetHourglassAccountOverview(string[] args)
		{

			bool success = false;

			// Create blank HourglassAccountStatisticsDTO object
			StatisticsModel statisticsModel = new();

			// Incoming args[0] should be the accountId
			int valInt;
			int accountId = 0;
			try
			{
				success = int.TryParse(args[0], out valInt);
				if (!success) return null;
				accountId = valInt;
			}
			catch (Exception ex)
			{
				logger?.LogError(ex, $"MethodAdapters.GetHourglassAccountOverview AccountId exception: {0}", ex.Message);
				throw new Exception("MethodAdapters.GetHourglassAccountOverview AccountId exception", ex);
			}

			try
			{
				// Call the method in the BusinessLogic class, passing accountId, and receive the resulting HourglassAccountStatisticsDTO
				//statisticsModel = trader.GetAccountOverview();

				// Dummy data
				statisticsModel.AccountId = 1;
				statisticsModel.Longs = 0.01m;
				statisticsModel.Shorts = 0.01m;
				statisticsModel.LongBalancers = 0.01m;
				statisticsModel.ShortBalancers = 0.01m;
				statisticsModel.CurrentStep = 10;
				statisticsModel.NextLotSize = 0.02m;
				statisticsModel.NextLotIncrease = 2000.54m;
				statisticsModel.NextLotIncreaseOrders = 123;
				statisticsModel.OrderCount = 20;

				statisticsModel.TopRate = 4.000m;
				statisticsModel.TopEquity = 2000m;
				statisticsModel.TopBalance = 2000m;
				statisticsModel.TopLongs = 0.05m;
				statisticsModel.TopShorts = 0.05m;

				statisticsModel.UpRate = 4.000m;
				statisticsModel.UpEquity = 2000m;
				statisticsModel.UpBalance = 2000m;
				statisticsModel.UpLongs = 0.05m;
				statisticsModel.UpShorts = 0.05m;

				statisticsModel.CenterRate = 4.000m;
				statisticsModel.CenterEquity = 2000m;
				statisticsModel.CenterBalance = 2000m;
				statisticsModel.CenterLongs = 0.05m;
				statisticsModel.CenterShorts = 0.05m;
				
				statisticsModel.DownRate = 4.000m;
				statisticsModel.DownEquity = 2000m;
				statisticsModel.DownBalance = 2000m;
				statisticsModel.DownLongs = 0.05m;
				statisticsModel.DownShorts = 0.05m;

				statisticsModel.BottomRate = 4.000m;
				statisticsModel.BottomEquity = 2000m;
				statisticsModel.BottomBalance = 2000m;
				statisticsModel.BottomLongs = 0.05m;
				statisticsModel.BottomShorts = 0.05m;
				
				// Serialize the resulting StatisticsModel into a string[], including a prepended "OK" status code, then return it
				string[] retSerialized = PrepareResponse(conv.HourglassAccountStatisticsModelToListOfString(statisticsModel).ToArray());

				return retSerialized;
			}
			catch (Exception ex)
			{
				logger?.LogError(ex, $"MethodAdapters.GetAccountOverview exception: {0}", ex.Message);
				throw new Exception("MethodAdapters.GetAccountOverview exception", ex);
			}
			//return new string[] { "OK", "true" };
		}

		public string[] RunUpdaterTesting(string[] args)
		{
			//try
			//{
			//	bool success = false;
			//	int testNumber = 0;

			//	success = int.TryParse(args[0], out testNumber);

			//	if (!success)
			//	{
			//		return PrepareError(string.Format("Argument 0 ({0}) couldn't be parsed as {1}", args[0], "Pragmatic.Common.Entities.DTOs.HourglassAccountRegistrationDTO"));
			//	}

			//	Task<bool> task = Task.Run(async () => await trader.UpdaterTesting(testNumber));
			//	bool result = task.Result;
			//	List<string> resultList = new List<string>();
			//	resultList.Add(result.ToString());
			//	if (result)
			//	{
			//		success = true;
			//	}
			//	// Serialize the HourglassAccountRegistrationResultDTO into a string[], including a prepended "OK" status code, then return it
			//	string[] retSerialized = PrepareResponse(resultList.ToArray());

			//	return retSerialized;
			//}
			//catch (Exception ex)
			//{
			//	logger?.LogError(ex, $"MethodAdapters.RunUpdaterTesting exception: {0}", ex.Message);
			//	throw new Exception("MethodAdapters.RunUpdaterTesting exception", ex);
			//}

			return new string[] { "OK", "true" };
		}

	}
}