# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  email         :string(255)
#  fullname      :string(255)
#  token         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  apple_user_id :string(255)
#
class User < ApplicationRecord
end
