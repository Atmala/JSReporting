define ['jquery'], ($) ->

  class SelectControl

    @grayoutDefaultValue: (className) ->
      $(".select").each ->
        $(this).change ->
          console.log $(this).val()
          selector = '#' + this.id + ' option:selected';
          if $(selector).hasClass(className)
            $(this).addClass(className)
          else
            $(this).removeClass(className)
