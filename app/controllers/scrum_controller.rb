class ScrumController < ApplicationController
  unloadable

  before_action :find_project_by_project_id, :authorize
  before_action :find_version_by_version_id, :authorize
  before_action :find_sprint_by_sprint_id, :authorize

  def index
    @scrum = Scrum.new @project, @version, @sprint
  end

  def find_version_by_version_id
    @version = Version.find(params[:version_id])
  rescue ActiveRecord::RecordNotFound
    @version = nil
  end

  def find_sprint_by_sprint_id
    @sprint = Sprint.find(params[:sprint_id])
  rescue ActiveRecord::RecordNotFound
    @sprint = nil
  end
end
