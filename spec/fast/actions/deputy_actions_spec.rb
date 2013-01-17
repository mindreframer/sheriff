require 'spec/spec_helper_fast'

describe DeputyActions do
  it "works" do
    a = DeputyActions.new({})
    a.should be_instance_of(DeputyActions)
  end
end