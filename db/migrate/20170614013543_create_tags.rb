class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags, id: :uuid do |t|
      t.string :name
      t.references :link, type: :uuid
      t.references :user, type: :uuid
      t.references :team, type: :uuid

      t.timestamps
    end
  end
end
