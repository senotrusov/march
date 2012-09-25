
 # Copyright 2012 Stanislav Senotrusov <stan@senotrusov.com>
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #     http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.


buildAbstract = (callback) ->
  abstract = []

  callback(abstract)

  abstract = abstract.join(" ").truncate()
  abstract = 'Untitled' if abstract.length == 0
  abstract


$(document).ready ->

  $('.map').initMap()

  $('.paragraph_destroy').bind 'ajax:success', (event, data, status, xhr) ->
    $(this).parent().slideUp('fast')

  $('.paragraph_destroy').bind 'ajax:error', (event, xhr, status, error) ->
    alert("Error: #{xhr.status} #{error}")

  $('.button.add_form_template').live 'click', ->
    button = $(this)
    template = $(button.attr 'data-template').children().clone().hide()
    collection = button.closest(button.attr 'data-item-type').children(button.attr 'data-append-to')
    template.appendTo(collection).initLocationInput().slideDown('fast')


  $('.delete_form_item').live 'click', ->
    button = $(this)
    button.closest(button.attr 'data-selector').slideUp 'fast', -> $(this).remove()


  $('label').live 'click', -> return false # TODO


  $('form.new_document, form.edit_document')
    .submit ->
      $(this).find('.frame').each ->
        frame = $(this).attr('data-frame')

        $(this).find('input[name="document[sections][][frame]"]').each -> $(this).val(frame)

    .initLocationInput()


  $('.button.sort').click ->
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
          sections.children('.section').each ->
            section = $(this)

            abstract = buildAbstract (abstract) ->

              section.find('input[name="document[sections][][title]"]').each -> abstract.push $(this).val()
              section.find('> .prototype > section.section > .header > h2 > .title').each -> abstract.push $(this).text()

            section.children('.abstract').each -> $(this).html("§ #{abstract}")

          sections.sortable()
        
        .each ->
          sections = $(this)
          sections.sortable('option', 'connectWith', frames.find('.sections').not(sections))
        

        frames.find('.paragraphs').each ->
          paragraphs = $(this)
        
          # Create abstract for each paragraph
          paragraphs.children('.paragraph').each ->
            paragraph = $(this)

            abstract = buildAbstract (abstract) ->
              input = (field) -> "[name=\"document[sections][][paragraphs][][#{field}]\"]"

              push = -> abstract.push $(this).val()
              paragraph.find(input 'title').each(push)
              paragraph.find(input 'message').each(push)
              paragraph.find(input 'location').each(push)
              paragraph.find(input 'url').each(push)

              push = -> abstract.push $(this).text()
              paragraph.find('> .prototype .title').each(push)
              paragraph.find('> .prototype .message').each(push)
              paragraph.find('> .prototype .map').each -> abstract.push("#{$(this).attr('data-lat')} #{$(this).attr('data-lng')}")
              paragraph.find('> .prototype .url a').each(push)

            paragraph.children('.abstract').each -> $(this).html("¶ #{abstract}")

          paragraphs.sortable()
        
        .each ->
          paragraphs = $(this)
          paragraphs.sortable('option', 'connectWith', frames.find('.paragraphs').not(paragraphs))

        button.children('.title').text('Done sorting')


  $('section.section .id, article.paragraph .id').live 'click', ->
    document.cookie = "prototype_id=#{$(this).text()}; path=/"

  
  $('.button.paste-prototype-id').live 'click', ->
    if match = document.cookie.match(/prototype_id=(.+);?/)
      prototype_id = match[1]
      $(this).closest('.field').find('input').val(prototype_id).trigger('change')

  
  $('input[data-prototype-source]').live 'keyup paste cut change', ->
    input = $(this)

    nextTick ->
      prototype_id = input.val().replace(/\D/g, '')
      
      if input.attr(state = 'data-value-change-handled') != prototype_id
        input.attr state, prototype_id

        placeholder = input.closest(input.attr('data-item-type')).children('.prototype')

        $.get(url = "#{input.attr('data-prototype-source')}/#{prototype_id}")
          .success (data, statusText, jqXHR) ->
            placeholder.html(data).find('.map').initMap()

          .error (jqXHR, statusText, error) ->
            placeholder.html(
              "<div class=alert><i class=icon-warning-sign></i>#{jqXHR.status} #{jqXHR.statusText} requesting #{url}</div>")
