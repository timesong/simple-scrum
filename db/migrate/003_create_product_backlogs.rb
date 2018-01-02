class CreateProductBacklogs < ActiveRecord::Migration
  def change
    create_table :product_backlogs do |t|
      t.references :project, index: true, foreign_key: true, null: false
      t.references :version, index: true, foreign_key: true, null: false
      t.column :issue_ids, :text, :null => true
    end
  end
end
