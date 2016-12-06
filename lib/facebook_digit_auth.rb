require "facebook_digit_auth/version"

class FacebookDigitAuth

	def test_method(facebook_user_token)
		FacebookClient.data(facebook_user_token)
	end

end
