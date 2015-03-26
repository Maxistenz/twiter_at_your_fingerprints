class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin

  has_and_belongs_to_many :trends

  # Adds a trend to a user. In case that the trend exist adds that instance.
  # Otherwise crates a new trend with the name and url passed and associates to the user.
  #
  # @param string [name] the name of the trend
  # @param string [url] the url of the trend
  #
  # @return [boolean] true if no exists already a trend in the users trend list, with the same
  # name and url. Otherwise returns false
  def add_trend(name, url)
    trend_exists =  User.joins(:trends).where('email = ? AND trends.name = ? AND trends.url = ?',
                                       self.email, name, url)
    if trend_exists.empty?
      trend = Trend.where('name = ? AND url = ?', name, url).first
      if (trend.nil?)
        trend = Trend.new(name: name, url: url)
      end
      self.trends << trend
      trend
    else
      nil
    end
  end

end