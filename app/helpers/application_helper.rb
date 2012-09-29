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
end
