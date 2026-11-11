module QuestionKit
  module TimeTaken
    def self.seconds(run)
      return unless run.flow.each_step?

      last_answered = run.completed_at.values.max
      (last_answered - run.created_at).to_i if last_answered
    end
  end
end
