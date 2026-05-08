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
    m.calendarUrls = [
        "https://p155-caldav.icloud.com/published/2/MTg2Mzk3NDczMTg2Mzk3NGG2KV__F16zhZcpGUf7pI7IFvkhTI9T0Xyt-3MSz8sv",
        "https://p43-caldav.icloud.com/published/2/NTUyODIyMjQ4NTUyODIyMuFV2TmWATgWZxsOim4AjUkQajsGMR_QaTDTo8zrrgaUMYbgTLSzbT515zEew3KJk72eDSkQFoRJ7wsBWvqWHFw"
    ]
    
    m.allEvents = []
    m.pendingRequests = m.calendarUrls.Count()
    
    for each url in m.calendarUrls
        fetchEvents(url)
    end for
end sub

sub fetchEvents(url as String)
    task = CreateObject("roSGNode", "ICalTask")
    task.url = url
    task.observeField("events", "onEventsReceived")
    task.control = "RUN"
end sub

sub onEventsReceived(event as Object)
    task = event.getRoSGNode()
    events = task.events
    
    if events <> invalid
        m.allEvents.Append(events)
    end if
    
    m.pendingRequests--
    
    if m.pendingRequests <= 0
        if m.allEvents.Count() > 0
            m.statusLabel.visible = false
            m.calendarGrid.events = m.allEvents
        else
            m.statusLabel.text = "No events found or error loading calendars."
        end if
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
