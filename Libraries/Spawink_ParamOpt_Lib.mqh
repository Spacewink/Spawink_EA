//+------------------------------------------------------------------+
//|                                          Spawink_ParamOpt_Lib.mqh |
//|                                                 SpaWink EA        |
//|                                                   Version 1.4    |
//|                                                                  |
//|                                      Copyright © 2022 SpaWink   |
//|                                         https://spawink.com     |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2022 SpaWink"
#property link      "https://spawink.com"
#property version   "1.00"
#property strict

/**
 * @brief Class to handle parameter optimization.
 */
class SpawinkParamOpt
{
private:
    double m_stopLoss;
    double m_takeProfit;
    double m_trailingStop;
    double m_magicNumber;
    double m_lotSize;

public:
    /**
     * @brief Default constructor.
     */
    SpawinkParamOpt()
    {
        m_stopLoss = 0.0;
        m_takeProfit = 0.0;
        m_trailingStop = 0.0;
        m_magicNumber = 0.0;
        m_lotSize = 0.0;
    }

    /**
     * @brief Constructor to initialize the parameters.
     * 
     * @param stopLoss Stop loss value.
     * @param takeProfit Take profit value.
     * @param trailingStop Trailing stop value.
     * @param magicNumber Magic number for the orders.
     * @param lotSize Lot size for the orders.
     */
    SpawinkParamOpt(double stopLoss, double takeProfit, double trailingStop, double magicNumber, double lotSize)
    {
        m_stopLoss = stopLoss;
        m_takeProfit = takeProfit;
        m_trailingStop = trailingStop;
        m_magicNumber = magicNumber;
        m_lotSize = lotSize;
    }

    /**
     * @brief Function to get the stop loss value.
     * 
     * @return double Stop loss value.
     */
    double getStopLoss() const
    {
        return m_stopLoss;
    }

    /**
     * @brief Function to set the stop loss value.
     * 
     * @param stopLoss Stop loss value.
     */
    void setStopLoss(double stopLoss)
    {
        m_stopLoss = stopLoss;
    }

    /**
     * @brief Function to get the take profit value.
     * 
     * @return double Take profit value.
     */
    double getTakeProfit() const
    {
        return m_takeProfit;
    }

    /**
     * @brief Function to set the take profit value.
     * 
     * @param takeProfit Take profit value.
     */
    void setTakeProfit(double takeProfit)
    {
        m_takeProfit = takeProfit;
    }

    /**
     * @brief Function to get the trailing stop value.
     * 
     * @return double Trailing stop value.
     */
    double getTrailingStop() const
    {
        return m_trailingStop;
    }

    /**
     * @brief Function to set the trailing stop value.
     * 
     * @param trailingStop Trailing stop value.
     */
    void setTrailingStop(double trailingStop)
    {
        m_trailingStop = trailingStop;
    }

    /**
     * @brief Function to get the magic number.
     * 
     * @return double Magic number.
     */
    double getMagicNumber() const
    {
        return m_magicNumber;
    }

    /**
     * @brief Function to set the magic number.
     * 
     * @param magicNumber Magic number.
     */
        void setMagicNumber

(string symbol, int magicNumber)
{
if (symbol.IsEmpty())
{
for (int i = 0; i < SymbolsTotal(true); i++)
{
string sym = SymbolName(i, true);
SymbolInfoInteger(sym, SYMBOL_MAGICNUMBER, magicNumber);
}
}
else
{
SymbolInfoInteger(symbol, SYMBOL_MAGICNUMBER, magicNumber);
}
}
/**
 * Sets the EA comment for all symbols or for a specific symbol.
 * 
 * @param symbol Symbol name. Leave empty to set for all symbols.
 * @param comment EA comment.
 */
void setComment(string symbol, string comment)
{
    if (symbol.IsEmpty())
    {
        for (int i = 0; i < SymbolsTotal(true); i++)
        {
            string sym = SymbolName(i, true);
            Comment(sym, comment);
        }
    }
    else
    {
        Comment(symbol, comment);
    }
}
} // namespace spawink_paramopt_lib

//+------------------------------------------------------------------+
//| End of Spawink_ParamOpt_Lib.mqh file |
//+------------------------------------------------------------------+

