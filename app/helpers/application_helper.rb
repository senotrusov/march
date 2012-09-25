module ApplicationHelper
  def can action, model
    @poster && model.__send__("can_#{action}?", @poster)
  end

  def icon name
  	"<i class=icon-#{name}></i>".html_safe
  end
end
