function FormatICalDate(icalDate as String) as String
    ' Typical formats: 20231027T103000Z or 20231027
    if icalDate.Len() < 8 then return icalDate
    
    year = icalDate.Left(4)
    month = icalDate.Mid(4, 2)
    day = icalDate.Mid(6, 2)
    
    formattedDate = year + "-" + month + "-" + day
    
    if icalDate.Len() >= 15 and icalDate.Mid(8, 1) = "T"
        hour = icalDate.Mid(9, 2)
        minute = icalDate.Mid(11, 2)
        formattedDate = formattedDate + " " + hour + ":" + minute
    end if
    
    return formattedDate
end function

function ParseICal(icalText as String) as Object
    ' ... (rest of the function)
    ' Unfold lines: RFC 5545 says any line starting with a space or tab is a continuation of the previous line
    unfoldedText = ""
    lines = icalText.Split(chr(13) + chr(10)) ' Try CRLF first
    if lines.Count() = 1 then lines = icalText.Split(chr(10)) ' Then try LF
    
    for i = 0 to lines.Count() - 1
        line = lines[i]
        if i > 0 and (line.Left(1) = " " or line.Left(1) = chr(9))
            unfoldedText = unfoldedText + line.Mid(1)
        else
            if unfoldedText <> "" then unfoldedText = unfoldedText + chr(10)
            unfoldedText = unfoldedText + line
        end if
    end for

    events = []
    lines = unfoldedText.Split(chr(10))
    currentEvent = invalid

    for each line in lines
        line = line.Trim()
        if line <> ""
            if line.Left(12) = "BEGIN:VEVENT"
                currentEvent = {}
            else if line.Left(10) = "END:VEVENT"
                if currentEvent <> invalid
                    events.Push(currentEvent)
                    currentEvent = invalid
                end if
            else if currentEvent <> invalid
                colonIndex = line.Instr(":")
                if colonIndex > -1
                    key = line.Left(colonIndex)
                    value = line.Mid(colonIndex + 1)
                    
                    ' Handle parameters in keys like DTSTART;VALUE=DATE
                    semicolonIndex = key.Instr(";")
                    if semicolonIndex > -1
                        key = key.Left(semicolonIndex)
                    end if

                    currentEvent[key] = value
                end if
            end if
        end if
    end for

    return events
end function

function FetchAndParseICal(url as String) as Object
    request = CreateObject("roUrlTransfer")
    request.SetUrl(url)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.InitClientCertificates()
    
    icalText = request.GetToString()
    if icalText <> ""
        return ParseICal(icalText)
    end if
    
    return []
end function
