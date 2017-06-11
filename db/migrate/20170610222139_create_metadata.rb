class CreateMetadata < ActiveRecord::Migration[5.0]
  def change
    create_table :metadata, id: :uuid do |t|
      t.string :url, index: true
      t.string :title
      t.string :description
      t.string :domain

      t.attachment :image

      t.timestamps
    end

    add_reference :links, :metadata, type: :uuid
  end
end
