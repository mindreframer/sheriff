class ReporterFyrehose
  # options:
  # - msg
  # - token
  def self.report(options ={})
    return true unless CFG[:report_to_fyrehose]

    pub = {
      :token   => options[:token],
      :channel => CFG[:report_to_fyrehose_channel],
      :type    => "issue",
      :message => options[:msg]
    }

    sock = UDPSocket.new
    sock.connect(*CFG[:report_to_fyrehose].split(":"))
    sock.write(pub.to_json + "\n")
    sock.close
  rescue Exception => e
    puts "cant report to fyrehose: #{e.to_s}"
  end


  def self.send_alert(alert)
    return if alert.error_level < 1
    prio = alert_prio(alert)

    ReporterFyrehose.report(
      :token => "sherrif.#{alert.report.group.full_name}",
      :msg   => "#{prio} #{alert.report.full_name} - #{alert.message}"
    )
  end

  def self.alert_prio(alert)
    if alert.error_level == 2
      "[CRITICAL]"
    elsif alert.error_level == 3
      "[DOOM]"
    else
      ""
    end
  end
end