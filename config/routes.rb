Rails.application.routes.draw do
  namespace :api do
    api_version(
      module: 'V0',
      path: { value: 'v0' },
      defaults: { format: :json }
    ) do

      resources :highlights

      get :swagger, to: 'swagger/docs#json'

      get :info, to: 'info#info'

      scope :diagnostics, controller: :diagnostics do
        get :exception
        get 'status_code/:status_code', action: :status_code
      end
    end
  end
end
