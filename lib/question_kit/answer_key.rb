module QuestionKit
  module AnswerKey
    def self.chosen(step)
      Score.right_answers(step).first
    end
  end
end
