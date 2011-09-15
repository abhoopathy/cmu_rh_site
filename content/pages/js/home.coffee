$('document').ready ->

  $('.dialog-link').each ->
    $(this).css cursor: 'pointer'
    dialog_id = $(this).attr 'dialog'
    $dialog_box = $('.dialog[dialog='+dialog_id+']')
 
    $dialog_box.dialog
      modal: true
      title: $dialog_box.attr 'title'
      autoOpen: false
      width: 425
    $(this).click (e) ->
      e.preventDefault
      $dialog_box.dialog 'open'



#  $('#rmu-dialog-box').dialog
#    modal: true
#    title: 'RMU Island Sports Center'
#    autoOpen: false
#    width: 425
# 
#  $('#rmu-dialog-link').click (e) ->
#    e.preventDefault
#
#    $('#rmu-dialog-box').dialog 'open'
