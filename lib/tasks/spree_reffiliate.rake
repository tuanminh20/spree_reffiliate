namespace :reffiliate do
  task generate: :environment do
    Spree.user_class.all.each do |user|
      user.create_referral if user.referral.nil?
    end
    puts 'Referrals generated.'
  end
end
