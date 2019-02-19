# frozen_string_literal: true

module Phillumeny

  module ActiveRecord # :nodoc:

    # Confirm a default value is getting returned as expected
    #
    # @api public
    #
    # @example
    #
    #   { user_id: nil, timezone: 'PDT' }.each do |attribute, value|
    #     # Just checks the subject that the right value is present
    #     it { should have_default_value_of(value).for(attribute) }
    #   end
    #
    #   # Checks both the subject and confirms at the database column level
    #   it { should have_default_value_of('PDT').for(:timezone).in_the_database }
    #
    # @return [Phillumeny::ActiveRecord::HaveADefaultValueOf]
    def have_default_value_of(default_value)
      HaveDefaultValueOf.new(default_value)
    end

    class HaveDefaultValueOf # :nodoc:
      # @note
      #   Part of this could live outside of the ActiveRecord module but we have
      #   an option here to confirm and check the database also so leaving
      #   it in here for now

      include Phillumeny::ActiveRecord::TableInformation

      def description
        "have a default value of '#{default_value}':#{default_value.class} for #{attribute_name}"
      end

      def failure_message
        # rubocop:disable LineLength
        "The value of '#{value_for_attribute}':#{value_for_attribute.class} was found not '#{default_value}':#{default_value.class}"
        # rubocop:enable LineLength
      end

      def for(attribute_name)
        self.attribute_name = attribute_name
        self
      end

      def in_the_database
        self.check_column_default = true
        self
      end

      def initialize(default_value)
        self.default_value = default_value
      end

      def matches?(subject)
        @subject = subject
        default_value_found? && column_configured_for_default_value?
      end

      protected

      attr_accessor :attribute_name, :check_column_default, :default_value

      private

      def column
        @column ||= table_columns.find { |column| column.name == attribute_name.to_s }
      end

      def column_configured_for_default_value?
        return true unless @check_column_default

        default_column_value == default_value
      end

      def column_type
        @column_type ||= ::ActiveModel::Type.lookup(column.type)
      end

      def default_column_value
        column_type.deserialize(column.default)
      end

      def default_value_found?
        value_for_attribute == default_value
      end

      def value_for_attribute
        @subject.send(attribute_name)
      end

    end

  end

end
