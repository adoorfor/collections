class User < ActiveRecord::Base
end


class Organisation < ActiveRecord::Base

  include Collections

  collection(
    :name => :members,
    :as => :user,
  )

  collection(
    :name => :owner,
    :as => :user,
    :through => :members,
  )

  collection(
    :name => :admins,
    :as => :user,
    :through => :members,
  )
end
