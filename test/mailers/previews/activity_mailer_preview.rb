class PodAdminAnalyticsPreview < ActionMailer::Preview
  def analytics_email
    PodAdminMailer.analytics_email(PodAdmin.first)
  end
end
