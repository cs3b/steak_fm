require 'spec_helper'

describe SteakFM::Feature do
  it "should store path for file" do
    path = "some_path_to_my_spec.rb"
    feature = SteakFM::Feature.new(path)
    feature.path.should == path
  end

  it "should return filename" do
    path = "/somedir/andanother/some_path_to_my_spec.rb"
    feature = SteakFM::Feature.new(path)
    feature.filename.should == 'some_path_to_my_spec.rb'
  end

  it "should return filename without extension" do
    path = "/somedir/andanother/some_path_to_my_spec.rb"
    feature = SteakFM::Feature.new(path)
    feature.filename_without_extension.should == 'some_path_to_my'
  end

  it "should load file content" do
    feature = SteakFM::Feature.new('spec_fake/spec/acceptance/one_spec.rb')
    feature.file_raw.should == %q{feature "Edit feature content", %q{
  To update requirement for project
  product owner
  should be able to change feature content} do

  ## effort: 5

  scenario "Inserting Background", :milestone => ['0.1']

  ## effort: 7.5
  scenario "Inserting Scenario when cursor on text field", :milestone => ['0.1']

end}
  end

  describe "PARSING" do
    before(:each) do
      subject { SteakFM::Feature.new('some_path') }
      subject.stub(:file_raw).and_return(FEATURE_CONTENT)
      cfm = mock(:cfm)
#      filter = SteakFM::TagFilter.new('')
#      cfm.stub(:filter).and_return(filter)
      subject.stub(:cfm).and_return(cfm)
    end
    it "should parse feature info" do
      subject.narration.should == %q{In order to fetch only scenarios that i want
as project manager, developer
I want to be able to create filter scope
some comment}
    end
    it "should parse background" do
      pending
      SteakFM::FeatureElement::Background.should_receive(:new).with(subject, BACKGROUND_CONTENT)
      subject.background
    end

