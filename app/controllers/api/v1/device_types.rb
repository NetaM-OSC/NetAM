# frozen_string_literal: true

require 'doorkeeper/grape/helpers'

module API
  module V1
    class DeviceTypes < Grape::API
      include API::V1::Defaults
      helpers Doorkeeper::Grape::Helpers

      before do
        doorkeeper_authorize!
        authorize_route!
      end

      resource :device_types do
        desc 'Return all device types'
        get '', root: 'device_type' do
          DeviceType.all.filter { |s| can?(:read, s) }
        end

        desc 'Create a device type'
        params do
          requires :name, type: String
          requires :color, type: String
        end
        post '', root: 'device_type' do
          ::DeviceTypes::CreateService.new(current_user, declared_params(include_missing: false)).execute
        end

        desc 'Return a device type'
        params do
          requires :id, type: Integer, desc: 'ID of the device type'
        end
        get ':id', root: 'device type' do
          device = DeviceType.where(id: permitted_params[:id]).first!
          authorize! :read, device
          device
        end
      end
    end
  end
end
