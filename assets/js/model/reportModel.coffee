define [], () ->

  class ReportModel
    constructor: (data, title) ->
      @reportData = data;
      @reportTitle = title;

      match = /([a-z]+).([a-z]+)(\W*)([a-z A-Z]*\s+[a-z A-Z]*)/.exec title
      @reportPersonFName = match[1];
      @reportPersonLName = match[2];
