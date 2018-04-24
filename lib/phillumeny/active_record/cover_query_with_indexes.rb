# frozen_string_literal: true

module Phillumeny

  module ActiveRecord # :nodoc:

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

    # There is often a misunderstanding on how database indexes
    # work when you are indexing across multiple columns. An index
    # created for the columns [:col1, :col2] will *usually* cover
    # where clauses against :col1 and [:col2, :col1] also but does not
    # guarantee it will be even used if a where clause only has :col2.
    class CoverQueryWithIndexes

      include Phillumeny::ActiveRecord::TableInformation

      def initialize(columns)
        self.columns = Array(columns).map(&:to_s)
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

      attr_accessor :columns

      def invalid_columns
        @invalid_columns ||= columns.reject do |col_name|
          ::ActiveRecord::Base.connection.column_exists?(table_name, col_name)
        end
      end

      def matching_index?
        sized_table_indexs_columns.any? do |relevent_columns|
          (columns - relevent_columns).empty?
        end
      end

      def sized_table_indexs_columns
        table_indexes.map { |index| index.columns.first(columns.size) }
      end

      def valid_columns?
        invalid_columns.empty?
      end

    end

  end

end
