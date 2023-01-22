package GregorianCalendar

import (
  "strconv"
  "time"
  "fmt"
)

func CreateCalendarTable() []map[string]string {
  var FirstCalendarDate time.Time = time.Date(time.Now().Year(), time.January, 1, 0, 0, 0, 0, time.Now().Local().Location())
  // 1 second = 1 000 000 000 nanoseconds
  var LastCalendarDate time.Time = time.Date(time.Now().Year(), time.December, 31, 23, 59, 59, 999999999, time.Now().Local().Location())
  var TotalDays int = LastCalendarDate.YearDay() - FirstCalendarDate.YearDay() + 1
  var CreatedCalendarTable []map[string]string = make([]map[string]string, 0, TotalDays)
  for i := 0; i < TotalDays; i++ {
    var CalendarDates time.Time
    CalendarDates = FirstCalendarDate.AddDate(0, 0, i)
    var CalendarTableEntries map[string]string = map[string]string{
      "DayOfYear":  strconv.Itoa(i + 1),
      "Month":      strconv.Itoa(int(CalendarDates.Month())),
      "DayOfMonth": strconv.Itoa(CalendarDates.Day()),
      "WeekDay":    strconv.Itoa(int(CalendarDates.Weekday())),
    }
    CreatedCalendarTable = append(CreatedCalendarTable, CalendarTableEntries)
  }
  return CreatedCalendarTable
}
