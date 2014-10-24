class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  
  has_many(
    :authored_polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id
  )
  
  has_many(
    :responses,
    class_name: "Response",
    foreign_key: :respondent_id,
    primary_key: :id
  )
  
  def completed_polls
   
    # query1 = <<-SQL
    # SELECT
    #   polls.id, COUNT(questions.id), COUNT(user_responses.respondent_id)
    # FROM
    #   polls
    # JOIN
    #   questions
    # ON
    #   polls.id = questions.poll_id
    # JOIN
    #   answer_choices
    # ON
    #   questions.id  = answer_choices.question_id
    # JOIN
    #     (
    #     SELECT
    #       *
    #     FROM
    #       responses
    #     WHERE
    #       responses.respondent_id = 21
    #     ) AS user_responses
    # ON
    #   answer_choices.id = user_responses.answer_choice_id
    # GROUP BY
    #   polls.id
    # HAVING
    #   COUNT(user_responses.respondent_id) = COUNT(questions.id)
    #
    # SQL
    #
    # ActiveRecord::Base.connection.execute(query1)
    
    user_responses = Response.select("*").where("responses.respondent_id = ?", id)
    
    Poll
    .joins("LEFT OUTER JOIN questions on questions.poll_id = polls.id")
    .joins("LEFT OUTER JOIN answer_choices on questions.id = answer_choices.question_id")
    .joins("LEFT OUTER JOIN responses on answer_choices.id = responses.answer_choice_id")
    .where("responses.respondent_id IS NULL or responses.respondent_id = #{self.id}")
    .group("polls.id")
    .having("COUNT(DISTINCT responses.id) = COUNT(DISTINCT questions.id)")
    
    # .group("polls.id")
    # .having("COUNT(user_responses.respondent_id) = COUNT(questions.id)")
    
     
  end
  
end