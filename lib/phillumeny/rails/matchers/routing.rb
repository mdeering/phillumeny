require 'rspec-rails'

module Phillumeny
  module Rails
    module Matchers

      # Rails routing matchers
      module Routing
        # What would this do for us?
        extend RSpec::Matchers::DSL

        def route_resources(*expected)
          RouteResourcesMatcher.new(self, *expected)
        end

        # TODO: collection action addition
        # TODO: nested resources
        # TODO: singular resources
        # TODO: scope and namespace are the same thing? should alias and document the preferred routing convention
        # TODO: shallow resources, shallow_path
        # TODO: Enforce the except and only calls raise on removed routes, might do this with requiring a explicit call to :all, :except, or :only to ensure explicitness
        # TODO: Conver actions to test into a Set
        # https://github.com/rails/rails/blob/31778a34a8c6e1d186c1e807491c1f44c5f07357/actionpack/lib/action_dispatch/routing/mapper.rb#L1104-L1122
        class RouteResourcesMatcher < RSpec::Matchers::BuiltIn::BaseMatcher

          REST_METHOD_MAP = {
            'create'  => 'post',
            'destroy' => 'delete',
            'edit'    => 'get',
            'index'   => 'get',
            'new'     => 'get',
            'update'  => 'put',
            'show'    => 'get'
          }.freeze

          def initialize(scope, *expected)
            @controller = expected[0].to_s
            @namespace  = nil
            @param      = 'id'
            @path       = expected[0].to_s
            @scope      = scope
          end

          def all_actions
            actions_to_test.merge http_method_map.keys
            self
          end

          def controller(controller_name)
            @controller = controller_name
            self
          end

          def does_not_match?(*)
            return false if actions_to_test.empty?
            actions_to_test.all? do |action|
              extra_params = {}
              extra_params.merge!(@param.to_sym => @param) if member_actions.include?(action)
              # https://github.com/rspec/rspec-rails/blob/master/lib/rspec/rails/matchers/routing_matchers.rb#L27-L31
              begin
                @scope.assert_routing(
                  { method: http_method_map[action], path: path_for_action(action) },
                  { controller: controller_name, action: action }.merge(extra_params)
                )
                error_messages << "Was able to route action: #{action}, controller: #{controller_name}, method: #{http_method_map[action]}, path: #{path_for_action(action)}"
                false
              rescue Minitest::Assertion => error
                true
              end
            end
          end

          def description
            "route actions: #{actions_to_test.inspect}"
          end

          def except(*actions_to_remove)
            actions_to_test.merge(REST_METHOD_MAP.keys - actions_to_remove.map(&:to_s))
            self
          end

          def failure_message
            "It did not route restfully as expected namespace:#{@namespace} actions:#{actions_to_test.inspect}#{"\n" unless error_messages.empty?}#{error_messages.join("\n")}"
          end

          def failure_message_when_negated
            "It restfully routed namespace:#{@namespace} actions:#{actions_to_test.inspect}#{"\n" unless error_messages.empty?}#{error_messages.join("\n")}"
          end

          def matches?(*)
            return false if actions_to_test.empty?
            actions_to_test.all? do |action|
              extra_params = {}
              extra_params.merge!(@param.to_sym => @param) if member_actions.include?(action)
              # https://github.com/rspec/rspec-rails/blob/master/lib/rspec/rails/matchers/routing_matchers.rb#L27-L31
              begin
                @scope.assert_routing(
                  { method: http_method_map[action], path: path_for_action(action) },
                  { controller: controller_name, action: action }.merge(extra_params)
                )
                true
              rescue Minitest::Assertion => error
                error_messages << error.to_s
                false
              end
            end
          end

          def member(new_member_routes = {})
            new_member_routes.stringify_keys!
            member_actions.merge new_member_routes.keys
            actions_to_test.merge  new_member_routes.keys
            named_routes.merge new_member_routes.keys
            http_method_map.merge!(new_member_routes)
            self
          end

          def namespace(routing_namespace)
            @namespace = routing_namespace
            self
          end

          def only(*limited_actions)
            actions_to_test.merge(REST_METHOD_MAP.keys & limited_actions.map(&:to_s))
            self
          end

          def param(parameter)
            @param = parameter.to_s
            self
          end

          def path(path_parameter)
            @path = path_parameter
            self
          end

          private

          def actions_to_test
            @actions_to_test ||= Set.new
          end

          def controller_name
            "#{"#{@namespace}/" if @namespace}#{@controller}"
          end

          def error_messages
            @error_messages ||= []
          end

          def http_method_map
            @http_method_map ||= REST_METHOD_MAP.dup
          end

          def member_actions
            @member_actions ||= Set.new ['destroy', 'edit', 'show', 'update']
          end

          def named_routes
            @named_routes ||= Set.new ['edit', 'new']
          end

          def path_for_action(action)
            "#{"#{@namespace}/" if @namespace}#{@path}#{"/#{@param}" if @member_actions.include?(action)}#{"/#{action}" if named_routes.include?(action)}"
          end


        end

      end
    end
  end
end
