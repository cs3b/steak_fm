require 'spec_helper'

describe SteakFM::FeatureElement::Scenario do
  before(:each) do
raw = %q{# Given user is do
# When he is doing this
# then it would happend that
## effort: 5
## developer: mc

scenario "nice scenario title", :milestone => '0.1', :status => 'todo' do

end}
   @feature = SteakFM::Feature.new('fake_path')
   @scenario = SteakFM::FeatureElement::Scenario.new(@feature, raw)
   @feature.stub!(:meta_info).and_return({})
  end

  it "should have access to feature" do
    @scenario.feature.should == @feature
  end

  it "should find story" do
    @scenario.story.should == %q{Given user is do
When he is doing this
then it would happend that}
  end

  it "should find milestone from hash meta info" do
    @scenario.meta_info.should have_key(:milestone)
    @scenario.milestone == '0.1'
  end
  it "should find status from hash meta info" do
    @scenario.meta_info.should have_key(:status)
    @scenario.status.should == 'todo'
  end

  it "should find effort from comments meta info" do
    @scenario.meta_info.should have_key(:effort)
  end

  it "should find developer from comments meta info" do
    @scenario.meta_info.should have_key(:developer)
    @scenario.developer.should == 'mc'
  end

  it "should parse title" do
    @scenario.title.should == "nice scenario title"
  end

  it "should parse estimation" do
    @scenario.effort.should == 5.0
  end
end