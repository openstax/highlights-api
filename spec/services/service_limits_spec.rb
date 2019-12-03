require 'rails_helper'

RSpec.describe ServiceLimits, type: :service do
  describe '.with_create_protection' do
    subject(:service_limits) { described_class.new(user_id: user.id) }

    context 'over the limits for max highlights per user' do
      let!(:user) { create(:new_user, num_highlights: 5) }

      before do
        @prev = reset_constant(const_name: 'MAX_HIGHLIGHTS_PER_USER', value: 2)
      end

      after do
        reset_constant(const_name: 'MAX_HIGHLIGHTS_PER_USER', value: @prev)
      end

      it 'raises an exception because this would be over max' do
        expect(user.num_highlights).to eq 5
        expect(Highlight.count).to eq 0

        expect do
          service_limits.with_create_protection do
            create(:highlight, user: user)
          end
        end.to raise_error(ServiceLimits::ExceededMaxHighlightsPerUser)

        expect(Highlight.count).to eq 0
        expect(user.num_highlights).to eq 5
      end
    end

    context 'under the limits for max highlights per user' do
      let!(:user) { create(:new_user, num_highlights: 2) }

      before do
        @prev_max_hls_per_user = reset_constant(const_name: 'MAX_HIGHLIGHTS_PER_USER', value: 4)
      end

      after do
        reset_constant(const_name: 'MAX_HIGHLIGHTS_PER_USER', value: @prev_max_hls_per_user)
      end

      it 'will add the highlight without a service limit exception' do
        expect(user.reload.num_highlights).to eq 2
        expect(Highlight.count).to eq 0

        expect do
          service_limits.with_create_protection do
            create(:highlight, user: user)
          end
        end.not_to raise_error

        expect(user.reload.num_highlights).to eq 3
        expect(Highlight.count).to eq 1
      end
    end

    context 'under the limits for max chars per annotation' do
      let!(:user) { create(:new_user) }

      let(:under_10) { 'under10' }

      before do
        @prev = reset_constant(const_name: 'MAX_CHARS_PER_ANNOTATION', value: 10)
      end

      after do
        reset_constant(const_name: 'MAX_CHARS_PER_ANNOTATION', value: @prev)
      end

      it 'will add an annotation without a service limit exception' do
        expect do
          service_limits.with_create_protection do
            create(:highlight, user: user, annotation: under_10)
          end
        end.not_to raise_error

        expect(Highlight.count).to eq 1
        expect(Highlight.first.annotation).to eq under_10
      end
    end

    context 'over the limits for max chars per annotation' do
      let!(:user) { create(:new_user) }
      let(:over_10) { 'this is a very very long note' }

      before do
        @prev = reset_constant(const_name: 'MAX_CHARS_PER_ANNOTATION', value: 10)
      end

      after do
        reset_constant(const_name: 'MAX_CHARS_PER_ANNOTATION', value: @prev)
      end

      it 'will add an annotation without a service limit exception' do
        expect do
          service_limits.with_create_protection do
            create(:highlight, user: user, annotation: over_10)
          end
        end.to raise_error(ServiceLimits::ExceededMaxAnnotationChars)

        expect(Highlight.count).to eq 0
      end
    end

    context 'limits for max chars per annotation per user' do
      let!(:another_user) { create(:new_user, num_annotation_characters: under_10.length) }
      let!(:user) { create(:new_user) }

      let(:under_10) { 'under10' }
      let(:over_10) { 'a long note over 10 characters' }

      before do
        @prev = reset_constant(const_name: 'MAX_ANNOTATION_CHARS_PER_USER', value: 10)
        create(:highlight, user: another_user, annotation: over_10)
      end

      after do
        reset_constant(const_name: 'MAX_ANNOTATION_CHARS_PER_USER', value: @prev)
      end

      it 'will add an annotation without a service limit exception' do
        expect do
          service_limits.with_create_protection do
            create(:highlight, user: user, annotation: under_10)
          end
        end.not_to raise_error

        expect(user.reload.num_annotation_characters).to eq under_10.length

        expect do  # this time, it should hit it
          service_limits.with_create_protection do
            create(:highlight, user: user, annotation: under_10)
          end
        end.to raise_error(ServiceLimits::ExceededMaxAnnotationCharsPerUser)

        expect(user.reload.num_annotation_characters).to eq under_10.length
      end

      it 'will hit the service limit exception for the other user' do
        expect do
          service_limits.with_create_protection do
            create(:highlight, user: another_user, annotation: over_10)
          end
        end.to raise_error(ServiceLimits::ExceededMaxAnnotationCharsPerUser)

        expect(another_user.reload.num_annotation_characters).to eq under_10.length
      end
    end

    context 'over the limits for user source max highlights' do
      let!(:user) { create(:new_user) }
      let!(:user_source) { create(:user_source, source_id: source_id, user: user, num_highlights: 1) }

      let(:source_id) { SecureRandom.uuid }
      let(:highlight1) { create(:highlight, user: user, source_id: source_id) }
      let(:highlight2) { create(:highlight, prev_highlight_id: highlight1.id, user: user, source_id: source_id) }

      before do
        @prev = reset_constant(const_name: 'MAX_HIGHLIGHTS_PER_SOURCE_PER_USER', value: 2)
      end

      after do
        reset_constant(const_name: 'MAX_HIGHLIGHTS_PER_SOURCE_PER_USER', value: @prev)
      end

      it 'raises an exception because this would be over max' do
        expect(user_source.reload.num_highlights).to eq 1

        expect do
          service_limits.with_create_protection do
            highlight1
          end
        end.to_not raise_error

        expect(user_source.reload.num_highlights).to eq 2

        expect do
          service_limits.with_create_protection do
            highlight2
          end
        end.to raise_error(ServiceLimits::ExceededMaxHighlightsPerUserPerSource)

        expect(user_source.reload.num_highlights).to eq 2
      end
    end
  end

  describe '.with_update_protection' do
    subject(:service_limits) { described_class.new(user_id: user.id) }

    context 'limits for max chars per annotation per user' do
      let!(:user) { create(:new_user, num_annotation_characters: under_10.length) }
      let!(:highlight) { create(:highlight, user: user, annotation: under_10) }

      let(:under_10) { 'under10' }
      let(:over_10) { 'a long note over 10 characters' }

      before do
        @prev = reset_constant(const_name: 'MAX_ANNOTATION_CHARS_PER_USER', value: 10)
      end

      after do
        reset_constant(const_name: 'MAX_ANNOTATION_CHARS_PER_USER', value: @prev)
      end

      it 'will update an annotation up to the max annotation limits' do
        expect do
          service_limits.with_update_protection(prev_annotation_length: highlight.annotation.length) do
            highlight.annotation = over_10
            highlight.tap(&:save!)
          end
        end.to raise_error(ServiceLimits::ExceededMaxAnnotationCharsPerUser)

        expect(user.reload.num_annotation_characters).to eq under_10.length

        expect do
          service_limits.with_update_protection(prev_annotation_length: highlight.reload.annotation.length) do
            highlight.annotation = under_10
            highlight.tap(&:save!)
          end
        end.to_not raise_error

        expect(user.reload.num_annotation_characters).to eq under_10.length
      end
    end
  end

  describe '.with_delete_reincrement' do
    let!(:user) { create(:new_user, num_highlights: 10, num_annotation_characters: 100) }
    let!(:user_source) { create(:user_source, user: user, source_id: highlight.source_id, num_highlights: 5 ) }
    let!(:highlight) { create(:highlight, user: user, annotation: annotation) }
    let(:annotation) { 'foobar' }

    subject(:service_limits) { described_class.new(user_id: user.id) }

    context 'resets the user annotation max' do
      it 'will decrement the length of the annotation' do
        expect(user.reload.num_annotation_characters).to eq 100

        service_limits.with_delete_reincrement do
          highlight.destroy!
        end

        expect(user.reload.num_annotation_characters).to eq (100 - annotation.length)
      end
    end

    context 'resets the user source num highlights' do
      it 'will decrement highlight from the user source' do
        expect(user_source.reload.num_highlights).to eq 5

        service_limits.with_delete_reincrement do
          highlight.destroy!
        end

        expect(user_source.reload.num_highlights).to eq 4
      end
    end

    context 'resets the user num highlights' do
      it 'will decrement the user num highlights' do
        expect(user.reload.num_highlights).to eq 10

        service_limits.with_delete_reincrement do
          highlight.destroy!
        end

        expect(user.reload.num_highlights).to eq 9
      end
    end
  end

  def reset_constant(const_name:, value:)
    prev_value = ServiceLimits.const_get(const_name)
    ServiceLimits.send('remove_const', const_name)
    ServiceLimits.const_set(const_name, value)
    prev_value
  end
end
