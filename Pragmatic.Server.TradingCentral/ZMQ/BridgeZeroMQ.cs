using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using NetMQ;
using NetMQ.Sockets;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Pragmatic.Server.TradingCentral.ZMQ
{
	public class BridgeZeroMQ : Base
	{
		private readonly Encoding encoding = Encoding.UTF8;
		private readonly ResponseSocket Server = new();
		private readonly ILogger Logger;
		//private readonly CancellationTokenSource CancellationToken = new();
		const string DEF_ADDRESS = "127.0.0.1";
		const string DEF_PROTOCOL = "tcp";
		const int DEF_PORT = 9001;

		public BridgeZeroMQ(IConfiguration configuration, ILogger<BridgeZeroMQ> logger) : base("HourGlass ZMQ Server")
		{
			var address = configuration.GetValue<string>("Address", DEF_ADDRESS);
			var port = configuration.GetValue<int>("Port", DEF_PORT);
			var protocol = configuration.GetValue<string>("Protocol", DEF_PROTOCOL);
			ServerAddress = $"{protocol}://{address}:{port}";
			Logger = logger;
		}

		#region IBridge

		public string ServerAddress { get; private set; } = string.Empty;

		public override async Task Run(CancellationToken stoppingToken)
		{
			using (var runtime = new NetMQRuntime())
			{
				Server.Bind(ServerAddress);
				runtime.Run(stoppingToken, ServerAsync(stoppingToken));
			}
		}
		#endregion

		#region implementation
		private async Task ServerAsync(CancellationToken token)
		{
			Logger.LogInformation("Waiting for messages...");
			while (!token.IsCancellationRequested)
			{
				var command = await ReceiveCommand(token);
				Logger.LogDebug("Received command: `{Name}`(params {Length}:{Data})", command.Name, command.Data.Length, String.Join(',', command.Data));
				string[] res = Execute(command);
				Respond(res);
			}
		}

		protected override Task<Command> ReceiveCommand(CancellationToken token)
		{
			return ReceiveCommandInternal(token);
		}

		private async Task<Command> ReceiveCommandInternal(CancellationToken token)
		{
			var (data, more) = await Server.ReceiveFrameStringAsync(encoding, token);
			string name = data;
			Logger.LogDebug("Received message: `{data}` (more: {more})", data, more);
			List<string> args = new();
			while (more)
			{
				(data, more) = await Server.ReceiveFrameStringAsync(encoding, token);
				args.Add(data);
			}
			return new Command(name, args.ToArray());

		}

		protected override void Respond(string[] response)
		{
			int last = response.Length - 1;
			for (int i = 0; i < last; ++i)
			{
				Server.SendMoreFrame(response[i]);
			}
			Server.SendFrame(response[last]);
		}

		public override string GetListenParams()
		{
			return ServerAddress;
		}

		/*
		protected override async Task ExecuteAsync(CancellationToken stoppingToken)
		{
			 using (var runtime = new NetMQRuntime())
			 {
				  Server.Bind(ServerAddress);
				  await Task.Run(() => runtime.Run(stoppingToken, ServerAsync(stoppingToken)), stoppingToken);
				  //return serverTask;
			 }
		}
		*/

		#endregion
	}
}