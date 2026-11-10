module QuestionKit
  module Score
    def self.worth(step, value)
      chosen = EasyFlow::Steps::Question.answers_of(step).find { |answer| answer.is_a?(Hash) && answer["value"] == value }

      chosen&.fetch("weight", nil).to_i
    end
  end
end
