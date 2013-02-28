require 'spec/spec_helper_fast'


class FakeRequest
  attr_accessor :params
  attr_accessor :remote_host
  attr_accessor :ip
  def initialize(options={})
    options.each do |k,v|
      self.send(:"#{k}=", v)
    end
  end
end


describe Deputy do
  def fake_request(*args)
    FakeRequest.new(*args)
  end

  describe :disabled? do
    it "is not disabled by default" do
      Factory(:deputy).disabled?.should == false
      Deputy.new.disabled?.should == false
    end

    it "is disabled when i turn it off" do
      deputy = Factory(:deputy, :disabled_until => 1.minute.from_now)
      deputy.disabled?.should == true
    end

    it "is not disabled when time ran out" do
      deputy = Factory(:deputy, :disabled_until => 1.minute.ago)
      deputy.disabled?.should == false
    end
  end


  describe :extract_address_and_name do
    describe :hostname do
      it  "takes the param, if present" do
        request = fake_request :params => {:hostname => 'hostname_from_params'}, :ip => '10.10.10.10'
        Deputy.extract_address_and_name(request).should == ["10.10.10.10", "hostname_from_params"]
      end

      it  "takes remote host otherwise" do
        request = fake_request :params => {}, :ip => '10.10.10.10', :remote_host => 'from_remote_host'
        Deputy.extract_address_and_name(request).should == ["10.10.10.10", "from_remote_host"]
      end

      it  "or just falls back to UNKNOWN_HOST" do
        request = fake_request :params => {}, :ip => '10.10.10.10'
        Deputy.extract_address_and_name(request).should == ["10.10.10.10", Deputy::UNKNOWN_HOST]
      end
    end

    describe :ip do
      it  "takes the param, if present" do
        request = fake_request :params => {:hostname => 'hostname_from_params', :ip => '20.20.20.20' }
        Deputy.extract_address_and_name(request).should == ["20.20.20.20", "hostname_from_params"]
      end

      it  "takes the ip on request otherwise" do
        request = fake_request :params => {:hostname => 'hostname_from_params' }, :ip => '20.20.20.20'
        Deputy.extract_address_and_name(request).should == ["20.20.20.20", "hostname_from_params"]
      end

      it  "falls back to UNKNOWN_ADDRESS, if forced_host param present" do
        request = fake_request :params => {:hostname => 'hostname_from_params', :forced_host => 1 }
        Deputy.extract_address_and_name(request).should == [Deputy::UNKNOWN_ADDRESS, "hostname_from_params"]
      end
    end
  end

  describe :delete do
    before do
      @deputy        = Factory(:deputy)
      @deputy_plugin = Factory(:deputy_plugin, :deputy => @deputy)
      @report        = Factory(:report, :deputy => @deputy)
      @deputy.reload
    end
    it "sets deleted_at" do
      @deputy.deleted_at.should == nil
      @deputy.delete
      @deputy.deleted_at.should_not == nil
    end

    it "deletes deputy plugins" do
      @deputy.deputy_plugins.should == [@deputy_plugin]
      dp = @deputy.deputy_plugins.first
      dp.should_receive(:delete)
      @deputy.delete
    end

    it "deletes deputy reports" do
      @deputy.reports.should == [@report]
      report = @deputy.reports.first
      report.should_receive(:delete)
      @deputy.delete
    end

  end
end