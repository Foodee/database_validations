module DatabaseValidations
  class BelongsToOptions
    VALIDATOR_MESSAGE =
      if ActiveRecord::VERSION::MAJOR < 5
        :blank
      else
        :required
      end

    def self.validator_options(association, foreign_key)
      { attributes: association, foreign_key: foreign_key, message: VALIDATOR_MESSAGE }
    end

    attr_reader :column, :adapter, :relation

    def initialize(column, relation, adapter)
      @column = column
      @relation = relation
      @adapter = adapter

      raise_if_unsupported_database!
      raise_if_foreign_key_missed! unless ENV['SKIP_DB_UNIQUENESS_VALIDATOR_INDEX_CHECK']
    end

    # @return [String]
    def key
      @key ||= Helpers.generate_key_for_belongs_to(column)
    end

    def handle_foreign_key_error(instance)
      # Hack to not query the database because we know the result already
      instance.send("#{relation}=", nil)
      instance.errors.add(relation, :blank, message: VALIDATOR_MESSAGE)
    end

    private

    def raise_if_foreign_key_missed!
      raise Errors::ForeignKeyNotFound.new(column, adapter.foreign_keys) unless adapter.find_foreign_key_by_column(column)
    end

    def raise_if_unsupported_database!
      raise Errors::UnsupportedDatabase.new(:db_belongs_to, adapter.adapter_name) if adapter.adapter_name == :sqlite3
    end
  end
end
