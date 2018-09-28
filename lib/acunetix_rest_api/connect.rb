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

    module CALL_TYPE
      TARGETS = '/api/v1/targets'
      SCANS = '/api/v1/scans'
      GROUPS = '/api/v1/target_groups'
    end

    def get(api_type)

      case api_type
      when 'targets'
        api_url = CALL_TYPE::TARGETS
      when 'scans'
        api_url = CALL_TYPE::SCANS
      when 'groups'
        api_url = CALL_TYPE::GROUPS
      end

      data = []
      next_cursor = 0

      loop do
        request = Net::HTTP::Get.new(api_url + "?c=#{next_cursor}")
        request["X-Auth"] = @api_key
        request["Content-Type"] = "application/json"
        response = @https.request(request)
        json_hash = JSON.parse(response.body)

        json_hash[api_type].each do |obj|
          data << obj
        end
        break if json_hash['pagination']['next_cursor'].nil?
        next_cursor = json_hash['pagination']['next_cursor'].to_i
      end
      return data
    end

    def get_targets
      self.get('targets')
    end

    def get_scans
      self.get('scans')
    end

    def get_groups
      self.get('groups')
    end

  end
end
