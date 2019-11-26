FactoryBot.define do
  factory :user_source do
    source_id { SecureRandom.uuid }
    num_highlights { 100 }
    user
  end
end
