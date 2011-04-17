require 'spec_helper'

describe SteakFeatureManager do
  context "files scaning" do
    before(:all) do
      @cfm = SteakFeatureManager.new("spec_fake/spec/acceptance")
    end
    it "should store path for features" do
      @cfm.prefix.should == 'spec_fake/spec/acceptance'
    end
    it "should scan files in specific directory" do
      @cfm.should have(4).features
    end
    it "should return list of all scenarios" do
      @cfm.should have(5).scenarios
    end
    it "should compute correct total estimation value" do
      @cfm.effort.should == 15.25
    end
  end

  context "features filtering by one tag" do
    before(:all) do
      @cfm = SteakFeatureManager.new("spec_fake/spec/acceptance", "spec_fake", {'tags' => 'milestone:0.1'})
    end
    it "should scan files that have one tag" do
      @cfm.should have(3).features
    end
    it "should return list of all scenarios that have this tag" do
      @cfm.should have(4).scenarios
    end
  end


  context "features filtering by one multiple tags" do
    before(:all) do
      @cfm = SteakFeatureManager.new("spec_fake/spec/acceptance", "spec_fake", {'tags' => 'milestone:0.1 developer:mc'})
    end
    it "should scan files that have every one tag" do
      @cfm.should have(1).features
    end
    it "should return list of all scenarios that have both tag" do
      @cfm.should have(1).scenarios
    end
  end

  context "dir scoping" do
    before(:all) do
      @cfm = SteakFeatureManager.new("spec_fake/spec/acceptance", "spec_fake", {'dir' => 'subdir'})
    end
    it "should scan files in specific directory" do
      @cfm.should have(2).features
    end
    it "should return list of all scenarios" do
      @cfm.should have(1).scenarios
    end
  end

end