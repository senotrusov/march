#  encoding: UTF-8

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


module ApplicationHelper
  def can action, model
    model.__send__("can_#{action}?", @poster)
  end

  def icon name
    "<i class=icon-#{name}></i>".html_safe
  end

  def edit_controls? local_assigns
    local_assigns[:with_edit_controls] || (!local_assigns[:without_edit_controls] && !request.xhr?)
  end

  def markdown text
    (@markdown ||= markdown_processor).render(text).html_safe
  end

  def markdown_processor
    Redcarpet::Markdown.new(
      
      MarkdownRender.new(
        filter_html: false,
        no_images: true,
        no_links: false,
        no_styles: true,
        safe_links_only: true,
        with_toc_data: false,
        hard_wrap: true),

      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      space_after_headers: true,
      superscript: true)
  end

  include Board::Cache
end
