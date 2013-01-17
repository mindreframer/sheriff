require 'spec/spec_helper_fast'

describe DeputyBatchAction do
  it "works" do
    a = DeputyBatchAction.new({})
    a.should be_instance_of(DeputyBatchAction)
  end
end