class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_mail(@contact).deliver
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
end
