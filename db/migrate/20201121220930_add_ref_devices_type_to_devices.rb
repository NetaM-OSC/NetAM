# frozen_string_literal: true

class AddRefDevicesTypeToDevices < ActiveRecord::Migration[6.0]
  def change
    add_reference :devices, :device_type, null: true, foreign_key: true
  end
end
