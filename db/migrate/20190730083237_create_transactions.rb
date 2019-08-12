class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :transaction_hash
      t.string :transaction_type
      t.string :user_wallet
      t.string :status

      t.timestamps
    end
  end
end
