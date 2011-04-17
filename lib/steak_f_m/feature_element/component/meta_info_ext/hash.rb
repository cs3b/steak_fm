module SteakFM
  module FeatureElement
    module Component
      module MetaInfoExt
        module Hash

          KEY_VALUE_METADATA_PATTERN = /:([^\s]+|"[^\s"]+"|'[^\s']+') => ("([^\s"]+)"|'([^\s']+)'|:([^\s]+))/
          KEY_VALUES_METADATA_PATTERN = /(#{KEY_VALUE_METADATA_PATTERN}(, ?)?)+(?= do)/

          def hash_meta_info
            @hash_meta_info ||= fetch_meta_info_from_hash
          end

          private

          def fetch_meta_info_from_hash
            if any_info = KEY_VALUES_METADATA_PATTERN.match(raw)
              any_info[0].split(/,\s?(?=:)/).inject({}) do |info, string|
                if key_value = KEY_VALUE_METADATA_PATTERN.match(string)
                  info[key_value[1].to_sym] = (key_value[3] || key_value[4] || key_value[5])
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