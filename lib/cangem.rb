require "cangem/version"

module Cangem
  class Role < ActiveRecord::Base
  	has_many :user_roles
	has_many :users,through: :user_roles
  end

  class User < ActiveRecord::Base
  	has_many :user_roles
    has_many :roles,through: :user_roles   
  end

  class UserRole < ActiveRecord::Base
  	belongs_to :user
	belongs_to :role
	validates :user,presence: true
	validates :role,presence: true
	validates_uniqueness_of  :user_id, scope: :role_id
  end
end
