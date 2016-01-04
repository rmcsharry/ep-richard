class PodAdminMailer < ApplicationMailer
  def analytics_email(pod_admin)
    @pod_admin = pod_admin
    @pod = @pod_admin.pod
    subject = '[TEST - only being sent internally] EasyPeasy weekly report'
    mail(to: 'bsafwat@gmail.com', subject: subject)
    # mail(to: 'hello@easypeasyapp.com', subject: subject)
  end
end
