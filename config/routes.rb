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

    end
  end
end
