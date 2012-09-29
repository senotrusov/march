
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


class ActionController::Base
  def iframe_upload_response
    if params['X-Requested-With'] =~ /iframe/i
      
      response.headers['Content-Type'] = 'text/plain'
      response.headers['X-Content-Type-Options'] = 'nosniff'

      if response.status != 200
        response.body = "#{response.status};" + response.body
      end

      if request.env['HTTP_USER_AGENT'] =~ /MSIE [1-7]\D/
        # 193 is sufficient for IE8/WinXP, but internet sources referes to 256
        response.body = (' ' * 256) + response.body
      end

    end
  end
end

module IframeUpload
  def self.included base
    base.class_eval do
      alias_method_chain :xml_http_request?, :iframe_upload
      alias_method_chain :xhr?, :iframe_upload
    end
  end

  def xml_http_request_with_iframe_upload?
    xml_http_request_without_iframe_upload? || parameters['X-Requested-With'] =~ /iframe/i
  end

  def xhr_with_iframe_upload?
    xhr_without_iframe_upload? || parameters['X-Requested-With'] =~ /iframe/i
  end
end

ActionDispatch::Request.send :include, IframeUpload
