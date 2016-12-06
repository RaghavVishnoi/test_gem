require "facebook_digit_auth/version"
require "facebook_client"
class FacebookDigitAuth

	def test_method(facebook_user_token)
		FacebookClient.new(facebook_user_token).data
	end



end
