
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


  $('.sort_button').click ->
    button = $(this)
    button.nextAll('.section_frames').each ->
      frames = $(this)

      if frames.is('.sortable')

        frames.find('.sections').each ->
          sections = $(this)
          sections.sortable 'destroy'

        frames.removeClass('sortable')

        button.children('.title').text('Sort')

      else
        frames.addClass('sortable')

        frames.find('.sections').each ->
          sections = $(this)
        
          # Create abstract for each section
          sections.find('.section').each ->
            section = $(this)
            
            section.find('input[name="document[sections][][title]"]').each ->
              title = $.trim($(this).val())
              title = 'Untitled' if title.length == 0

              section.children('.abstract').each ->
                $(this).text("§ #{title}")

          sections.sortable()
        
        .each ->
          sections = $(this)
          sections.sortable('option', 'connectWith', frames.find('.sections').not(sections))
        
        button.children('.title').text('Done sorting')
