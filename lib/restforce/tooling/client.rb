module Restforce
  module Tooling
    class Client < AbstractClient

      private

        def api_path
          super("tooling/#{path}")
        end

    end
  end
end