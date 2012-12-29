angular.module('idea-boardy')
  .directive 'autocomplete', ['$parse'
    ($parse) ->
      require: 'ngModel'
      link: (scope, element, attrs, ngModelCtrl) ->
        multiple = attrs.ngList?
        split = (value) -> value.split(/,\s*/)
        getKeyword = (term) -> if multiple then split(term).pop() else term
        options =
          minLength: 0
          source: (request, response) ->
            data = $parse(attrs.autocomplete)(scope)
            response($.ui.autocomplete.filter(data, getKeyword(request.term)))
          select: (event, ui) ->
            if multiple
              values = split @value
              values.pop()
              values.push ui.item.value
              viewValue = values.join ', '
              @value = viewValue + ", "
            else
              viewValue = ui.item.value
            ngModelCtrl.$setViewValue viewValue
            false
          focus: (event, ui) -> false
        element.autocomplete options
  ]