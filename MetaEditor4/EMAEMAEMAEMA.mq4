//+------------------------------------------------------------------+
//|                                                 EMAEMAEMAEMA.mq4 |
//|                                    umutcan.yavuz2000@hotmail.com |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "umutcan.yavuz2000@hotmail.com"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


bool CTB = false;
bool CTS = false;

void MA(){
   CTB = false;
   CTS = false;
   double maSC = iMA(_Symbol, 0, 200, 0, 0, 1 ,0);
   double maSP = iMA(_Symbol, 0, 200, 0, 0, 1 ,1);
   double maFC = iMA(_Symbol, 0, 50, 0, 0, 1 ,0);
   double maFP = iMA(_Symbol, 0, 200, 0, 0, 1 ,1);
   
   if ((maSC > maFC) && (maSP < maFP)){
      CTS = true;
   }
   
   if ((maSC < maFC) && (maSP > maFP)){
      CTB = true;
   }
   
   



}
void OnTick()
  {
   int Slippage = 0;
   double BidPrice = MarketInfo(OrderSymbol(), MODE_BID);
   double AskPrice = MarketInfo(OrderSymbol(), MODE_ASK);
   int Highest = iHighest(_Symbol, 0, MODE_HIGH, 6, 0);
   int Lowest = iLowest(_Symbol, 0, MODE_LOW, 6, 0);
   int margin = 100000;
   double nTickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   MA();
  
if (CTB && OrdersTotal() == 0){
    OrderClose(OrderTicket(), OrderLots(), BidPrice, Slippage);
    double stoplossB = NormalizeDouble(10000 * (Ask - Low[Lowest]), 4);
    double lotB = (margin * 1 / 1000) / (stoplossB * nTickValue);
    lotB = MathRound(lotB / MarketInfo(Symbol(), MODE_LOTSTEP)) * MarketInfo(Symbol(), MODE_LOTSTEP);
    OrderSend(_Symbol, OP_BUY, lotB, Ask, 0, 0, 0, NULL, 0, 0, Green);
}
   
   
if (CTS && OrdersTotal() == 0){
    OrderClose(OrderTicket(), OrderLots(), AskPrice, Slippage);
    double stoplossS = NormalizeDouble(10000 * (Bid - High[Highest]), 4);
    double lotS = (margin * 1 / 1000) / (stoplossS * nTickValue);
    lotS = MathRound(lotS / MarketInfo(Symbol(), MODE_LOTSTEP)) * MarketInfo(Symbol(), MODE_LOTSTEP);
    OrderSend(_Symbol, OP_SELL, -lotS, Bid, 0, 0, 0, NULL, 0, 0, Red);
}

  }
//+------------------------------------------------------------------+
