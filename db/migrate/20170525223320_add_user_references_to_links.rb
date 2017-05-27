class AddUserReferencesToLinks < ActiveRecord::Migration[5.0]
  def change
    remove_column :links, :user_from, type: :string
    remove_column :links, :user_to, type: :string

    add_reference :links, :user_from, type: :uuid, index: true, references: :users
    add_reference :links, :user_to, type: :uuid, index: true, references: :users
  end
end
