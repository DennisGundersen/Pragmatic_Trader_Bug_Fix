//using Pragmatic.Common.Entities;
//using Pragmatic.Common.Entities.DTOs;
using Pragmatic.Common.Models;
using Pragmatic.Common.Models.API;
using Pragmatic.Common.Models.Hourglass;
using System.Collections.Generic;

namespace Pragmatic.Server.TradingCentral.Interfaces
{
	public interface IMQL4ConverterService
	{
		//List<string> ApiResultDTOToBoolOnly(ApiResultDTO dto);
		//List<string> ApiResultDTOToListOfString(ApiResultDTO dto);
		bool ArrayToHourglassAccountRegistrationModel(string[] data, ref int currentPosition, AccountRegistrationModel dto);
		bool ArrayToHourglassAccountStatisticsModel(string[] data, ref int currentPosition, StatisticsModel result);
		bool ArrayToListOfOrderModel(string[] data, ref int currentPosition, ref List<OrderModel> ordersList);
		List<string> BoolToListOfString(bool input);
		int ConvertBoolToInt(bool r);
		bool ConvertIntToBool(int i);
		//bool HourglassAccountRegistrationDTOToList(ref List<string> payload, AccountRegistrationDTO dto);
		List<string> HourglassAccountRegistrationResultModelToListOfString(AccountRegistrationResultModel model);
		List<string> HourglassAccountStatisticsModelToListOfString(StatisticsModel result);
		List<string> HourglassChangeOrderModelToListOfString(List<ChangeOrderModel> changeOrderItems);
		List<string> IntToListOfString(int input);
	}
}