# frozen_string_literal: true

require_relative "fcm/version"
require 'googleauth'
require 'http'
require 'json'
require 'redis'

module Snm
  module Fcm
    class Error < StandardError; end

    class Configuration
      attr_accessor :credentails_file_path, :project_id, :redis_endpoint, :snm_fcm_redis
    end

    class Notification
      def self.configuration
        @configuration ||= Configuration.new
      end

      def self.configure(&block)
        yield(configuration)
      end

      def self.deliver data={}
        raise 'Data is missing' if data.nil?

        response = HTTP.headers("Content-Type"=> "application/json", "Authorization"=> "Bearer #{get_access_token}").post("https://fcm.googleapis.com/v1/projects/#{Notification.configuration.project_id}/messages:send", json: data)
        JSON.parse(response.body)
      end

      def self.get_access_token
        access_token = Notification.configuration.snm_fcm_redis.get('access_token')
        if access_token.nil?
          scope = 'https://www.googleapis.com/auth/cloud-platform'
          authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
            json_key_io: File.open(Notification.configuration.credentails_file_path),
            scope: scope
          )
          access_token = authorizer.fetch_access_token!['access_token']
          Notification.configuration.snm_fcm_redis.setex('access_token', 3599, access_token)
        end
        access_token
      end

      def self.setup
        file = File.read(Notification.configuration.credentails_file_path)
        data_hash = JSON.parse(file)
        Notification.configuration.project_id = data_hash["project_id"]
        Notification.configuration.snm_fcm_redis = Redis.new(url: Notification.configuration.redis_endpoint)
      end
    end

  end
end
