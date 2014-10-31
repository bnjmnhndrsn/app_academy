class NotesController < ApplicationController
  def create
    note = Note.new(note_params)
    note.user_id = current_user.id
    note.save
    redirect_to track_path(note_params[:track_id])
  end
  
  def destroy
    note = Note.find(params[:id])
    
    if note.user_id != current_user.id
      render status: :forbidden, text: "FORBIDDEN"
      return
    end
    
    track_id = note.track_id
    note.destroy
    redirect_to track_path(track_id)
  end
  
  def note_params
    params[:note].permit(:content, :track_id)
  end
end