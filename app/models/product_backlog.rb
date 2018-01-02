class ProductBacklog < ActiveRecord::Base
  include Redmine::SafeAttributes
  include ScrumHelper

  belongs_to :project
  belongs_to :version

  safe_attributes 'issue_ids'

  def pbis
    issue_list = Array.new
    issue_id_list = ids_to_list

    issue_id_list.each do |i|
      issue = Issue.find_by(:id => i, :project => project, :fixed_version => version)
      issue_list.push(issue) unless issue.nil? or issue.blank?
    end

    issue_list
  end
end
