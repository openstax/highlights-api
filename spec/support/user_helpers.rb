module UserHelpers

  def stub_current_user_uuid(uuid)
    allow_any_instance_of(ApplicationController).to receive(:current_user_uuid) { uuid }
  end

end
