using Microsoft.Extensions.Logging;
//using Pragmatic.Common.Entities;
//using Pragmatic.Common.Entities.DTOs;
using Pragmatic.Common.Models;
using Pragmatic.Common.Models.API;
using Pragmatic.Common.Models.Hourglass;
//using Pragmatic.Core.Services.Interfaces;
using Pragmatic.Server.TradingCentral.Interfaces;
using System;
using System.Collections.Generic;

namespace Pragmatic.Server.TradingCentral.Services
{
	public class MQL4ConverterService (): IMQL4ConverterService
	{

		public bool ConvertIntToBool(int i)
		{
			try
			{
				bool result = false;
				if (i == 1)
				{
					result = true;
				}
				return result;
			}
			catch (Exception ex)
			{
				throw new Exception("MQL4ConverterService.ConvertIntToBool exception", ex);
			}
		}

		public int ConvertBoolToInt(bool r)
		{
			try
			{
				int result = 0;
				if (r)
				{
					result = 1;
				}
				return result;
			}
			catch (Exception ex)
			{
				throw new Exception("MQL4ConverterService.ConvertBoolToInt exception", ex);
			}
		}

		public bool ArrayToHourglassAccountRegistrationModel(string[] data, ref int currentPosition, AccountRegistrationModel model)
		{
			bool r = false;
			int valI = 0;
			decimal valD = 0;

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);                // 0
				if (!r) return false;
				model.AccountNumber = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing AccountNumber", e);
			}

			try
			{
				model.AccountName = data[currentPosition++].ToString();               // 1
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing AccountName", e);
			}

