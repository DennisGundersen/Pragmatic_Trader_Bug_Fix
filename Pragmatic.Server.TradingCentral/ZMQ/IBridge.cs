using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace Pragmatic.Server.TradingCentral.ZMQ
{
    public interface IBridge //: IDisposable
    {
        public string Name { get; }

        public Task Run(CancellationToken cancellationToken);
        //public void Stop();
    }
}