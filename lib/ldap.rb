require "csv"

class LDAP
  HEADERS = [:cn, :sn, :mail, :uid, :homeDirectory, :uidNumber, :gidNumber]

  attr_accessor :root, :options, :results

  def initialize(root, options)
    @root = root
    @options = options
    @results = []
  end

  def self.search(root, options)
    ldap = new(root, options)
    ldap.handle
    ldap.persist
  end

  def handle
    metadata_root = File.join(root, '.metadata')
    attributes = JSON.parse(File.read("#{metadata_root}/metadata.json"))
    records = attributes.map {|attribute| CSVRecord.new(root, attribute) }

    options.each do |option, search_value|
      records.each do |record|
        if record.public_send(option).match(search_value)
          results << record
        end
      end
    end
  end

  def persist
    CSV.open("./search.csv", "wb") do |csv|
      csv << HEADERS
      results.each do |result|
        csv << result.as_csv
      end
    end
  end
end
