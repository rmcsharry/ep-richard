class PodAdminMailer < ApplicationMailer
  def analytics_email(pod_admin)
    @pod_admin = pod_admin
    @pod = @pod_admin.pod
    subject = 'EasyPeasy weekly report'
    mail(to: 'bsafwat@gmail.com', subject: subject)
  end
end
