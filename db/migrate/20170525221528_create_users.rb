class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :slack_id, unique: true
      t.string :slug, unique:true
      t.references :team, type: :uuid

      t.timestamps
    end
  end
end
