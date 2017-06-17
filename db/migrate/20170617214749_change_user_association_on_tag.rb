class ChangeUserAssociationOnTag < ActiveRecord::Migration[5.0]
  def change
    remove_reference :tags, :user, type: :uuid
    add_reference :tags, :slack_user, type: :uuid, references: :slack_account
  end
end
