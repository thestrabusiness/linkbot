class CreateLinkTags < ActiveRecord::Migration[5.0]
  def change
    create_table :links_tags, id: :uuid do |t|
      t.references :link, type: :uuid
      t.references :tag, type: :uuid
    end

    remove_reference :tags, :link, type: :uuid
  end
end
