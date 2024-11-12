using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Server.TradingCentral.ZMQ
{
    public interface ICommandsProvider
    {
        public Dictionary<string, Base.Cmd> GetCommands();
    }
}
