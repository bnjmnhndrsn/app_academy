class Question < ActiveRecord::Base
  validates :poll_id, :text, presence: true
  
  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )
  
  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id
  )
  
  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )
  
  def results

    
    response_with_counts = self.answer_choices
    .select('answer_choices.text, COUNT(responses.respondent_id) AS count')
    .joins("LEFT OUTER JOIN responses ON answer_choices.id = answer_choice_id")
    .group("answer_choices.id")
    
    result_hash = {}
    response_with_counts.each do |resp|
      result_hash[resp["text"]] = resp.count
    end
    
    result_hash
    
  end
  
end



# 1, 5, 9, 13