class Sprint < ActiveRecord::Base
  include Redmine::SafeAttributes
  include ScrumHelper

  belongs_to :project
  belongs_to :version
  # has_many :backlog_issues :dependent => :nullify

  safe_attributes :name, :description, :start_date, :end_date, :issue_ids

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:version_id]
  validates_length_of :name, :maximum => 60
  validates_length_of :description, :maximum => 25
  attr_protected :id

  def to_s
    name
  end

  def pbis(status)
    issue_list = Array.new
    issue_id_list = ids_to_list

    issue_id_list.each do |i|
      issue = Issue.find_by(:id => i, :project => project, :fixed_version => version, :status => status)
      issue_list.push(issue) unless issue.nil? or issue.blank?
    end

    issue_list
  end
end