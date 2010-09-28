class ParseOptions
  def initialize(args, &block)
    @args = args
    instance_eval(&block) if block_given?
  end
  
  
  ##
  # Version
  #
  def version(value, value2='', &block)
    puts yield(block) if display_message(value, value2)
  end
  
  
  ##
  # Help Menu
  #
  def help(value, value2='', &block)
    puts yield(block) if display_message(value, value2)
  end
  
  
  ##
  # Scan for values
  #
  def scan_for_value(v1, v2='', &block)
    found = nil
    @args.each_with_index do |value, index|
      next if found
      found = @args[index + 1] if (v1.to_s == value.to_s || v2.to_s == value.to_s)
    end
    yield found 
  end
  alias_method :value, :scan_for_value
  
  
  ##
  # Boolean
  #
  def boolean(v1, v2='', &block)
    found = false
    @args.each do |value|
      next if found
      found = true if (v1.to_s == value.to_s || v2.to_s == value.to_s)
    end
    yield found
  end
  
  
  ##
  # Display Message
  #
  def display_message(value, value2)
    found = false
    @args.each do |arg|
      next if found
      found = true if (value.to_s == arg.to_s || value2.to_s == arg.to_s)
    end
    found
  end

end