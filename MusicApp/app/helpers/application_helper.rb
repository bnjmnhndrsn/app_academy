module ApplicationHelper
  def logout_button
    destroy_button(session_path, "Log out")
  end
  
  def destroy_button(action, value)
    form = "<form action=\"#{action}\" method=\"POST\">"
    form += authenticity_field
    form += "<input type=\"hidden\" name=\"_method\" value=\"DELETE\">"
    form += "<input type=\"submit\" value=\"#{value}\">"
    form += "</form>"
    form.html_safe
  end
  
  def authenticity_field
    "<input type=\"hidden\" name=\"authenticity_token\"
            value=\"#{form_authenticity_token}\">".html_safe
  end
end
