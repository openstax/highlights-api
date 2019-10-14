class Api::V0::InfoController < Api::V0::BaseController

  # swagger_path '/info' do
  #   operation :get do
  #     key :summary, 'Get info on indexes'
  #     key :description, 'Get info on indexes'
  #     key :operationId, 'info'
  #     response 200 do
  #       key :description, 'Success.  Returns the index info.'
  #       schema do
  #         key :'$ref', :InfoResults
  #       end
  #     end
  #     extend Api::V0::Swagger::ErrorResponses::UnprocessableEntityError
  #     extend Api::V0::Swagger::ErrorResponses::ServerError
  #   end
  # end

  def info
    # starting = Time.now
    # time_took = Time.at(Time.now - starting).utc.strftime('%H:%M:%S')

    json = {
      version: '0.0.0'
    }

    render json: json, status: :ok
  end
end
