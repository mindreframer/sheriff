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
end