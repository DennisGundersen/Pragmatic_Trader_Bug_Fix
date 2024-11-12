using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;

namespace Pragmatic.Server.TradingCentral.ZMQ
{
    public abstract class Base : IBridge
    {
        public const string RESP_OK = "OK";
        public const string RESP_ERROR = "ERR";

        public delegate string[] Cmd(string[] input);
        protected Dictionary<string, Cmd> BaseCommands;
        protected Dictionary<string, Cmd> CustomCommands;
        private readonly string version = "1.0";

        public string Name { get; private set; } = "?";

        protected Base(string name)
        {
            version = Assembly.GetEntryAssembly()?.GetCustomAttribute<AssemblyFileVersionAttribute>()?.Version ?? "?";
            BaseCommands = new Dictionary<string, Cmd>()
            {
                { "HELO", Welcome },
                { "Version", Version },
                { "Tic", Tac }
            };
            CustomCommands = new Dictionary<string, Cmd>();
            Name = name;
        }

        public void AddCommands(Dictionary<string, Cmd> newCommands)
        {
            foreach (var command in newCommands)
            {
                CustomCommands[command.Key] = command.Value;
                //UserCommands.TryAdd(command.Key, command.Value);
            }
        }

        public string[] Execute(Command command)
        {
            Cmd cmd = null;
            try
            {
                if (BaseCommands.TryGetValue(command.Name, out cmd))
                {
                    Console.WriteLine("Executing Standard Command: {0}({1})", command.Name, command.Data);
                    return cmd.Invoke(command.Data);
                }
                if (CustomCommands.TryGetValue(command.Name, out cmd))
                {
                    //Console.WriteLine("Executing Custom Command: {0}({1})", command.Name, command.Data);
                    return cmd.Invoke(command.Data);
                }
                Console.WriteLine("Received unknown command {0}({1})", command.Name, string.Join(" | ", command.Data));
                return Response("Unknown command", ResponseType.Error);
            }
            catch (JsonException ex)
            {
                Console.WriteLine("Exception related to JSON mapping");
                Console.WriteLine("Path: `{0}`, Message: `{1}`", ex.Path, ex.Message);
                return Response("Exception during JSON mapping", ResponseType.Error);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception during command execution");
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.StackTrace);
                return Response("Exception during command execution", ResponseType.Error);
            }
        }

        public string[] Welcome(string[] input) => new string[] { RESP_OK, "EHLO" };

        public string[] Version(string[] input) => new string[] { RESP_OK, version };

        public string[] Tac(string[] input) => new string[] { RESP_OK, "Tac " + input };

        protected string[] Response(IEnumerable<string> response, ResponseType type = ResponseType.OK)
        {
            return response.Prepend(ResponseHeader(type)).ToArray();
        }

        protected string[] Response(string response, ResponseType type = ResponseType.OK)
        {
            return new string[] { ResponseHeader(type), response };
        }

        private string ResponseHeader(ResponseType type)
        {
            if (type == ResponseType.OK)
            {
                return RESP_OK;
            }
            return RESP_ERROR;
        }

        protected abstract Task<Command> ReceiveCommand(CancellationToken token);
        protected abstract void Respond(string[] response);

        public abstract Task Run(CancellationToken stoppingToken);

        //public abstract void Stop();

        public abstract string GetListenParams();

    }
}