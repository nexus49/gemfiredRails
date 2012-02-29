class RubyCache
  def initialize
    @cache_factory= com.gemstone.gemfire.cache.CacheFactory.new
    @cache_inst = @cache_factory.set("locators","localhost[55221]").set("mcast-port","0").set("log-level","error").create()

    unless @cache_inst.getRegion("users")
      @cache_inst.createRegionFactory("REPLICATE_PERSISTENT").create("users")
    end

    @user_region = @cache_inst.getRegion("users")
  end

  def region
    @user_region
  end

  def cache
    @cache_inst
  end
end