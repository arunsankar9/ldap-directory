require 'csv'
require_relative './csv_record.rb'

class CSVProcess
  HEADERS = [:cn, :sn, :mail, :uid, :homeDirectory, :uidNumber, :gidNumber]

  attr_accessor :root, :records, :path

  def initialize(root, path)
    @root = root
    @path = File.expand_path(path)
    @records = []
  end

  def self.start(root, path)
    processor = new(root, path)
    processor.handle
    processor.save!
  end

  def save!
    records.each(&:save!)
    save_metadata
  end

  def save_metadata
    metadata = File.join(root, '.metadata')
    FileUtils.mkdir_p(metadata)
    File.open("#{metadata}/metadata.json", 'w') do |file|
      file.write JSON.generate records.map(&:as_json)
    end
  end

  def handle
    CSV.foreach(path, :headers => true) do |row|
      csv_record = CSVRecord.new(root)
      HEADERS.each do |attribute|
        csv_record.public_send "#{attribute}=", row[attribute.to_s]
      end
      records.push(csv_record)
    end
  end
end
