//+------------------------------------------------------------------+
//|                                                Spawink Visualization Lib                                             |
//|                                                    Copyright 2023|
//+------------------------------------------------------------------+
#property link      "https://spawink.com"
#property version   "1.0"
#property strict

#include <Canvas\Canvas.mqh>
#include <Canvas\ChartObjects.mqh>

//+------------------------------------------------------------------+
//| Class for creating a visualization of the equity curve           |
//+------------------------------------------------------------------+

class EquityCurveVisualization
{
private:
    MqlRates rates[];
    double startingBalance;
    double currentBalance;
    datetime lastTime;
    double equity[];
    int trades;

    Canvas canvas;
    string symbol;
    int timeframe;
    int chartPeriod;

public:
    EquityCurveVisualization(string symbol, int timeframe, int chartPeriod);
    void update(double profit);
};

// Constructor for EquityCurveVisualization
EquityCurveVisualization::EquityCurveVisualization(string symbol, int timeframe, int chartPeriod)
{
    this.symbol = symbol;
    this.timeframe = timeframe;
    this.chartPeriod = chartPeriod;

    ChartSetSymbolPeriod(0, symbol, timeframe);
    ChartSetPeriod(0, chartPeriod);

    startingBalance = AccountBalance();
    currentBalance = startingBalance;

    int size = ChartGetInteger(0, CHART_VISIBLE_RECORDS);
    ArrayResize(rates, size);

    if (!ChartGetRates(0, rates))
    {
        Print("Error getting chart data.");
    }

    lastTime = rates[size-1].time;
    trades = 0;

    canvas.Create(0, "SpaWink Equity Curve", 0, 0, 800, 600);
    canvas.SetBackgroundColor("#FFFFF0");
    canvas.SetMargin(50, 50, 50, 50);

    ChartArea* chartArea = canvas.CreateChartArea();
    chartArea.SetPriceRange(0, 100000);

    LineSeries* equityCurve = chartArea.CreateSeries<Series_Line>("Equity Curve");
    equityCurve.SetWidth(3);

    DateTimeXAxis* dateTimeAxis = chartArea.CreateXAxis<DateTimeXAxis>();
    dateTimeAxis.SetTickCount(10);
    dateTimeAxis.SetFormat("%m/%d/%Y");

    NumberYAxis* numberYAxis = chartArea.CreateYAxis<NumberYAxis>();
    numberYAxis.SetTickCount(10);
    numberYAxis.SetFormat("#,##0.00");

    equityCurve.AddPoint(lastTime, startingBalance);

    equity[0] = startingBalance;
}

// Function to update equity curve
void EquityCurveVisualization::update(double profit)
{
    currentBalance += profit;
    equity[trades+1] = currentBalance;
    trades++;

    int size = ChartGetInteger(0, CHART_VISIBLE_RECORDS);
    MqlRates tempRates[];
    ArrayResize(tempRates, size);
    if (!ChartGetRates(0, tempRates))
    {
        Print("Error getting chart data.");
    }

    for (int i = 0; i < size; i++)
    {
        if (tempRates[i].time > lastTime)
        {
            equityCurve.AddPoint(tempRates[i].time, currentBalance);
            lastTime = tempRates[i].time;
            break;
        }
    }
}
