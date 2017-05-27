class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :teams, id: :uuid do |t|
      t.string :team_id, unique: true
      t.string :name
      t.boolean :active, default: true
      t.string :domain
      t.string :token

      t.timestamps
    end
  end
end
