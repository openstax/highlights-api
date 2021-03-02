class Precalculated < ApplicationRecord
  scope :info, -> { where(data_type: 'info') }
end
