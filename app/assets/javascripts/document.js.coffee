
$(document).ready ->
  $('.add_form_template').live 'click', ->
    button = $(this)
    $(button.attr 'data-template').children().clone().hide().appendTo(button.prev()).slideDown('fast')

  $('.delete_form_item').live 'click', ->
    button = $(this)
    button.closest(button.attr 'data-selector').slideUp 'fast', ->
      $(this).remove()

  $('label').live 'click', ->
    return false

  $('form.new_document, form.edit_document').submit ->
    $(this).find('.frame').each ->
      frame = $(this).attr('data-frame')

      $(this).find('input[name="document[sections][][frame]"]').each ->
        $(this).val(frame)
