require "facebook_digit_auth/version"

module FacebookDigitAuth
  
	def self.test_method(facebook_user_token)
		FacebookClient.new(facebook_user_token).data
	end

end
