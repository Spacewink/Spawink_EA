//+------------------------------------------------------------------+
//|                                                   Spawink_RiskManagement.mq4 |
//|                                Copyright 2023, Your Name Here      |
//|                                                https://www.example.com |
//+------------------------------------------------------------------+

#property strict

#include "Spawink.mqh"

// Money management parameters
extern double RiskPercent = 2.0; // Percentage of account balance to risk per trade
extern int MaxTrades = 5; // Maximum number of open trades
extern double LotSize = 0.01; // Default lot size to use when calculating trade size
extern bool UseFixedLotSize = false; // Whether to use a fixed lot size instead of calculating dynamically

//+------------------------------------------------------------------+
//| Calculate the lot size to use for a new trade                      |
//+------------------------------------------------------------------+
double CalculateLotSize(double riskAmount, double stopLoss)
{
    if (UseFixedLotSize)
    {
        return LotSize;
    }
    else
    {
        double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
        double balance = AccountBalance();
        double lotSize = NormalizeDouble(riskAmount / (stopLoss * tickSize * 100000.0), 2);
        lotSize = MathMin(lotSize, NormalizeDouble(balance * RiskPercent / 100.0 / stopLoss / tickSize / 100000.0, 2));
        return MathMax(lotSize, SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN));
    }
}

//+------------------------------------------------------------------+
//| Check if it is safe to open a new trade                            |
//+------------------------------------------------------------------+
bool IsSafeToOpenTrade(int magicNumber)
{
    int numOpenTrades = CountOpenTrades(magicNumber);
    if (numOpenTrades >= MaxTrades)
    {
        return false;
    }
    else
    {
        return true;
    }
}

//+------------------------------------------------------------------+
//| Calculate the stop loss for a trade based on the current price    |
//+------------------------------------------------------------------+
double CalculateStopLoss(int tradeType, double entryPrice)
{
    if (tradeType == OP_BUY)
    {
        return entryPrice - (iATR(_Symbol, _Period, 14, 0) * 1.5);
    }
    else if (tradeType == OP_SELL)
    {
        return entryPrice + (iATR(_Symbol, _Period, 14, 0) * 1.5);
    }
    else
    {
        Print("Error: Invalid trade type specified in CalculateStopLoss");
        return 0.0;
    }
}

//+------------------------------------------------------------------+
//| Open a new trade using the specified parameters                   |
//+------------------------------------------------------------------+
bool OpenTrade(int tradeType, double lotSize, double stopLoss, double takeProfit, int magicNumber)
{
    if (!IsSafeToOpenTrade(magicNumber))
    {
        return false;
    }
    
    int ticket = OrderSend(_Symbol, tradeType, lotSize, Ask, 3, stopLoss, takeProfit, "Spawink", magicNumber, 0, Green);
    if (ticket > 0)
    {
        Print("Opened trade ", ticket, " at ", (tradeType == OP_BUY ? Ask : Bid));
        return true;
    }
    else
    {
        Print("Error opening trade: ", GetLastError());
        return false;
    }
}

//+------------------------------------------------------------------+
//| Calculate the risk amount for a new trade
 
//+------------------------------------------------------------------+
double calculateRiskAmount(double riskPercent, double stopLoss, double lotSize) {
double riskAmount;
double accountBalance = AccountBalance();
double accountCurrency = AccountCurrency();
double pointValue = MarketInfo(Symbol(), MODE_POINT);
double stopLossInCurrency = stopLoss / pointValue;
double lotValue = MarketInfo(Symbol(), MODE_TICKVALUE);
double maxRiskAmount = (accountBalance * riskPercent) / 100;

if (accountCurrency == _Currency_USD) {
riskAmount = stopLossInCurrency * lotSize * lotValue;
} else {
double exchangeRate = MarketInfo(_SymbolNameUSD(accountCurrency), MODE_BID);
riskAmount = (stopLossInCurrency * lotSize * lotValue) / exchangeRate;
}

return MathMin(riskAmount, maxRiskAmount);
}

//+------------------------------------------------------------------+
//| Calculate the lot size based on risk and stop loss |
//+------------------------------------------------------------------+
double calculateLotSize(double riskAmount, double stopLoss) {
double accountBalance = AccountBalance();
double accountCurrency = AccountCurrency();
double pointValue = MarketInfo(Symbol(), MODE_POINT);
double stopLossInCurrency = stopLoss / pointValue;
double lotValue = MarketInfo(Symbol(), MODE_TICKVALUE);

if (accountCurrency == _Currency_USD) {
return (riskAmount / (stopLossInCurrency * lotValue));
} else {
double exchangeRate = MarketInfo(_SymbolNameUSD(accountCurrency), MODE_BID);
double riskAmountInUSD = riskAmount * exchangeRate;
double stopLossInUSD = stopLossInCurrency * exchangeRate;
return (riskAmountInUSD / (stopLossInUSD * lotValue));
}
}

//+------------------------------------------------------------------+
//| Get the current equity balance of the account |
//+------------------------------------------------------------------+
double getCurrentEquity() {
return AccountEquity();
}

//+------------------------------------------------------------------+
//| Get the current account balance |
//+------------------------------------------------------------------+
double getCurrentBalance() {
return AccountBalance();
}

//+------------------------------------------------------------------+
//| Get the current profit or loss |
//+------------------------------------------------------------------+
double getCurrentProfit() {
return AccountProfit();
}

//+------------------------------------------------------------------+
//| Check if there are enough free margin to open a trade |
//+------------------------------------------------------------------+
bool hasEnoughMargin(double lotSize) {
double marginRequired = calculateMarginRequired(lotSize);
double freeMargin = AccountFreeMargin();

if (marginRequired > freeMargin) {
return false;
}

return true;
}

//+------------------------------------------------------------------+
//| Calculate the margin required for the given lot size |
//+------------------------------------------------------------------+
double calculateMarginRequired(double lotSize) {
double margin = (lotSize * MarketInfo(Symbol(), MODE_MARGINREQUIRED));
return margin;
}

// Calculate the position size based on risk and stop loss distance
double calculatePositionSize(double riskAmount, double stopLossDistance) {
    double positionSize = NormalizeDouble(riskAmount / stopLossDistance, 2);
    return positionSize;
}

// Calculate the lot size based on position size and current account balance
double calculateLotSize(double positionSize, double accountBalance) {
    double lotSize = NormalizeDouble(positionSize * accountBalance / MarketInfo(Symbol(), MODE_TICKVALUE), 2);
    return lotSize;
}

// Set the lot size based on the calculated value
void setLotSize(double lotSize) {
    if (lotSize > MarketInfo(Symbol(), MODE_MAXLOT)) {
        lotSize = MarketInfo(Symbol(), MODE_MAXLOT);
    }
    if (lotSize < MarketInfo(Symbol(), MODE_MINLOT)) {
        lotSize = MarketInfo(Symbol(), MODE_MINLOT);
    }
    double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
    lotSize = NormalizeDouble(lotSize / lotStep, 0) * lotStep;
    Print("Setting lot size to ", lotSize);
    if (!IsTesting()) {
        // Send an alert with the new lot size
        Alert("Setting lot size to ", lotSize);
    }
    // Set the lot size for the current trade
    Trade.SetExpertMagicNumber();
    Trade.SetType(TRADE_ACTION_DEAL);
    Trade.SetVolume(lotSize);
}
