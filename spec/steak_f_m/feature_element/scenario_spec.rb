require 'spec_helper'

describe SteakFM::FeatureElement::Scenario do
  before(:each) do
raw = %q{# Given user is do
# When he is doing this
# then it would happend that
## estimation: 5
## developer: mc

scenario "nice scenario title", :milestone => '0.1', :status => 'todo' do

end}
   @feature = SteakFM::Feature.new('fake_path')
   @scenario = SteakFM::FeatureElement::Scenario.new(@feature, raw)
   @scenario.stub!(:parent_tags).and_return(['@mc', '@_done', '@aaa', '@4.5'])
  end

  it "should have access to feature" do
    @scenario.feature.should == @feature
  end

  it "should find story" do
    @scenario.story.should == %q{Given user is do
When he is doing this
then it would happend that}
  end

  it "should parse hash meta info" do
    @scenario.meta_info.should have_key(:milestone)
    @scenario.meta_info.should have_key(:status)
  end

  it "should parse comments meta info" do
    @scenario.meta_info.should have_key(:milestone)
    @scenario.meta_info.should have_key(:status)
  end

  it "should parse title" do
    @scenario.title.should == "nice scenario title"
  end

  it "should parse estimation" do
    @scenario.estimation.should == 2.5
  end
end