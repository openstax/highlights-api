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
          type: "TextPositionSelector",
          start: 12,
          end: 10
         }
     ].to_json
    end
    source_id { SecureRandom.uuid }
    source_parent_ids { [123, 456] }
    source_metadata { '{page_version: 14}' }

    trait :red do
      color { '#ff0000' }
    end
  end
end
