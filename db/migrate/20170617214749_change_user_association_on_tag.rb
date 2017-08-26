class ChangeUserAssociationOnTag < ActiveRecord::Migration[5.0]
  def change
    remove_reference :tags, :user, type: :uuid
    remove_reference :user_tags, :user, type: :uuid
    add_reference :tags, :slack_account, type: :uuid
    add_reference :user_tags, :slack_account, type: :uuid
  end
end
