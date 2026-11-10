require "test_helper"

module QuestionKit
  class TimeTakenTest < ActiveSupport::TestCase
    Flow = Data.define(:saves_each_step) do
      def each_step?
        saves_each_step
      end
    end

    Run = Data.define(:flow, :created_at, :completed_at)

    def started
      Time.zone.local(2026, 10, 20, 9, 0, 0)
    end

    test "a run's seconds taken run from its start to its last answer when the flow saves every answer" do
      run = Run.new(flow: Flow.new(true), created_at: started, completed_at: { a: started + 30, b: started + 90 })

      assert_equal 90, TimeTaken.seconds(run)
    end
  end
end
