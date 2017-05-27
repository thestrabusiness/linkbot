class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links, id: :uuid do |t|
      t.string :url
      t.string :slug, unique: true
      t.string :user_from
      t.string :user_to
      t.datetime :reminder

      t.timestamps
    end
  end
end
