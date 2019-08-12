class AddUserStatusPlayerinfos < ActiveRecord::Migration[5.2]
  def change
    add_column :playerinfos, :status, :string
  end
end
