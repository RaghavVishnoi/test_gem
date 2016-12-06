class FacebookClient
  def initialize(token)
    @client = Koala::Facebook::API.new(token)
  end

  def data
  	{
  		"id": user_id,
  		"birthday": birthday,
  		"first_name": first_name,
  		"last_name": last_name,
  		"email": email,
  		"work": work,
  		"education": education,
  		"gender": gender,
  		"age": age,
  		"token_for_business": token_for_business,
  		"facebook_friend_ids": facebook_friend_ids,
  		"profile_picture": profile_picture

  	}
  end

  def user_id
    basic_information["id"]
  end

  def birthday
    if basic_information["birthday"].present?
      Date.strptime(basic_information["birthday"], "%m/%d/%Y")
    else
      ""
    end
  end

  def first_name
    basic_information["first_name"]
  end

  def last_name
    basic_information["last_name"]
  end

  def email
    basic_information["email"]
  end

  def work
    if basic_information["work"].present?
      work = basic_information["work"][0]
      if work["position"] 
        "#{work["position"]["name"]} at #{work["employer"]["name"]}"
      else
        "#{work["employer"]["name"]}"
      end
    else
      ""
    end
  end

  def education
    if basic_information["education"].present?
      education = basic_information["education"]
      if education.length != 0
        education.last['school']['name']
      else  
        "Education not mentioned!"
      end
    end
  end

  def gender
    if basic_information["gender"].present?
      basic_information["gender"]
    else
      "notspecified"
    end
  end

  def age
    if basic_information["birthday"].present?
      Date.today.year - Date.strptime(basic_information["birthday"], "%m/%d/%Y").year 
    else
      0
    end
  end

  def token_for_business
    business_token_info["token_for_business"]
  end

  def facebook_friend_ids
    friends_response.map { |friend| friend["id"] }
  end

  def mutual_friends(facebook_user_id)
    get_mutual_friends(facebook_user_id)
  end

  def profile_picture
  	puts "basic information #{basic_information}"
  	photo_url(basic_information["facebook_user_id"])
  end

  private

  attr_reader :client

  def basic_information
    @basic_information ||= client.get_object("me")
  end

  def user_context(facebook_user_id)
    context = client.get_object("#{facebook_user_id}?fields=context")
  end

  def get_mutual_friends(facebook_user_id)
    context = user_context(facebook_user_id)
    mutual_friends =  client.get_object("#{context["context"]["id"]}?fields=all_mutual_friends.fields(picture.width(100).height(100), name)") 
    if mutual_friends["all_mutual_friends"]
      mutual_friends["all_mutual_friends"]["data"].map{|friend| {"name" => friend["name"], "profile_picture_url" => friend["picture"]["data"]["url"]}}
    else
      []
    end
  end

  def business_token_info
    @business_token_info ||= client.get_object("me?fields=token_for_business")
  end

  def friends_response
    @friends_response ||= client.get_connections("me", "friends?limit=5000")
    puts @friends_response.inspect
    @friends_response ||= client.get_connections("me", "friends?limit=5000")
  end

  def photo_url(facebook_user_id)
	      "http://graph.facebook.com/v2.3/#{facebook_user_id}/picture" +
	      "?height=500&width=500"
  end
end
