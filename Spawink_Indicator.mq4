#property strict


#include "Spawink_Indicators_Lib.mqh"

// Moving Average
double MovingAverage(double price[], int length)
{
    double sum = 0;
    for(int i = 0; i < length; i++)
    {
        sum += price[i];
    }
    return sum / length;
}

// Exponential Moving Average
double ExponentialMovingAverage(double price[], int length)
{
    double multiplier = 2.0 / (length + 1);
    double ema = MovingAverage(price, length);
    for(int i = length; i < ArraySize(price); i++)
    {
        ema = (price[i] - ema) * multiplier + ema;
    }
    return ema;
}

// Bollinger Bands
void BollingerBands(double price[], int length, double& upperBand[], double& lowerBand[])
{
    double sma = MovingAverage(price, length);
    double stdDev = 0;
    for(int i = 0; i < length; i++)
    {
        stdDev += MathPow(price[i] - sma, 2);
    }
    stdDev = MathSqrt(stdDev / length);
    upperBand[0] = sma + 2 * stdDev;
    lowerBand[0] = sma - 2 * stdDev;
    for(int i = length; i < ArraySize(price); i++)
    {
        sma = MovingAverage(ArrayRange(price, i - length + 1, i), length);
        stdDev = 0;
        for(int j = i - length + 1; j <= i; j++)
        {
            stdDev += MathPow(price[j] - sma, 2);
        }
        stdDev = MathSqrt(stdDev / length);
        upperBand[i] = sma + 2 * stdDev;
        lowerBand[i] = sma - 2 * stdDev;
    }
}

// Relative Strength Index (RSI)
double RelativeStrengthIndex(double price[], int length)
{
    double sumGain = 0;
    double sumLoss = 0;
    for(int i = 1; i < length; i++)
    {
        double difference = price[i] - price[i-1];
        if(difference > 0)
        {
            sumGain += difference;
        }
        else
        {
            sumLoss += MathAbs(difference);
        }
    }
    double rs = sumGain / sumLoss;
    double rsi = 100 - (100 / (1 + rs));
    return rsi;
}

// Moving Average Convergence Divergence (MACD)
void MovingAverageConvergenceDivergence(double price[], int fastLength, int slowLength, int signalLength, double& macd[], double& signal[], double& histogram[])
{
    double fastEma = ExponentialMovingAverage(price, fastLength);
    double slowEma = ExponentialMovingAverage(price, slowLength);
    macd[0] = fastEma - slowEma;
    signal[0] = ExponentialMovingAverage(ArrayRange(macd, 0, signalLength), signalLength);
    histogram[0] = macd[0] - signal[0];
    for(int i = slowLength; i < ArraySize(price); i++)
    {
        fastEma = ExponentialMovingAverage(ArrayRange(price, i - fastLength + 1, i), fastLength);
        slowEma = ExponentialMovingAverage(ArrayRange(price, i - slowLength + 1,


    // Calculate the MACD and signal lines
    macd = fastEma - slowEma;
    signal = ExponentialMovingAverage(ArrayRange(macdBuffer, i - signalLength + 1, i), signalLength);

    // Calculate the histogram
    histogram = macd - signal;

    // Set the output buffers
    SetIndexBuffer(0, macdBuffer);
    SetIndexBuffer(1, signalBuffer);
    SetIndexBuffer(2, histogramBuffer);

    // Fill the output buffers
    for (int j = 0; j < limit; j++) {
        int idx = i - limit + j;
        if (idx >= 0) {
            macdBuffer[j] = fastEmaBuffer[j] - slowEmaBuffer[j];
            signalBuffer[j] = ExponentialMovingAverage(ArrayRange(macdBuffer, idx - signalLength + 1, idx), signalLength);
            histogramBuffer[j] = macdBuffer[j] - signalBuffer[j];
        }
    }

    // Return the limit
    return limit;
}
}

//+------------------------------------------------------------------+
//| Custom functions |
//+------------------------------------------------------------------+

// Calculates the exponential moving average of the given values with the given length
double ExponentialMovingAverage(double[] values, int length) {
double alpha = 2.0 / (length + 1);
double ema = values[length - 1];
for (int i = length - 2; i >= 0; i--) {
ema = alpha * values[i] + (1 - alpha) * ema;
}
return ema;
}

// Calculates the simple moving average of the given values with the given length
double SimpleMovingAverage(double[] values, int length) {
double sum = 0;
for (int i = 0; i < length; i++) {
sum += values[i];
}
return sum / length;
}

// Calculates the highest value of the given values over the given length
double Highest(double[] values, int length) {
double highest = values[length - 1];
for (int i = length - 2; i >= 0; i--) {
if (values[i] > highest) {
highest = values[i];
}
}
return highest;
}

// Calculates the lowest value of the given values over the given length
double Lowest(double[] values, int length) {
double lowest = values[length - 1];
for (int i = length - 2; i >= 0; i--) {
if (values[i] < lowest) {
lowest = values[i];
}
}
return lowest;
}

// Calculates the average true range of the given values over the given length
double AverageTrueRange(double[] high, double[] low, double[] close, int length) {
double[] trueRange = new double[length];
for (int i = length - 1; i >= 0; i--) {
double range1 = high[i] - low[i];
double range2 = Math.Abs(high[i] - close[i + 1]);
double range3 = Math.Abs(low[i] - close[i + 1]);
trueRange[i] = Math.Max(range1, Math.Max(range2, range3));
}
return SimpleMovingAverage(trueRange, length);
}

// Calculates the relative strength index of the given values over the given length
double RelativeStrengthIndex(double[] values, int length) {
double[] changes = new double[length];
for (int i = length - 1;
double sma[length];

// Calculate the SMA for the given length
for (int i = length - 1; i < bars; i++)
{
    double sum = 0;

    // Sum the prices over the specified length
    for (int j = i; j > i - length; j--)
    {
        sum += price[j];
    }

    sma[i] = sum / length;
}

// Calculate the standard deviation of the prices over the specified length
double stddev[length];
for (int i = length - 1; i < bars; i++)
{
    double sum = 0;

    // Calculate the sum of the squared differences between the price and the SMA over the specified length
    for (int j = i; j > i - length; j--)
    {
        sum += MathPow(price[j] - sma[i], 2);
    }

    stddev[i] = MathSqrt(sum / length);
}

// Calculate the upper and lower Bollinger Bands
double upper[length];
double lower[length];
for (int i = length - 1; i < bars; i++)
{
    upper[i] = sma[i] + (multiplier * stddev[i]);
    lower[i] = sma[i] - (multiplier * stddev[i]);
}

// Return the indicator value for the most recent bar
if (mode == MODE_UPPER)
{
    return upper[bars - 1];
}
else if (mode == MODE_LOWER)
{
    return lower[bars - 1];
}
else
{
    return sma[bars - 1];
}



