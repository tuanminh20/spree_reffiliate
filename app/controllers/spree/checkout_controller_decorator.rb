module Spree::CheckoutControllerDecorator
  def self.prepended(base)
    base.before_action :set_affilate, only: :update
    base.after_action :clear_session, only: :update
  end

  private

  def set_affilate
    @order.affiliate = Spree::Affiliate.find_by(path: session[:affiliate]) if @order.payment? && session[:affiliate]
  end

  def clear_session
    session[:affiliate] = nil if @order.completed?
  end
end
Spree::CheckoutController.prepend Spree::CheckoutControllerDecorator
