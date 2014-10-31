require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.map { |k, v| "#{k} = ?" }.join(" AND ")
    query = <<-SQL
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      #{where_line}
    SQL
    
  results = DBConnection.execute(query, *params.values)
  results.map do |result|
    self.new(result)
  end
  end
end

class SQLObject
  extend Searchable
end

class Relation

  
end
