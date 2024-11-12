using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Common.Models.Hourglass;
public class SnapshotStatsModel : SnapshotModel
{
	public string AccountName { get; set; }
	public decimal EquityPercent { get; set; }
	public decimal Weight { get; set; } = 0;
}
