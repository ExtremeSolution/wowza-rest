class String
  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end

  def camelize
    tr('-', '_')
      .gsub(/\b[A-Z]+/) { |w| w.downcase }
      .gsub(/_(.)/) { |w| w.upcase }
      .tr('_', '')
  end
end
