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
        # https://github.com/rails/rails/blob/31778a34a8c6e1d186c1e807491c1f44c5f07357/actionpack/lib/action_dispatch/routing/mapper.rb#L1104-L1122
        class RouteResourcesMatcher < RSpec::Matchers::BuiltIn::BaseMatcher

          def initialize(scope, *expected)
            @actions = {
              'create'  => 'post',
              'destroy' => 'delete',
              'edit'    => 'get',
              'index'   => 'get',
              'new'     => 'get',
              'update'  => 'put',
              'show'    => 'get'
            }
            @controller = expected[0].to_s
            @namespace  = nil
            @param      = 'id'
            @path       = expected[0].to_s
            @scope      = scope
          end

          def controller(controller_name)
            @controller = controller_name
            self
          end

          def except(*actions_to_remove)
            @actions = @actions.except(*actions_to_remove)
            self
          end

          def failure_message
            "It did not route restfully as expected namespace:#{@namespace} actions:#{@actions.keys}"
          end

          def matches?(subject)
            @actions.each do |action, http_method|
              extra_params = {}
              extra_params = {}.merge(@param => @param) if ['destroy', 'edit', 'show', 'update'].include?(action)
              # https://github.com/rspec/rspec-rails/blob/master/lib/rspec/rails/matchers/routing_matchers.rb#L27-L31
              @scope.assert_recognizes(
                { controller: controller_name, action: action }.merge(extra_params),
                { method: http_method, path: path_for_action(action) }
              )
            end
          end

          def namespace(routing_namespace)
            @namespace = routing_namespace
            self
          end

          def only(*limited_actions)
            @actions.slice!(*limited_actions)
            self
          end

          def param(parameter)
            @param = parameter
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
            "#{"#{@namespace}/" if @namespace}/#{@path}#{"/#{@param}" if ['destroy', 'edit', 'show', 'update'].include?(action)}#{"/#{action}" if ['edit', 'new'].include?(action)}"
          end

        end

      end
    end
  end
end
