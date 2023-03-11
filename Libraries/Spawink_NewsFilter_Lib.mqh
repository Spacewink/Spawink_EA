// Spawink_NewsFilter_Lib.mqh

// Define NewsFilter class
class NewsFilter {
private:
    datetime m_newsTime;
    int m_minutesBefore;
    int m_minutesAfter;
public:
    NewsFilter(datetime newsTime, int minutesBefore, int minutesAfter);
    bool isNewsTime(datetime checkTime);
};

// Define NewsEvent class
class NewsEvent {
private:
    datetime m_time;
    string m_currency;
    string m_impact;
    string m_event;
public:
    NewsEvent(datetime time, string currency, string impact, string event);
    datetime getTime();
    string getCurrency();
    string getImpact();
    string getEvent();
};

// Define NewsCalendar class
class NewsCalendar {
private:
    string m_url;
    string m_apiKey;
    int m_maxEvents;
public:
    NewsCalendar(string url, string apiKey, int maxEvents);
    std::vector<NewsEvent> getEvents(string currency, datetime fromDate, datetime toDate);
};

// Implementation of NewsFilter class
NewsFilter::NewsFilter(datetime newsTime, int minutesBefore, int minutesAfter)
{
    m_newsTime = newsTime;
    m_minutesBefore = minutesBefore;
    m_minutesAfter = minutesAfter;
}

bool NewsFilter::isNewsTime(datetime checkTime)
{
    if (checkTime >= (m_newsTime - m_minutesBefore * 60) && 
        checkTime <= (m_newsTime + m_minutesAfter * 60))
        return true;
    return false;
}

// Implementation of NewsEvent class
NewsEvent::NewsEvent(datetime time, string currency, string impact, string event)
{
    m_time = time;
    m_currency = currency;
    m_impact = impact;
    m_event = event;
}

datetime NewsEvent::getTime()
{
    return m_time;
}

string NewsEvent::getCurrency()
{
    return m_currency;
}

string NewsEvent::getImpact()
{
    return m_impact;
}

string NewsEvent::getEvent()
{
    return m_event;
}

// Implementation of NewsCalendar class
NewsCalendar::NewsCalendar(string url, string apiKey, int maxEvents)
{
    m_url = url;
    m_apiKey = apiKey;
    m_maxEvents = maxEvents;
}

std::vector<NewsEvent> NewsCalendar::getEvents(string currency, datetime fromDate, datetime toDate)
{
    // Retrieve news events from the API using m_url and m_apiKey
    // Parse the response and store the events in a vector of NewsEvent objects
    // Filter the events based on currency and date range
    // Return the filtered vector of NewsEvent objects
}

