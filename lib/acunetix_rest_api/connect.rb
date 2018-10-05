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

      json_hash = {}
      data = []

      loop do
        if method == VERB_TYPE::POST
          request = Net::HTTP::Post.new(path)
          request.set_form_data(params)
        else
          path = params.empty? ? api_path : path = api_path + "?" + URI.encode_www_form(params)
          request = Net::HTTP::Get.new(path)
        end

        request["X-Auth"] = @api_key
        request.content_type = MIME_TYPE::JSON

        response = @https.request(request)

        json_hash = JSON.parse(response.body)

        if opts[:category].empty?
          data << json_hash
        else
          json_hash[opts[:category]].each do |obj|
            data << obj
          end
        end

        if !json_hash['pagination'].nil?
          break if json_hash['pagination']['next_cursor'].nil?
        else
          break
        end
        
        params[:c] = json_hash['pagination']['next_cursor'].to_i
      end
      return data # return array of hash
    end

  end
end
