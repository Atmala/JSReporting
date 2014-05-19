XLSX = require 'xlsx'
fs = require 'fs'

module.exports = ->
    save: (xlData) ->
      fs.writeFile("d:/temp/testNode.csv", xlData);

    parse: (xlData) ->
      xlsx = XLSX.readFile('d:\\Temp\\TimeReport.xlsx');
      result = []

      num = 1
      while xlsx.Sheets['TimeReport']['C' + num].v?
        result.push {
        'date' : xlsx.Sheets['TimeReport']['A' + num]?.v
        'project' : xlsx.Sheets['TimeReport']['B' + num]?.v
        'task' : xlsx.Sheets['TimeReport']['C' + num]?.v
        'time' : xlsx.Sheets['TimeReport']['F' + num]?.v
        }
        console.log 'NUM: ', num++

      return result

    parseCSV: (csvData) ->
      rows = csvData.split('\n')
      result = []
      fieldIndexes = {
        date: 0
        project: 1
        task: 2
        type: 3
        description: 4
        duration: 5
        overtime: 6
      }

      console.log 'Fields are: ', fieldIndexes

      for row, i in rows
        #Stop cicle when we meet first empty row
        break if row.replace(',', '').length <= 1

        cells = row.split(',')
        #console.log 'Row cells are: ', cells
        result.push {
          'type' : cells[fieldIndexes['type']]
          'date' : cells[fieldIndexes['date']]
          'project' : cells[fieldIndexes['project']]
          'task' : cells[fieldIndexes['task']]
          'duration' : cells[fieldIndexes['duration']]
        }

      console.log 'Rows count: ', rows.length
      return result

    toJson: (workbook) ->
      result = {};
      workbook.SheetNames.forEach((sheetName) ->
        rObjArr = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
        result[sheetName] = rObjArr if rObjArr.length > 0
      )
      return result
