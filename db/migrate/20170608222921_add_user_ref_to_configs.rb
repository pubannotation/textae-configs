class AddUserRefToConfigs < ActiveRecord::Migration
  def change
    add_reference :configs, :user, index: true, foreign_key: true
  end
end
