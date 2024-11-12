using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Pragmatic.Server.TradingCentral.ZMQ;
using System.Globalization;
using System.Threading;
using System.Threading.Tasks;

namespace Pragmatic.Server.TradingCentral
{
    internal class Server(Base server, ICommandsProvider commands, ILogger<Server> logger) : BackgroundService
    {
        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            logger.LogInformation("Initializing...");
            CultureInfo.CurrentCulture = CultureInfo.InvariantCulture;
            logger.LogInformation("Culture set to invariant");

            logger.LogInformation("Starting server {0} listening on `{1}`", server.Name, server.GetListenParams());

            // Register all custom commands as defined in the AvailableCommands() Dictionary below. ("adapters" mapped to methods).
            server.AddCommands(commands.GetCommands());

            await server.Run(stoppingToken);
        }
    }
}
