require 'lib/antlr.jar'
require 'lib/gemfire-6.6.1.jar'

class UserModel
  include com.gemstone.gemfire.DataSerializable

  attr_accessor :firstname, :lastname

  def initialize(firstname, lastname)
    @firstname, @lastname = firstname, lastname
  end

  @@cache = RubyCache.new

  def self.find_all
    @@cache.region.entrySet(false)
  end

  def self.add(key, value)
    @@cache.region.put(key, value)
  end

  def self.search(query)
    result = @@cache.cache.query_service().new_query(query).execute()
    Rails.logger.info result
    result
  end

  def to_data(out)
    Rails.logger.info "Serializing #{to_json(self)}"
    out.writeBytes(to_json(self).to_java)
  end
end