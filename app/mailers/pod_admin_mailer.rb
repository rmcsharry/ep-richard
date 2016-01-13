class PodAdminMailer < ApplicationMailer
  def analytics_email(pod_admin)
    @pod_admin = pod_admin
    @pod = @pod_admin.pod
    subject = 'EasyPeasy weekly report'
    mail(to: "#{@pod_admin.email}", bcc: "bsafwat@gmail.com, hello@easypeasyapp.com", subject: subject)
  end
end
