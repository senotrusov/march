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
    (@markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(
        filter_html: false,
        no_images: true,
        no_links: false,
        no_styles: true,
        safe_links_only: true,
        with_toc_data: false,
        hard_wrap: true),
      no_intra_emphasis: true,
      tables: false,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      space_after_headers: true,
      superscript: true)).render(text).html_safe
  end
end