# SKIP bug in rspec
#    it "should parse scenarios" do
#      SteakFM::FeatureElement::Scenario.should_receive(:new).with(subject, SCENARIO_CONTENT)
#      subject.scenarios
#    end
#    it "should parse scenario outlines" do
#      SteakFM::FeatureElement::ScenarioOutline.should_receive(:new).with(subject, SCENARIO_OUTLINE)
#      subject.scenarios
#    end

    it "should parse two scenarios" do
      subject.should have(2).scenarios
    end

    context "TAGS" do
      specify { subject.meta_info.keys.should == [:wireframe, :developer] }
      specify { subject.meta_info.values.should == %w(http://cs3b.com mc) }
    end
  end

  describe "WRITING" do
    # TODO
    #    it "should compact file content"
    it "should write content to file" do
      pending
      @feature = SteakFM::Feature.new('tmp/some.feature')
      @feature.stub!(:raw).and_return("Some Content")
      @feature.save
      File.open('tmp/some.feature', 'r') { |stream| stream.read.should == "Some Content" }

      # claenup
      File.delete('tmp/some.feature')
    end
  end

  describe "ESTIMATION" do
    before(:each) do
      subject { SteakFM::Feature.new('some_path') }
      subject.stub(:file_raw).and_return(FEATURE_CONTENT)
      cfm = mock(:cfm)
#      filter = SteakFM::TagFilter.new('')
#      cfm.stub!(:filter).and_return(filter)
      subject.stub(:cfm).and_return(cfm)
    end

    it "should compute correct total estimation" do
      subject.effort.should == 8.25
    end
  end

  context "PATH & ID" do
    before(:each) do
      cfm = mock('cfm', :path => "/some/path/features")
      @feature = SteakFM::Feature.new("/some/path/features/one/user_login_spec.rb", cfm)
    end

    it "should return relative path based on cfm path" do
      @feature.relative_path.should == "one/user_login_spec.rb"
    end

    it "should return id (base64 encode relative path)" do
      @feature.id.should == Base64.encode64("one/user_login_spec.rb")
    end
  end


#  context "CVS TRIGGER" do
#    context "on default config values" do
#      before(:each) do
#        cfm = mock('cfm', :send_to_remote => true, :commit_change_on => true, :config => SteakFM::Config.new)
#        @feature = SteakFM::Feature.new("", cfm)
#      end
#      it "should do commit" do
#        @feature.send(:do_commit?).should be_true
#      end
#      it "should do push" do
#        @feature.send(:do_push?).should be_true
#      end
#    end
#    context "when push is set to false" do
#      before(:each) do
#        cfm = mock('cfm', :send_to_remote => true, :commit_change_on => true,
#                   :config => SteakFM::Config.new({:cvs_push => '0'}))
#        @feature = SteakFM::Feature.new("", cfm)
#      end
#      it "should do commit" do
#        @feature.send(:do_commit?).should be_true
#      end
#      it "should skip push" do
#        @feature.send(:do_push?).should be_false
#      end
#    end
#    context "when only commit is set to false" do
#      before(:each) do
#        cfm = mock('cfm', :send_to_remote => true, :commit_change_on => true,
#                   :config => SteakFM::Config.new({:cvs_commit => '0'}))
#        @feature = SteakFM::Feature.new("", cfm)
#      end
#      it "should skip commit" do
#        @feature.send(:do_commit?).should be_false
#      end
#      it "should skip push" do
#        @feature.send(:do_push?).should be_false
#      end
#    end
#    context "when only commit and push are set to false" do
#      before(:each) do
#        cfm = mock('cfm', :send_to_remote => true, :commit_change_on => true,
#                   :config => SteakFM::Config.new({:cvs_commit => '0', :cvs_push => '0'}))
#        @feature = SteakFM::Feature.new("", cfm)
#      end
#      it "should skip commit" do
#        @feature.send(:do_commit?).should be_false
#      end
#      it "should skip push" do
#        @feature.send(:do_push?).should be_false
#      end
#    end
#  end


end

INFO_CONTENT = <<EOF
# some comment
## wireframe: http://cs3b.com
## developer: mc

feature "Tag filter", %q{
  In order to fetch only scenarios that i want
  as project manager, developer
  I want to be able to create filter scope}, :tag => true do
EOF

ALTERNATIVE_INFO_CONTENT = <<EOF
#  In order to fetch only scenarios that i want
#  as project manager, developer
#  I want to be able to create filter scope
# some comment
## wireframe: http://cs3b.com
## developer: mc

feature "Tag filter", :tag => true do
EOF

BACKGROUND_CONTENT = <<EOF
#    Given system user "t_a@hp.mc/secret" with role "locale"
#    And system user "p_e@hp.mc/secret" with role "product"
#    And signed up with "not_system_user@hp.mc/secret"
#    And I sign in as "admin@github.com/test_pass"
#    And user "admin@hearingpages.com" has assigned role "sys_user"
#    And I am on system user administration page
## title: I am logged in as user admin

   background do
   do
EOF

SCENARIO_CONTENT = <<EOF
  #  When I follow "New system user"
  #  And I fill in "systemuser@hp.mc" for "Email"
  #  And I fill in "password" for "Password"
  #  And I fill in "password" for "Password Confirmation"
  #  And I fill in "password" for "Password Confirmation"
  ## wireframe: http://somelink
  ## effort: 5.25

  scenario "creating filter scope" do
  end
EOF

SCENARIO_OUTLINE = <<EOF
# When I set user with <id> email address <email>
# Then he would have role <roles>
#
#  Examples:
#    |id   |email                |roles                             |
#    |5    |some@oo.com          |admin                             |
## effort: 3

  scenario "Selecting filter scope as active" do
  end
EOF

FEATURE_CONTENT = <<EOF
#{ALTERNATIVE_INFO_CONTENT}

#{BACKGROUND_CONTENT}

#{SCENARIO_OUTLINE}

#{SCENARIO_CONTENT}

end
EOF



