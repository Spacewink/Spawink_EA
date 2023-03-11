//+------------------------------------------------------------------+
//|                                             Spawink_Trading_Lib.mqh |
//|                             Copyright © 2021, SpaWink Trading |
//|                                      https://www.spawink.com |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2021, SpaWink Trading"
#property link      "https://www.spawink.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Class CSpawinkTradingLib                                          |
//| Description: Library for SpaWink Trading                          |
//+------------------------------------------------------------------+
class CSpawinkTradingLib
{
private:
    // Variables
    double m_lots = 0.1;
    double m_stopLoss = 100.0;
    double m_takeProfit = 100.0;

public:
    // Constructor
    CSpawinkTradingLib() {}

    // Destructor
    ~CSpawinkTradingLib() {}

    // Methods
    bool Buy(const string symbol, const double price, const string comment = "")
    {
        bool result = false;

        // Check if the symbol is valid
        if (!SymbolInfoDouble(symbol, SYMBOL_ASK))
        {
            Print("Invalid symbol: ", symbol);
            return result;
        }

        // Calculate the stop loss and take profit levels
        double stopLoss = NormalizeDouble(price - m_stopLoss * Point, Digits);
        double takeProfit = NormalizeDouble(price + m_takeProfit * Point, Digits);

        // Place the buy order
        int ticket = OrderSend(symbol, OP_BUY, m_lots, price, 3, stopLoss, takeProfit, comment);

        if (ticket > 0)
        {
            Print("Buy order placed successfully. Ticket: ", ticket);
            result = true;
        }
        else
        {
            Print("Error placing buy order. Error code: ", GetLastError());
        }

        return result;
    }

    bool Sell(const string symbol, const double price, const string comment = "")
    {
        bool result = false;

        // Check if the symbol is valid
        if (!SymbolInfoDouble(symbol, SYMBOL_BID))
        {
            Print("Invalid symbol: ", symbol);
            return result;
        }

        // Calculate the stop loss and take profit levels
        double stopLoss = NormalizeDouble(price + m_stopLoss * Point, Digits);
        double takeProfit = NormalizeDouble(price - m_takeProfit * Point, Digits);

        // Place the sell order
        int ticket = OrderSend(symbol, OP_SELL, m_lots, price, 3, stopLoss, takeProfit, comment);

        if (ticket > 0)
        {
            Print("Sell order placed successfully. Ticket: ", ticket);
            result = true;
        }
        else
        {
            Print("Error placing sell order. Error code: ", GetLastError());
        }

        return result;
    }

    // Setters
    void SetLots(const double lots)
    {
        m_lots = lots;
    }

    void SetStopLoss(const double stopLoss)
    {
        m_stopLoss = stopLoss;
    }

    void SetTakeProfit(const double takeProfit)
    {
        m_takeProfit = takeProfit;
    }

    // Getters
    double GetLots() const
    {
        return m_lots;
    }

    double GetStopLoss() const
    {
        return m_stopLoss;
    }

    double GetTakeProfit() const
    {
        return m_takeProfit;
    }
};
