sub init()
    m.titleLabel = m.top.findNode("titleLabel")
    m.calendarGrid = m.top.findNode("calendarGrid")
    m.statusLabel = m.top.findNode("statusLabel")
    
    m.top.setFocus(true)
    
    ' Set current date
    now = CreateObject("roDateTime")
    m.calendarGrid.month = now.GetMonth()
    m.calendarGrid.year = now.GetYear()
    
    ' Trigger the iCal fetch
    url = "webcal://p155-caldav.icloud.com/published/2/MTg2Mzk3NDczMTg2Mzk3NGG2KV__F16zhZcpGUf7pI7IFvkhTI9T0Xyt-3MSz8sv"
    if url.Left(9) = "webcal://"
        url = "https://" + url.Mid(9)
    end if
    fetchEvents(url) 
end sub

sub fetchEvents(url as String)
    m.icalTask = CreateObject("roSGNode", "ICalTask")
    m.icalTask.url = url
    m.icalTask.observeField("events", "onEventsReceived")
    m.icalTask.control = "RUN"
end sub

sub onEventsReceived(event as Object)
    events = event.getData()
    if events <> invalid and events.Count() > 0
        m.statusLabel.visible = false
        m.calendarGrid.events = events
    else
        m.statusLabel.text = "No events found or error loading calendar."
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press
        if key = "left"
            m.calendarGrid.month--
            if m.calendarGrid.month < 1
                m.calendarGrid.month = 12
                m.calendarGrid.year--
            end if
            handled = true
        else if key = "right"
            m.calendarGrid.month++
            if m.calendarGrid.month > 12
                m.calendarGrid.month = 1
                m.calendarGrid.year++
            end if
            handled = true
        end if
    end if
    return handled
end function
