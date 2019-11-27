# frozen_string_literal: true

FactoryBot.define do
  factory :highlight do
    user_uuid { SecureRandom.uuid }
    source_type { 'openstax_page' }
    color { Api::V0::HighlightsSwagger::VALID_HIGHLIGHT_COLORS.first }
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
    scope_id { 'ccf8e44e-05e5-4272-bd0a-aca50171b50f' }
    source_metadata { '{page_version: 14}' }
    # order_in_source { rand(1e6)/(1e6*1.0) }
    prev_highlight { nil }
    next_highlight { nil }

    trait :red do
      color { '#ff0000' }
    end
  end
end
