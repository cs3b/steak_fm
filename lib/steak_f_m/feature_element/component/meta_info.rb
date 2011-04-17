module SteakFM
  module FeatureElement
    module Component
      module MetaInfo

        include SteakFM::FeatureElement::Component::MetaInfoExt::Comment
        include SteakFM::FeatureElement::Component::MetaInfoExt::Hash

        STATUS_COMPLETE = %w(done qa accepted)

        def meta_info
          @meta_info ||= fetch_meta_info
        end

        def tags= tags
          @tags = tags
        end

        def done?
          STATUS_COMPLETE.include?(status)
        end

        def effort
          meta_info[:effort] ? meta_info[:effort].to_f : 0.0
        end

        private

        def fetch_meta_info
          feature_meta_info.merge(this_meta_info)
        end

        def this_meta_info
          comments_meta_info.merge(hash_meta_info)
        end

        def feature_meta_info
          respond_to?(:feature) ? feature.meta_info : {}
        end

        def method_missing(m, *args, &block)
          meta_info[m.to_sym] || super
        end
      end
    end
  end
end