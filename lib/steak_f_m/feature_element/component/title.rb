module SteakFM
  module FeatureElement
    module Component
      module Title
        TITLE_PATTERN = /((scenario|feature|background) )"(.*)"/

        def title
          @title ||= fetch_title
        end

        private

        def fetch_title
          if title_line = TITLE_PATTERN.match(raw)
            title_line[3].strip
          else
            '--- no title found'
          end
        end
      end
    end
  end
end