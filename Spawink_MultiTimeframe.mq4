//+------------------------------------------------------------------+
//|                                            Spawink_MultiTimeframe.mq4 |
//|                                   Copyright 2023, Your Name Here |
//|                                       https://www.example.com     |
//+------------------------------------------------------------------+

#property strict

//+------------------------------------------------------------------+
//|                        Global Variables                            |
//+------------------------------------------------------------------+

// User-defined input variables
input int maPeriod = 20;  // Moving average period

// Other variables
int maTimeframe = PERIOD_H4;  // Timeframe for moving average calculation
double maValue;  // Moving average value

//+------------------------------------------------------------------+
//|                        Custom Indicator                           |
//+------------------------------------------------------------------+

// Calculate the moving average for a specified timeframe
double MultiTimeframeMovingAverage(int timeframe)
{
    double ma = iMA(Symbol(), timeframe, maPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);
    return ma;
}

//+------------------------------------------------------------------+
//|                          Expert Advisor                           |
//+------------------------------------------------------------------+

// Initialize the expert advisor
int OnInit()
{
    // Set the chart to the desired timeframe
    PeriodSet(maTimeframe);
    return(INIT_SUCCEEDED);
}

// Execute the expert advisor
void OnTick()
{
    // Calculate the moving average value for the specified timeframe
    maValue = MultiTimeframeMovingAverage(maTimeframe);

    // Do something with the moving average value
    if (maValue > Ask)
    {
        // Buy signal
        // ...
    }
    else if (maValue < Bid)
    {
        // Sell signal
        // ...
    }
}

// Handle chart events
void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
{
    // Check for a change in timeframe
    if (id == CHARTEVENT_CHART_CHANGE)
    {
        // Get the new timeframe
        int newTimeframe = (int)dparam;

        // Only update if the new timeframe is different from the current timeframe
        if (newTimeframe != maTimeframe)
        {
            maTimeframe = newTimeframe;
        }
    }
}
