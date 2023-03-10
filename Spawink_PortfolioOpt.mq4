//+------------------------------------------------------------------+
//|                                                    Spawink_PortfolioOpt.mq4 |
//|                                Copyright 2023, Your Name Here   |
//|                                        https://www.yourwebsite.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2023, Your Name Here"
#property link      "https://www.yourwebsite.com"
#property version   "1.00"
#property strict

// Include trade management and risk management files
#include <Spawink_TradeManagement.mqh>
#include <Spawink_RiskManagement.mqh>

// Include technical analysis indicator files
#include <Spawink_Indicator.mqh>

// Define portfolio optimization class
class PortfolioOptimization
{
private:
    double initialBalance; // Initial portfolio balance
    double portfolioValue; // Current portfolio value
    int numInstruments; // Number of instruments in portfolio
    double lotSize; // Lot size for all instruments in portfolio
    double* weights; // Array of weights for each instrument in portfolio
    double* instrumentReturns; // Array of historical returns for each instrument in portfolio
    double* instrumentVolatilities; // Array of historical volatilities for each instrument in portfolio
    
public:
    PortfolioOptimization(double initialBalance, int numInstruments, double lotSize)
    {
        this.initialBalance = initialBalance;
        this.portfolioValue = initialBalance;
        this.numInstruments = numInstruments;
        this.lotSize = lotSize;
        
        // Allocate memory for weights, instrumentReturns, and instrumentVolatilities
        this.weights = new double[numInstruments];
        this.instrumentReturns = new double[numInstruments];
        this.instrumentVolatilities = new double[numInstruments];
        
        // Set initial weights to equal distribution
        for (int i = 0; i < numInstruments; i++)
        {
            this.weights[i] = 1.0 / numInstruments;
        }
    }
    
    ~PortfolioOptimization()
    {
        // Deallocate memory for weights, instrumentReturns, and instrumentVolatilities
        delete[] this.weights;
        delete[] this.instrumentReturns;
        delete[] this.instrumentVolatilities;
    }
    
    void calculateReturns(double* priceData[], int dataLength)
    {
        // Calculate historical returns for each instrument
        for (int i = 0; i < numInstruments; i++)
        {
            double returns = 0.0;
            for (int j = 1; j < dataLength; j++)
            {
                double priceDiff = priceData[i][j] - priceData[i][j-1];
                returns += (priceDiff / priceData[i][j-1]);
            }
            this.instrumentReturns[i] = returns / (dataLength - 1);
        }
    }
    
    void calculateVolatilities(double* priceData[], int dataLength, int lookbackPeriod)
    {
        // Calculate historical volatilities for each instrument
        for (int i = 0; i < numInstruments; i++)
        {
            double sumSqReturns = 0.0;
            for (int j = lookbackPeriod; j < dataLength; j++)
            {
                double returns = 0.0;
                for (int k = 0; k < lookbackPeriod; k++)
                {
                    double priceDiff = priceData[i][j-k] - priceData[i][j-k-1];
                                        returns += (priceDiff / priceData[i][j-k-1]);
                }
                sumSqReturns += returns * returns;
            }

            double volatility = MathSqrt(sumSqReturns / (lookbackPeriod - 1));
            assetVolatility.Add(volatility);
        }

        return assetVolatility;
    }

    // Function to calculate the portfolio volatility given the asset weights and asset volatilities
    double CalculatePortfolioVolatility(const double weights[], const double assetVolatilities[])
    {
        double portfolioVolatility = 0;
        int numAssets = ArraySize(assetVolatilities);

        for (int i = 0; i < numAssets; i++)
        {
            for (int j = 0; j < numAssets; j++)
            {
                portfolioVolatility += weights[i] * weights[j] * assetVolatilities[i] * assetVolatilities[j];
            }
        }

        portfolioVolatility = MathSqrt(portfolioVolatility);

        return portfolioVolatility;
    }

