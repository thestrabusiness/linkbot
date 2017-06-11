class AddMultipleRecipientsToLink < ActiveRecord::Migration[5.0]
  def up
    create_table :user_tags, id: :uuid do |t|
      t.references :user, type: :uuid
      t.references :link, type: :uuid
      t.index [:user_id, :link_id]

      t.timestamps
    end

    add_index :users, :slack_id
    remove_column :links, :user_to_id
  end

  def down
    drop_table :user_tags
    remove_index :users, :slack_id
    add_reference :links, :user_to, type: :uuid, index: true, references: :users
  end
end
