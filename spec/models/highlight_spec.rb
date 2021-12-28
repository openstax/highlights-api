require 'rails_helper'

RSpec.describe Highlight, type: :model do
  let(:highlight) { create(:highlight) }
  let(:uuid1) { SecureRandom.uuid }
  let(:uuid2) { SecureRandom.uuid }
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:other_user) { create(:user) }

  describe 'creates to db ok' do
    let(:valid_uuid) { Highlight::VALID_UUID }

    before { create(:highlight) }

    it 'has a count of 1 in the db' do
      expect(Highlight.count).to eq 1
    end

    it 'created an id w/ a valid uuid' do
      expect(Highlight.first.id).to match(valid_uuid)
    end
  end

  describe 'validations' do
    describe '#source_type' do
      it 'must be a valid enum' do
        expect { described_class.new(source_type: 'invalid source_type') }
          .to raise_exception(ArgumentError)

        record = described_class.new(source_type: :openstax_page)
        expect(record.valid?).to be_falsey
        expect(record.errors[:source_type]).to_not include('is invalid')
      end
    end

    context 'generic normalizations' do
      it 'color will be downcased' do
        record = described_class.new(color: '#C0C0C0')
        record.validate
        expect(record.color).to eq '#c0c0c0'
      end
    end

    context 'openstax_page source_type' do
      it 'color will be downcased' do
        record = described_class.new(color: '#C0C0C0')
        record.validate
        expect(record.color).to eq '#c0c0c0'
      end

      it 'scope_id will be downcased' do
        record = described_class.openstax_page.new(scope_id: 'ABC')
        record.validate
        expect(record.scope_id).to eq 'abc'
      end

      it 'source_id will be downcased' do
        record = described_class.openstax_page.new(source_id: 'ABC')
        record.validate
        expect(record.source_id).to eq 'abc'
      end

      context 'source ids' do
        it 'source_id must be a uuid' do
          record = described_class.openstax_page.new(source_id: 'ABC')
          record.validate
          expect(record.errors['source_id']).to eq ['must be a UUID for source_type openstax_page']

          record = described_class.openstax_page.new(source_id: SecureRandom.uuid)
          record.validate
          expect(record.errors['source_id']).to be_empty
        end

        it 'scope_id must be a uuid' do
          record = described_class.openstax_page.new(scope_id: 'ABC')
          record.validate
          expect(record.errors['scope_id']).to eq ['must be a UUID for source_type openstax_page']

          record = described_class.openstax_page.new(scope_id: SecureRandom.uuid)
          record.validate
          expect(record.errors['scope_id']).to be_empty
        end
      end
    end

    context 'page_content_fetchable?' do
      it 'checks that required source_metadata is available' do
        # old clients won't have new metadata, only bookVersions
        record = build(:highlight, source_metadata: { })
        expect(record.page_content_fetchable?).to be false

        record = build(:highlight, source_metadata: { bookVersion: '1.0' })
        expect(record.page_content_fetchable?).to be true
      end
    end

    context 'neighbors' do
      let(:page_anchors) { ['a', 'b', 'c'] }

      context 'when prev or next information is missing' do
        context 'new anchor' do
          before do
            allow_any_instance_of(Highlight).to receive(:page_anchors).and_return(page_anchors)
          end

          context 'with page anchors' do
            it 'can find neighbors from the start and end' do
              hlb = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'b')
              hla = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')
              hlc = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'c')

              orders = [hla, hlb, hlc].map {|hl| hl.reload.order_in_source }
              expect(orders).to eq [-1.0, 0.0, 1.0]
              expect(hlb.prev_highlight.anchor).to eq hla.anchor
              expect(hlb.next_highlight.anchor).to eq hlc.anchor
            end

            it 'can find neighbors from the middle' do
              hla = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')
              hlc = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'c')
              hlb = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'b')

              orders = [hla, hlb, hlc].map {|hl| hl.reload.order_in_source }
              expect(orders).to eq [0.0, 0.5, 1.0]
              expect(hlb.prev_highlight_id).to eq hla.id
              expect(hlb.next_highlight_id).to eq hlc.id
            end

          end

          context 'without page anchors' do
            it 'places the highlight at the end' do
              hl1 = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')
              hl2 = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'b')

              expect(hl1.reload.next_highlight_id).to eq hl2.id
              expect(hl2.reload.prev_highlight_id).to eq hl1.id
            end
          end
        end

        context 'existing anchor' do
          before do
            allow_any_instance_of(Highlight).to receive(:page_anchors).and_return(page_anchors)
          end

          context 'inside anchor position methods' do
            let(:hl1) { create(:highlight, :with_content_path, path: [0, 0],
                               source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a') }
            let(:hl2) { create(:highlight, :with_content_path, path: [0, 100],
                               source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a') }
            let(:hl3) { build(:highlight, :with_content_path,  path: [0, 50],
                              source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a') }

            before { [hl1, hl2].map(&:reload) }

            it '#sorted_neighbors sorts a new record with existing' do
              sorted_anchors = [
                [hl1.id, hl1.content_path],
                ["self", hl3.content_path],
                [hl2.id, hl2.content_path]
              ]

              expect(hl3.send(:sorted_anchor_neighbors)).to eq sorted_anchors
            end

            it '#self_index finds itself' do
              expect(hl3.send(:self_index)).to eq 1
            end
          end

          it 'can find neighbors from the start and end' do
            hl1 = create(:highlight, :with_content_path, path: [1, 0],
                         source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')

            hl2 = create(:highlight, :with_content_path, path: [0, 0],
                         source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')

            hl3 = create(:highlight, :with_content_path, path: [2, 0],
                         source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')

            orders = [hl2, hl1, hl3].map {|hl| hl.reload.order_in_source }
            expect(orders).to eq [-1.0, 0.0, 1.0]
            expect(hl1.prev_highlight_id).to eq hl2.id
            expect(hl1.next_highlight_id).to eq hl3.id
          end

          it 'can find neighbors from the middle' do
            hl2 = create(:highlight, :with_content_path, path: [0, 0],
                         source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')

            hl3 = create(:highlight, :with_content_path, path: [2, 0],
                         source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')

            hl1 = create(:highlight, :with_content_path, path: [1, 0],
                         source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')


            orders = [hl2, hl1, hl3].map {|hl| hl.reload.order_in_source }
            expect(orders).to eq [0.0, 0.5, 1.0]
            expect(hl1.prev_highlight_id).to eq hl2.id
            expect(hl1.next_highlight_id).to eq hl3.id
          end

          it 'works with existing highlights that do not have node_path data' do
            hl1 = create(:highlight, :with_base_xpath_selector,
                         source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')

            hl2 = create(:highlight, :with_base_xpath_selector,
                         source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')

            hl3 = create(:highlight, :with_base_xpath_selector,
                         source_id: uuid1, scope_id: uuid1, user_id: user_id, anchor: 'a')

            hl2.reload

            expect(hl2.prev_highlight_id).to eq hl1.id
            expect(hl2.next_highlight_id).to eq hl3.id
          end
        end
      end

      context 'when prev or next information is stale' do
        before do
          allow_any_instance_of(Highlight).to receive(:page_anchors).and_return(page_anchors)
        end

        it 'determines the correct order' do
          hla = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id,
                       content_path: [0], anchor: 'a')

          hlb = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id,
                       content_path: [0], anchor: 'b')

          hld = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id,
                       content_path: [0], anchor: 'd')

          hlc = create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id,
                       content_path: [0], anchor: 'c', prev_highlight_id: hla.id)

          expect(hlc.prev_highlight_id).to eq hlb.id
        end
      end

      context 'source consistency' do
        it 'is invalid unless prev has same source as the highlight' do
          hl1 = create(:highlight, source_id: uuid1)
          record = described_class.openstax_page.new(source_id: uuid2, prev_highlight: hl1)
          expect_error(record, :prev_highlight_id, /highlight in the same source/)
        end

        it 'is invalid unless next has same source as the highlight' do
          hl1 = create(:highlight, source_id: uuid1)
          record = described_class.openstax_page.new(source_id: uuid2, next_highlight: hl1)
          expect_error(record, :next_highlight_id, /highlight in the same source/)
        end
      end

      context 'when there are no highlights on a source' do
        it 'can create a HL without specifying prev and next' do
          hl1 = create(:highlight, source_id: uuid1, scope_id: uuid1)
          expect(hl1.order_in_source).to eq 0.0
        end
      end

      context 'when there is one highlight on a source' do
        let!(:hl1) { create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: user_id) }

        context 'working in the same scope' do
          it 'is ok if the highlight is from a different user' do
            expect{
              create(:highlight, source_id: uuid1, scope_id: uuid1, user_id: other_user.id)
            }.not_to raise_error
          end

          it 'complains about making one in between when next is wrong' do
            expect{
              create(:highlight, source_id: uuid1, scope_id: uuid1, next_highlight_id: SecureRandom.uuid, user_id: user_id)
            }.to raise_error(ActiveRecord::RecordInvalid, /is unknown/)
          end

          it 'complains about making one in between when prev is wrong' do
            expect{
              create(:highlight, source_id: uuid1, scope_id: uuid1, prev_highlight_id: SecureRandom.uuid, user_id: user_id)
            }.to raise_error(ActiveRecord::RecordInvalid, /is unknown/)
          end

          it 'works to make one before (at beginning) as long as it specifies the existing as next' do
            hl3 = create(:highlight, source_id: uuid1, scope_id: uuid1, next_highlight: hl1, user_id: user_id)
            expect(hl3.order_in_source).to be < hl1.order_in_source
            hl1.reload
            expect(hl1.prev_highlight_id).to eq hl3.id
          end

          it 'works to make one after (at end) as long as it specifies the existing as prev' do
            hl2 = create(:highlight, source_id: uuid1, scope_id: uuid1, prev_highlight: hl1, user_id: user_id)
            expect(hl2.order_in_source).to be > hl1.order_in_source
            hl1.reload
            expect(hl1.next_highlight_id).to eq hl2.id
          end

          it 'is happily deleted' do
            expect(hl1.destroy).to be_truthy
          end
        end

        context 'working in a different scope' do
          it 'does not complain that prev and next are not set when in a different scope' do
            expect{create(:highlight, source_id: uuid1, scope_id: uuid2)}.not_to raise_error
          end

          it 'complains when prev is in a different scope' do
            expect{
              create(:highlight, source_id: uuid1, scope_id: uuid2, prev_highlight: hl1)
            }.to raise_error(ActiveRecord::RecordInvalid, /does not live in the same scope/)
          end

          it 'complains when next is in a different scope' do
            expect{
              create(:highlight, source_id: uuid1, scope_id: uuid2, next_highlight: hl1)
            }.to raise_error(ActiveRecord::RecordInvalid, /does not live in the same scope/)
          end
        end
      end

      context 'when there are two highlights on a source' do
        let!(:hl1) { create(:highlight, source_id: uuid1, scope_id: uuid1) }
        let!(:hl2) { create(:highlight, source_id: uuid1, scope_id: uuid1, prev_highlight: hl1) }

        it 'complains about making one in between without specifying prev' do
          expect{
            create(:highlight, source_id: uuid1, scope_id: uuid1, next_highlight: hl2)
          }.to raise_error(ActiveRecord::RecordInvalid, /are not adjacent/)
        end

        it 'complains about making one in between without specifying next' do
          expect{
            create(:highlight, source_id: uuid1, scope_id: uuid1, prev_highlight: hl1)
          }.to raise_error(ActiveRecord::RecordInvalid, /are not adjacent/)
        end

        it 'works to make one in the middle when prev and next are correct' do
          hl3 = create(:highlight, source_id: uuid1, scope_id: uuid1, prev_highlight: hl1, next_highlight: hl2)
          hl1.reload
          hl2.reload
          expect(hl1.next_highlight_id).to eq hl3.id
          expect(hl2.prev_highlight_id).to eq hl3.id
          expect(hl3.order_in_source).to be > hl1.order_in_source
          expect(hl3.order_in_source).to be < hl2.order_in_source
        end

        it 'sets the first highlight\'s next pointer to null when the last one is deleted' do
          hl2.destroy
          hl1.reload
          expect(hl1.next_highlight_id).to be_nil
        end

        it 'sets the last highlight\'s prev pointer to null when the first one is deleted' do
          hl1.destroy
          hl2.reload
          expect(hl2.prev_highlight_id).to be_nil
        end
      end

      context 'when there are three highlights on a source' do
        let!(:hl1) { create(:highlight, source_id: uuid1, scope_id: uuid1) }
        let!(:hl2) { create(:highlight, source_id: uuid1, scope_id: uuid1, prev_highlight: hl1) }
        let!(:mid) { create(:highlight, source_id: uuid1, scope_id: uuid1, prev_highlight: hl1, next_highlight: hl2) }

        it 'reconnects neighbors when the middle highlight is deleted' do
          mid.destroy
          hl1.reload
          hl2.reload
          expect(hl1.next_highlight_id).to eq hl2.id
          expect(hl2.prev_highlight_id).to eq hl1.id
        end
      end
    end
  end

  def expect_error(record, field, regex)
    record.validate
    expect(record.errors[field]).to include(regex)
  end
end
