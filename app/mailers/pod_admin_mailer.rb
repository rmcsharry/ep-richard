class PodAdminMailer < ApplicationMailer
  def analytics_email(pod_admin)
    @pod_admin = pod_admin
    mail(to: 'bsafwat@gmail.com', subject: 'EasyPeasy weekly report')
  end
end
