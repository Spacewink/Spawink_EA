//+------------------------------------------------------------------+
//|                                                    SpaWink ST Lib|
//|                                                    Copyright 2023|
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Classes and Functions                                           |
//+------------------------------------------------------------------+

// Trade Signal Class
class TradeSignal
{
    private:
        int signalId;
        string symbol;
        int type;
        double lots;
        double price;
        double stopLoss;
        double takeProfit;
        datetime openTime;
        datetime closeTime;
        int status;

    public:
        TradeSignal(int signalId, string symbol, int type, double lots, double price, double stopLoss, double takeProfit, datetime openTime, datetime closeTime, int status);
        ~TradeSignal();

        int getSignalId();
        string getSymbol();
        int getType();
        double getLots();
        double getPrice();
        double getStopLoss();
        double getTakeProfit();
        datetime getOpenTime();
        datetime getCloseTime();
        int getStatus();

        void setStatus(int status);
};

// Constructor for Trade Signal Class
TradeSignal::TradeSignal(int signalId, string symbol, int type, double lots, double price, double stopLoss, double takeProfit, datetime openTime, datetime closeTime, int status)
{
    this->signalId = signalId;
    this->symbol = symbol;
    this->type = type;
    this->lots = lots;
    this->price = price;
    this->stopLoss = stopLoss;
    this->takeProfit = takeProfit;
    this->openTime = openTime;
    this->closeTime = closeTime;
    this->status = status;
}

// Destructor for Trade Signal Class
TradeSignal::~TradeSignal()
{

}

// Getter functions for Trade Signal Class
int TradeSignal::getSignalId()
{
    return signalId;
}

string TradeSignal::getSymbol()
{
    return symbol;
}

int TradeSignal::getType()
{
    return type;
}

double TradeSignal::getLots()
{
    return lots;
}

double TradeSignal::getPrice()
{
    return price;
}

double TradeSignal::getStopLoss()
{
    return stopLoss;
}

double TradeSignal::getTakeProfit()
{
    return takeProfit;
}

datetime TradeSignal::getOpenTime()
{
    return openTime;
}

datetime TradeSignal::getCloseTime()
{
    return closeTime;
}

int TradeSignal::getStatus()
{
    return status;
}

// Setter function for Trade Signal Class
void TradeSignal::setStatus(int status)
{
    this->status = status;
}

// Trade Signal Manager Class
class TradeSignalManager
{
    private:
        int nextSignalId;
        TradeSignal** signals;
        int numSignals;

    public:
        TradeSignalManager();
        ~TradeSignalManager();

        void addSignal(string symbol, int type, double lots, double price, double stopLoss, double takeProfit);
        TradeSignal* getSignal(int signalId);
        TradeSignal* getNextSignal();
        void deleteSignal(int signalId);
        void updateSignal(TradeSignal* signal);
        int getNumSignals();
};

// Constructor for Trade Signal Manager Class
TradeSignalManager::TradeSignalManager()
{
    nextSignalId = 1;
    signals = new TradeSignal*[10];
    numSignals = 0;
}

// Destructor for Trade Signal Manager Class
TradeSignalManager::~TradeSignalManager()
{
    for (int i = 0; i < numSignals; i++)
    {
        delete signals[i];
    }
    delete[] signals;
}

// Add Signal function for Trade Signal Manager Class
void TradeSignalManager::addSignal(string
