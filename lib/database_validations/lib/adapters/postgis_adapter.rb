module DatabaseValidations
  module Adapters
    class PostgisAdapter < BaseAdapter
      ADAPTER = :postgis

      class << self
        def unique_index_name(error_message)
          error_message[/unique constraint "([^"]+)"/, 1]
        end

        def unique_error_columns(error_message)
          error_message.split("\n")
        end

        def foreign_key_error_column(error_message)
          error_message.split("\n")
        end
      end
    end
  end
end
