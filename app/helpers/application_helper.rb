module ApplicationHelper
	class ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::AssetTagHelper

    def bootstrap_date *args
      text_field *args, class: 'datepicker'
    end
  end
end
