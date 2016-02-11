require 'rspec-rails'

module Phillumeny
  module Rails
    module Matchers
      module RoutingMatchers
        # What would this do for us?
        # extend RSpec::Matchers::DSL

        def route_resources(*expected)
          RouteResourcesMatcher.new(self, *expected)
        end

        # TODO: member action addition
        # TODO: collection action addition
        # TODO: nested resources
        # TODO: singular resources
        # TODO: scope and namespace are the same thing? should alias and document the preferred routing convention
        # TODO: shallow resources, shallow_path
        # TODO: Enforce the except and only calls raise on removed routes, might do this with requiring a explicit call to :all, :except, or :only to ensure explicitness
        # TODO: Conver actions to test into a Set
        # https://github.com/rails/rails/blob/31778a34a8c6e1d186c1e807491c1f44c5f07357/actionpack/lib/action_dispatch/routing/mapper.rb#L1104-L1122
        class RouteResourcesMatcher < RSpec::Matchers::BuiltIn::BaseMatcher

          def initialize(scope, *expected)
            @actions_to_test = []
            @action_http_method_map = {
              'create'  => 'post',
              'destroy' => 'delete',
              'edit'    => 'get',
              'index'   => 'get',
              'new'     => 'get',
              'update'  => 'put',
              'show'    => 'get'
            }
            @controller = expected[0].to_s
            @member_actions = ['destroy', 'edit', 'show', 'update']
            @named_member_routes = ['edit', 'new']
            @namespace  = nil
            @param      = 'id'
            @path       = expected[0].to_s
            @scope      = scope
          end

          def all_actions
            @actions_to_test = (@actions_to_test + @action_http_method_map.keys).uniq
            self
          end

          def controller(controller_name)
            @controller = controller_name
            self
          end

          def description
            "route actions: #{@actions_to_test}"
          end

          def except(*actions_to_remove)
            @actions_to_test = (@actions_to_test + (@action_http_method_map.keys - actions_to_remove.map(&:to_s))).uniq
            self
          end

          def failure_message
            "It did not route restfully as expected namespace:#{@namespace} actions:#{@actions_to_test}"
          end

          def matches?(*)
            return false if @actions_to_test.empty?
            @actions_to_test.all? do |action|
              extra_params = {}
              extra_params = {}.merge(@param => @param) if @member_actions.include?(action)
              # https://github.com/rspec/rspec-rails/blob/master/lib/rspec/rails/matchers/routing_matchers.rb#L27-L31
              match_unless_raises Minitest::Assertion, ActionController::RoutingError do
                puts "#{{ controller: controller_name, action: action }.merge(extra_params)}"
                puts "#{{ method: @action_http_method_map[action], path: path_for_action(action) }}"
                @scope.assert_recognizes(
                  { controller: controller_name, action: action }.merge(extra_params),
                  { method: @action_http_method_map[action], path: path_for_action(action) }
                )
              end
            end
          end

          def member(member_routes = {})
            member_routes.stringify_keys!
            @member_actions << member_routes.keys
            @member_actions.flatten!
            @actions_to_test << member_routes.keys
            @actions_to_test.flatten!
            @named_member_routes << member_routes.keys
            @named_member_routes.flatten!
            @action_http_method_map.merge!(member_routes)
            self
          end

          def namespace(routing_namespace)
            @namespace = routing_namespace
            self
          end

          def only(*limited_actions)
            @actions_to_test = (@actions_to_test + (@action_http_method_map.keys & limited_actions.map(&:to_s))).uniq
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

          def controller_name
            "#{"#{@namespace}/" if @namespace}#{@controller}"
          end

          def path_for_action(action)
            "#{"#{@namespace}/" if @namespace}#{@path}#{"/#{@param}" if @member_actions.include?(action)}#{"/#{action}" if @named_member_routes.include?(action)}"
          end

        end

      end
    end
  end
end
