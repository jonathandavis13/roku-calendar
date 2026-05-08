function GetDaysInMonth(month as Integer, year as Integer) as Integer
    if month = 2
        if (year mod 4 = 0 and year mod 100 <> 0) or (year mod 400 = 0)
            return 29
        else
            return 28
        end if
    else if month = 4 or month = 6 or month = 9 or month = 11
        return 30
    else
        return 31
    end if
end function

function GetDayOfWeek(day as Integer, m as Integer, y as Integer) as Integer
    ' Zeller's congruence for Gregorian calendar
    ' m is month (3=March, ..., 12=Dec, 13=Jan, 14=Feb)
    ' y is year
    if m < 3
        m = m + 12
        y = y - 1
    end if
    
    K = y mod 100
    J = Int(y / 100)
    
    ' h is day of week (0=Sat, 1=Sun, ..., 6=Fri)
    h = (day + Int((13 * (m + 1)) / 5) + K + Int(K / 4) + Int(J / 4) + (5 * J)) mod 7
    
    ' Convert to Roku format (0=Sun, 1=Mon, ..., 6=Sat)
    ' Zeller result h: 0:Sat, 1:Sun, 2:Mon, 3:Tue, 4:Wed, 5:Thu, 6:Fri
    rokuWeekday = [6, 0, 1, 2, 3, 4, 5]
    return rokuWeekday[h]
end function

function FormatYear(year as Integer) as String
    return year.ToStr()
end function

function FormatMonth(month as Integer) as String
    m = month.ToStr()
    if month < 10 then m = "0" + m
    return m
end function

function FormatDay(day as Integer) as String
    d = day.ToStr()
    if day < 10 then d = "0" + d
    return d
end function

function GetMonthName(month as Integer) as String
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    if month < 1 or month > 12
        return "Unknown"
    end if
    return months[month - 1]
end function
