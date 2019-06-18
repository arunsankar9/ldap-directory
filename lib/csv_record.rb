require 'fileutils'
require 'json'

class CSVRecord
  attr_accessor :root, :cn, :sn, :mail, :uid, :homeDirectory, :uidNumber, :gidNumber

  def initialize(root, attributes = {})
    @root = root
    attributes.each do |attribute, value|
      self.public_send "#{attribute}=", value
    end
  end

  def save!
    home = File.join(root, cn)
    FileUtils.mkdir_p(home)
    File.open("#{home}/attributes.json", 'w') do |file|
      file.write(JSON.generate(attributes))
    end
  end

  def attributes
    {
      cn: cn,
      sn: sn,
      mail: mail,
      uid: uid,
      homeDirectory: homeDirectory,
      uidNumber: uidNumber,
      gidNumber: gidNumber
    }
  end

  def as_json
    attributes
  end

  def as_csv
    [cn, sn, mail, uid, homeDirectory, uidNumber, gidNumber]
  end
end
