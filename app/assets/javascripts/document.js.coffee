
$(document).ready ->
  $('.add_form_template').live "click", ->
    button = $(this)
    $(button.attr 'data-template').children().clone().hide().appendTo(button.prev()).slideDown('fast')

  $('.delete_form_item').live "click", ->
    button = $(this)
    button.closest(button.attr 'data-selector').slideUp('fast')
