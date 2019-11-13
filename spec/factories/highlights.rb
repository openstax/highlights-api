# frozen_string_literal: true

FactoryBot.define do
  factory :highlight do
    user_uuid  { SecureRandom.uuid }
    source_type { 'openstax_page' }
    color { '#000000' }
    anchor { 'fs-id1170572203905' }
    annotation { 'this is important' }
    highlighted_content { 'Einstein was smart' }
    location_strategies do
      [
        {
          type: 'TextPositionSelector',
          start: 12,
          end: 10
        }
      ].to_json
    end
    source_id { SecureRandom.uuid }
    source_parent_ids do
      %w[ccf8e44e-05e5-4272-bd0a-aca50171b50f 972c21f9-a56e-4fa6-b52c-1a8854a9cc63]
    end
    source_metadata { '{page_version: 14}' }
    order_in_source { rand(100) }
    source_order { '12.1' }

    trait :red do
      color { '#ff0000' }
    end
  end
end
