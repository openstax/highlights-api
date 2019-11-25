require 'rails_helper'

RSpec.describe ServiceLimits, type: :service do
  describe '.get_check' do
    context 'over the limit for gets' do
      let(:highlights) { build_list(:highlight, 10) }

      before do
        ServiceLimits.send('remove_const', 'MAX_HIGHLIGHTS_PER_GET')
        ServiceLimits.const_set('MAX_HIGHLIGHTS_PER_GET', 2)
      end

      it 'raises an exception' do
         expect do
           ServiceLimits.get_check(highlights)
         end.to raise_error(ServiceLimits::ExceededMaxHighlightsPerGet)
      end
    end
  end
end
