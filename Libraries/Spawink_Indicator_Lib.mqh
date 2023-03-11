//+------------------------------------------------------------------+
//|                                                     Spawink_Indicator_Lib.mqh |
//|                                                        SpaWink EA 1.4 |
//|                       https://www.mql5.com/en/users/spawink/ea/spawink |
//+------------------------------------------------------------------+

#property strict

//+------------------------------------------------------------------+
//| Function to get the Force Index for a symbol and timeframe        |
//+------------------------------------------------------------------+
double spwGetForceIndex(string symbol, int timeframe, int period, int appliedPrice, int mode, int shift)
{
    int limit = Bars(symbol, timeframe);
    if (limit > 0)
    {
        double currentPrice = 0;
        double previousPrice = 0;
        double currentVolume = 0;
        double previousVolume = 0;
        double forceIndex = 0;

        for (int i = limit-1; i >= 0; i--)
        {
            currentPrice = iClose(symbol, timeframe, i);
            previousPrice = iClose(symbol, timeframe, i+1);
            currentVolume = iVolume(symbol, timeframe, i);
            previousVolume = iVolume(symbol, timeframe, i+1);

            double force = (currentPrice - previousPrice) * currentVolume;
            forceIndex += force;

            if (i <= limit-period)
            {
                double sma = 0;
                for (int j = 0; j < period; j++)
                {
                    sma += (iClose(symbol, timeframe, i+j) - iClose(symbol, timeframe, i+j+1)) * iVolume(symbol, timeframe, i+j);
                }
                sma /= period;
                forceIndex = iMA(NULL, 0, sma, 0, mode, appliedPrice, shift);
                break;
            }
        }
        return forceIndex;
    }
    else
    {
        return 0;
    }
}

//+------------------------------------------------------------------+
//| Function to get the Chaikin Oscillator for a symbol and timeframe |
//+------------------------------------------------------------------+
double spwGetChaikinOsc(string symbol, int timeframe, int fastPeriod, int slowPeriod, int appliedPrice, int shift)
{
    int limit = Bars(symbol, timeframe);
    if (limit > 0)
    {
        double currentPrice = 0;
        double previousPrice = 0;
        double currentVolume = 0;
        double previousVolume = 0;
        double adl = 0;
        double adlFast = 0;
        double adlSlow = 0;
        double chaikinOsc = 0;

        for (int i = limit-1; i >= 0; i--)
        {
            currentPrice = iClose(symbol, timeframe, i);
            previousPrice = iClose(symbol, timeframe, i+1);
            currentVolume = iVolume(symbol, timeframe, i);
            previousVolume = iVolume(symbol, timeframe, i+1);

            double cmf = ((currentPrice - previousPrice) / (currentPrice + previousPrice)) * currentVolume;
            adl += cmf;
            adlFast = iMA(NULL, 0, adl, fastPeriod, 0, appliedPrice, shift);
            adlSlow = iMA(NULL, 0, adl, slowPeriod, 0, appliedPrice, shift);
            chaikinOsc = adlFast - adlSlow;
        }
        return chaikinOsc;
    }
    else
    {
        return 0;
    }
}

//+------------------------------------------------------------------+
//| Function to get the

double spwGetMomentum(string symbol, int timeframe, int period, int appliedPrice, int mode, int shift)
{
    double momentum = 0.0;
    double price = 0.0;
    double prevPrice = 0.0;
    int limit = Bars(symbol, timeframe);
    
    if (limit > 0)
    {
        if (shift >= limit)
            shift = limit - 1;

        price = iCustom(symbol, timeframe, "Spawink Indicators", "Momentum", period, appliedPrice, mode, shift);
        prevPrice = iCustom(symbol, timeframe, "Spawink Indicators", "Momentum", period, appliedPrice, mode, shift + 1);

        momentum = price - prevPrice;
    }

    return momentum;
}

