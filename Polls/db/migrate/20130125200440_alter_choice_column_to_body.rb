class AlterChoiceColumnToBody < ActiveRecord::Migration
  def change
    rename_column(:choices, :choice, :body)
  end
end
