//+------------------------------------------------------------------+
//|                                              visualization.mqh   |
//|                                   Library for trade visualization|
//|                                                    Copyright 2023 |
//+------------------------------------------------------------------+

#ifndef VISUALIZATION_MQH
#define VISUALIZATION_MQH

// Include necessary libraries here

class TradeVisualizer
{
    private:
        int chartID;
        int objectID;
        string objectName;

    public:
        TradeVisualizer(int chartID, int objectID, string objectName);
        void draw(double x, double y, string text, color clr, int size, int arrowType);
        void drawEntry(double x, double y, color clr, int size, int arrowType);
        void drawExit(double x, double y, color clr, int size, int arrowType);
};

// Constructor for TradeVisualizer Class
TradeVisualizer::TradeVisualizer(int chartID, int objectID, string objectName)
{
    this->chartID = chartID;
    this->objectID = objectID;
    this->objectName = objectName;
}

// Function to draw a text object on the chart
void TradeVisualizer::draw(double x, double y, string text, color clr, int size, int arrowType)
{
    ObjectCreate(chartID, objectName, OBJ_TEXT, 0, 0, 0);
    ObjectSetInteger(chartID, objectName, OBJPROP_SELECTABLE, false);
    ObjectSetText(chartID, objectName, text, size, "Arial", clr);
    ObjectSetInteger(chartID, objectName, OBJPROP_TIME1, TimeCurrent());
    ObjectSetDouble(chartID, objectName, OBJPROP_PRICE1, y);
    ObjectSetInteger(chartID, objectName, OBJPROP_ANCHOR, anchorType);
    ObjectSetInteger(chartID, objectName, OBJPROP_ARROWCODE, arrowType);
}

// Function to draw an entry arrow on the chart
void TradeVisualizer::drawEntry(double x, double y, color clr, int size, int arrowType)
{
    ObjectCreate(chartID, objectName, OBJ_ARROW, 0, 0, 0);
    ObjectSetInteger(chartID, objectName, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(chartID, objectName, OBJPROP_TIME1, TimeCurrent());
    ObjectSetDouble(chartID, objectName, OBJPROP_PRICE1, y);
    ObjectSetInteger(chartID, objectName, OBJPROP_ANCHOR, anchorType);
    ObjectSetInteger(chartID, objectName, OBJPROP_ARROWCODE, arrowType);
    ObjectSetInteger(chartID, objectName, OBJPROP_COLOR, clr);
}

// Function to draw an exit arrow on the chart
void TradeVisualizer::drawExit(double x, double y, color clr, int size, int arrowType)
{
    ObjectCreate(chartID, objectName, OBJ_ARROW, 0, 0, 0);
    ObjectSetInteger(chartID, objectName, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(chartID, objectName, OBJPROP_TIME1, TimeCurrent());
    ObjectSetDouble(chartID, objectName, OBJPROP_PRICE1, y);
    ObjectSetInteger(chartID, objectName, OBJPROP_ANCHOR, anchorType);
    ObjectSetInteger(chartID, objectName, OBJPROP_ARROWCODE, arrowType);
    ObjectSetInteger(chartID, objectName, OBJPROP_COLOR, clr);
}

#endif
