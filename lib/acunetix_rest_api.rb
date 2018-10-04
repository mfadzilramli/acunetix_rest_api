require "acunetix_rest_api/version"
require "acunetix_rest_api/connect"
require "acunetix_rest_api/acunetix_api"

module AcunetixRestApi
  # Your code goes here...
end

class Array
  def uniq_findings
    vulns = self.group_by.map { |vulnerability| [vulnerability['vt_name'], vulnerability['severity']] }
    vulns_uniq = Hash.new(0)
    vulns.uniq.each do |vuln_name, severity|
      case severity
      when 3
        vulns_uniq['high'] += 1
      when 2
        vulns_uniq['medium'] += 1
      when 1
        vulns_uniq['low'] += 1
      when 0
        vulns_uniq['info'] += 1
      end
    end
    return vulns_uniq
  end
end
