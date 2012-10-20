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


class MarkdownRender < Redcarpet::Render::HTML

  # pp Sanitize::Config::RELAXED
  SANITIZE_CONFIG = {
    :elements=>
      ["a",
       "abbr",
       "b",
       "bdo",
       "blockquote",
       "br",
       "caption",
       "cite",
       "code",
       "col",
       "colgroup",
       "dd",
       "del",
       "dfn",
       "dl",
       "dt",
       "em",
       "figcaption",
       "figure",
    #  "h1",
       "h2",
       "h3",
       "h4",
       "h5",
       "h6",
       "hgroup",
       "i",
    #  "img",
       "ins",
       "kbd",
       "li",
       "mark",
       "ol",
       "p",
       "pre",
       "q",
       "rp",
       "rt",
       "ruby",
       "s",
       "samp",
       "small",
       "strike",
       "strong",
       "sub",
       "sup",
       "table",
       "tbody",
       "td",
       "tfoot",
       "th",
       "thead",
       "time",
       "tr",
       "u",
       "ul",
       "var",
       "wbr"],
     :attributes=>
      {:all=>["dir", "lang", "title"],
       "a"=>["href"],
       "blockquote"=>["cite"],
       "col"=>["span", "width"],
       "colgroup"=>["span", "width"],
       "del"=>["cite", "datetime"],
    #  "img"=>["align", "alt", "height", "src", "width"],
       "ins"=>["cite", "datetime"],
       "ol"=>["start", "reversed", "type"],
       "q"=>["cite"],
       "table"=>["summary", "width"],
       "td"=>["abbr", "axis", "colspan", "rowspan", "width"],
       "th"=>["abbr", "axis", "colspan", "rowspan", "scope", "width"],
       "time"=>["datetime", "pubdate"],
       "ul"=>["type"]},
     :protocols=>
      {"a"=>{"href"=>["ftp", "http", "https", "mailto", :relative]},
       "blockquote"=>{"cite"=>["http", "https", :relative]},
       "del"=>{"cite"=>["http", "https", :relative]},
    #  "img"=>{"src"=>["http", "https", :relative]},
       "ins"=>{"cite"=>["http", "https", :relative]},
       "q"=>{"cite"=>["http", "https", :relative]}}
    }

  def initialize render_options = {}
    super render_options
    @sanitize_config = SANITIZE_CONFIG.merge(transformers: method(:parse_links))
  end


  include ActionView::Helpers::UrlHelper

  include Rails.application.routes.url_helpers
  def controller; end # for url_helpers to work


  # this is [a link](¶123123 "with title") to an existing paragraph
  # ¶123123
  # p123123
  # :123123
  # §123123
  # s123123
  # 12@foo/123123
  #    foo/123123

  # "foo p123 bar".gsub(LINK_REGEXP) { "{identity:'#{$1}' board:'#{$2}' type:'#{$3}' id:'#{$4}'}" }

  LINK_REGEXP = /
    (?: \A | \(\s* | (?<=\s) )
    (?:
      (?:(\d+)@)? (#{Board::SLUG_CHARS}+)\/ |
      ([§s¶p:])
    ) (\d+)
    (?: \z | \s*\) | (?=\s) )
    /x
  
  VALID_LINKS = Regexp.new("\\A(/|http://|https://|ftp://|mailto:)")


  def link link, title, content
    content = content.strip

    if link.match LINK_REGEXP
      build_link($1, $2, $3, $4, title, content)

    elsif link.match VALID_LINKS
      link_to content, link, title: title

    else
      "[#{content}](#{link}#{" \"#{title}\"" if title})"
    end
  end

  def build_link identity, board, type, id, title = nil, content = nil
    case type
      when /[¶p:]/
        link_to (content || "¶#{id}"), single_paragraph_path(id), title: title
      when /[§s]/
        link_to (content || "§#{id}"), single_section_path(id), title: title
      else
        link_to (content || "#{"#{identity}@" if identity}#{board}/#{id}"), document_path(id, board_slug: board, anchor: identity && "i#{identity}"), title: title
    end
  end

  def postprocess text
    Sanitize.clean(text, @sanitize_config)
  end
  
  def parse_links env
    if (node = env[:node]).text? && !node.closest('a')
      with_links = (content = node.content).gsub(LINK_REGEXP) { build_link($1, $2, $3, $4) }
      node.replace(with_links) if content != with_links
    end
  end
end
