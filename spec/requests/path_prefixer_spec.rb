require 'rails_helper'

RSpec.describe '"highlights" path prefix', type: :request do

  it "should route requests that have the prefix" do
    expect_any_instance_of(Api::V0::InfoController).to receive(:info)
    get("/highlights/api/v0/info")
  end

  it "should route requests that don't have the prefix" do
    expect_any_instance_of(Api::V0::InfoController).to receive(:info)
    get("/api/v0/info")
  end

end
