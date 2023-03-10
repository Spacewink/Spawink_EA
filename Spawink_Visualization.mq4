    //+------------------------------------------------------------------+
//|                                                     Spawink_Visualization.mq4 |
//|                              Copyright 2023, Your Company Name      |
//|                                          https://www.yourcompany.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2023, Your Company Name"
#property link      "https://www.yourcompany.com"
#property version   "1.0"
#property strict

//+------------------------------------------------------------------+
//| Include files                                                     |
//+------------------------------------------------------------------+
#include <ChartObjects/ChartObjectsTxt.h>
#include "trade_history.mqh"

//+------------------------------------------------------------------+
//| Class definition                                                  |
//+------------------------------------------------------------------+
class TradeVisualizer
{
private:
    datetime m_startTime;
    datetime m_endTime;
    int m_chartId;
    ChartObjectsTxt m_objects;
    CTradeHistory m_tradeHistory;

public:
    TradeVisualizer(datetime startTime, datetime endTime, int chartId)
    {
        m_startTime = startTime;
        m_endTime = endTime;
        m_chartId = chartId;
    }

    void Initialize()
    {
        m_tradeHistory.Initialize();
        m_objects.Create(0, "TradeVisualizerTxt");
        m_objects.Font("Arial");
        m_objects.FontSize(10);
    }

    void DrawTrades()
    {
        m_objects.Clear();
        for (int i = 0; i < m_tradeHistory.Size(); i++)
        {
            Trade trade = m_tradeHistory.GetTrade(i);
            if (trade.openTime >= m_startTime && trade.closeTime <= m_endTime)
            {
                double entryPrice = trade.type == TRADE_BUY ? trade.openPrice : trade.closePrice;
                double exitPrice = trade.type == TRADE_BUY ? trade.closePrice : trade.openPrice;
                string txt = "Entry: " + DoubleToString(entryPrice, Digits) + "\n" +
                             "Exit: " + DoubleToString(exitPrice, Digits) + "\n" +
                             "Profit: " + DoubleToString(trade.profit, Digits) + "\n" +
                             "Duration: " + trade.duration;
                m_objects.SetText(i, txt);
                m_objects.SetX(i, trade.openTime);
                m_objects.SetY(i, entryPrice);
                m_objects.Color(i, trade.profit > 0 ? LimeGreen : Red);
            }
        }
    }
};

//+------------------------------------------------------------------+
//| Global variables                                                  |
//+------------------------------------------------------------------+
TradeVisualizer g_tradeVisualizer;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    g_tradeVisualizer = TradeVisualizer(Time[0], Time[0] + 24 * 60 * 60, ChartID());
    g_tradeVisualizer.Initialize();
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
    g_tradeVisualizer.DrawTrades();
    return(rates_total);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                        |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    g_tradeVisualizer.~TradeVisualizer();
}
