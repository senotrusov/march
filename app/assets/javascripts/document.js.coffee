
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


ajaxError = (request, jqXHR) ->
  "<div class=alert><i class=icon-warning-sign></i>#{jqXHR.status} #{jqXHR.statusText} requesting #{request.url}</div>"


calculatePreviewPosition = (link, paragraph) ->
  width = 450
  margin = 30
  offset = 15
  arrow = 10
  arrow_shadow = 3
  border_radius = 6

  left = link.position().left + (link.width() / 2) - (width / 2)
  right = paragraph.width() - link.position().left - (link.width() / 2) - (width / 2)

  space_left = paragraph.offset().left - margin
  space_right = $(document).width() - paragraph.offset().left - paragraph.width() - margin

  if (overflow_left = space_left + left) < 0
    left = space_left * -1
    right += overflow_left

  if (overflow_right = space_right + right) < 0
    right = space_right * -1

    unless overflow_left < 0
      left += overflow_right

      if (space_left + left) < 0
        left = space_left * -1


  arrow_left = link.position().left + (link.width() / 2) - left - arrow

  if arrow_left < border_radius
    arrow_left = border_radius

  else if arrow_left > (max_arrow_left = paragraph.width() - left - right - (arrow * 2) - border_radius - arrow_shadow - 1)
    arrow_left = max_arrow_left

  return {
    arrow: {
      left: arrow_left + 'px'
      },
    arrow_shadow: {
      left: (arrow_left - arrow_shadow) + 'px'
      },
    preview: {
      top: (link.position().top + link.height() + offset) + 'px',
      left: left + 'px',
      right: right + 'px'
    }
  }

tooltipMouseHover = (current, dest, remove) ->
  current.one 'mouseleave', ->
    timeout_id = timeoutSet 200, ->
      remove.remove()

    dest.one 'mouseover', ->
      clearTimeout(timeout_id)

      tooltipMouseHover(dest, current, remove)

$.fn.tooltipMouseHover = (tooltip) ->
  tooltipMouseHover(this, tooltip, tooltip)


$.fn.loading = (action) ->
  switch action
    when 'add'
      $(this).append("<div class=load_indicator><i class=icon-cloud></i><i class=icon-cloud></i><i class=icon-cloud></i></div>")
    when 'show'
      $(this).children('.load_indicator').children().each (index) ->
        icon = $(this)
        timeoutSet index * 100, ->
         icon.fadeTo('fast', 0.7 + 0.15 * index)
    when 'hide'
      $(this).children('.load_indicator').remove()
  this


cloneParagraph = (paragraph) ->
  result = paragraph.cloneNode(false)
  $(paragraph).children().not('.paragraph_destroy, .media, .preview').clone().appendTo(result)
  result


$.fn.cloneContent = ->
  this.map ->
    item = $(this)

    if item.hasClass('paragraph')
      cloneParagraph(this)

    else if item.hasClass('section')
      result = this.cloneNode(false)

      item.children().not('.edit_controls, .paragraphs').clone().appendTo(result)

      item.children('.paragraphs').each ->
        paragraphs = $(this.cloneNode(false)).appendTo(result)

        $(this).children('.paragraph').each ->
          paragraphs.append(cloneParagraph(this))

      result


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


$.fn.paragraphMedia = ->
  if (media = this.children('.media')).length
    media
  else
    $('<div/>', class: 'media').insertBefore(this.children('.details'))


$.fn.initParagraphSingleMarkerMap = ->
  this.each ->
    marker = $(this)
    media = marker.parent().paragraphMedia()

    map = $('<div/>', class: 'map')

    $('<div/>', class: 'map_container').append(map).appendTo(media)

    map.initSingleMarkerMap(L.latLng(marker.data('lat'), marker.data('lng')), marker.data('zoom'))


$.fn.setDimensions16x9 = ->
  if this.parent().width() > 853
    this.width(853)
  else
    this.width('100%')

  this.height(Math.round(this.width() / 16 * 9))


$.fn.monitorWidth = ->
  this.find('> tbody > tr > td.frame').each ->
    frame = $(this)
    if (width = frame.width()) != frame.data('lastwidth')
      frame.data('lastwidth', width)
      frame.find('iframe').each ->
        $(this).setDimensions16x9()

  .end()


$.fn.addMedia = (element) ->
  media = this.closest('.paragraph').paragraphMedia()

  if (frames = media.closest('.section_frames')).length
    unless frames.data('width_monitor')
      frames.monitorWidth()
      frames.data('width_monitor', intervalSet(1000, -> frames.monitorWidth()))

  $(element).appendTo(media).setDimensions16x9()

  this


