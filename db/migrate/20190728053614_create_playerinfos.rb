class CreatePlayerinfos < ActiveRecord::Migration[5.2]
  def change
    create_table :playerinfos do |t|
      t.string :userWallet

      t.timestamps
    end
  end
end
