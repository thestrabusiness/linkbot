class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :url
      t.string :internal_url
      t.string :user_from
      t.string :user_to
      t.datetime :reminder

      t.timestamps
    end
  end
end