$.fn.initMedia = ->

  if this.hasClass('document')
    this.find('> .header > .line > .map').each ->
      map = $(this)
      map.initSingleMarkerMap(L.latLng(map.data('lat'), map.data('lng')), map.data('zoom'))


  if this.hasClass('paragraph')
    this.children('.map_marker').initParagraphSingleMarkerMap()
  else
    this.find('.paragraph > .map_marker').initParagraphSingleMarkerMap()

 
  this.find('a[href^="http://youtu.be/"], a[href^="https://youtu.be/"], a[href^="http://www.youtube.com/"], a[href^="https://www.youtube.com/"], a[href^="http://vimeo.com/"], a[href^="https://vimeo.com/"]').each ->
    link = $(this)

    if match = link.attr('href').match(/^(?:https?:\/\/youtu.be\/|https?:\/\/www.youtube.com\/.+v=)([A-Za-z0-9-]+)/)
      link.addMedia('<iframe width="100%" height="315" src="http://www.youtube-nocookie.com/embed/'+match[1]+'?rel=0&wmode=opaque" frameborder="0" allowfullscreen></iframe>')

    else if match = link.attr('href').match(/^(?:https?:\/\/vimeo.com\/)(?:groups\/[^\/]+\/videos\/)?([0-9]+)/)
      link.addMedia('<iframe src="http://player.vimeo.com/video/'+match[1]+'" width="100%" height="315" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>')

  this


$(document).ready ->
  cache = $('body > .cache')

  $(window).on 'resize', ->
    $('.section_frames').each ->
      $(this).monitorWidth()

  $('.overview_map').createOverviewMap($('.document_overview:has(> .locations)'))

  $('body > .document')

    .on 'ajax:success', '.paragraph_destroy', (event, data, status, xhr) ->
      $(this).parent().slideUpRemove()

    .on 'ajax:error', '.paragraph_destroy', (event, xhr, status, error) ->
      alert("Error: #{xhr.status} #{error}")


    .on 'click', '.add_paragraph_form, .add_paragraph_instance_form', ->
      button = $(this)
      template = button.children('.template').children().clone().hide()
      collection = button.closest('.section').children('.paragraphs')
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
          response.initMedia()

    .on 'ajax:error', 'form.edit_section', (event, xhr, status, error) ->
      if xhr.status == 422 # Unprocessable Entity
        $(xhr.responseText).replaceAll($(this)).initLocationInput()
      else
        alert("Error: #{xhr.status} #{error}")

    .iframeUpload('form.edit_section')


  $('form.new_document, form.edit_document, body > .document, body > .section, body > .paragraph')

    .initMedia()

    .on('click', 'label', false)

    .on 'click', '.section-id, .paragraph-id', ->
      clipboardSetPrototype($(this).text())
      $(this).addClass('clicked').one 'mouseout', ->
        $(this).removeClass('clicked')

    .on 'click', '.quote', ->
      if prototype_id = clipboardGetPrototype()
        $(this).closest('.field').find('textarea').val( (index, value) ->
          if value.match(/^>\s[¶§]/)
            "> #{prototype_id}, #{value.substring(2)}"
          else
            "> #{prototype_id}\n\n#{value}"
          )
  
    .on 'click', '.link', ->
      if prototype_id = clipboardGetPrototype()
        if textarea = $(this).closest('.field').find('textarea').get(0)
          if typeof textarea.selectionStart == 'number' # HTML 5
            $(textarea).val( (index, value) -> value.substring(0, textarea.selectionStart) + "(#{prototype_id})" + value.substring(textarea.selectionEnd, value.length))
          else
            $(textarea).val( (index, value) -> "#{value}(#{prototype_id})")
  
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
              placeholder.html(data).initMedia()

            .error (jqXHR, statusText, error) ->
              placeholder.html(ajaxError(this, jqXHR))


    .on 'mouseover', 'a[href^="/paragraphs/"], a[href^="/sections/"]', ->

      link = $(this)
      paragraph = link.closest('.paragraph')

      position = calculatePreviewPosition(link, paragraph)

      preview =      $('<div/>', class: 'preview'     ).css(position.preview)
      arrow =        $('<div/>', class: 'arrow'       ).css(position.arrow)
      arrow_shadow = $('<div/>', class: 'arrow_shadow').css(position.arrow_shadow)
      
      link.tooltipMouseHover(preview)

      show = (data = undefined) ->
        preview.append(arrow, arrow_shadow)
        if data then preview.append(data) else preview.loading('add')
        preview.appendTo(paragraph).initMedia()
        preview.loading('show') unless data


      if (match = link.attr('href').match(/^\/(paragraph|section)s\/(\d+)/))
        type = match[1]
        id = match[2]

        if (found = $(".#{type}[data-id=\"#{id}\"]")).length
          show(found.first().cloneContent())
        else
          show()
          $.get("/#{type}s/#{id}")
            .success (data, statusText, jqXHR) ->
              preview.loading('hide')
              $(data).appendTo(cache).clone().appendTo(preview).initMedia()
            .error (jqXHR, statusText, error) ->
              preview.loading('hide')
              preview.append(ajaxError(this, jqXHR))


  
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
                paragraph.find('> .prototype .map_marker').each -> abstract.push("#{$(this).attr('data-lat')} #{$(this).attr('data-lng')}")

              paragraph.children('.abstract').each -> $(this).html("¶ #{abstract}")

            paragraphs.sortable()
          
          .each ->
            paragraphs = $(this)
            paragraphs.sortable('option', 'connectWith', frames.find('.paragraphs').not(paragraphs))

          button.children('.title').text('Done sorting')