			try
			{
				model.Symbol = data[currentPosition++].ToString();                    // 2
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing Symbol", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 3
				if (!r) return false;
				model.TradingLotSize = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing TradingLotSize", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 4
				if (!r) return false;
				model.ExtremeTopRate = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing ExtremeTopRate", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 5
				if (!r) return false;
				model.NormalTopRate = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing NormalTopRate", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 6
				if (!r) return false;
				model.CenterRate = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing CenterRate", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 7
				if (!r) return false;
				model.NormalBottomRate = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing NormalBottomRate", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        //  8
				if (!r) return false;
				model.ExtremeBottomRate = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing ExtremeBottomRate", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 9
				if (!r) return false;
				model.MaxPlacementDistance = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing MaxPlacementDistance", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 10
				if (!r) return false;
				model.TestUpToRate = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing TestUpToRate", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 11
				if (!r) return false;
				model.TestDownToRate = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing TestDownToRate", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 12
				if (!r) return false;
				model.TestPipsUp = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing TestPipsUp", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 13
				if (!r) return false;
				model.TestPipsDown = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing TestPipsDown", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 14
				if (!r) return false;
				model.BalancerMinPlacementDistanceLongs = valI;

			}
			catch (Exception e)
			{
				throw new Exception("Error parsing BalancerMinPlacementDistanceLongs", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 15
				if (!r) return false;
				model.BalancerMinPlacementDistanceShorts = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing BalancerMinPlacementDistanceShorts", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 16
				if (!r) return false;
				model.LongStabilizerSizeFactor = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing LongStabilizerSizeFactor", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 17
				if (!r) return false;
				model.ShortStabilizerSizeFactor = valI;

			}
			catch (Exception e)
			{
				throw new Exception("Error parsing ShortStabilizerSizeFactor", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 18
				if (!r) return false;
				model.LongBalancerSizeFactor = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing LongBalancerSizeFactor", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 19
				if (!r) return false;
				model.ShortBalancerSizeFactor = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing ShortBalancerSizeFactor", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 20
				if (!r) return false;
				model.PrimerSizeFactor = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing PrimerSizeFactor", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 21
				if (!r) return false;
				model.BalancerStopLossPips = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing BalancerStopLossPips", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 22
				if (!r) return false;
				model.SecurePips = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing SecurePips", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);              // 23
				if (!r) return false;
				model.AutoLotIncrease = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing AutoLotIncrease", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 24
				if (!r) return false;
				model.AutoLotSafeEQLevel = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing AutoLotSafeEQLevel", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 25
				if (!r) return false;
				model.TakeProfit = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing TakeProfit", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);           // 26
				if (!r) return false;
				model.TradeMidTerm = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing TradeMidTerm", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 27
				if (!r) return false;
				model.FixedSpread = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing FixedSpread", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 28
				if (!r) return false;
				model.ExtraLongBuffer = valI;

			}
			catch (Exception e)
			{
				throw new Exception("Error parsing ExtraLongBuffer", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 29
				if (!r) return false;
				model.ExtraShortBuffer = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing ExtraShortBuffer", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 30
				if (!r) return false;
				model.WarningLevel = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing WarningLevel", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 31
				if (!r) return false;
				model.HeartbeatMonitorTimer = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing HeartbeatMonitorTimer", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 32
				if (!r) return false;
				model.SnapshotLogTimer = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing DatabaseLogTimer", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);           // 33
				if (!r) return false;
				model.AutoCloseExtremes = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing AutoCloseExtremes", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);           // 34
				if (!r) return false;
				model.RunBalancers = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing RunBalancers", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);           // 35
				if (!r) return false;
				model.RunStabilizers = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing RunStabilizers", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);           // 36
				if (!r) return false;
				model.RunBreakouts = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing RunBreakouts", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);           // 37
				if (!r) return false;
				model.RunWhiplash = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing RunWhiplash", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);           // 38
				if (!r) return false;
				model.RunPrimers = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing RunPrimers", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 39
				if (!r) return false;
				model.GMTOffset = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing GMTOffset", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 40
				if (!r) return false;
				model.UsePoint = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing UsePoint", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 41
				if (!r) return false;
				model.RateDecimalNumbersToShow = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing RateDecimalNumbersToShow", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);           // 42
				if (!r) return false;
				model.IsAccountMaster = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing IsAccountMaster", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);           // 43
				if (!r) return false;
				model.IsSymbolMaster = ConvertIntToBool(valI);
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing IsSymbolMaster", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 44
				if (!r) return false;
				model.ScreenshotTimer = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing ScreenshotTimer", e);
			}

			try
			{
				r = int.TryParse(data[currentPosition++], out valI);            // 45
				if (!r) return false;
				model.MaxWeight = valI;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing MaxWeight", e);
			}

			try
			{
				model.DataFolder = data[currentPosition++].ToString();                    // 46
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing DataFolder", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);            // 47
				if (!r) return false;
				model.AccountPercentage = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing AccountPercentage", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 48
				if (!r) return false;
				model.Ask = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing Ask", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 49
				if (!r) return false;
				model.Bid = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing Bid", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 50
				if (!r) return false;
				model.Balance = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing Balance", e);
			}

			try
			{
				r = decimal.TryParse(data[currentPosition++], out valD);        // 51
				if (!r) return false;
				model.Equity = valD;
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing Equity", e);
			}
			return true;
		}

		// Used by tester only
		//public bool HourglassAccountRegistrationDTOToList(ref List<string> payload, AccountRegistrationDTO dto)
		//{
		//	try
		//	{
		//		payload.Add(dto.AccountNumber.ToString());
		//		payload.Add(dto.AccountName.ToString());
		//		payload.Add(dto.Symbol.ToString());

		//		payload.Add(dto.TradingLotSize.ToString());
		//		payload.Add(dto.ExtremeTopRate.ToString());
		//		payload.Add(dto.NormalTopRate.ToString());
		//		payload.Add(dto.CenterRate.ToString());
		//		payload.Add(dto.NormalBottomRate.ToString());
		//		payload.Add(dto.ExtremeBottomRate.ToString());

		//		payload.Add(dto.MaxPlacementDistance.ToString());
		//		payload.Add(dto.TestUpToRate.ToString());
		//		payload.Add(dto.TestDownToRate.ToString());
		//		payload.Add(dto.TestPipsUp.ToString());
		//		payload.Add(dto.TestPipsDown.ToString());
		//		payload.Add(dto.BalancerMinPlacementDistanceLongs.ToString());
		//		payload.Add(dto.BalancerMinPlacementDistanceShorts.ToString());

		//		payload.Add(dto.LongStabilizerSizeFactor.ToString());
		//		payload.Add(dto.ShortStabilizerSizeFactor.ToString());
		//		payload.Add(dto.LongBalancerSizeFactor.ToString());
		//		payload.Add(dto.ShortBalancerSizeFactor.ToString());
		//		payload.Add(dto.PrimerSizeFactor.ToString());
		//		payload.Add(dto.BalancerStopLossPips.ToString());
		//		payload.Add(dto.SecurePips.ToString());

		//		//b = Helpers.Converters.ConvertBoolToInt(dto.AutoLotIncrease);
		//		payload.Add(ConvertBoolToInt(dto.AutoLotIncrease).ToString());
		//		payload.Add(dto.AutoLotSafeEQLevel.ToString());
		//		payload.Add(dto.TakeProfit.ToString());
		//		payload.Add(ConvertBoolToInt(dto.TradeMidTerm).ToString());
		//		payload.Add(dto.FixedSpread.ToString());
		//		payload.Add(dto.ExtraLongBuffer.ToString());
		//		payload.Add(dto.ExtraShortBuffer.ToString());

		//		payload.Add(dto.WarningLevel.ToString());
		//		payload.Add(dto.HeartbeatMonitorTimer.ToString());
		//		payload.Add(dto.SnapshotLogTimer.ToString());
		//		payload.Add(ConvertBoolToInt(dto.AutoCloseExtremes).ToString());

		//		payload.Add(ConvertBoolToInt(dto.RunBalancers).ToString());
		//		payload.Add(ConvertBoolToInt(dto.RunStabilizers).ToString());
		//		payload.Add(ConvertBoolToInt(dto.RunBreakouts).ToString());
		//		payload.Add(ConvertBoolToInt(dto.RunWhiplash).ToString());
		//		payload.Add(ConvertBoolToInt(dto.RunPrimers).ToString());

		//		payload.Add(dto.GMTOffset.ToString());
		//		payload.Add(dto.UsePoint.ToString());
		//		payload.Add(dto.RateDecimalNumbersToShow.ToString());
		//		payload.Add(ConvertBoolToInt(dto.IsAccountMaster).ToString());
		//		payload.Add(ConvertBoolToInt(dto.IsSymbolMaster).ToString());

		//		payload.Add(dto.ScreenshotTimer.ToString());
		//		payload.Add(dto.MaxWeight.ToString());
		//		payload.Add(dto.DataFolder.ToString());
		//		payload.Add(dto.AccountPercentage.ToString());
		//		payload.Add(dto.Ask.ToString());
		//		payload.Add(dto.Bid.ToString());
		//		payload.Add(dto.Balance.ToString());
		//		payload.Add(dto.Equity.ToString());

		//		return true;
		//	}
		//	catch (Exception ex)
		//	{
		//		throw new Exception("MQL4ConverterService.HourglassAccountRegistrationDTOToList exception", ex);
		//	}
		//}

		// Used by tester only
		//public bool ArrayToHourglassAccountRegistrationResultDTO(string[] data, ref int currentPosition, AccountRegistrationResultDTO dto)
		//{
		//	// currentPosition is starting from [1], as [0] is the response code "OK"
		//	bool success = true;
		//	int valInt;
		//	decimal valDecimal;
		//	DateTime valDate;

		//	try
		//	{
		//		success = int.TryParse(data[currentPosition++], out valInt);
		//		if (!success) return false;
		//		dto.Id = valInt;
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing Id", e);
		//	}

		//	try
		//	{
		//		success = int.TryParse(data[currentPosition++], out valInt);
		//		if (!success) return false;
		//		dto.StrategyId = valInt;
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing StrategyId", e);
		//	}

		//	try
		//	{
		//		success = int.TryParse(data[currentPosition++], out valInt);
		//		if (!success) return false;
		//		dto.AccountNumber = valInt;
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing AccountNumber", e);
		//	}

		//	try
		//	{
		//		dto.AccountName = data[currentPosition++];
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing AccountName", e);
		//	}

		//	try
		//	{
		//		dto.BrokerName = data[currentPosition++];
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing BrokerName", e);
		//	}

		//	try
		//	{
		//		dto.Symbol = data[currentPosition++];
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing Symbol", e);
		//	}

		//	try
		//	{
		//		success = decimal.TryParse(data[currentPosition++], out valDecimal);
		//		if (!success) return false;
		//		dto.StepGrowthFactor = valDecimal;
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing StepGrowthFactor", e);
		//	}

		//	try
		//	{
		//		success = decimal.TryParse(data[currentPosition++], out valDecimal);
		//		if (!success) return false;
		//		dto.StartingBalance = valDecimal;
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing StartingBalance", e);
		//	}

		//	try
		//	{
		//		success = int.TryParse(data[currentPosition++], out valInt);
		//		if (!success) return false;
		//		dto.StartFactor = valInt;
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing StartFactor", e);
		//	}

		//	try
		//	{
		//		success = decimal.TryParse(data[currentPosition++], out valDecimal);
		//		if (!success) return false;
		//		dto.Commission = valDecimal;
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing Commission", e);
		//	}

		//	try
		//	{
		//		success = int.TryParse(data[currentPosition++], out valInt);
		//		if (!success) return false;
		//		dto.IsLive = ConvertIntToBool(valInt);
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing IsLive", e);
		//	}

		//	try
		//	{
		//		dto.AccountCurrency = data[currentPosition++];
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing AccountCurrency", e);
		//	}

		//	try
		//	{
		//		success = DateTime.TryParse(data[currentPosition++], out valDate);
		//		if (!success) return false;
		//		dto.RegisteredTime = valDate;
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing RegisteredTime", e);
		//	}

		//	try
		//	{
		//		success = int.TryParse(data[currentPosition++], out valInt);
		//		if (!success) return false;
		//		dto.LastOrderClose = valInt;
		//	}
		//	catch (System.Exception e)
		//	{
		//		throw new System.Exception("Error parsing LastOrderClose", e);
		//	}
		//	return true;
		//}

		public List<string> HourglassAccountRegistrationResultModelToListOfString(AccountRegistrationResultModel model)
		{
			try
			{
				List<string> result = new List<string>
				{
					 model.Id.ToString(),
					 model.StrategyId.ToString(),
					 model.AccountNumber.ToString(),
					 model.AccountName,
					 model.BrokerName,
					 model.Symbol,
					 //Skipping Security as it's not needed in the EA (and I don't want to mess with the string[])
					 //model.Security.ToString(),
					 model.StepGrowthFactor.ToString(),
					 model.StartingBalance.ToString(),
					 model.StartFactor.ToString(),
					 model.Commission.ToString(),
					 ConvertBoolToInt(model.IsLive).ToString(),
					 model.AccountCurrency,
					 model.RegisteredTime.ToString(),
					 model.LastOrderClose.ToString()
				};

				return result;
			}
			catch (Exception ex)
			{
				throw new Exception("MQL4ConverterService.HourglassAccountRegistrationResultModelToListOfString exception", ex);
			}
		}

		public bool ArrayToHourglassAccountStatisticsModel(string[] data, ref int currentPosition, StatisticsModel result)
		{
			// currentPosition is starting from [1], as [0] is the response code "OK"
			bool success = true;
			int valInt;
			decimal valDecimal;

			// Overview
			try
			{
				success = int.TryParse(data[currentPosition++], out valInt);
				if (!success) return false;
				result.AccountId = valInt;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing Id", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.Longs = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing Longs", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.Shorts = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing Shorts", e);
			}
			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.LongBalancers = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing Balance", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.ShortBalancers = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing Equity", e);
			}

			try
			{
				success = int.TryParse(data[currentPosition++], out valInt);
				if (!success) return false;
				result.CurrentStep = valInt;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing CurrentStep", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.NextLotSize = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing NextLot", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.NextLotIncrease = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing NextLotIncrease", e);
			}
			try
			{
				success = int.TryParse(data[currentPosition++], out valInt);
				if (!success) return false;
				result.NextLotIncreaseOrders = valInt;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing OrderCount", e);
			}

			try
			{
				success = int.TryParse(data[currentPosition++], out valInt);
				if (!success) return false;
				result.OrderCount = valInt;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing OrderCount", e);
			}


			// Upward
			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.UpRate = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing UpRate", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.UpEquity = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing UpEquity", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.UpBalance = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing UpBalance", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.UpLongs = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing UpLongs", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.UpShorts = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing UpShorts", e);
			}


