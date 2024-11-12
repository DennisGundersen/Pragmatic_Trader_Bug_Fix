//+------------------------------------------------------------------+
//|                                                        Tools.mqh |
//|                                              Dennis Gundersen AS |
//|                                  https://www.dennisgundersen.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Dennis Gundersen AS"
#property link      "https://www.dennisgundersen.com"

datetime       unixEpoch = D'1970-01-01 00:00:00';

string BoolToString(bool item)
{
   return item ? "true" : "false";
}

bool StringToBool(string value)
{
   if(value == "false" || value == "0")
   {
      return false;
   }
   return true;
}

datetime IntToDateTime(int incoming)
{
   //PrintFormat("IntToDateTime, incoming: %d", incoming);
   
   //datetime result = D'1970-01-01 00:00:00';
   datetime result = unixEpoch;
   //PrintFormat("IntToDateTime, result: %d", result);
   result = result + incoming;
   //PrintFormat("IntToDateTime, result+icoming: %d", result);
   
   return result;
}

void WriteStringToFile(string json)
{
   Print("WriteStringToFile() triggered...");
   string InpFileName = "output.txt";       // File name
   string InpDirectoryName = "Data";     // Folder name

   //Print("WriteStringToFile(string json) was triggered");
   
   int file_handle = FileOpen(InpDirectoryName + "//" + InpFileName, FILE_READ|FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(file_handle != INVALID_HANDLE)
   {
      PrintFormat("%s file is available for writing", InpFileName);
      PrintFormat("File path: %s\\Files\\", TerminalInfoString(TERMINAL_DATA_PATH));
      FileWriteString(file_handle, json + "\r\n");
      //--- close the file
      FileClose(file_handle);
      PrintFormat("Data is written, %s file is closed", InpFileName);
   }
   else
   {
      PrintFormat("Failed to open %s file, Error code = %d", InpFileName, GetLastError());
   }
}

// Calculate the number of pips between two rates
int CalcPips(string argCurrency, double argRate1, double argRate2)
{
   double point = PipPoint(argCurrency);
   int pips = NormalizeDouble((argRate1-argRate2)/point, 0);
   return(pips);
}


double CalcPipValue(string argCurrency, double argRate)
{
   double pipValue = 0;
   if(argCurrency == "EURUSD")
   {
      pipValue = 10;
   }
   else if(argCurrency == "GBPUSD")
   {
      pipValue = 10;
   }
   else if(argCurrency == "NZDUSD")
   {
      pipValue = 10;
   }
   else if(argCurrency == "AUDUSD")
   {
      pipValue = 10;
   }
   else if(argCurrency == "USDCHF")
   {
      // argRate should be USDCHF
      pipValue = argRate * 10;
   }
   else if(argCurrency == "USDCAD")
   {
      // argRate should be USDCAD
      pipValue = argRate * 10;
   }
   else if(argCurrency == "USDJPY")
   {
      // argRate should be USDJPY
      pipValue = argRate / 10;
   }

   
   return(pipValue);
}


string FormatDouble(double number, int precision, string pcomma=".", string ppoint=",")
{
   string snum   = DoubleToStr(number, precision);
   int    decp   = StringFind(snum, ".", 0);
   string sright = StringSubstr(snum, decp+1, precision);
   string sleft  = StringSubstr(snum, 0, decp);
   string formated = "";
   string comma    = "";
   
   while (StringLen(sleft) > 3)
   {
      int length = StringLen(sleft);
      string part = StringSubstr(sleft, length - 3, 0);
      formated = part + comma + formated;
      comma = pcomma;
      sleft = StringSubstr(sleft, 0, length - 3);
   }
      
   if (sleft != "")
   {
      formated = sleft + comma + formated;
   }
   if (precision > 0)
   {
      formated = formated + ppoint + sright;
   }
   
   return(formated);
} 


// Calculate the correct digit format for this broker and account
double PipPoint(string argCurrency)
{
   double calcDigits = MarketInfo(argCurrency, MODE_DIGITS);
   double calcPoint = 0;

   if(calcDigits == 2 || calcDigits == 3) 
   {
      calcPoint = 0.01;
      rateDecimalNumbersToShow = 2;
   }
   else if(calcDigits == 4 || calcDigits == 5) 
   {
      calcPoint = 0.0001;
      rateDecimalNumbersToShow = 4;
   }
   return(calcPoint);
}
