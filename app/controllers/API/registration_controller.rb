class API::RegistrationController < ActionController::API
  def register
    response = RestClient.post('localhost:9292/api/teams', {code: params[:code]})

    if response.code == 200
      render nothing: true, status: 200
    end

  rescue RestClient::BadRequest
    render nothing: true, status: 400
  end
end
