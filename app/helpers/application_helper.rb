module ApplicationHelper
	class ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::AssetTagHelper

    def bootstrap_date *args
      text_field *args, class: 'datepicker input-field'
    end
  end

  def flash_class type
    case type
    when "alert"
      "alert-danger"
    when "notice"
      "alert-success"
    else
      "alert-info"
    end
  end

  def get_classes_users(params)
    if params[:controller]=="my_devise/registrations" && params[:action]=="edit" || (params[:controller]=="roles" && params[:action]=="index")
      "active"
    else
      ""
    end
  end

end