			// Top
			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.TopRate = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing TopRate", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.TopEquity = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing TopEquity", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.TopBalance = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing TopBalance", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.TopLongs = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing TopLongs", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.TopShorts = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing TopShorts", e);
			}

			// Center
			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.CenterRate = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing CenterRate", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.CenterEquity = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing CenterEquity", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.CenterBalance = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing CenterBalance", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.CenterLongs = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing CenterLongs", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.CenterShorts = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing CenterShorts", e);
			}

			// Downward
			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.DownRate = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing DownRate", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.DownEquity = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing DownEquity", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.DownBalance = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing DownBalance", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.DownLongs = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing DownLongs", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.DownShorts = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing DownShorts", e);
			}

			// Bottom
			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.BottomRate = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing BottomRate", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.BottomEquity = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing BottomEquity", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.BottomBalance = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing BottomBalance", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.BottomLongs = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing BottomLongs", e);
			}

			try
			{
				success = decimal.TryParse(data[currentPosition++], out valDecimal);
				if (!success) return false;
				result.BottomShorts = valDecimal;
			}
			catch (System.Exception e)
			{
				throw new System.Exception("Error parsing BottomShorts", e);
			}

			return true;

		}

		public List<string> HourglassAccountStatisticsModelToListOfString(StatisticsModel result)
		{
			try
			{
				List<string> stats = new List<string>
				{
					 result.AccountId.ToString(),
					 result.Longs.ToString(),
					 result.Shorts.ToString(),
					 result.LongBalancers.ToString(),
					 result.ShortBalancers.ToString(),
					 result.CurrentStep.ToString(),
					 result.NextLotSize.ToString(),
					 result.NextLotIncrease.ToString(),
					 result.NextLotIncreaseOrders.ToString(),
					 result.OrderCount.ToString(),
					 result.UpRate.ToString(),
					 result.UpEquity.ToString(),
					 result.UpBalance.ToString(),
					 result.UpLongs.ToString(),
					 result.UpShorts.ToString(),
					 result.TopRate.ToString(),
					 result.TopEquity.ToString(),
					 result.TopBalance.ToString(),
					 result.TopLongs.ToString(),
					 result.TopShorts.ToString(),
					 result.CenterRate.ToString(),
					 result.CenterEquity.ToString(),
					 result.CenterBalance.ToString(),
					 result.CenterLongs.ToString(),
					 result.CenterShorts.ToString(),
					 result.DownRate.ToString(),
					 result.DownEquity.ToString(),
					 result.DownBalance.ToString(),
					 result.DownLongs.ToString(),
					 result.DownShorts.ToString(),
					 result.BottomRate.ToString(),
					 result.BottomEquity.ToString(),
					 result.BottomBalance.ToString(),
					 result.BottomLongs.ToString(),
					 result.BottomShorts.ToString()
				};

				return stats;
			}
			catch (Exception ex)
			{
				throw new Exception("MQL4ConverterService.HourglassAccountStatisticsModelToListOfString exception", ex);
			}

		}

		public List<string> HourglassChangeOrderModelToListOfString(List<ChangeOrderModel> changeOrderItems)
		{
			try
			{
				List<string> result = new List<string>
				{
					 changeOrderItems.Count.ToString()
				};

				foreach (var item in changeOrderItems)
				{
					result.Add(item.Ticket.ToString());
					result.Add(item.OrderType.ToString());
					result.Add(item.Lots.ToString());
					result.Add(item.OpenRate.ToString());
					result.Add(item.StopLossRate.ToString());
					result.Add(item.TakeProfitRate.ToString());
					result.Add(item.OrderFunction.ToString());
					result.Add(item.Action.ToString());
					result.Add(item.Comment);
				}
				return result;
			}
			catch (Exception ex)
			{
				throw new Exception("MQL4ConverterService.HourglassChangeOrderModelToListOfString exception", ex);
			}

		}

		//public List<string> ApiResultDTOToListOfString(ApiResultDTO dto)
		//{
		//	try
		//	{
		//		List<string> result = new List<string>();

		//		result.Add(dto.Success.ToString());
		//		result.Add(dto.Message);
		//		result.Add(dto.ErrorCode);
		//		result.Add(dto.ErrorDescription);

		//		return result;
		//	}
		//	catch (Exception ex)
		//	{
		//		throw new Exception("MQL4ConverterService.ApiResultDTOToListOfString exception", ex);
		//	}
		//}

		//public List<string> ApiResultDTOToBoolOnly(ApiResultDTO dto)
		//{
		//	try
		//	{
		//		List<string> result = new List<string>();

		//		result.Add(dto.Success.ToString());

		//		return result;
		//	}
		//	catch (Exception ex)
		//	{
		//		throw new Exception("MQL4ConverterService.ApiResultDTOToBoolOnly exception", ex);
		//	}

		//}

		public List<string> BoolToListOfString(bool input)
		{
			try
			{
				List<string> result = new List<string>();

				result.Add(input.ToString());

				return result;
			}
			catch (Exception ex)
			{
				throw new Exception("MQL4ConverterService.BoolToListOfString exception", ex);
			}
		}

		public List<string> IntToListOfString(int input)
		{
			try
			{
				List<string> result = new List<string>();

				result.Add(input.ToString());

				return result;
			}
			catch (Exception ex)
			{
				throw new Exception("MQL4ConverterService.IntToListOfString exception", ex);
			}
		}

		public bool ArrayToListOfOrderModel(string[] data, ref int currentPosition, ref List<OrderModel> ordersList)
		{
			// Get the order count from the first element
			int orderCount = 0;
			bool r = false;

			int valInt;
			decimal valDecimal;

			// Find the amount of incoming orders
			try
			{
				r = int.TryParse(data[currentPosition++], out valInt);
				if (!r) return false;
				orderCount = valInt;                                                // 0
			}
			catch (Exception e)
			{
				throw new Exception("Error parsing Order Count", e);
			}


			// Loop through the orders
			for (int i = 0; i < orderCount; i++)
			{
				OrderModel order = new OrderModel();
				try
				{
					r = int.TryParse(data[currentPosition++], out valInt);
					if (!r) return false;
					order.Ticket = valInt;                                        // 1
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing Ticket", e);
				}

				try
				{
					r = int.TryParse(data[currentPosition++], out valInt);
					if (!r) return false;
					order.OrderType = valInt;                                     // 2
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing OrderType", e);
				}

				try
				{
					r = decimal.TryParse(data[currentPosition++], out valDecimal);
					if (!r) return false;
					order.Lots = valDecimal;                                      // 3
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing Lots", e);
				}

				try
				{
					r = int.TryParse(data[currentPosition++], out valInt);
					if (!r) return false;
					order.OpenTime = valInt;                                      // 4
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing OpenTime", e);
				}

				try
				{
					r = int.TryParse(data[currentPosition++], out valInt);
					if (!r) return false;
					order.CloseTime = valInt;                                     // 5
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing CloseTime", e);
				}

				try
				{
					order.Symbol = data[currentPosition++];                       // 6
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing Symbol", e);
				}
				try
				{
					r = decimal.TryParse(data[currentPosition++], out valDecimal);
					if (!r) return false;
					order.OpenRate = valDecimal;                                  // 7
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing OpenRate", e);
				}

				try
				{
					r = decimal.TryParse(data[currentPosition++], out valDecimal);
					if (!r) return false;
					order.CloseRate = valDecimal;                                 // 8
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing CloseRate", e);
				}

				try
				{
					r = decimal.TryParse(data[currentPosition++], out valDecimal);
					if (!r) return false;
					order.StopLossRate = valDecimal;                              // 9
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing StopLossRate", e);
				}

				try
				{
					r = decimal.TryParse(data[currentPosition++], out valDecimal);
					if (!r) return false;
					order.TakeProfitRate = valDecimal;                            // 10
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing TakeProfitRate", e);
				}

				try
				{
					r = decimal.TryParse(data[currentPosition++], out valDecimal);
					if (!r) return false;
					order.Swap = valDecimal;                                      // 11
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing Swap", e);
				}

				try
				{
					r = decimal.TryParse(data[currentPosition++], out valDecimal);
					if (!r) return false;
					order.Commission = valDecimal;                                // 12
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing Commission", e);
				}

				try
				{
					r = decimal.TryParse(data[currentPosition++], out valDecimal);
					if (!r) return false;
					order.Profit = valDecimal;                                    // 13
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing Profit", e);
				}

				try
				{
					order.Comment = data[currentPosition++];                      // 14
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing Comment", e);
				}

				try
				{
					r = int.TryParse(data[currentPosition++], out valInt);
					if (!r) return false;
					order.AccountId = valInt;                                     // 15
				}
				catch (Exception e)
				{
					throw new Exception("Error parsing AccountId", e);
				}

				// OrderFunction and PlannedOpenRate must be in the Business Logic it's not found in an MT4 OrderSelect() call
				ordersList.Add(order);
			}
			return true;
		}

	}
}
