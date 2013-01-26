class AddRestrictedColumn < ActiveRecord::Migration
  def change
    add_column(:polls, :restricted, :boolean)
  end
end
