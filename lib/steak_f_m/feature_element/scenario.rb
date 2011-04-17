module SteakFM
  module FeatureElement
    class Scenario < Struct.new(:feature, :raw)
      PATTERN = /((^.*#+.*\n)+\n?)?(^.*@+.*\n)?^[ \t]*scenario ".*"(.*do\b(.*?\n?)+end)?/

      include SteakFM::FeatureElement::Component::Story
      include SteakFM::FeatureElement::Component::Title
      include SteakFM::FeatureElement::Component::MetaInfo

    end
  end
end
