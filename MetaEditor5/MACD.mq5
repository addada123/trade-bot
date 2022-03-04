//+------------------------------------------------------------------+
//|                                                          EMA.mq5 |
//|                                    umutcan.yavuz2000@hotmail.com |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "umutcan.yavuz2000@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


bool CTB = false;
bool CTS = false;


void CheckMACD(){//MACD CONTROL
   CTB = false;
   CTS = false;
   
   double MACD_MainC = iMACD(_Symbol, 0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1);
   double MACD_MainP = iMACD(_Symbol, 0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 2);
   double MACD_SignalC = iMACD(_Symbol, 0, 12, 26, 9, PRICE_CLOSE, MODE_SIGNAL, 1);
   double MACD_SignalP = iMACD(_Symbol, 0, 12, 26, 9, PRICE_CLOSE, MODE_SIGNAL, 2);
   
   if ((MACD_MainC > MACD_SignalC) && (MACD_MainP < MACD_SignalP) && MACD_MainC < 0 && MACD_SignalC < 0){
      CTB = true;
      Print("Buy");
   }
   
   if ((MACD_MainC < MACD_SignalC) && (MACD_MainP > MACD_SignalP) && MACD_MainC > 0 && MACD_SignalC > 0){
      CTS = true;
      Print("Sell");
   }
   else
   {
      return;
   }
}




void OnTick()
  {
  
 
int Highest = iHighest(_Symbol, 0, MODE_HIGH, 12, 0);
int Lowest = iLowest(_Symbol, 0, MODE_LOW, 12, 0);
int margin = 10000;
double nTickValue = MarketInfo(_Symbol, MODE_TICKVALUE);
string signal = "";
CheckMACD();
double MAsc = iMA(Symbol(), 0, 200, 0, MODE_EMA, PRICE_CLOSE, 0);
if (Open[0] > MAsc)
 {
 signal = "Buy";
 }
  
if (Open[0] < MAsc)
 {
 signal = "Sell";
 }
  
  
if (CTB && signal == "Buy"){
    double stoplossB = NormalizeDouble(10000 * (Ask - Low[Lowest]), 4);
    double lotB = (margin * 1 / 1000) / (stoplossB * nTickValue);
    lotB = MathRound(lotB / MarketInfo(Symbol(), MODE_LOTSTEP)) * MarketInfo(Symbol(), MODE_LOTSTEP);
    OrderSend(_Symbol, OP_BUY, lotB, Ask, 0, Ask - int(100000*(Ask - Low[Lowest]) + 10)*_Point, Ask + (int(100000*(Ask - Low[Lowest]))*_Point * 200/100), NULL, 0, 0, Green);
}
  
if (CTS && signal == "Sell"){
    double stoplossS = NormalizeDouble(10000 * (Bid - High[Highest]), 4);
    double lotS = (margin * 1 / 1000) / (stoplossS * nTickValue);
    lotS = MathRound(lotS / MarketInfo(Symbol(), MODE_LOTSTEP)) * MarketInfo(Symbol(), MODE_LOTSTEP);
    OrderSend(_Symbol, OP_SELL, -lotS, Bid, 0, Bid - int(100000*(Bid - High[Highest]) - 10)*_Point, Bid + (int(100000*(Bid - High[Highest]))*_Point * 200/100), NULL, 0, 0, Red);
}


}
//+------------------------------------------------------------------+
