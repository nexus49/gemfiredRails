require 'lib/gemfire.jar'

class UserModel < HashIt
  def self.init_region
    cache= com.gemstone.gemfire.cache.CacheFactory.new
    cache_inst = cache.set("locators","localhost[55221]").set("mcast-port","0").set("log-level","error").create()

    unless cache_inst.getRegion("users")
      cache_inst.createRegionFactory().create("users")
    end

    cache_inst.getRegion("users")
  end

  @@user_region = UserModel.init_region


  def self.find_all
    @@user_region.entrySet(false)
  end

  def self.add(key, value)
    begin
      @@user_region.put(key, value)
    rescue Exception => e
      Rails.logger.info "[UserModel] Error #{e.class} #{e.message}"
    end

  end
end