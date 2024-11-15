using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Identity.Abstractions;
using Microsoft.Identity.Web;
using Microsoft.Identity.Web.TokenCacheProviders.InMemory;
using Pragmatic.Common.Models.API;
//using Pragmatic.Core.Services;
//using Pragmatic.Core.Services.Interfaces;
using Pragmatic.Server.TradingCentral.Interfaces;
using Pragmatic.Server.TradingCentral.Services;
using Pragmatic.Server.TradingCentral.ZMQ;
//using Pragmatic.Strategy.Hourglass.BusinessLogic;
//using Pragmatic.Strategy.Hourglass.BusinessLogic.BusinessRules;
//using Pragmatic.Strategy.Hourglass.BusinessLogic.Interfaces;
//using Pragmatic.Strategy.Hourglass.BusinessLogic.Services;
using System;
using System.Collections.Generic;

namespace Pragmatic.Server.TradingCentral
{

	/*
		 This is the entry point of the Trading Central server.
		 It is responsible for:
			  - Creating the host builder
			  - Configuring the host builder with all the necessary services used by the server and business logic
			  - Initializing the ZeroMQ server
			  - Configuring the server
			  - Registering commands that expose methods (for any strategy) using "adapters"
			  - Starting the server
		     - Setting the console title to the account name and port
			  - Stopping the server   
	 */
	public class Program
	{
		const string DEF_ACCOUNT = "Trading Central: no account registered";
		static void Main(string[] args)
		{

			HostApplicationBuilder builder = Host.CreateApplicationBuilder(args);
			//var aadConfig = builder.Configuration.GetSection("AzureAd");
			//var apiConfig = builder.Configuration.GetSection("DownstreamApi");

			// Set the console title to the account name and port
			Console.Title = GenerateTitle(builder.Configuration);


			// Configure the host builder with all the necessary services used by the server and business logic (dependency injection)
			builder.Services
						  // Add the Microsoft Entra/Identity dependencies    
						  //.AddTokenAcquisition(true)
						  //.Configure<MicrosoftIdentityApplicationOptions>(aadConfig)
						  //.AddInMemoryTokenCaches()
						  //.AddHttpClient()

						  // Add the downstream API
						  //.AddDownstreamApi("DownstreamApi", apiConfig)

						  // Register the ZeroMQ server and its dependencies
						  .AddHostedService<Server>()
						  .AddSingleton<Base, BridgeZeroMQ>()
						  .AddSingleton<ICommandsProvider, AvailableCommands>()
						  .AddSingleton<MethodAdapters>()

						  // Register the Trader entity and all of its dependencies
						  //.AddSingleton<ITrader, HourglassTrader>()

						  // Register the TradingService and its dependencies, such as Business rules
						  //.AddSingleton<ITradingService, TradingService>()
						  //.AddSingleton<Regulars>()
						  //.AddSingleton<Balancers>()
						  //.AddSingleton<Breakouts>()
						  //.AddSingleton<Manuals>()
						  //.AddSingleton<Primers>()
						  //.AddSingleton<Stabilizers>()
						  //.AddSingleton<Projections>()
						  //.AddSingleton<IStatisticsService, StatisticsService>()
						  //.AddSingleton<IMappingService, MappingService>()
						  //.AddSingleton<ICalculationService, CalculationService>()
						  //.AddSingleton<IAPIService, APIService>()
						  //.AddSingleton<IUpdaterService, UpdaterService>()
						  //.AddSingleton<IHourglassTestingService, HourglassTestingService>()
						  //.AddSingleton<IVolatilityService, VolatilityService>()
						  //.AddSingleton<IConverterService, ConverterService>()
						  .AddSingleton<IMQL4ConverterService, MQL4ConverterService>();
						  //.AddSingleton<ICurrencyService, CurrencyService>()
						  //.AddSingleton<IAzureService, AzureService>();


			builder.Logging.AddConsole();

			using (IHost host = builder.Build())
			{
				host.Run();
			}

		}

		private static string GenerateTitle(ConfigurationManager configuration)
		{
			var accountName = configuration.GetValue<string>("Account", DEF_ACCOUNT);
			var port = configuration.GetValue<int>("Port", 0);
			return (port > 0) ? accountName + ":" + port : accountName;
		}


		/* List all custom command names that should be available on the Trading Central */
		class AvailableCommands(MethodAdapters commands) : ICommandsProvider
		{
			public Dictionary<string, Base.Cmd> GetCommands()
			{
				return new()
					 {
						  { "RegisterHourglassAccount", commands.RegisterHourglassAccount },
						  { "RegisterHourglassTrades", commands.RegisterHourglassTrades },
						  { "RegisterClosedTrades", commands.RegisterClosedTrades },
						  { "GetHourglassAccountOverview", commands.GetHourglassAccountOverview },
						  //{ "RunUpdaterTesting", commands.RunUpdaterTesting }
					 };

			}
		}
	}
}