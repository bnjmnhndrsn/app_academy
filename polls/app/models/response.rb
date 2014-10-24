class Response < ActiveRecord::Base
  validates :respondent_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  #validate :respondent_is_not_author
  
  belongs_to(
    :respondent,
    class_name: "User",
    foreign_key: :respondent_id,
    primary_key: :id
  )
  
  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id
  )
  
  has_one(
    :question, 
    through: :answer_choice, 
    source: :question
  )
  
  has_one(
    :poll,
    through: :question, 
    source: :poll
  )
  
  def sibling_responses
    if Response.exists?(self) # persisted? new_record?
      question.responses.where("responses.id != ?", id)
    else
      question.responses
    end
  end
  
  def respondent_has_not_already_answered_question
    unless sibling_responses
            .where("respondent_id = ?", self.respondent_id).empty?
      errors[:base] << "Respondent has already responded."
    end
  end
  
  def respondent_is_not_author
    if respondent_id == poll.author.id
      errors[:base] << "Author cannot respond to their own poll."
    end
  end
end