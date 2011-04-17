module SteakFM
  module FeatureElement
    module Component
      module Story
        STORY_PATTERN = /(^\s*#[^#].*\n)+(?=((.*\n)*(scenario|feature|background) ".*"))/

        def story
          @story ||= fetch_story
        end

        private

        def fetch_story
          if story_raw = STORY_PATTERN.match(raw)
            story_raw[0].gsub(/^\s*#\s*/, '').strip
          end
        end
      end
    end
  end
end