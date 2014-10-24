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
  
  def sibling2 
    
  end
  
  def sibling_responses
    r_query  = Response
      .select("responses.id, responses.answer_choice_id, responses.respondent_id")
      .joins("JOIN answer_choices ON responses.answer_choice_id = answer_choices.id")
      .joins("JOIN questions on answer_choices.question_id = questions.id")
      .joins("JOIN answer_choices AS answer_choices_b ON questions.id = answer_choices_b.question_id")
      .where("answer_choices_b.id = ?", answer_choice_id)
      
    if persisted?
      r_query.where("responses.id != ?", id)
    else
      r_query
    end
  end
  
  def respondent_has_not_already_answered_question
    unless sibling_responses.where("respondent_id = ?", respondent_id).empty?
      errors[:base] << "Respondent has already responded."
    end
  end
  
  def respondent_is_not_author
    if respondent_id == poll.author.id
      errors[:base] << "Author cannot respond to their own poll."
    end
  end
end