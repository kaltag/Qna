class AddMarkToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :mark, :bool, default: false
  end
end