    // Function to optimize the portfolio weights
    void OptimizePortfolioWeights(const double assetReturns[][MAX_LOOKBACK_PERIOD], const int numAssets, const int lookbackPeriod,
                                  const double minWeight, const double maxWeight, const double portfolioTargetReturn, double weights[])
    {
        double targetFunctionValue = portfolioTargetReturn;
        int numIterations = 0;
        const int maxIterations = 100;
        const double tolerance = 0.0001;

        while (true)
        {
            double assetWeights[MAX_NUM_ASSETS];
            double assetVolatilities[MAX_NUM_ASSETS];

            for (int i = 0; i < numAssets; i++)
            {
                assetVolatilities[i] = CalculateVolatility(assetReturns[i], lookbackPeriod);
            }

            double portfolioVolatility = CalculatePortfolioVolatility(weights, assetVolatilities);

            for (int i = 0; i < numAssets; i++)
            {
                assetWeights[i] = weights[i] * assetVolatilities[i] / portfolioVolatility;
            }

            double portfolioReturn = 0;

            for (int i = 0; i < numAssets; i++)
            {
                double sumReturns = 0;

                for (int j = 0; j < lookbackPeriod; j++)
                {
                    sumReturns += assetReturns[i][j];
                }

                double meanReturn = sumReturns / lookbackPeriod;
                portfolioReturn += meanReturn * assetWeights[i];
            }

            double functionValue = (portfolioReturn - targetFunctionValue) * (portfolioReturn - targetFunctionValue);

            if (functionValue <= tolerance || numIterations >= maxIterations)
            {
                break;
            }

            double gradient[MAX_NUM_ASSETS] = {0};

            for (int i = 0; i < numAssets; i++)
            {
                double delta = 0.0001;
                double perturbedWeights[MAX_NUM_ASSETS];

                for (int j = 0; j < numAssets; j++)
                {
                    perturbedWeights[j] = weights[j];
                }

                perturbedWeights[i] += delta;
                double perturbedPortfolioVolatility = CalculatePortfolioVolatility(perturbedWeights, assetVolatilities);

                for (int j = 0; j < numAssets; j++)
                {
                    double perturbedAssetWeight = perturbedWeights[j] * assetVolatilities[j] / perturbedPortfolioVolatility;
                    double perturbedPortfolioReturn = 0;

                    for (int k = 0; k < numAssets; k++)
                    {
                        double sumReturns = 0;for (int k = 0; k < numAssets; k++)
                    {
                        double sumReturns = 0.0;
                        for (int j = 0; j < numDays; j++)
                        {
                            double priceDiff = priceData[k][j] - priceData[k][j-1];
                            double ret = priceDiff / priceData[k][j-1];
                            sumReturns += ret;
                        }
                        double avgReturn = sumReturns / numDays;
                        double var = 0.0;
                        for (int j = 0; j < numDays; j++)
                        {
                            double priceDiff = priceData[k][j] - priceData[k][j-1];
                            double ret = priceDiff / priceData[k][j-1];
                            var += pow(ret - avgReturn, 2);
                        }
                        double stdDev = sqrt(var / numDays);
                        double sharpeRatio = (avgReturn - riskFreeRate) / stdDev;
                        
                        // Add asset to the portfolio
                        PortfolioAsset asset;
                        asset.symbol = assetSymbols[k];
                        asset.weight = 1.0 / numAssets;
                        asset.expectedReturn = avgReturn;
                        asset.stdDev = stdDev;
                        asset.sharpeRatio = sharpeRatio;
                        portfolio.push_back(asset);
                    }
                    
                    // Calculate portfolio weights using Mean-Variance Optimization
                    MeanVarianceOptimization mvo(portfolio, riskAversion);
                    mvo.optimize();
                    
                    // Get optimized portfolio weights
                    vector<double> weights = mvo.getWeights();
                    
                    // Update positions based on new weights
                    for (int k = 0; k < numAssets; k++)
                    {
                        double equity = AccountEquity();
                        double marginReq = MarketInfo(assetSymbols[k], MODE_MARGINREQUIRED);
                        double maxVolume = NormalizeDouble((equity * maxRisk) / (100 * marginReq * priceData[k][0]), 2);
                        double desiredVolume = NormalizeDouble((weights[k] * equity * maxRisk) / (100 * marginReq * priceData[k][0]), 2);
                        double currentVolume = PositionsTotalVolume(assetSymbols[k]);
                        
                        if (desiredVolume > currentVolume)
                        {
                            // Buy additional volume
                            double volume = desiredVolume - currentVolume;
                            double slippage = Slippage(assetSymbols[k], volume, true);
                            double price = SymbolInfoDouble(assetSymbols[k], SYMBOL_ASK);
                            double stopLoss = price - (stopLossPct * price / 100);
                            double takeProfit = price + (takeProfitPct * price / 100);
                            double deviation = SymbolInfoInteger(assetSymbols[k], SYMBOL_TRADEALLOWED) ? deviationInPoints : 0;
                            int ticket = OrderSend(assetSymbols[k], OP_BUY, volume, price, slippage, stopLoss, takeProfit, "", 0, 0, Green);
                            if (ticket > 0)
                            {
                                Print("Opened buy position on ", assetSymbols[k], " with volume ", volume);
                                Trade newTrade = Trade(ticket, assetSymbols[k], OP_BUY, volume, price, stopLoss, takeProfit, deviation, OrderOpenTime(), 0);
                                tradeManager.addTrade(newTrade);
                            }
                            else
                            {
                                Print("Failed to open buy position on ", assetSymbols[k], " with error code ", GetLastError());
                            }
                        }
                        else if (desiredVolume < currentVolume)
                        {
                            // Sell excess volume
double volume = currentVolume - desiredVolume;
if (volume > 0) {
    TradeRequest request = {0};
    request.action = TRADE_ACTION_DEAL;
    request.symbol = symbol;
    request.volume = volume;
    request.type = TRADE_TYPE_SELL;
    request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
    request.position = positionTicket;
    if (OrderSend(request, result)) {
        Print("Sold ", DoubleToString(volume, 2), " lots of ", symbol, " at market price.");
        positionTicket = 0;
        currentVolume -= volume;
        return true;
    } else {
        Print("Failed to sell excess volume of ", symbol, " at market price: ", ErrorDescription(GetLastError()));
        return false;
    }
}
