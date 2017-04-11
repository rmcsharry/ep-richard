# Preview all emails at http://localhost:3000/rails/mailers/devise/mailer
class Devise::MailerPreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(Admin.last, {})
  end
end
