class ContactsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    contacts = user.contacts.to_a + user.shared_contacts.to_a
    render json: contacts
  end
  
  def create
    contact = Contact.new(contact_params)
    if contact.save
      render json: contact
    else
      render(
        json: contact.errors.full_messages, status: :unprocessable_entity 
      )
    end
  end
  
  def show
    @contact = Contact.find(params[:id])
    render json: @contact
  end
  
  def update
    contact = Contact.find(params[:id])
    if contact.update(contact_params)
      render json: contact
    else
      render(
        json: contact.errors.full_messages, status: :unprocessable_entity 
      )
    end
  end
  
  def destroy
    contact = Contact.find_by_id(params[:id])
    contact.try(:destroy)
    render json: {success: "deleted"}, status: 200
      
  end
  
  private
  def contact_params
    params[:contact].permit(:name, :email, :user_id)
  end
end