define  ['jquery', 'bootstr/bootstrap-datepicker', 'controls/select'], ($, datepicker, selectCtrl) ->

  class ReportItemForm

    constructor: ->
      initDatePicker()
      #disableOnSpecificProject(['Ill', 'Vacation', 'Day off'])
      selectCtrl.grayoutDefaultValue('empty')

    initDatePicker = ()->
      $('.datepicker').datepicker()
        .on('changeDate', (ev) ->
          $('.datepicker').datepicker 'hide'
        )

    disableOnSpecificProject = () ->
      projectNamesLst = ['Ill', 'Vacation', 'Day off']
      isDisabled  = _.contains projectNamesLst, $(this).find(":selected").text()

      $('#taskInp').val('')
      $('#selWorkType').val(0)
      $('#durationInp').val('')

      $('#taskInp').prop 'disabled', isDisabled
      $('#selWorkType').prop 'disabled', isDisabled
      $('#durationInp').prop 'disabled', isDisabled
