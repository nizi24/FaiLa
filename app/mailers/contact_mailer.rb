class ContactMailer < ApplicationMailer

  def contact_mail(contact)
    @contact = contact
    mail to: ENV['MAiL'], subject: 'お問い合わせ通知'
  end
end
