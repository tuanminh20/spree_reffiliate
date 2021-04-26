module Spree
  class Promotion
    module Rules
      class ReferredPromotionRule < Spree::PromotionRule
        def eligible?(order, _options = {})
          order.user&.referred?
        end

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end
      end
    end
  end
end
