class PodAdminMailer < ApplicationMailer
  def analytics_email(pod_admin)
    @pod_admin = pod_admin
    @pod = @pod_admin.pod
    mail(to: 'bsafwat@gmail.com', subject: 'EasyPeasy weekly report')
  end
end
