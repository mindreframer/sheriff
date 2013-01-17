require 'spec/spec_helper_fast'

describe ReportActions do
  it "works" do
    a = ReportActions.new({})
    a.should be_instance_of(ReportActions)
  end
end