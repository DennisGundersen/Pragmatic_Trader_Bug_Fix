using System;

namespace Pragmatic.Common.Models
{
    public class AlertModel
    {
        public int Id { get; set; }
        public decimal Rate { get; set; } = 1.0000M;
        public bool TriggerAbove { get; set; } = false;
        public bool IsActive { get; set; } = true;
		public string UserTag { get; set; } = "dennis@pragfx.com";
        public DateTime LastUpdated { get; set; } = DateTime.UtcNow;
        public int AccountId { get; set; }
    }
}
