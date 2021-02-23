require 'rails_helper'

RSpec.describe InfoJob do
  subject(:info_job) { described_class.new}

  it "should call the InfoStore" do
    expect_any_instance_of(InfoStore).to receive(:call).once
    info_job.perform('test')
  end
end
