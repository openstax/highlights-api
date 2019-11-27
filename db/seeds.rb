if Rails.env.development?
  Highlight.destroy_all

  hl = Highlight.create!(user_uuid: '52f42df8-17f4-4ad2-a702-3d6b8174a4df',
                         source_type: 'openstax_page',
                         color: 'yellow',
                         source_id: 'daece11d-23a1-4f2f-b184-d9bc6ef7849d',
                         scope_id: 'ccf8e44e-05e5-4272-bd0a-aca50171b50f',
                         anchor: 'fs-id1170572203905',
                         annotation: 'study this',
                         highlighted_content: 'red blood cells',
                         location_strategies: [{ "end": '10',
                                                 "type": 'TextPositionSelector',
                                                 "start": '12' }])

  hl = Highlight.create!(user_uuid: '52f42df8-17f4-4ad2-a702-3d6b8174a4df',
                         source_type: 'openstax_page',
                         color: 'yellow',
                         source_id: 'daece11d-23a1-4f2f-b184-d9bc6ef7849d',
                         scope_id: 'ccf8e44e-05e5-4272-bd0a-aca50171b50f',
                         prev_highlight_id: hl.id,
                         anchor: 'fs-id1170572203905',
                         annotation: 'review for test',
                         highlighted_content: 'autoimmune system',
                         location_strategies: [{ "end": '10',
                                                 "type": 'TextPositionSelector',
                                                 "start": '12' }])

  Highlight.create!(user_uuid: '52f42df8-17f4-4ad2-a702-3d6b8174a4df',
                    source_type: 'openstax_page',
                    color: 'green',
                    prev_highlight_id: hl.id,
                    source_id: 'daece11d-23a1-4f2f-b184-d9bc6ef7849d',
                    scope_id: 'ccf8e44e-05e5-4272-bd0a-aca50171b50f',
                    anchor: 'fs-id1170572203905',
                    annotation: 'another one',
                    highlighted_content: 'white blood cells',
                    location_strategies: [{ "end": '20',
                                            "type": 'TextPositionSelector',
                                            "start": '22' }])

  Highlight.create!(user_uuid: 'c967ccb8-97ad-4031-9fe5-7df8af056bfb',
                    source_type: 'openstax_page',
                    color: 'red',
                    source_id: 'e0ebcd05-0fbf-4fc2-a063-9c68d424fc5c',
                    scope_id: 'ccf8e44e-05e5-4272-bd0a-aca50171b50f',
                    anchor: 'fs-id48938221',
                    highlighted_content: 'big clouds',
                    location_strategies: [{ "end": '10',
                                            "type": 'TextPositionSelector',
                                            "start": '12' }])

  puts "#{Highlight.count} records seeded"
end
