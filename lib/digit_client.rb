require 'httparty'

class DigitsClient
  def initialize(digit_params)
    @digits_credentials = digit_params
    @user_id = digit_params[:user_id]
    @phone_no = digit_params[:number]
    @auth_token = digit_params[:auth_token]
    @auth_token_secret = digit_params[:auth_token_secret]
    @auth_headers = digit_params[:auth_headers]
  end

  def data
  	if verified
  		{result: true,data: response}
  	else
  		{result: false,message: "Wrong credentials supplied!"}
  	end	
  end

  def response
  	HTTParty.get(url, :headers => header)
  end

  def verified
    if response["phone_number"] != @phone_no || response["id_str"] != @user_id response["access_token"]["token"] != @auth_token || response["access_token"]["secret"] != @auth_token_secret
      	false
  	else
  		true
    end    
  end

  def header
  	{"Authorization" => @auth_headers['X-Verify-Credentials-Authorization']}
  end

  def url
  	@auth_headers["X-Auth-Service-Provider"]
  end

end  