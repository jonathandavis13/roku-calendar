sub init()
    m.monthLabel = m.top.findNode("monthLabel")
    m.dayHeaders = m.top.findNode("dayHeaders")
    m.gridCells = m.top.findNode("gridCells")

    m.cellWidth = 150
    m.cellHeight = 100
    m.spacing = 10

    setupHeaders()
end sub

sub setupHeaders()
    days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    for i = 0 to 6
        label = m.dayHeaders.createChild("Label")
        label.text = days[i]
        label.width = m.cellWidth
        label.horizAlign = "center"
        label.translation = [i * (m.cellWidth + m.spacing), 0]
    next
end sub

sub updateGrid()
    if m.top.month = 0 or m.top.year = 0 then return
    
    m.monthLabel.text = GetMonthName(m.top.month) + " " + m.top.year.ToStr()
    
    ' Clear previous cells
    m.gridCells.removeChildrenIndex(m.gridCells.getChildCount(), 0)

    firstDay = GetDayOfWeek(1, m.top.month, m.top.year)
    daysInMonth = GetDaysInMonth(m.top.month, m.top.year)

    row = 0
    col = firstDay
    for day = 1 to daysInMonth
        cell = m.gridCells.createChild("Group")
        cell.translation = [col * (m.cellWidth + m.spacing), row * (m.cellHeight + m.spacing)]
        
        bg = cell.createChild("Rectangle")
        bg.width = m.cellWidth
        bg.height = m.cellHeight
        bg.color = "0x333333FF"
        
        label = cell.createChild("Label")
        label.text = day.ToStr()
        label.translation = [5, 5]
        label.font = "font:SmallSystemFont"

        ' Placeholder for events
        eventsGroup = cell.createChild("Group")
        eventsGroup.id = "events_" + day.ToStr()
        eventsGroup.translation = [5, 30]

        col++
        if col > 6
            col = 0
            row++
        end if
    next
    
    updateEvents()
end sub

sub updateEvents()
    events = m.top.events
    if events = invalid or events.Count() = 0 then return
    
    ' This is a simplified event mapping
    ' In a real app, we'd filter events for the current month
    for each event in events
        dtstart = event.DTSTART
        if dtstart <> invalid and dtstart.Len() >= 8
            year = dtstart.Left(4).ToInt()
            month = dtstart.Mid(4, 2).ToInt()
            day = dtstart.Mid(6, 2).ToInt()
            
            if year = m.top.year and month = m.top.month
                eventsGroup = m.gridCells.findNode("events_" + day.ToStr())
                if eventsGroup <> invalid
                    if eventsGroup.getChildCount() < 3 ' Limit to 3 markers
                        marker = eventsGroup.createChild("Rectangle")
                        marker.width = m.cellWidth - 10
                        marker.height = 20
                        marker.color = "0x00AA00FF"
                        marker.translation = [0, eventsGroup.getChildCount() * 22]
                        
                        label = marker.createChild("Label")
                        label.text = event.SUMMARY
                        label.width = m.cellWidth - 10
                        label.font = "font:SmallestSystemFont"
                    end if
                end if
            end if
        end if
    next
end sub
