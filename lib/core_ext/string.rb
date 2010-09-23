class String
  
  def classify
    self.underscore.split(/_/).each { |word| word.capitalize! }.join('')
  end
  
  def underscore
    self.gsub(/-|\s+/, '_')
  end
  
  def reverse_classify
    self.gsub(/([A-Z])/, ' \1').strip.split(/ /).each { |word| word.downcase! }.join('_')
  end
  
end