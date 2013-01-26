class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :screen_name
      t.integer :team_id

      t.timestamps
    end
  end
end
