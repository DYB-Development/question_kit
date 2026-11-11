require "test_helper"

module QuestionKit
  class TitledStartTest < ActiveSupport::TestCase
    test "a flow takes a slug made from its title" do
      assert_equal "morning-routine", started("Morning Routine").slug
    end

    private
      def started(title, host: "quizzes", owner: nil)
        EasyFlow::Definition.new(host: host, owner: owner, title: title).tap { |flow| TitledStart.new(flow).save }
      end
  end
end
