module QuestionKit
  class Railtie < ::Rails::Railtie
    initializer "question_kit.answer_explanations" do |app|
      app.config.to_prepare { QuestionKit.explain_answer_fields }
    end

    initializer "question_kit.question_importer" do |app|
      app.config.to_prepare { require "question_kit/question_importer" if defined?(Ixport::Importer) }
    end
  end
end
