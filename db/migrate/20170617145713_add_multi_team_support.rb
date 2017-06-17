class AddMultiTeamSupport < ActiveRecord::Migration[5.0]
  def up
    create_table :teams_users, id: :uuid do |t|
      t.references :team, type: :uuid
      t.references :user, type: :uuid
    end

    remove_reference :users, :team, type: :uuid
    add_reference :users, :active_team, type: :uuid, references: :teams, index: true
    add_reference :links, :team, type: :uuid, index: true
  end

  def down
    drop_table :teams_users
    add_reference :users, :team, type: :uuid, index: true
    remove_reference :users, :active_team, references: :teams, index: true
    remove_reference :links, :team, type: :uuid, index: true
  end
end
