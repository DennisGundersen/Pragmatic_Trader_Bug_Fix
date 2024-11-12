namespace Pragmatic.Server.TradingCentral.ZMQ
{
    public readonly record struct Command(string Name, string[] Data);
}
