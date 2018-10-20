module AcunetixRestApi
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
