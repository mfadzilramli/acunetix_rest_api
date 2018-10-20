module AcunetixRestApi
  require 'net/http'
  require 'net/https'
  require 'uri'
  require 'json'

  class Connect
    attr_accessor :api_key, :host

    def initialize(api_key: nil, host: nil)
      @api_key = api_key
      @host = host

      uri = URI.parse(host)
      @https = Net::HTTP.new(uri.host, uri.port)
      @https.use_ssl = true
      @https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def get_targets
      self.call_api(VERB_TYPE::GET,
                    API_URL::TARGETS,
                    {category: 'targets'},
                    {c: 0})
    end

    def get_scans
      self.call_api(VERB_TYPE::GET,
                    API_URL::SCANS,
                    {category: 'scans'},
                    {c: 0})
    end

    def get_groups
      self.call_api(VERB_TYPE::GET,
                    API_URL::GROUPS,
                    {category: 'groups'},
                    {c: 0})
    end

    def get_target_scans(target_id)
      self.call_api(VERB_TYPE::GET,
                    API_URL::SCANS,
                    {category: 'scans'},
                    {q: "target_id:" + target_id})
    end

    def get_scan_vulnerabilities(scan_id, scan_session_id)
      self.call_api(VERB_TYPE::GET,
                    API_URL::SCANS + "/" + scan_id + "/results/" + scan_session_id + "/vulnerabilities",
                    {category: 'vulnerabilities'})
    end

    def get_target_vulnerabilities(target_id)
      self.call_api(VERB_TYPE::GET,
                    API_URL::VULNS,
                    {category: 'vulnerabilities'},
                    {q: "severity:3,2,1,0;status:open;target_id:" + target_id})
    end

    def search_targets(targets)
      self.call_api(VERB_TYPE::GET,
                    API_URL::TARGETS,
                    {category: 'targets'},
                    {q: "text_search:*#{targets}"})
    end

    def get_target_worker(target_id)
      self.call_api(VERB_TYPE::GET,
                    API_URL::TARGETS + "/" + target_id + "/configuration/workers",
                    {category: 'workers'})
    end

    def call_api(method, api_path, opts = {}, params = {})

      json_hash = Hash.new
      data = Array.new

      loop do

        case method
        when VERB_TYPE::POST
          request = Net::HTTP::Post.new(path)
          request.set_form_data(params)
        when VERB_TYPE::GET
          path = params.empty? ? api_path : path = api_path + "?" + URI.encode_www_form(params)
          request = Net::HTTP::Get.new(path)
        end

        # set request header
        request["X-Auth"] = @api_key
        request.content_type = MIME_TYPE::JSON

        response = @https.request(request)
        json_hash = JSON.parse(response.body)

        # if loop, append all output to data
        break if json_hash['code'] == 404
        json_hash[opts[:category]].each do |element|
          data << element
        end

        # check if pagination and next_cursor hash key exists else break from loop
        break unless (json_hash.has_key? :pagination) && (json_hash.has_key? :next_cursor)

        params[:c] = (json_hash['pagination']['next_cursor'].is_a? String) ? json_hash['pagination']['next_cursor'] : json_hash['pagination']['next_cursor'].to_i

      end
      return data # return array of hash
    end

  end
end
