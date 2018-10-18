module AcunetixRestApi
  # GET https://172.16.13.132:3443/api/v1/vulnerabilities?q=severity:3,2,1;status:open;target_id:cd8a2fc1-6942-46a1-9f96-93b79dd79d16 HTTP/1.1
  module API_URL
    BASE    = '/api/v1/'
    TARGETS = '/api/v1/targets'
    SCANS   = '/api/v1/scans'
    GROUPS  = '/api/v1/target_groups'
    VULNS   = '/api/v1/vulnerabilities'
  end

  module MIME_TYPE
    JSON    = 'application/json, text/plain, */*'
  end

  module VERB_TYPE
    GET     = :get
    POST    = :post
  end

  module SEVERITY
    HIGH = 3
    MEDIUM = 2
    LOW = 1
    INFO = 0
  end

end
