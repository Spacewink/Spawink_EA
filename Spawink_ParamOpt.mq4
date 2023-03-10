//+------------------------------------------------------------------+
//|                                             Spawink_ParamOpt.mq4 |
//|              Parameter optimization functions and classes        |
//|                       compatible with SpaWink EA v1.4             |
//+------------------------------------------------------------------+
#property strict

// Parameter optimization result
struct OptResult
{
    double profit;              // Total profit
    double avgProfit;           // Average profit per trade
    double winRate;             // Win rate (%)
    double maxDrawdown;         // Maximum drawdown
    datetime startDate;         // Start date of optimization period
    datetime endDate;           // End date of optimization period
    int numTrades;              // Total number of trades
};

// Optimization result comparer (sort by profit)
bool OptResultCompare(OptResult x, OptResult y)
{
    return x.profit > y.profit;
}

// Parameter optimization class
class ParamOptimizer
{
private:
    string fileName;            // File name of the EA to optimize
    datetime startDate;         // Start date of optimization period
    datetime endDate;           // End date of optimization period
    int numRuns;                // Number of runs per set of parameters
    int numParams;              // Number of parameters to optimize
    double stepSize[];          // Step size for each parameter
    double minValue[];          // Minimum value for each parameter
    double maxValue[];          // Maximum value for each parameter
    int numSets;                // Number of sets of parameters to try
    int currentSet;             // Current set of parameters being tried
    int currentParam[];         // Current parameter value for each parameter being tried
    OptResult results[];        // Optimization results for each set of parameters

public:
    ParamOptimizer(string fileName, datetime startDate, datetime endDate, int numRuns, int numParams, double stepSize[], double minValue[], double maxValue[], int numSets)
    {
        this.fileName = fileName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.numRuns = numRuns;
        this.numParams = numParams;
        this.numSets = numSets;
        this.currentSet = 0;

        ArrayResize(stepSize, numParams);
        ArrayResize(minValue, numParams);
        ArrayResize(maxValue, numParams);
        ArrayResize(currentParam, numParams);
        ArrayResize(results, numSets);

        this.stepSize = stepSize;
        this.minValue = minValue;
        this.maxValue = maxValue;

        // Initialize results
        for (int i = 0; i < numSets; i++)
        {
            OptResult result;
            result.profit = 0;
            result.avgProfit = 0;
            result.winRate = 0;
            result.maxDrawdown = 0;
            result.startDate = 0;
            result.endDate = 0;
            result.numTrades = 0;

            results[i] = result;
        }
    }

    // Optimize parameters and return the best result
    OptResult Optimize()
    {
        // Try each set of parameters
        for (currentSet = 0; currentSet < numSets; currentSet++)
        {
            // Set the current parameter values to the minimum values
            for (int i = 0; i < numParams; i++)
            {
                currentParam[i] = minValue[i];
            }

            // Try each combination of parameter values
            while (true)
            {
                // Optimize with current parameter values
                double profit = Optimize(parameters);

                // Update the best result and save the parameter values
                if (profit > bestResult.profit)
                {
                    bestResult.profit = profit;
                    bestResult.parameters = parameters;
                    Print("New best result found: profit = ", DoubleToString(profit, 2), ", parameters = ", ParametersToString(parameters));
                }

                // Move to the next combination of parameter values
                if (!MoveToNextCombination(parameters))
                {
                    // End of parameter combinations
                    break;
                }
            }

            // Output the best result
            Print("Parameter optimization completed.");
            Print("Best result: profit = ", DoubleToString(bestResult.profit, 2), ", parameters = ", ParametersToString(bestResult.parameters));

            // Set the optimized parameters in the EA inputs
            for (int i = 0; i < numParameters; i++)
            {
                string parameterName = parameterNames[i];
                double parameterValue = bestResult.parameters[i];
                if (parameterValue != InputGetDouble(parameterName))
                {
                    InputSetDouble(parameterName, parameterValue);
                    Print("Input parameter set: ", parameterName, " = ", DoubleToString(parameterValue, 2));
                }
            }
        }
    }

    // Function to optimize the EA with a set of parameter values
    double Optimize(double[] parameters)
    {
        // Set the parameter values in the EA inputs
        for (int i = 0; i < numParameters; i++)
        {
            InputSetDouble(parameterNames[i], parameters[i]);
        }

        // Test the EA with the current parameter values
        double profit = 0.0;
        int count = 0;
        for (int i = 0; i < numTests; i++)
        {
            if (i % numThreads == threadId)
            {
                // Run the EA on the current test period
                double testProfit = Test(parameters);
                profit += testProfit;
                count++;
            }
        }
        if (count > 0)
        {
            profit /= count;
        }

        // Return the average profit over all test periods
        return profit;
    }

    // Function to test the EA with the current parameter values on a specific test period
    double Test(double[] parameters)
    {
        // Set the parameter values in the EA inputs
        for (int i = 0; i < numParameters; i++)
        {
            InputSetDouble(parameterNames[i], parameters[i]);
        }

        // Set the test period in the EA inputs
        InputSetInteger("TestPeriod", testPeriods[testIndex]);

        // Run the EA on the test period and return the profit
        ResetLastError();
        double profit = AccountInfoDouble(ACCOUNT_BALANCE);
        bool success = StartTesting();
        if (success)
        {
            int ticks = 0;
            while (Testing())
            {
                ticks++;
                if (ticks >= maxTicks)
                {
                    Print("Test period exceeded maximum ticks: period = ", testPeriods[testIndex], ", ticks = ", ticks);
                    break;
                }
            }
            profit = AccountInfoDouble(ACCOUNT_BALANCE) - profit;
            StopTesting();
        }
        else
        {
            int error = GetLastError();
            Print("Failed to start testing: error = ", error);
        }
        return profit;
    }

    // Function to move to the next combination of parameter values
bool CParamOptimizer::MoveToNextCombination()
{
    int i = 0;
    while (i < m_paramCount && ++m_currentValues[i] == m_values[i].size())
    {
        m_currentValues[i] = 0;
        i++;
    }
    return (i < m_paramCount);
}

// Function to run optimization on the specified strategy
void CParamOptimizer::RunOptimization(const string& strategyName, const int& period)
{
    CExpertHandle expert = CreateExpert(strategyName);
    if (!expert.IsValid())
    {
        Print("Failed to create expert advisor: ", strategyName);
        return;
    }

    for (int i = 0; i < m_paramCount; i++)
    {
        expert.SetParameter(m_params[i], m_values[i][m_currentValues[i]]);
    }

    int ticks = SymbolsTotal(false);
    for (int i = 0; i < ticks; i++)
    {
        if (!SymbolInfoSessionTime(SymbolName(i)))
        {
            continue;
        }

        if (period == 0)
        {
            expert.SetSymbol(SymbolName(i), SYMBOL_CURRENT);
        }
        else
        {
            expert.SetSymbol(SymbolName(i), period);
        }

        if (expert.Start())
        {
            expert.Stop();
        }

        if (IsStopped())
        {
            return;
        }
    }

    expert.Delete();
}
