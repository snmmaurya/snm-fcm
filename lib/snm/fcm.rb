# frozen_string_literal: true

require_relative "fcm/version"
require 'googleauth'

module Snm
  module Fcm
    class Error < StandardError; end

    class Configuration
      attr_accessor :project_id, :access_token
    end

    class Notification
      def self.configuration
        @configuration ||= Configuration.new
      end

      def self.config(&block)
        @configuration = yield(configuration)
      end

      def self.deliver token, data={}
        raise 'Token is missing' if not token.present?
        raise 'Data is missing' if not data.present?
        HTTP.headers('Content-Type: application/json', "Authorization: Bearer #{Notification.configuration.access_token}").post("https://fcm.googleapis.com/v1/projects/#{Notification.configuration.project_id}/messages:send", json: data)
      end
    end

    def self.get_access_token credentails_file_path
      scope = 'https://www.googleapis.com/auth/cloud-platform'
      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(credentails_file_path),
        scope: scope
      )
      authorizer.fetch_access_token!['access_token']
    end
  end
end
