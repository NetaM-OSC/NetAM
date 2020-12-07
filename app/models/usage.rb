require 'csv'

class Usage < ApplicationRecord
  after_initialize :init

  enum state: %i[locked actived down dhcp]

  belongs_to :section

  validates :section, presence: true
  validates :state, :ip_used, :identifier, presence: true
  validates :ip_used, uniqueness: { scope: :section, message: "should happen once per section" }

  def init
    self.identifier = "#{section_id}_#{ip_used}"
  end

  # @param [int] section_id
  # @param [ActionDispatch::HTTP::UploadedFile] file
  def self.import(section_id, file)
    CSV.foreach(file.path, headers: true) do |row|
      Usage.create(
        {
          section_id: section_id,
          ip_used: row['ip'],
          fqdn: row['hostname'].presence,
          description: row['description'].presence,
          state: row['state'].downcase.to_sym
        }
      )
    end
  end
end
