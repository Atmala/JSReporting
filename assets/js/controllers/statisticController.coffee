define ['jquery', 'data/utilData', 'utils/workingDaysAnalyzer'], ($, data, WorkingDaysAnalyzer) ->

  return angular.module('statistic', ['utilData'])
      .controller('statisticCtrl',
        ($scope, $rootScope, GuidelinesData) ->
          $rootScope.$on('gridDataLoaded',
            (event, gridData) ->
              data = _.filter(gridData, (d) -> return d.date.getMonth() == Date.today().getMonth())

              $('.projModule').html('')

              initProjectStatistic(data)
              initMonthStatistic(data, gridData)
          )

          initProjectStatistic = (data) ->
            if data.length == 0
              $('.projModule').html('Empty report data for current month')
            else
              data = _.filter(data, (d) -> return d.duration > 0)
              reportItems = crossfilter(data)

              itemsByProject = reportItems.dimension((d) -> return d.project )

              projTotal = itemsByProject.group()
                .reduceSum((d) -> return d.duration )
                .top(3)

              x = d3.scale.linear()
                .domain([0, d3.max(projTotal, (d) -> return d.value)])
                .range(["0px", "157px"])

              chart = d3.select(".projModule")
               .append("div")
               .attr("class", "chart")

              chart.selectAll("div")
                  .data(projTotal)
                  .enter()
                  .append("div")
                  .attr("class", "row")

              row = chart.selectAll(".row")

              row.append("div").attr("class", "span4 text").text((d) -> return d.key)

              row.append("div").attr("class", "span8")
                  .append("div").attr("class", "bar")
                  .style("width", (d) -> return x(d.value))
                  .text((d) -> return d.value )

              $scope.projectStatTitle = 'Project hours'

          initMonthStatistic = (data, gridData)->
            if data.length == 0
              $('.monthModule').html('Empty report data for current month')
            else
              reportItems = crossfilter _.filter(data, (d) -> return d.duration > 0)
              itemsByHours = reportItems.dimension (d) -> return d.duration
              hours = itemsByHours
                .groupAll()
                .reduceSum((d) -> return d.duration)
                .value()

              dt = Date.today()
              expected = WorkingDaysAnalyzer.getWeekdaysInMonth(dt.getMonth(), dt.getFullYear()) * 8
              $scope.monthStatistic = [];
              $scope.monthStatistic.push initStatisticItem 'Work hours', expected, hours

              total =  _.find(GuidelinesData, (item)-> return item.hasOwnProperty('illDaysCount')).illDaysCount;
              days = _.filter(data, (d) -> return d.project?.toLowerCase() == 'ill' || d.task?.toLowerCase() == 'ill').length
              $scope.monthStatistic.push initStatisticItem 'Ill days', total, days

              total =  _.find(GuidelinesData, (item)-> return item.hasOwnProperty('vacationDaysCount')).vacationDaysCount;
              days = _.filter(gridData, (d) -> return d.project?.toLowerCase() == 'vacation' || d.task?.toLowerCase() == 'vacation').length
              $scope.monthStatistic.push initStatisticItem 'Vacation', total, days

              $scope.monthStatTitle = Date.today().getMonthName() + ' statistic'

          initStatisticItem = (title, total, current)->
            width = Math.ceil current*100/total

            return {
              title: title,
              total: total,
              current: current,
              width: width,
              style: {width: width + 'px'}
              }
      )
