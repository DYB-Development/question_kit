require_relative "lib/question_kit/version"

Gem::Specification.new do |spec|
  spec.name        = "question_kit"
  spec.version     = QuestionKit::VERSION
  spec.authors     = [ "tylercschneider" ]
  spec.email       = [ "tylercschneider@gmail.com" ]
  spec.homepage    = "https://github.com/DYB-Development/question_kit"
  spec.summary     = "Shared question and answer rules for apps that run easy_flow quizzes."
  spec.description = "QuestionKit holds the rules for what an answer to an easy_flow question step is worth, which answers are right, and how a quiz is built, so apps share them rather than each keeping a copy."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib,the_local}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.3"
  spec.add_dependency "easy_flow", "~> 0.35"
end
