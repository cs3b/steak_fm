module SteakFM
  module FeatureElement
    module Component
      module MetaInfoExt
        module TotalEffort
          def effort
            scenarios.inject(0.0) { |sum, scenario| sum + scenario.effort }
          end

          # before effort_done
          def effort_complete
            scenarios.inject(0.0) do |sum, scenario|
              scenario.complete? ?
                  sum + scenario.estimation :
                  sum
            end
          end

          def effort_complete_percentage
            effort > 0 ? (effort_complete.to_f / effort * 100).round : 0
          end

          def scenarios_complete
            scenarios.inject(0) {|number, s| s.complete? ? number+1 : number }
          end

          def scenarios_complete_percentage
            !scenarios.empty? ? (scenarios_complete.to_f / scenarios.size * 100).round : 0
          end

        end
      end
    end
  end
end