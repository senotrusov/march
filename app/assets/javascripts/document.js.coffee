
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


$.fn.slideUpRemove = (callback = null) ->
  this.each ->
    element = $(this)
    element.slideUp 'fast', ->
      element.remove()
      callback() if callback


clipboardGetPrototype = ->
  (match = document.cookie.match(/prototype_id=(.+);?/)) && match[1].replace(/s/g, '§').replace(/p/g, '¶')

clipboardSetPrototype = (id) ->
  document.cookie = "prototype_id=#{id.replace(/§/g, 's').replace(/¶/g, 'p')}; path=/"


$(document).ready ->

  $('.overview_map').createOverviewMap($('.document_overview:has(> .locations)'))

  $('body > .document')

    .on 'ajax:success', '.paragraph_destroy', (event, data, status, xhr) ->
      $(this).parent().slideUpRemove()

    .on 'ajax:error', '.paragraph_destroy', (event, xhr, status, error) ->
      alert("Error: #{xhr.status} #{error}")


    .on 'click', '.add_paragraph_form, .add_paragraph_instance_form', ->
      button = $(this)
      template = button.children('.template').children().clone().hide()
      collection = button.closest('.header').siblings('.paragraphs')
      template.prependTo(collection).initLocationInput().slideDown('fast')

      if (prototype_id = clipboardGetPrototype()) && prototype_id.match(/^\s*¶/)
        template.find('.paste-prototype-id').trigger('click')


    .on 'click', '.delete_form_item, .discard-add-paragraph', ->
      $(this).closest('form').slideUpRemove()


    .on 'ajax:success', 'form.edit_section', (event, data, status, xhr) ->
      form = $(this)
      response = $(xhr.responseText).hide().insertAfter(form.parent().children('form:last'))
      form.slideUpRemove ->
        response.slideDown 'fast', ->
          response.initMap()

    .on 'ajax:error', 'form.edit_section', (event, xhr, status, error) ->
      if xhr.status == 422 # Unprocessable Entity
        $(xhr.responseText).replaceAll($(this)).initLocationInput()
      else
        alert("Error: #{xhr.status} #{error}")

    .iframeUpload('form.edit_section')


  $('form.new_document, form.edit_document, body > .document, body > .section, body > .paragraph')

    .initMap()
    
    .on('click', 'label', false)

    .on 'click', '.section-id, .paragraph-id', ->
      clipboardSetPrototype($(this).text())
      $(this).addClass('clicked').one 'mouseout', ->
        $(this).removeClass('clicked')
  
    .on 'click', '.paste-prototype-id', ->
      if prototype_id = clipboardGetPrototype()
        $(this).closest('.field').find('input').val(prototype_id).trigger('change')

    .on 'keyup paste cut change', '.prototype-input', ->
      input = $(this)

      nextTick ->
        prototype_id = input.val().replace(/\D/g, '')
        
        if input.data('handled-prototype') != prototype_id
          input.data 'handled-prototype', prototype_id

          placeholder = input.closest('.field').siblings('.prototype')

          $.get(url = "#{input.data('source')}/#{prototype_id}")
            .success (data, statusText, jqXHR) ->
              placeholder.html(data).initMap()

            .error (jqXHR, statusText, error) ->
              placeholder.html(
                "<div class=alert><i class=icon-warning-sign></i>#{jqXHR.status} #{jqXHR.statusText} requesting #{url}</div>")

  
  $('form.new_document, form.edit_document')
    .initLocationInput()

    .on 'click', '.add_template', ->
      button = $(this)
      template = $(button.data 'template').children().clone().hide()
      collection = button.closest('.buttons').siblings(button.data 'append-to')
      template.appendTo(collection).initLocationInput().slideDown('fast')

      if (prototype_id = clipboardGetPrototype()) && ((button.data('append-to') == '.sections' && prototype_id.match(/^\s*§/)) || (button.data('append-to') == '.paragraphs' && prototype_id.match(/^\s*¶/)))
        template.find('.paste-prototype-id').trigger('click')


    .on 'click', '.delete_form_item', ->
      button = $(this)
      button.closest(button.data 'selector').slideUpRemove()

    .on 'submit', ->
      $(this).find('.frame').each ->
        frame = $(this).data('frame')
        $(this).find('input[name="document[sections][][frame]"]').each -> $(this).val(frame)

    .find('.button.sort').on 'click', ->
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
            sections.children('.section_form').each ->
              section = $(this)

              abstract = buildAbstract (abstract) ->

                section.find('input[name="document[sections][][title]"]').each -> abstract.push $(this).val()
                section.find('> .prototype > .section > .header > h2 > .title').each -> abstract.push $(this).text()

              section.children('.abstract').each -> $(this).html("§ #{abstract}")

            sections.sortable()
          
          .each ->
            sections = $(this)
            sections.sortable('option', 'connectWith', frames.find('.sections').not(sections))
          

          frames.find('.paragraphs').each ->
            paragraphs = $(this)
          
            # Create abstract for each paragraph
            paragraphs.children('.paragraph_form').each ->
              paragraph = $(this)

              abstract = buildAbstract (abstract) ->
                input = (field) -> "[name=\"document[sections][][paragraphs][][#{field}]\"]"

                push = -> abstract.push $(this).val()
                paragraph.find(input 'message').each(push)
                paragraph.find(input 'location').each(push)

                push = -> abstract.push $(this).text()
                paragraph.find('> .prototype .message').each(push)
                paragraph.find('> .prototype .map').each -> abstract.push("#{$(this).attr('data-lat')} #{$(this).attr('data-lng')}")

              paragraph.children('.abstract').each -> $(this).html("¶ #{abstract}")

            paragraphs.sortable()
          
          .each ->
            paragraphs = $(this)
            paragraphs.sortable('option', 'connectWith', frames.find('.paragraphs').not(paragraphs))

          button.children('.title').text('Done sorting')

