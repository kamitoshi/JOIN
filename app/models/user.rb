class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def fullname
    self.last_name + "　" + self.first_name
  end

  def kana_fullname
    self.kana_last_name + "　" + self.kana_first_name
  end

  # 年齢を生年月日から算出
  def age
    (Date.today.strftime("%Y%m%d").to_i - self.birthday.strftime("%Y%m%d").to_i) / 10000
  end

end
