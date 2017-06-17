class CreateSlackAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_accounts, id: :uuid do |t|
      t.references :user, type: :uuid, index: true
      t.references :team, type: :uuid, index: true
      t.string :slack_id, index: true
      t.string :email
    end

    remove_column :users, :slack_id, :string
    remove_column :users, :email, :string
  end
end
