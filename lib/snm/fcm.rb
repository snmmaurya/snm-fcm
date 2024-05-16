# frozen_string_literal: true

require_relative "fcm/version"
require 'googleauth'
require 'http'
require 'json'

module Snm
  module Fcm
    class Error < StandardError; end

    class Configuration
      attr_accessor :credentails_file_path, :project_id
    end

    class Notification
      def self.configuration
        @configuration ||= Configuration.new
      end

      def self.setup(&block)
        yield(configuration)
      end

      def self.deliver data={}
        raise 'Data is missing' if data.nil?

        response = HTTP.headers("Content-Type"=> "application/json", "Authorization"=> "Bearer #{get_access_token}").post("https://fcm.googleapis.com/v1/projects/#{Notification.configuration.project_id}/messages:send", json: data)
        JSON.parse(response.body)
      end

      def self.get_access_token
        scope = 'https://www.googleapis.com/auth/cloud-platform'
        authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: File.open(Notification.configuration.credentails_file_path),
          scope: scope
        )
        authorizer.fetch_access_token!['access_token']
      end

      def self.set_project
        file = File.read(Notification.configuration.credentails_file_path)
        data_hash = JSON.parse(file)
        Notification.configuration.project_id = data_hash["project_id"]
      end
    end

  end
end
