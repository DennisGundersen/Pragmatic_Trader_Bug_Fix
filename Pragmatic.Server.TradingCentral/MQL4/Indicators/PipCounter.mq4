//+------------------------------------------------------------------+
//|                                                   PipCounter.mq4 |
//|                                                 Dennis Gundersen |
//|                                   http://www.dennisgundersen.com |
//+------------------------------------------------------------------+
#property copyright "Dennis Gundersen"
#property link      "http://www.dennisgundersen.com"
#property version   "1.00"
#property strict

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  clrSilver
#property indicator_width1  1

double Range_Buffer[];
int PipFactor = 1;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{

   //---- indicators
   //---- drawing settings
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, Range_Buffer);
   SetIndexLabel(0, "Pips in candle:");
   
   //---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Pip counter");
   IndicatorDigits(1);
   
   // Counter for fractional pips
   if (Digits == 3 || Digits == 5)
   {
      PipFactor = 10;
   }
   
   return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

   int limit;
   int counted_bars = IndicatorCounted();
   //---- last counted bar will be recounted
   if(counted_bars > 0) 
   {
      counted_bars--;
   }
   limit = Bars - counted_bars;

   for(int i=0; i < limit; i++)
   {
      Range_Buffer[i] = ((High[i]-Low[i]) / Point) / PipFactor;   
   }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Indicator tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
}