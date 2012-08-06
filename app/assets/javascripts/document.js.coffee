
$(document).ready ->
  $('.add_form_template').live 'click', ->
    button = $(this)
    $(button.attr 'data-template').children().clone().hide().appendTo(button.prev()).slideDown('fast')


  $('.delete_form_item').live 'click', ->
    button = $(this)
    button.closest(button.attr 'data-selector').slideUp 'fast', -> $(this).remove()


  $('label').live 'click', -> return false


  $('form.new_document, form.edit_document').submit ->
    $(this).find('.frame').each ->
      frame = $(this).attr('data-frame')

      $(this).find('input[name="document[sections][][frame]"]').each -> $(this).val(frame)


  $('.sort_button').click ->
    abstract_min_length = 18
    abstract_max_length = 22

    button = $(this)
    button.nextAll('.section_frames').each ->
      frames = $(this)

      if frames.is('.sortable')

        frames.find('.sections').each -> $(this).sortable 'destroy'
        frames.find('.paragraphs').each -> $(this).sortable 'destroy'

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
              abstract = $(this).val().truncate(abstract_min_length, abstract_max_length)
              abstract = 'Untitled' if abstract.length == 0

              section.children('.abstract').each -> $(this).html("§ #{abstract}")

          sections.sortable()
        
        .each ->
          sections = $(this)
          sections.sortable('option', 'connectWith', frames.find('.sections').not(sections))
        

        frames.find('.paragraphs').each ->
          paragraphs = $(this)
        
          # Create abstract for each paragraph
          paragraphs.find('.paragraph').each ->
            paragraph = $(this)
            abstract = []

            paragraph.find(   'input[name="document[sections][][paragraphs][][title]"]').each   -> abstract.push $(this).val()
            paragraph.find('textarea[name="document[sections][][paragraphs][][message]"]').each -> abstract.push $(this).val()
            paragraph.find(   'input[name="document[sections][][paragraphs][][url]"]').each     -> abstract.push $(this).val()

            abstract = abstract.join(" ").truncate(abstract_min_length, abstract_max_length)
            abstract = 'Untitled' if abstract.length == 0

            paragraph.children('.abstract').each -> $(this).html("¶ #{abstract}")

          paragraphs.sortable()
        
        .each ->
          paragraphs = $(this)
          paragraphs.sortable('option', 'connectWith', frames.find('.paragraphs').not(paragraphs))

        button.children('.title').text('Done sorting')
