module GreetingHelper
  def create_login_greeting
    unless session[:display_welcome]
      name = current_admin.preferred_name
      if name.nil? || name = ""
        name = current_admin.name.split(" ")[0] if !current_admin.name.nil?
      end
      if !name.blank?
        name = "#{name},"
      else
        name = ""
      end
      flash.now[:info] = "#{greeting}, #{name} welcome to EasyPeasy. Let's see how #{current_admin.pod.name} pod is doing."
      session[:display_welcome] = true
    end     
  end

  def greeting
    now = Time.now
    today = Date.today.to_time

    morning = today.beginning_of_day
    noon = today.noon
    evening = today.change( hour: 17 )
    night = today.change( hour: 24 )
    
    if (morning..noon).cover? now
      'Good morning'
    elsif (noon..evening).cover? now
      'Good afternoon'
    elsif (evening..night).cover? now
      'Good evening'
    end
  end
end