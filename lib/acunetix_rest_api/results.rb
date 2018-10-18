module AcunetixRestApi
  class Results

    def self.uniq_findings(vulnerabilities)
      uniq_vuln_stats = Hash.new(0)

      vulns = vulnerabilities.group_by.map do |vuln|
        [
          vuln['vt_name'],
          vuln['severity']
        ]
      end

      vulns.uniq.each do |vuln_name, severity|
        case severity
        when SEVERITY::HIGH
          uniq_vuln_stats[:high] += 1
        when SEVERITY::MEDIUM
          uniq_vuln_stats[:medium] += 1
        when SEVERITY::LOW
          uniq_vuln_stats[:low] += 1
        when SEVERITY::INFO
          uniq_vuln_stats[:info] += 1
        end
      end
      return vulns.uniq, uniq_vuln_stats
    end
  end
end
