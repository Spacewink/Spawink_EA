
//+------------------------------------------------------------------+
//|                                            Spawink_RiskManagement_Lib.mqh |
//|                                 Copyright © 2023 Spawink Inc.     |
//|                                   https://www.spawink.com           |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2023, Spawink Inc."
#property link      "https://www.spawink.com"
#property version   "1.00"
#property strict

// Class for Risk Management
class SpwRiskManagement
{
private:
    double riskPercent;
    double accountBalance;
    double maxStopLossPips;
    double pipValue;
    double lotSize;

public:
    SpwRiskManagement(double risk, double balance, double stopLossPips, double pipVal)
    {
        riskPercent = risk;
        accountBalance = balance;
        maxStopLossPips = stopLossPips;
        pipValue = pipVal;
    }

    double CalculateLotSize(double price, double stopLoss)
    {
        double riskAmount = accountBalance * (riskPercent / 100.0);
        double stopLossPipsValue = pipValue * maxStopLossPips;
        double maxLots = riskAmount / stopLossPipsValue;

        double tradeSize = riskAmount / stopLoss;
        lotSize = NormalizeLotSize(tradeSize, maxLots);

        return lotSize;
    }

    double NormalizeLotSize(double lot, double maxLots)
    {
        if (lot > maxLots)
        {
            lot = maxLots;
        }
        else if (lot < 0.01)
        {
            lot = 0.01;
        }

        return NormalizeDouble(lot, 2);
    }

    double GetLotSize()
    {
        return lotSize;
    }
};

//| Function to calculate stop loss based on ATR
double spwCalculateStopLoss(double atr, double price, double risk, int digits)
{
    double stopLoss = NormalizeDouble(price - (atr * risk), digits);
    return stopLoss;
}

//| Function to calculate take profit based on risk/reward ratio
double spwCalculateTakeProfit(double risk, double reward, double price, int digits)
{
    double takeProfit = NormalizeDouble(price + (risk * (reward - 1)), digits);
    return takeProfit;
}

//| Function to calculate lot size based on risk percentage
double spwCalculateLotSize(double risk, double balance, double stopLoss, double maxStopLossPips, double pipValue)
{
    double riskAmount = balance * (risk / 100.0);
    double stopLossPipsValue = pipValue * maxStopLossPips;
    double lotSize = riskAmount / stopLossPipsValue;
    double normalizedLotSize = NormalizeDouble(lotSize, 2);

    return normalizedLotSize;
}

//| Function to get pip value of a symbol
double spwGetPipValue(string symbol)
{
    double point = MarketInfo(symbol, MODE_POINT);
    double tickSize = MarketInfo(symbol, MODE_TICKSIZE);
    double pipValue = point / tickSize;

    return pipValue;
}

//| Function to get lot size based on risk percentage and maximum stop loss in pips
double spwGetLotSize(double risk, double balance, double stopLossPips, double pipValue, double maxLots)
{
    double riskAmount = balance * (risk / 100.0);
    double stopLossPipsValue = pipValue * stopLossPips;
    double lotSize = riskAmount / stopLossPips
double lotSize = riskAmount / stopLoss;
return NormalizeLotSize(lotSize, symbol, tickValue);
}
    // Function to normalize the lot size based on tick value and market conditions
    double NormalizeLotSize(double lotSize, string symbol, double tickValue)
    {
        double minLotSize = MarketInfo(symbol, MODE_MINLOT);
        double maxLotSize = MarketInfo(symbol, MODE_MAXLOT);
        double lotStep = MarketInfo(symbol, MODE_LOTSTEP);

        if (lotSize < minLotSize)
        {
            lotSize = minLotSize;
        }
        else if (lotSize > maxLotSize)
        {
            lotSize = maxLotSize;
        }

        lotSize = MathRound(lotSize / lotStep) * lotStep;
        lotSize = MathFloor(lotSize / tickValue) * tickValue;
        return lotSize;
    }
}
}





