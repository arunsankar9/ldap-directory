require_relative './csv_process.rb'
require_relative './ldap.rb'

class OptionHandler
  attr_accessor :options, :root

  def initialize(root, options)
    @root = root
    @options = options
  end

  def self.process(root, options)
    new(root, options).handle
  end

  def handle
    if options[:csv]
      CSVProcess.start(root, options[:csv])
    else
      LDAP.search(root, options)
    end
  end
end
