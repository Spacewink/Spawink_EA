//+------------------------------------------------------------------+
//|                                                   Spawink_TradeHistory |
//|                                                 © SpaWink Trading |
//|                                             https://www.spawink.com |
//+------------------------------------------------------------------+

#property strict

//+------------------------------------------------------------------+
//| Trade History Object                                             |
//+------------------------------------------------------------------+
class CTradeHistory
{
private:
    struct STrade
    {
        int type;
        double lots;
        double price;
        datetime time;
        double sl;
        double tp;
        double profit;
    };

    STrade tradeHistory[];
    int tradesCount;

public:
    // Constructor
    CTradeHistory()
    {
        tradesCount = 0;
    }

    // Add trade to history
    void AddTrade(int type, double lots, double price, datetime time, double sl, double tp, double profit)
    {
        tradesCount++;
        tradeHistory[tradesCount].type = type;
        tradeHistory[tradesCount].lots = lots;
        tradeHistory[tradesCount].price = price;
        tradeHistory[tradesCount].time = time;
        tradeHistory[tradesCount].sl = sl;
        tradeHistory[tradesCount].tp = tp;
        tradeHistory[tradesCount].profit = profit;
    }

    // Get the count of trades in the history
    int TradesCount()
    {
        return tradesCount;
    }

    // Get the trade at a specific index
    STrade GetTrade(int index)
    {
        return tradeHistory[index];
    }
};

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
CTradeHistory g_tradeHistory;

//+------------------------------------------------------------------+
//| Add trade to trade history                                        |
//+------------------------------------------------------------------+
void AddToTradeHistory(int type, double lots, double price, datetime time, double sl, double tp, double profit)
{
    g_tradeHistory.AddTrade(type, lots, price, time, sl, tp, profit);
}

//+------------------------------------------------------------------+
//| Get trade history object                                          |
//+------------------------------------------------------------------+
CTradeHistory GetTradeHistory()
{
    return g_tradeHistory;
}

//+------------------------------------------------------------------+
//| Reset trade history                                               |
//+------------------------------------------------------------------+
void ResetTradeHistory()
{
    g_tradeHistory = CTradeHistory();
}
