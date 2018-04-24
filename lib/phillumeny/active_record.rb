# frozen_string_literal: true

module Phillumeny

  # Matchers for testing ActiveRecord functionality
  module ActiveRecord

    # Comb through indexes to ensure the columns are covered
    #
    # @api public
    #
    # @example
    #
    #   [:col1, [:col1, :col2], :col2].each do |columns|
    #     it { should cover_query_with_indexes columns }
    #   end
    #
    # @return [Phillumeny::ActiveRecord::CoverQueryWithIndexes]
    def cover_query_with_indexes(columns)
      CoverQueryWithIndexes.new(columns)
    end

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

    # There is often a misunderstanding on how database indexes
    # work when you are indexing across multiple columns. An index
    # created for the columns [:col1, :col2] will *usually* cover
    # where clauses against :col1 and [:col2, :col1] also but does not
    # guarantee it will be even used if a where clause only has :col2.
    class CoverQueryWithIndexes

      attr_reader :columns

      def initialize(columns)
        @columns = Array(columns).map(&:to_s)
      end

      def description
        "have database indexes that would cover #{columns}"
      end

      def failure_message
        return "No database column(s) found for #{invalid_columns.inspect}" unless valid_columns?
        "The table #{table_name} did not have index to cover queries for #{columns}"
      end

      def matches?(subject)
        @subject = subject
        valid_columns? && matching_index?
      end

      private

      def indexes
        @indexes ||= ::ActiveRecord::Base.connection.indexes(table_name)
      end

      def invalid_columns
        @invalid_columns ||= columns.reject do |col_name|
          ::ActiveRecord::Base.connection.column_exists?(table_name, col_name)
        end
      end

      def matching_index?
        sized_index_columns.any? do |relevent_columns|
          (columns - relevent_columns).empty?
        end
      end

      def model_class
        @model_class ||= @subject.class
      end

      def sized_index_columns
        indexes.map { |index| index.columns.first(columns.size) }
      end

      def table_name
        @table_name ||= model_class.table_name
      end

      def valid_columns?
        invalid_columns.empty?
      end

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
