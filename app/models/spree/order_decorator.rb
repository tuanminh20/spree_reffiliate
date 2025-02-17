module Spree::OrderDecorator
  include Spree::TransactionRegistrable
  def self.prepended(base)
    base.has_many :transactions, as: :commissionable, class_name: 'Spree::CommissionTransaction',
                                 dependent: :restrict_with_error
    base.belongs_to :affiliate, class_name: 'Spree::Affiliate'
    base.state_machine.after_transition to: :complete, do: :create_commission_transaction
  end

  private

  def create_commission_transaction
    register_commission_transaction(affiliate) if affiliate.present?
  end
end
Spree::Order.prepend Spree::OrderDecorator
