class CreateBacklogIssues < ActiveRecord::Migration
  def change
    create_table :backlog_issues do |t|
      t.references :project, index: true, foreign_key: true, null: false
      t.references :version, index: true, foreign_key: true, null: false
      t.references :issue, index: true, foreign_key: true, null: false
      t.column :status, :integer, :default => 0
    end
  end
end
