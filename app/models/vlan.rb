class Vlan < ApplicationRecord
  has_many :sections

  validates :vid, numericality: true
  validates :vid, uniqueness: true

  after_destroy do |vlan|
    Permission.where(subject_class: 'Vlan', subject_id: vlan.id).delete_all
  end
end