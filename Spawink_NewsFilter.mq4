//+------------------------------------------------------------------+
//|                                            Spawink_NewsFilter.mq4 |
//|                       Copyright 2023, Spawink.com                 |
//|                       https://www.spawink.com                      |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Spawink.com"
#property link      "https://www.spawink.com"
#property version   "1.00"
#property strict

#include <FFCal.mqh>

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
FFCal         g_FFCal;
datetime     g_lastNewsTime;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialize the FFCal news indicator
    g_FFCal.Create();
    g_lastNewsTime = 0;

    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Destroy the FFCal news indicator
    g_FFCal.Destroy();
}

//+------------------------------------------------------------------+
//| Check if there is any high impact news event in the next N bars   |
//+------------------------------------------------------------------+
bool IsNewsEventUpcoming(const int bars)
{
    bool result = false;

    for (int i = 0; i < bars; i++)
    {
        const int idx = g_FFCal.GetNextEvent(i, true);
        if (idx >= 0 && g_FFCal.GetImpact(idx) == FF_HIGH_IMPACT)
        {
            result = true;
            break;
        }
    }

    return result;
}

//+------------------------------------------------------------------+
//| Check if it's safe to trade based on the news filter             |
//+------------------------------------------------------------------+
bool IsSafeToTrade()
{
    bool result = true;

    // Check if there is any high impact news event in the next 3 bars
    if (IsNewsEventUpcoming(3))
    {
        const datetime currentTime = TimeCurrent();
        const datetime newsTime = g_FFCal.GetNextEventTime(0, true);
        const int timeDifference = MathAbs(TimeSeconds(currentTime - newsTime));

        // Check if the time difference is less than 10 minutes
        if (timeDifference < 10 * 60)
        {
            result = false;
        }
    }

    return result;
}
