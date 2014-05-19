define  ['lib/date'], () ->

  class WorkingDaysAnalyzer

    @monthNames: [
      "January", "February", "March",
      "April", "May", "June",
      "July", "August", "September",
      "October", "November", "December"
    ]

    constructor: (@hollidaysPerMonth) ->

    @getMonthName: (date) ->
      WorkingDaysAnalyzer.monthNames[date.getMonth()]

    @getShortMonthName: (date) ->
      WorkingDaysAnalyzer.monthNames[date.getMonth()].substr(0, 3)

    @getWeekdaysInMonth: (month,year) ->
      days = Date.getDaysInMonth year, month
      daysOrigin = new Number(days);
      startInd = new Date(year, month, 1).getDay()
      result = 0

      if startInd > 1
        days -= 7 - startInd
        result += 5 - startInd

      fullWeeksCount = Math.floor days / 7
      rest = days % 7
      result += fullWeeksCount * 5

      if rest > 0
        result += if rest < 6 then rest else 5

      console.log "There are #{result} days in #{month} month of #{year}"
      return result

  return WorkingDaysAnalyzer
