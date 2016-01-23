module Phillumeny

  # Matchers for supporting the validation of factories along with their
  # traits and build strategies
  module FactoryGirl

    # rubocop:disable PredicateName
    def have_a_valid_factory(name = nil)
      HaveAValidFactory.new(name)
    end
    # rubocop:enable PredicateName

    # it { should_not have_a_valid_factory }
    # it { should have_a_valid_factory.with_trait(:valid) }
    class HaveAValidFactory

      def description
        msg = "have a valid factory '#{@name}'"
        msg << " with the trait '#{@trait}'" if @trait
        msg
      end

      def failure_message
        "The '#{@name}' factory did not pass validation.\n#{@error_messages.join("\n")}"
      end

      def failure_message_when_negated
        "The '#{@name}' factory passed validation unexpectedly"
      end

      def initialize(name = nil)
        @name = name
        @trait = nil
      end

      def matches?(subject)
        factory_name = @name = @name.nil? ? subject.class.to_s.underscore : @name
        object = ::FactoryGirl.build(factory_name, @trait)
        @error_messages = object.errors.full_messages unless object.valid?
        object.valid?
      end

      def with_trait(trait)
        @trait = trait
        self
      end

    end

  end
end
