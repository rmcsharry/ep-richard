class PodAdminAnalyticsPreview < ActionMailer::Preview
  def analytics_email
    PodAdminMailer.analytics_email(PodAdmin.find(243))
  end
end
