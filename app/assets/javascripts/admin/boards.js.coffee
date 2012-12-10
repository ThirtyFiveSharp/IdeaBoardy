$(document).bind 'ready', ->
  selectAllCheckbox = $('#select_all')
  selectBoardCheckboxes = $('[name="boards[]"]')
  exportButton = $('input[name="export"]')

  isSelected = (checkBox) ->
    !!$(checkBox).attr('checked')

  toggleSelectAll = ->
    ($(checkBox).attr checked: isSelected(this)) for checkBox in selectBoardCheckboxes

  toggleSelect = ->
    isBoardSelected = isSelected(this)
    selectAllCheckbox.attr checked: isBoardSelected if !isBoardSelected
    allBoardsSelected = _.every(selectBoardCheckboxes, isSelected)
    selectAllCheckbox.attr checked: isBoardSelected if allBoardsSelected

  toggleExportStatus = ->
    anyBoardSelected = _.any(selectBoardCheckboxes, isSelected)
    exportButton.attr disabled: 'disabled' if !anyBoardSelected
    exportButton.removeAttr('disabled') if anyBoardSelected

  selectAllCheckbox.bind 'change', toggleSelectAll
  selectAllCheckbox.bind 'change', toggleExportStatus
  selectBoardCheckboxes.bind 'change', toggleSelect
  selectBoardCheckboxes.bind 'change', toggleExportStatus
  exportButton.attr disabled: 'disabled'