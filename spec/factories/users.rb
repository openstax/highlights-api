FactoryBot.define do
  factory :user do
    num_annotation_characters { 100 }
    num_highlights { 50 }

    factory :user_with_sources do
      after(:create) do |user, evaluator|
        create_list(:user_source, 2, user: user)
      end
    end

    factory :new_user do
      num_annotation_characters { 0 }
      num_highlights { 0 }
    end
  end
end
