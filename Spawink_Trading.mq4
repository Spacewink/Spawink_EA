//+------------------------------------------------------------------+
//|                                                     Spawink_Trading.mq4 |
//|                                      Copyright © 2023, Spawink Financial |
//|                                                   https://spawink.com |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2023, Spawink Financial"
#property link      "https://spawink.com"
#property version   "1.4"
#property strict

#include "Spawink_TradeHistory.mqh"
#include "Spawink_Risk_Lib.mqh"
#include "Spawink_Indicator_Lib.mqh"
#include "Spawink_News_Lib.mqh"
#include "Spawink_Portfolio_Lib.mqh"
#include "Spawink_SocialTrading_Lib.mqh"
#include "Spawink_MultiTimeframe_Lib.mqh"

//+------------------------------------------------------------------+
//|                      Trading Functions and Classes                |
//+------------------------------------------------------------------+

// TradeManager class to manage open trades
class TradeManager
{
private:
    int m_magicNumber;                          // Magic number for the trades
    double m_lotSize;                           // Lot size for the trades
    double m_stopLoss;                          // Stop loss for the trades
    double m_takeProfit;                        // Take profit for the trades
    bool m_useTrailingStop;                     // Flag to use trailing stop for the trades
    int m_trailingStop;                         // Trailing stop for the trades
    datetime m_expiryTime;                      // Expiry time for the trades
    int m_slippage;                             // Maximum slippage for the trades
    TradeHistory* m_tradeHistory;               // Trade history object for tracking trades

public:
    // Constructor
    TradeManager(int magicNumber, double lotSize, double stopLoss, double takeProfit, bool useTrailingStop, int trailingStop, datetime expiryTime, int slippage)
    {
        m_magicNumber = magicNumber;
        m_lotSize = lotSize;
        m_stopLoss = stopLoss;
        m_takeProfit = takeProfit;
        m_useTrailingStop = useTrailingStop;
        m_trailingStop = trailingStop;
        m_expiryTime = expiryTime;
        m_slippage = slippage;
        m_tradeHistory = new TradeHistory();
    }

    // Destructor
    ~TradeManager()
    {
        delete m_tradeHistory;
    }

    // Open a new trade
    bool OpenTrade(int tradeType, double entryPrice, string comment)
    {
        int orderType = (tradeType == TRADE_BUY) ? OP_BUY : OP_SELL;
        double stopLoss = (tradeType == TRADE_BUY) ? entryPrice - m_stopLoss * _Point : entryPrice + m_stopLoss * _Point;
        double takeProfit = (tradeType == TRADE_BUY) ? entryPrice + m_takeProfit * _Point : entryPrice - m_takeProfit * _Point;
        int ticket = OrderSend(Symbol(), orderType, m_lotSize, entryPrice, m_slippage, stopLoss, takeProfit, comment, m_magicNumber, 0, Green);
        if (ticket > 0) {
            // Add trade to the trade history
            m_tradeHistory.AddTrade(ticket, tradeType, entryPrice, m_lotSize, m_stopLoss, m_takeProfit, m_useTrailingStop, m_trailingStop, m_expiryTime, comment);
            return true;
        } else {
            Print("Error opening trade: ", ErrorDescription(GetLastError()));
            return false;
        }
    }

    // Close a trade by ticket
    bool CloseTrade(int ticket, double closePrice, string comment)
    {
        bool result    bool ModifyTrade(SWTrade &trade, double stoploss, double takeprofit)
    {
        // Check if the trade is already closed
        if (trade.status == SWTradeStatus::CLOSED)
        {
            Print("Error: Trade #" + IntegerToString(trade.ticket) + " is already closed.");
            return false;
        }

        // Check if the trade is already modified
        if (trade.stoploss == stoploss && trade.takeprofit == takeprofit)
        {
            Print("Error: Trade #" + IntegerToString(trade.ticket) + " has already been modified with the same stoploss and takeprofit values.");
            return false;
        }

        // Modify the trade with the new stoploss and takeprofit values
        bool result = OrderModify(trade.ticket, trade.type, stoploss, takeprofit, 0, CLR_NONE);

        if (result)
        {
            // Update the trade object with the new stoploss and takeprofit values
            trade.stoploss = stoploss;
            trade.takeprofit = takeprofit;
            trade.modified = TimeLocal();

            // Update the trade history with the modified trade
            tradeHistory.UpdateTrade(trade);

            Print("Trade #" + IntegerToString(trade.ticket) + " modified with stoploss=" + DoubleToString(stoploss, Digits) + " and takeprofit=" + DoubleToString(takeprofit, Digits));
        }
        else
        {
            Print("Error: Failed to modify trade #" + IntegerToString(trade.ticket) + " with stoploss=" + DoubleToString(stoploss, Digits) + " and takeprofit=" + DoubleToString(takeprofit, Digits) + ". Error code: " + GetLastError());
        }

        return result;
    }
}

