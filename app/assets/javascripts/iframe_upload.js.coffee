
#  Copyright 2012 Stanislav Senotrusov <stan@senotrusov.com>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.


window.upload_iframe = 0

$.fn.iframeUpload = (selector = null) ->
  this.each ->
    $(this).on 'submit', selector, ->
      form = $(this)

      form
        .removeAttr('target')
        .find('input[name="X-Requested-With"]').remove()

      if form.find('input[type="file"]').is(-> $(this).val())

        (iframe = $("<iframe id='upload_iframe_#{window.upload_iframe}' name='upload_iframe_#{window.upload_iframe}' src='javascript:false' style='display: none'></iframe>"))

          .appendTo('body')
          
          .on 'load', ->
            iframe_object = iframe.get(0)
            document = iframe_object.contentDocument || iframe_object.contentWindow && iframe_object.contentWindow.document
            root = document.documentElement || document.body
            content = root.textContent || root.innerText

            if match = content.match(/^\s*(\d+);/)
              status = parseInt(match[1])
              content = content.replace(/^\s*(\d+);/, '')
            else
              status = 200
              content = content.replace(/^\s*/, '')
            
            if status == 200
              form.trigger 'ajax:success', [content, "success", {readyState: 4, responseText: content, status: status, statusText: 'OK'}]
            else
              form.trigger 'ajax:error', [{readyState: 4, responseText: content, status: status, statusText: ''}, 'error', '']

            iframe.remove()


        form
          .attr('target', "upload_iframe_#{window.upload_iframe}")
          .append($("<input type='hidden' name='X-Requested-With' value='iframe'/>"))

        window.upload_iframe += 1

        return true

      else
        $.rails.handleRemote(form)

        return false
