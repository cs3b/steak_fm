module SteakFM
  module FeatureElement
    class Scenario < Struct.new(:feature, :raw)
      PATTERN = /((^.*#+.*\n)+\n?)?(^.*@+.*\n)?^[ \t]*scenario ".*"(.*do\b(.*?\n?)+end)?/

      include SteakFM::FeatureElement::Component::Story
      include SteakFM::FeatureElement::Component::Title


# TODO
#      include SteakFM::FeatureElement::Component::Tags
#      include SteakFM::FeatureElement::Component::Comments

      # todo cleanup this fake
      def tags
        []
      end

      # todo rename
      def second_tags_source
        feature.info
      end
    end
  end
end
