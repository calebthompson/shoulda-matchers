require 'active_support/core_ext/object/blank'

module Shoulda # :nodoc:
  module Matchers
    module ActiveRecord # :nodoc:

      # Ensures that the record is not valid if the given association is not
      # also valid.
      #
      # Options:
      # * <tt>with_message</tt> - value the tests expect to find in
      #   <tt>options[:message]</tt>. <tt>Regexp</tt> or <tt>String</tt>.
      #   Defaults to "is invalid".
      # * <tt>on</tt> - Specifies the value the tests expect to find for when
      #   the validations should be run. <tt>:create</tt> and <tt>:update</tt>
      #   are the acceptable values for an actual association. Defaults to nil.
      # * <tt>if</tt> - value the tests expect to find for a method or
      #   string to call to determine if the validation should occur.
      #   Defaults to nil.
      #   *Note that we cannot currently check for a Proc.*
      # * <tt>:unless</tt> -  value the tests expect to find for a method or
      #   string to call to determine if the validation should not occur
      #   (e.g. <tt>unless(:skip_validation)</tt>)
      def validate_associated(attr)
        ValidateAssociatedMatcher.new(attr)
      end

      class ValidateAssociatedMatcher
        def initialize(attribute)
          @attribute = attribute
        end

        def with_message(message)
          @message = message
          self
        end

        def on(context)
          @context = context
          self
        end

        def if(condition)
          @condition = condition
          self
        end

        def unless(negative_condition)
          @negative_condition = negative_condition
          self
        end

        def description
          description = "validate associated #{ attribute }"
          description << %( with message "#{ @message }") if @message
          description << " on #{ @context }" if @context
          description << " if #{ condition }" if @condition
          description << " unless #{ negative_condition }" if @negative_condition
          description
        end

        def matches?(subject)
          validation_exists? &&
            message_correct? &&
            on_correct? &&
            if_correct? &&
            unless_correct?
        end

        private

        def validation_exists?
          if validator.present?
            true
          else
            @missing = "#{ model_class.name } does not validate association #{ @attribute }"
            false
          end
        end

        def message_correct?
          return true unless @message
          actual_message = validator.options[:message] || "nil"
          if @message == actual_message || @message =~ actual_message
            true
          else
            @missing = "expected message to be #{ @message }, but got #{ actual_message }"
          end
        end

        def on_correct?
          return true unless @context
          actual_on = validator.options[:on] || "nil"
          if @on == actual_on
            true
          else
            @missing = "expected validation to happen on #{ @context }, but got #{ actual_on }"
          end
        end

        def if_correct?
          return true unless @condition
          actual_if = validator.options[:if] || "nil"
          if @condition == actual_if
            true
          else
            @missing = "expected validation precondition to be #{ @condition }, but got #{ actual_if }"
          end
        end

        def unless_correct?
          return true unless @condition
          actual_unless = validator.options[:unless] || "nil"
          if @condition == actual_unless
            true
          else
            @missing = "expected validation precondition to be #{ @negative_condition }, but got #{ actual_unless }"
          end
        end

        def validator
          @validator ||=
            model_class.validators.select do |validator|
              validator.attributes.include? @attribute &&
                validator.class = ActiveRecord::Validations::AssociatedValidator
            end.first
        end

        def model_class
          @subject.class
        end
      end
    end
  end
end
