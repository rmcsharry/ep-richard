module ParentHelper
  def sms_button_text
    if @parent.welcome_sms_sent
      "Welcome SMS already sent. Send again?"
    else
      "Send welcome SMS"
    end
  end
end