//+------------------------------------------------------------------+
//|                                                    SpaWink TH Lib|
//|                                                    Copyright 2023|
//+------------------------------------------------------------------+
#property link      "https://spawink.com"
#property version   "1.0"

//+------------------------------------------------------------------+
//| Classes and Functions                                           |
//+------------------------------------------------------------------+

// Trade Class
class Trade
{
    private:
        int ticket;
        double openPrice;
        double closePrice;
        int type;
        datetime openTime;
        datetime closeTime;
        double lots;
        double profit;

    public:
        Trade(int ticket, double openPrice, double closePrice, int type, datetime openTime, datetime closeTime, double lots, double profit);
        int getTicket();
        double getOpenPrice();
        double getClosePrice();
        int getType();
        datetime getOpenTime();
        datetime getCloseTime();
        double getLots();
        double getProfit();
};

// Constructor for Trade Class
Trade::Trade(int ticket, double openPrice, double closePrice, int type, datetime openTime, datetime closeTime, double lots, double profit)
{
    this->ticket = ticket;
    this->openPrice = openPrice;
    this->closePrice = closePrice;
    this->type = type;
    this->openTime = openTime;
    this->closeTime = closeTime;
    this->lots = lots;
    this->profit = profit;
}

// Getter functions for Trade Class
int Trade::getTicket()
{
    return ticket;
}

double Trade::getOpenPrice()
{
    return openPrice;
}

double Trade::getClosePrice()
{
    return closePrice;
}

int Trade::getType()
{
    return type;
}

datetime Trade::getOpenTime()
{
    return openTime;
}

datetime Trade::getCloseTime()
{
    return closeTime;
}

double Trade::getLots()
{
    return lots;
}

double Trade::getProfit()
{
    return profit;
}

// Trade History Class
class TradeHistory
{
    private:
        int totalTrades;
        Trade* trades;

    public:
        TradeHistory();
        ~TradeHistory();

        void addTrade(int ticket, double openPrice, double closePrice, int type, datetime openTime, datetime closeTime, double lots, double profit);
        int getTotalTrades();
        Trade* getTrades();
};

// Constructor for Trade History Class
TradeHistory::TradeHistory()
{
    totalTrades = 0;
    trades = NULL;
}

// Destructor for Trade History Class
TradeHistory::~TradeHistory()
{
    if (trades != NULL)
    {
        delete[] trades;
    }
}

// Function for adding a trade to the trade history
void TradeHistory::addTrade(int ticket, double openPrice, double closePrice, int type, datetime openTime, datetime closeTime, double lots, double profit)
{
    Trade* newTrades = new Trade[totalTrades+1];

    for (int i = 0; i < totalTrades; i++)
    {
        newTrades[i] = trades[i];
    }

    newTrades[totalTrades] = Trade(ticket, openPrice, closePrice, type, openTime, closeTime, lots, profit);

    totalTrades++;

    if (trades != NULL)
    {
        delete[] trades;
    }

    trades = newTrades;
}

// Getter function for total trades in the trade history
int TradeHistory::getTotalTrades()
{
    return totalTrades;
}

// Getter function for all trades
