using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Common.Models.API;
public class AccountSymbolMasterModel
{
	public int Id { get; set; }
	public string AccountName { get; set; }
	public bool IsLive { get; set; }
	public bool Subscribed { get; set; } = true;

}
