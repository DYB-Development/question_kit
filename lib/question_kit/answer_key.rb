module QuestionKit
  module AnswerKey
    def self.chosen(step)
      case step["type"]
      when "multiple_select" then Score.right_answers(step)
      else Score.right_answers(step).first
      end
    end
  end
end
