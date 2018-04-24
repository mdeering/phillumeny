# frozen_string_literal: true

module Phillumeny

  # Matchers for testing ActiveRecord functionality
  module ActiveRecord

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
    def have_default_value_of(default)
      HaveDefaultValueOf.new(default)
    end

    # This could live outside of the ActiveRecord module but we have
    # an option here to confirm and check the database also so leaving
    # it in here for now
    class HaveDefaultValueOf

      attr_reader :attribute_name, :default

      def description
        "have a default value of '#{default}':#{default.class} for #{attribute_name}"
      end

      def failure_message
        "The value of '#{value_for_attribute}':#{value_for_attribute.class} was found not '#{default}':#{default.class}"
      end

      def for(attribute_name)
        @attribute_name = attribute_name
        self
      end

      def in_the_database
        @check_database_column = true
        self
      end

      def initialize(default)
        @default = default
      end

      def matches?(subject)
        @subject = subject
        default_value_found? && database_checks_out?
      end

      private

      def database_checks_out?
        return true unless @check_database_column
        database_default_value == default
      end

      def database_column
        @database_column ||= database_columns.find { |column| column.name == attribute_name.to_s }
      end

      def database_column_type
        @database_column_type ||= ::ActiveModel::Type.lookup(database_column.type)
      end

      def database_columns
        @database_columns ||= ::ActiveRecord::Base.connection.columns(table_name)
      end

      def database_default_value
        database_column_type.deserialize(database_column.default)
      end

      def default_value_found?
        value_for_attribute == default
      end

      def model_class
        @model_class ||= @subject.class
      end

      def table_name
        @table_name ||= model_class.table_name
      end

      def value_for_attribute
        @subject.send(attribute_name)
      end

    end

  end

end
