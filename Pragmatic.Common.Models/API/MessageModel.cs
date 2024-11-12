using Pragmatic.Common.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Pragmatic.Common.Models.API;
public class MessageModel
{
	public int AccountId { get; set; }
	public string Recipient { get; set; } = "dennis@pragfx.com";
	public string Message { get; set; }
	public MessageType Type { get; set; }
	public DateTime MessageTime { get; set; } = DateTime.UtcNow;
}