require './spec/spec_helper_fast'

describe SettingsActions do
  it "works" do
    a = SettingsActions.new({})
    a.should be_instance_of(SettingsActions)
  end
end