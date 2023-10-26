class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true
      t.integer :voice

      t.timestamps
    end

    add_index :votes, %i[user_id votable_type votable_id], unique: true
  end
end
