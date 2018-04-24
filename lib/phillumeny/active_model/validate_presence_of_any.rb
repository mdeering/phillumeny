# frozen_string_literal: true

module Phillumeny

  module ActiveModel # :nodoc:

    def validate_presence_of_any(*args)
      ValidatePresenceOfAny.new(args)
    end

    # Used for testing conditional validation of presence where you need one of the other
    #
    # @example
    #
    #   class Webpage
    #
    #     include ActiveModel::Validations
    #
    #     attr_accessor :body
    #     attr_accessor :headline
    #     attr_accessor :title
    #
    #     validates :body,
    #               presence: true
    #
    #     validates :headline,
    #               presence: true,
    #               unless: -> { title.present? }
    #
    #     validates :title,
    #               presence: true,
    #               inclusion: { allow_blank: true, in: ['this'] },
    #               unless: -> { headline.present? && headline != 'needs title' }
    #
    #   end
    #
    #   RSpec.describe Webpage, type: :model do
    #
    #     it { should     validate_presence_of_any(:headline, :title).valid_values(title: 'this') }
    #     it { should_not validate_presence_of_any(:headline, :title) }
    #     it { should_not validate_presence_of_any(:headline, :title).valid_value(:title, 'that') }
    #
    #   end
    class ValidatePresenceOfAny

      attr_reader :attributes
      attr_reader :subject

      # Description used when matcher is used
      #
      # @api private
      #
      # @return [String]
      def description
        "validate the presence of any of these attributes: #{attributes.join(', ')}"
      end

      # Compiles the error message for display
      #
      # @api private
      #
      # @return [String]
      def failure_message
        messages = [subject.inspect]
        attributes.each do |attribute|
          messages << subject.errors.full_messages_for(attribute)
        end
        messages.compact.join("\n")
      end

      # Sets up arguments for the matcher
      #
      # @api private
      #
      # @return [void]
      def initialize(args)
        @attributes = args
      end

      # Runs the logic to determine if expectations are being met
      #
      # @api private
      #
      # @return [Boolean]
      def matches?(subject)
        @subject = subject
        store_initial_values
        invalid_when_none_present? && attributes.all? do |attribute|
          clear_attributes_and_errors
          initialize_value(attribute)
          free_of_errors_on_attribute?(attribute) ? other_attributes_valid?(attribute) : false
        end
      end

      # Explicitly set the value to test for an attribute if 'X' is not acceptable
      #
      # @api public
      #
      # @example
      #   it { should validate_presence_of_any(:headline, :title).valid_value(:title, 'A valid title') }
      #
      # @return [self]
      def valid_value(attribute, value)
        attribute_values[attribute] = value
        self
      end

      # Explicitly set the value to test for an attribute if 'X' is not acceptable
      #
      # @api public
      #
      # @example
      #   it do
      #     should validate_presence_of_any(:headline, :title).valid_values(title: 'A valid title')
      #   end
      #
      # @return [self]
      def valid_values(**values)
        attribute_values.merge!(values)
        self
      end

      private

      # Storage for our initial and valid values for the attributes we are testing against
      #
      # @api private
      #
      # @return [Hash]
      def attribute_values
        @attribute_values ||= {}
      end

      # Clears all of the attributes that we are testing against
      #
      # @api private
      #
      # @return [void]
      def clear_attributes_and_errors
        attributes.each do |attribute|
          subject.send("#{attribute}=", nil)
        end
        subject.errors.clear
      end

      # Checks that the current attribute we are checking against passes its other validations
      #
      # @api private
      #
      # @return [Boolean]
      def free_of_errors_on_attribute?(attribute)
        subject.class.validators_on(attribute).each do |validator|
          # Can/do we use self[attribute] here or would that be better used in the
          # conditional Proc on the validation itself?
          validator.validate_each(subject, attribute, subject.send(attribute))
        end
        subject.errors[attribute].empty?
      end

      # Sets the value of the attribute that we currently testing against
      #
      # @api private
      #
      # @return [void]
      def initialize_value(attribute)
        subject.send("#{attribute}=", attribute_values[attribute] || 'X')
      end

      def invalid_when_none_present?
        clear_attributes_and_errors
        !subject.valid? && attributes.all? { |attribute| subject.errors[attribute].present? }
      end

      # Checks that the other attributes that we are checking against are valid as promised
      #
      # @api private
      #
      # @return [Boolean]
      def other_attributes_valid?(exclude_attribute)
        subject.valid?
        (attributes - [exclude_attribute]).all? do |attribute|
          subject.errors[attribute].empty?
        end
      end

      # Store the initial values of our subject before we start messing around with it
      #
      # @api private
      #
      # @return [void]
      def store_initial_values
        attributes.each do |attribute|
          next if attribute_values.key?(attribute)
          attribute_values[attribute] = subject.send(attribute)
        end
      end

    end

  end

end
