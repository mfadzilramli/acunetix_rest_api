module AcunetixRestApi
  class Results
    def self.uniq_findings(vulnerabilities)
      uniq_vulns = vulnerabilities.group_by.map do |vulnerability|
        [vulnerability['vt_name'],
        vulnerability['severity']]
      end

      uniq_vuln_stats = Hash.new(0)
      uniq_vulns.uniq.each do |vuln_name, severity|
        case severity
        when 3
          uniq_vuln_stats[:high] += 1
        when 2
          uniq_vuln_stats[:medium] += 1
        when 1
          uniq_vuln_stats[:low] += 1
        when 0
          uniq_vuln_stats[:info] += 1
        end
      end
      return uniq_vulns, uniq_vuln_stats
    end
  end
end
