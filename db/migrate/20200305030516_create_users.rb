class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :type
      t.string :source_identifier
      t.string :encrypted_password

      t.timestamps
    end
  end
end
