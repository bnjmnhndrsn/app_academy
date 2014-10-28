class ContactSharesController < ApplicationController
  def create
    contact_share = ContactShare.new(
      contact_id: contact_share_params[:contact_id], 
      user_id: contact_share_params[:user_id]
    )
    
    if contact_share.save
      render json: contact_share
    else
      render(
        json: contact_share.errors.full_messages, status: :unprocessable_entity
      )
    end
  end
  
  def delete
    contact_share = ContactShare.find_by_id(params[:id])
    contact_share.try(:destroy)
    render json: {success: "deleted"}, status: 200
  end
  
  def contact_share_params
    params[:contact_share].permit(:contact_id, :user_id)
  end
end