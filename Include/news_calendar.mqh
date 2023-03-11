#ifndef NEWS_CALENDAR_MQH
#define NEWS_CALENDAR_MQH

#include <stdlib.mqh>

struct NewsEvent
{
    datetime time;
    string currency;
    string event;
    int impact;
    double actual;
    double forecast;
    double previous;
};

class NewsCalendar
{
    private:
        string m_url;
        int m_cacheExpirationTime;
        datetime m_lastUpdateTime;
        NewsEvent* m_events;
        int m_numEvents;

    public:
        NewsCalendar(string url, int cacheExpirationTime);
        NewsCalendar(int cacheExpirationTime);
        ~NewsCalendar();

        void update();
        bool isEventUpcoming(NewsEvent event, int minutesBefore);
        NewsEvent* getEventsForDay(datetime date, string currency = "");
        int getNumEvents();
        NewsEvent getEvent(int index);
};

NewsCalendar::NewsCalendar(string url, int cacheExpirationTime)
{
    m_url = url;
    m_cacheExpirationTime = cacheExpirationTime;
    m_lastUpdateTime = 0;
    m_events = NULL;
    m_numEvents = 0;
}

NewsCalendar::NewsCalendar(int cacheExpirationTime)
{
    m_url = "http://www.forexfactory.com/calendar.php";
    m_cacheExpirationTime = cacheExpirationTime;
    m_lastUpdateTime = 0;
    m_events = NULL;
    m_numEvents = 0;
}

NewsCalendar::~NewsCalendar()
{
    if (m_events != NULL)
    {
        delete[] m_events;
    }
}

void NewsCalendar::update()
{
    if (m_events != NULL)
    {
        delete[] m_events;
    }

    int webRequestHandle = WebRequest("GET", m_url, NULL, NULL, 10000);
    if (webRequestHandle == INVALID_HANDLE)
    {
        return;
    }

    string response = WebRequest("GET", m_url, NULL, NULL, 10000);

    int numEvents = 0;
    string startTag = "<tr class=\"calendar_row ";
    string endTag = "</tr>";
    string remainingText = response;

    while (remainingText != "")
    {
        int start = StringFind(remainingText, startTag, 0);
        if (start == -1)
        {
            break;
        }
        remainingText = StringSubstr(remainingText, start);

        int end = StringFind(remainingText, endTag, 0);
        if (end == -1)
        {
            break;
        }

        string eventHtml = StringSubstr(remainingText, 0, end + StringLen(endTag));
        remainingText = StringSubstr(remainingText, end + StringLen(endTag));

        NewsEvent event;
        event.time = StrToTime(StringSubstr(eventHtml, StringFind(eventHtml, "<td class=\"calendar__date\"") + StringLen("<td class=\"calendar__date\""), StringFind(eventHtml, "</td>", StringFind(eventHtml, "<td class=\"calendar__date\""))));
        event.currency = StringSubstr(eventHtml, StringFind(eventHtml, "<td class=\"calendar__currency\"") + StringLen("<td class=\"calendar__currency\""), StringFind(eventHtml, "</td>", StringFind(eventHtml, "<td class=\"calendar__currency\"")) - StringFind(eventHtml, "<td class=\"calendar__currency\"") - StringLen("<td class=\"calendar__currency\""));
        event.event = StringSubstr(eventHtml, StringFind(eventHtml, "<td class=\"calendar__event\"") + StringLen("<td class=\"calendar__event
bool filterNews(const datetime& startTime, const datetime& endTime, const int impact)
{
    int newsCount = NewsCalTotal();

    for (int i = 0; i < newsCount; i++)
    {
        NewsEvent event;
        if (NewsCalGetEvent(i, event))
        {
            if (event.DateTime() >= startTime && event.DateTime() <= endTime && event.Impact() >= impact)
            {
                return true;
            }
        }
    }

    return false;
}
