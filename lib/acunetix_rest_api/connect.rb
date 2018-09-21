module AcunetixRestApi
  require 'net/http'
  require 'net/https'
  require 'uri'
  require 'json'

  class Connect

    def initialize(api_key, acunetix_host)
      @api_key = api_key
      @acunetix_host = acunetix_host

      uri = URI.parse(acunetix_host)
      @https = Net::HTTP.new(uri.host, uri.port)
      @https.use_ssl = true
      @https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def get_all_scans
      scans = []
      counter = 0

      loop do
        request = Net::HTTP::Get.new("/api/v1/scans?c=#{counter}")
        request["X-Auth"] = @api_key
        request["Content-Type"] = "application/json"
        response = @https.request(request)
        json_hash = JSON.parse(response.body)

        json_hash['scans'].each do |object|
          scans << object
        end
        break if json_hash['pagination']['next_cursor'].nil?
        counter += 100
      end
      return scans
    end

    def get_all_targets
      targets = []
      counter = 0

      loop do
        request = Net::HTTP::Get.new("/api/v1/targets?c=#{counter}")
        request["X-Auth"] = @api_key
        request["Content-Type"] = "application/json"
        response = @https.request(request)
        json_hash = JSON.parse(response.body)

        json_hash['targets'].each do |object|
          targets << object
        end
        break if json_hash['pagination']['next_cursor'].nil?
        counter += 100
      end
      return targets
    end

    def get_target_last_scan_info(target_id)
      # https://172.16.129.94:3443/api/v1/targets/25efe9d4-b9c5-40a7-961d-d4088f9fdc91
      request = Net::HTTP::Get.new("/api/v1/targets/#{target_id}")
      request["X-Auth"] = @api_key
      request["Content-Type"] = "application/json"
      response = @https.request(request)
      json_hash = JSON.parse(response.body)
    end

    def get_scan_info(scan_id)
      # https://172.16.129.94:3443/api/v1/targets/25efe9d4-b9c5-40a7-961d-d4088f9fdc91
      request = Net::HTTP::Get.new("/api/v1/scans/#{scan_id}")
      request["X-Auth"] = @api_key
      request["Content-Type"] = "application/json"
      response = @https.request(request)
      json_hash = JSON.parse(response.body)
    end
  end
end
