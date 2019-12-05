FactoryBot.define do
  factory :user_source do
    source_id { SecureRandom.uuid }
    source_type { 'openstax_page' }
    num_highlights { 100 }
    user
  end
end
