class HashIt
  
  attr_accessor :underlying
  
  def initialize(hash = {})
    self.underlying = initialize_hash_attributes(hash)
  end
  
  def initialize_hash_attributes(hash)
    hash.keys.each do |key|
        hash[key] = Hashit.new(hash[key]) if hash[key].instance_of? Hash
        hash[key] = initialize_array_attributes(hash[key]) if hash[key].instance_of? Array
    end
    hash
  end
  
  def initialize_array_attributes(array)
    array.each_index do |index|
      array[index] = Hashit.new(array[index]) if array[index].instance_of? Hash
      array[index] = initialize_array_attributes(array[index]) if array[index].instance_of? Array
    end
    array
  end

  def method_missing(method_id, *args)
    debug = false
    Rails.logger.info "" if debug
    Rails.logger.info "[METHOD MISSING] #{method_id.inspect}, #{args} #{underlying.inspect}" if debug
    
    case method_id
    when :length
      self.underlying.length
    when :[]=
      raise "Wrong number of arguments #{args.size}" if args.size != 2
      Rails.logger.info "[METHOD MISSING] setting key: #{args.first.to_s} to value #{args.second}" if debug
      underlying[args.first.to_s] = args.second
    when :[]
        raise "Wrong number of arguments #{args.size}" if args.size != 1
        Rails.logger.info "[METHOD MISSING] returning key: #{args.first.to_s} with value #{underlying[args.first.to_s]}" if debug
        underlying[args.first.to_s]
      when /[a-zA-Z0-9]*=/
        raise "Wrong number of arguments #{args.size}" if args.size != 1
        method_id =~ /[a-zA-Z0-9]*/
        key = $&
        Rails.logger.info "[METHOD MISSING] setting key: #{key} to value #{args.first.to_s}" if debug
        underlying[key]=args.first.to_s
    else
      Rails.logger.info "[METHOD MISSING] Try to return value for: #{method_id.to_s} value: #{underlying[method_id.to_s]}" if debug
      underlying[method_id.to_s]
    end
  end
  
  def has(key)
    underlying.key?(key)
  end  
  
  def keys
    underlying.keys
  end
  
  def as_json(options = nil)
    self.underlying.as_json(options)
  end
  
  def to_s
    self.underlying.to_s
  end
end