class CreatePublications < ActiveRecord::Migration[7.1]
  def change
    create_table :publications do |t|
      t.string :title
      t.text :content
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :publications, :deleted_at
  end
end
