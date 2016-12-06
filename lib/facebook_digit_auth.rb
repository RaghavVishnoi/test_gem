require "facebook_digit_auth/version"

class FacebookDigitAuth < FacebookClient

	def test_method(facebook_user_token)
		FacebookClient.new(facebook_user_token).data
	end



end
