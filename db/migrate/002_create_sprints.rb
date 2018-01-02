class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.references :project, index: true, foreign_key: true, null: false
      t.references :version, index: true, foreign_key: true, null: false
      t.column :name, :string, :null => false
      t.column :description, :text
      t.column :start_date, :date
      t.column :end_date, :date
      t.column :project_id, :integer, :null => false
      t.column :version_id, :integer, :null => false
      t.column :issue_ids, :text, :null => true
    end

    add_index :sprints, [:name], :name => "sprints_name"
  end
end
