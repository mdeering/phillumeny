# frozen_string_literal: true

module Phillumeny
  module ActiveRecord # :nodoc:

    # Helper methods for working with the database
    #
    # All the methods depend on the @subject instance variable being set
    module TableInformation

      protected

      def model_class
        @model_class ||= @subject.class
      end

      # Retrieve all the table
      def table_columns
        @table_columns ||= ::ActiveRecord::Base.connection.columns(table_name)
      end

      def table_indexes
        @table_indexes ||= ::ActiveRecord::Base.connection.indexes(table_name)
      end

      def table_name
        @table_name ||= model_class.table_name
      end

    end
  end
end

require 'phillumeny/active_record/cover_query_with_indexes'
require 'phillumeny/active_record/have_default_value_of'
