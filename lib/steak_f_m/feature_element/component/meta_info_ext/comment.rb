module SteakFM
  module FeatureElement
    module Component
      module MetaInfoExt
        module Comment

          COMMENT_METADATA_PATTERN = /(^\s*##.*\n)+(?=((.*\n)*^.*(scenario|feature|background) ".*"))/


          def comments_meta_info
            @comments_meta_info ||= fetch_meta_info_from_comment
          end

          private

          def fetch_meta_info_from_comment
            if any_info = COMMENT_METADATA_PATTERN.match(raw)
               any_info[0].split("\n").inject({}) do |info, line_value|
                 if key_value = /## (\S+):\s?(.*)/.match(line_value)
                   info[key_value[1].to_sym] = key_value[2]
                 end
                 info
               end
            else
              {}
            end
          end

        end
      end
    end
  end
end