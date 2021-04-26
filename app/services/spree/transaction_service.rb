module Spree
  class TransactionService
    attr_accessor :transaction, :affiliate, :affiliate_commission_rule, :amount

    def calculate_commission_amount
      if affiliate_commission_rule.present?
        rate = affiliate_commission_rule.rate
        @amount = if affiliate_commission_rule.fixed_commission?
                    rate
                  else
                    (transaction.commissionable.try(:item_total) * rate) / 100
                  end
        @amount.to_f
      end
    end

    private

    def initialize(transaction)
      @transaction = transaction
      @affiliate = transaction.affiliate
      case @transaction.commissionable_type
      when 'Spree::User'
        @affiliate_commission_rule = affiliate.affiliate_commission_rules.active.user_registration.first
      when 'Spree::Order'
        @affiliate_commission_rule = affiliate.affiliate_commission_rules.active.order_placement.first
      end
    end
  end
end
