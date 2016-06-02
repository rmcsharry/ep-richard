class PodAdminMailer < ApplicationMailer
  def analytics_email(pod_admin)
    @pod_admin = pod_admin
    @pod = @pod_admin.pod
    subject = 'EasyPeasy weekly report'
    mail(to: "#{@pod_admin.email}", bcc: "bsafwat@gmail.com, hello@easypeasyapp.com, jane@easypeasyapp.com", subject: subject)
  end

  def greetings_email(pod_admin)
    @pod_admin = pod_admin
    subject = 'Greetings from EasyPeasy!'
    mail(to: "#{@pod_admin.email}", bcc: "hello@easypeasyapp.com", subject: subject)
  end
  
  def trial_reminder_email(pod_admin, support_person_name=nil)
    @pod_admin = pod_admin
    @pod = @pod_admin.pod
    subject = 'EasyPeasy Trial'   
    if support_person_name.nil?
      mail(to: "#{@pod_admin.email}", subject: subject)
    else
      @support_person_name = support_person_name
      mail(to: 'hello@easypeasyapp.com', subject: subject)
    end
  end
  
  def account_already_exists_email(pod_admin)
    @pod_admin = pod_admin
    subject = 'Login to EasyPeasy!'
    mail(to: "#{@pod_admin.email}", subject: subject)
  end
end
