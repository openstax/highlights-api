if Rails.env.development?
  Highlight.destroy_all

  Highlight.create!(user_uuid: '52f42df8-17f4-4ad2-a702-3d6b8174a4df',
                    source_type: 'openstax_page',
                    color: '#000000',
                    source_id: 'daece11d-23a1-4f2f-b184-d9bc6ef7849d',
                    source_parent_ids: ['ccf8e44e-05e5-4272-bd0a-aca50171b50f'],
                    anchor: 'fs-id1170572203905',
                    annotation: 'study this',
                    highlighted_content: 'red blood cells',
                    location_strategies: [{ "end": '10',
                                            "type": 'TextPositionSelector',
                                            "start": '12' }])

  Highlight.create!(user_uuid: '52f42df8-17f4-4ad2-a702-3d6b8174a4df',
                    source_type: 'openstax_page',
                    color: '#000000',
                    source_id: 'daece11d-23a1-4f2f-b184-d9bc6ef7849d',
                    source_parent_ids: ['ccf8e44e-05e5-4272-bd0a-aca50171b50f'],
                    anchor: 'fs-id1170572203905',
                    annotation: 'review for test',
                    highlighted_content: 'autoimmune system',
                    location_strategies: [{ "end": '10',
                                            "type": 'TextPositionSelector',
                                            "start": '12' }])

  Highlight.create!(user_uuid: '52f42df8-17f4-4ad2-a702-3d6b8174a4df',
                    source_type: 'openstax_page',
                    color: '#ffffff',
                    source_id: 'daece11d-23a1-4f2f-b184-d9bc6ef7849d',
                    source_parent_ids: ['ccf8e44e-05e5-4272-bd0a-aca50171b50f'],
                    anchor: 'fs-id1170572203905',
                    annotation: 'another one',
                    highlighted_content: 'white blood cells',
                    location_strategies: [{ "end": '20',
                                            "type": 'TextPositionSelector',
                                            "start": '22' }])

  puts "#{Highlight.count} records seeded"
end
