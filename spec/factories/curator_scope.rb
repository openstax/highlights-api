FactoryBot.define do
  factory :curator_scope do
    scope_id { SecureRandom.uuid }
    curator_id { SecureRandom.uuid }
  end
end
