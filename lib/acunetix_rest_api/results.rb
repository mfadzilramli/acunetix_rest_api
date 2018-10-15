module AcunetixRestApi
  class Results
    def self.uniq_findings(vulnerabilities)
      vulns = vulnerabilities.group_by.map do |vulnerability|
        [vulnerability['vt_name'],
        vulnerability['severity']]
      end

      uniq_vuln = Hash.new(0)
      vulns.uniq.each do |vuln_name, severity|
        case severity
        when 3
          uniq_vuln[:high] += 1
        when 2
          uniq_vuln[:medium] += 1
        when 1
          uniq_vuln[:low] += 1
        when 0
          uniq_vuln[:info] += 1
        end
      end
      return uniq_vuln
    end
  end
end
