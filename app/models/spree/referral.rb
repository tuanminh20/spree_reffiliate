module Spree
  class Referral < Spree::Base
    belongs_to :user, class_name: Spree.user_class.to_s
    has_many :referred_records

    validates :user_id, :code, presence: true

    before_validation :attach_code, on: :create

    def referred_users
      referred_records.includes(:user).filter_map(&:user)
    end

    def referred_orders
      referred_records_with_user_orders.collect { |u| u.user.orders }.flatten.compact
    end

    def referral_activated_users
      referred_records_with_user_orders.select { |u| post_referral_order?(u) }.collect(&:user)
    end

    protected

    def attach_code
      self.code = loop do
        code =  (0...8).map { rand(65..90).chr }.join
        break code unless Referral.exists?(code: code)
      end
    end

    private

    def referred_records_with_user_orders
      referred_records.includes({ user: :orders })
    end

    def post_referral_order?(referred_record)
      referred_record.user.orders.where('completed_at > ?', user.created_at).any?
    end
  end
end
