# SteakFm
require 'steak_f_m/config'
require 'steak_f_m/feature'
require 'steak_f_m/meta_info_filter'

require 'steak_f_m/feature_element/scenario'

# feature
# for no multiline
# ((^.*#+.*\n)+\n?)?(^.*@+.*\n)?^[ \t]*feature ".*"(,\s".*")?\sdo
#as same but simpler
# ((^.*#+.*\n)+\n?)?(^.*@+.*\n)?^[ \t]*feature.*\sdo


# scenario have duty regex
# ((^.*#+.*\n)+\n?)?(^.*@+.*\n)?^[ \t]*scenario ".*".*do\b(.*?\n?)+end
class SteakFeatureManager < Struct.new(:path, :repo_path, :config_parameters)

#  include Grit
#  include SteakFM::FeatureElement::Component::TotalEstimation

  attr_reader :info

  def features
    @features ||= scan_features
  end

  def scenarios
    (features.collect { |feature| feature.scenarios }).flatten
  end

  def config
    @config ||= SteakFM::Config.new((config_parameters || {}))
  end

  def filter
    @filter ||= SteakFM::MetaInfoFilter.new(config.tags)
  end

  def aggregate
    unless patterns_for_aggregator.empty?
      @raport ||= SteakFM::Aggregator.new(self, patterns_for_aggregator).collection
    end
  end

  def prefix
    config.dir.empty? ? path : File.join(path, config.dir)
  end

#  def commit_change_on(feature)
#    # use info to notify user
#    # @info = 'aaaa'
#    add_to_index(feature)
#    repo.commit_index("spec-update: #{feature.filename}")
#  end
#
#  def remove_file_from_repo(relative_path)
#    `cd #{repo_path} && git rm #{relative_path}`
#  end
#
#  def send_to_remote
#    push_to_remote
#  end

  private
#
#  def add_to_index(feature)
#    # WTF - why this is not works
#    # repo.add(feature.path)
#    `cd #{repo_path} && git add #{feature.path}`
#  end
#
#  # TODO cleanup
#  def push_to_remote
#    # WTF - why this is not works
#    # git.push({}, repo_remote_name, "#{repo_current_branch}:#{repo_remote_branch_name}")
#    if capistrano_branch_name
#      `cd #{repo_path} && git push #{repo_remote_name} #{repo_current_branch}:#{capistrano_branch_name}`
#    elsif last_stories_branch_name
#      begin
#        response = `cd #{repo_path} && git push #{repo_remote_name} #{repo_current_branch}:#{last_stories_branch_name}`
#        throw :not_fast_forward if response =~ /non\-fast\-forward/
#      rescue => e
#        `cd #{repo_path} && git push #{repo_remote_name} #{repo_current_branch}:#{new_branch_name}`
#      end
#    else
#      `cd #{repo_path} && git push #{repo_remote_name} #{repo_current_branch}:#{new_branch_name}`
#    end
#  end

  def scan_features
    all_features.collect { |feature| feature if filter.pass?(feature.tags_all) }.compact
  end

  def all_features
    @all_features ||= scan_all_features
  end

  def scan_all_features
    features = []
    Dir.glob("#{prefix}/**/*_spec.rb").each do |full_path|
      feature = SteakFM::Feature.new(full_path, self)
      features.push(feature) if feature.valid?
    end
    features
  end

#  def repo_relative_path(path)
#    path.gsub(repo_path, '').gsub(/^\//, '')
#  end
#
#  def repo
#    @repo ||= Repo.new(repo_path)
#  end
#
#  def git
#    repo.git
#  end
#
#  def repo_current_branch
#    repo.head.name
#  end
#
#  def repo_remote_name
#    repo.remote_list.first
#  end
#
#  def last_stories_branch_name
#    repo.remotes.map(& :name).collect { |name| /stories_\d+/.match(name) }.compact.map(& :to_s).sort.last
#  end
#
#  def capistrano_branch_name
#    "stories_#{timestamp_capistrano}" if timestamp_capistrano
#  end
#
#  def timestamp_capistrano
#    pattern = /\d{14}$/
#    if defined?(Rails)
#      pattern.match(Rails.root.to_s)
#    end
#  end
#
#  def new_branch_name
#    "stories_#{Time.now.strftime('%Y%m%d%H%M%S')}"
#  end

  def patterns_for_aggregator
    config.aggregate.map { |label|
      SteakFM::FeatureElement::Component::Tags::PATTERN[label.to_sym] unless label.blank?
    }.compact
  end
end