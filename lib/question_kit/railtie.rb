module QuestionKit
  class Railtie < ::Rails::Railtie
    initializer "question_kit.answer_explanations" do |app|
      app.config.to_prepare { QuestionKit.explain_answer_fields }
    end
  end
end
