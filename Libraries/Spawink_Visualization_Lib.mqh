//+------------------------------------------------------------------+
//|                       SpaWink_Visualization_Lib.mqh              |
//|                  Copyright 2023, SpaWink Inc.                    |
//|                       https://www.spawink.com                    |
//+------------------------------------------------------------------+

#property copyright "Copyright 2023, SpaWink Inc."
#property link      "https://www.spawink.com"
#property version   "1.00"
#property strict

/**
 * @brief Enumeration for chart types.
 */
enum ChartType
{
    CHART_LINE,        ///< Line chart.
    CHART_BAR,         ///< Bar chart.
    CHART_CANDLE,      ///< Candle chart.
    CHART_AREA,        ///< Area chart.
    CHART_POINTFIGURE, ///< Point and figure chart.
    CHART_RENKO,       ///< Renko chart.
    CHART_KAGI,        ///< Kagi chart.
    CHART_PNF,         ///< Point and figure chart.
    CHART_COUNT        ///< Total chart types.
};

/**
 * @brief Enumeration for chart line styles.
 */
enum ChartLineStyle
{
    LINE_STYLE_SOLID,     ///< Solid line style.
    LINE_STYLE_DASH,      ///< Dash line style.
    LINE_STYLE_DOT,       ///< Dot line style.
    LINE_STYLE_DASHDOT,   ///< Dash-dot line style.
    LINE_STYLE_DASHDOTDOT ///< Dash-dot-dot line style.
};

/**
 * @brief Structure to hold chart data.
 */
struct ChartData
{
    datetime time; ///< Chart bar time.
    double   open; ///< Chart bar open price.
    double   high; ///< Chart bar high price.
    double   low;  ///< Chart bar low price.
    double   close;///< Chart bar close price.
};

/**
 * @brief Class for creating and manipulating charts.
 */
class Chart
{
private:
    string m_name; ///< Chart name.
    int    m_window;///< Chart window number.
public:
    /**
     * @brief Class constructor.
     * 
     * @param name Chart name.
     * @param window Chart window number.
     */
    Chart(const string name, const int window) : m_name(name), m_window(window) {}

    /**
     * @brief Function to set chart window property.
     * 
     * @param property Property to set.
     * @param value Value to set property to.
     */
    void setProperty(const int property, const long value) const
    {
        ChartSetInteger(m_window, property, value);
    }

    /**
     * @brief Function to add a chart indicator.
     * 
     * @param name Indicator name.
     * @param subWindow Sub-window to add indicator to.
     * @param inputs Input parameters for the indicator.
     */
    void addIndicator(const string name, const int subWindow, const double& inputs[]) const
    {
        int indicatorHandle = iCustom(NULL, m_window, name, inputs);
        ChartIndicatorAdd(m_window, subWindow, indicatorHandle);
    }

    /**
     * @brief Function to add a chart object.
     * 
     * @param objectName Object name.
     * @param subWindow Sub-window to add object to.
     * @param time Time of the object.
     * @param price Price of the object.
     */
    void addObject(const string objectName, const int subWindow, const datetime time, const double price) const
    {
        int objectHandle = ObjectCreate(m_window, objectName, OBJ_TREND, subWindow, time, price, time, price);
   
