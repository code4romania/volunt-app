class CreateValidationTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :validation_tokens do |t|
     t.binary :token, limit: 255, null: false
      t.references :user, null: true
      t.integer :category, null: false
      t.datetime :valid_until, null: true

      t.timestamps null: false
    end

    add_index :validation_tokens, :token, unique: true
  end
end
