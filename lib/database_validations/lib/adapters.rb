require 'database_validations/lib/adapters/base_adapter'
require 'database_validations/lib/adapters/sqlite_adapter'
require 'database_validations/lib/adapters/postgis_adapter'
require 'database_validations/lib/adapters/postgresql_adapter'
require 'database_validations/lib/adapters/mysql_adapter'

module DatabaseValidations
  module Adapters
    module_function

    def factory(model)
      database = if ActiveRecord.version < Gem::Version.new('6.1.0')
                   model.connection_config[:adapter].downcase.to_sym
                 else
                   model.connection_db_config.adapter.downcase.to_sym
                 end

      case database
      when SqliteAdapter::ADAPTER then SqliteAdapter
      when PostgresqlAdapter::ADAPTER then PostgresqlAdapter
      when PostgisAdapter::ADAPTER then PostgisAdapter
      when MysqlAdapter::ADAPTER then MysqlAdapter
      else
        raise Errors::UnknownDatabase, database
      end
    end
  end
end
