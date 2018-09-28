module AcunetixRestApi
  require 'net/http'
  require 'net/https'
  require 'uri'
  require 'json'

  class Connect

    def initialize(api_key: nil, acunetix_host: nil)
      @api_key = api_key
      @acunetix_host = acunetix_host

      uri = URI.parse(acunetix_host)
      @https = Net::HTTP.new(uri.host, uri.port)
      @https.use_ssl = true
      @https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    # def call_api(api_type)
    #
    #   case api_type
    #   when 'targets'
    #     api_url = API_URL::TARGETS
    #   when 'scans'
    #     api_url = API_URL::SCANS
    #   when 'groups'
    #     api_url = API_URL::GROUPS
    #   end
    #
    #   data = []
    #   next_cursor = 0
    #
    #   loop do
    #     request = Net::HTTP::Get.new(api_url + "?c=#{next_cursor}")
    #     request["X-Auth"] = @api_key
    #     request["Content-Type"] = MIME_TYPE::JSON
    #     response = @https.request(request)
    #     json_hash = JSON.parse(response.body)
    #
    #     json_hash[api_type].each do |obj|
    #       data << obj
    #     end
    #     break if json_hash['pagination']['next_cursor'].nil?
    #     next_cursor = json_hash['pagination']['next_cursor'].to_i
    #   end
    #   return data
    # end

    def get_targets
      self.call_api('targets')
    end

    def get_scans
      self.call_api('scans')
    end

    def get_groups
      self.call_api('groups')
    end

    def call_api(api_type)

      case api_type
      when 'targets'
        api_url = API_URL::TARGETS
      when 'scans'
        api_url = API_URL::SCANS
      when 'groups'
        api_url = API_URL::GROUPS
      end

      data = []
      next_cursor = 0

      loop do
        request = Net::HTTP::Get.new(api_url + "?c=#{next_cursor}")
        request["X-Auth"] = @api_key
        request["Content-Type"] = MIME_TYPE::JSON
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

  end
end
