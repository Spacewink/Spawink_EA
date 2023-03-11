//+------------------------------------------------------------------+
//|                                                      SpaWink MTF |
//|                                                    Copyright 2023|
//+------------------------------------------------------------------+
#property link      "https://spawink.com"
#property version   "1.0"

//+------------------------------------------------------------------+
//|                        Constants                                 |
//+------------------------------------------------------------------+

#define MAX_TIMEFRAMES 5

//+------------------------------------------------------------------+
//|                        Global Variables                          |
//+------------------------------------------------------------------+

int g_timeframes[MAX_TIMEFRAMES];
int g_numTimeframes;

//+------------------------------------------------------------------+
//|                        Functions                                 |
//+------------------------------------------------------------------+

// Initialize function
void MTF_Init(int timeframes[])
{
    g_numTimeframes = ArraySize(timeframes);
    for (int i = 0; i < g_numTimeframes; i++)
    {
        g_timeframes[i] = timeframes[i];
    }
}

// Get data function
double MTF_GetData(string symbol, int timeframe, ENUM_TIMEFRAMES mtf, ENUM_APPLIED_PRICE priceType, int index)
{
    if (!ArrayContains(g_timeframes, g_numTimeframes, timeframe))
    {
        Print("MTF_GetData error: timeframe not supported.");
        return 0.0;
    }

    double value = 0.0;

    if (timeframe == mtf)
    {
        value = iCustom(symbol, mtf, "Spawink", priceType, index);
    }
    else
    {
        datetime prevTime = iTime(symbol, mtf, index+1);
        int prevIndex = iBarShift(symbol, timeframe, prevTime);
        if (prevIndex >= 0)
        {
            value = MTF_GetData(symbol, timeframe, mtf, priceType, prevIndex);
        }
    }

    return value;
}
