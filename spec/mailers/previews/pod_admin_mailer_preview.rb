# Preview all emails at http://localhost:3000/rails/mailers/
class PodAdminMailerPreview < ActionMailer::Preview
  def preview
    PodAdminMailer.analytics_email(Admin.where(id: 46).first)
  end
end
