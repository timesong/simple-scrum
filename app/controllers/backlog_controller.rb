class BacklogController < ApplicationController
  unloadable

  before_action :find_backlog_by_backlog_id

  def create
    issue = Issue.new params[:subject]
    issue.description = params[:description] unless params[:description].nil?
    issue.save

    issue_id_list = @product_backlog.ids_to_list
    issue_id_list << issue.id
    @product_backlog.issue_ids = issue_id_list.join(",")
    @product_backlog.save

    render :json => {:ok => true}
  end

  def update
    @product_backlog.issue_ids = params[:ids]
    @product_backlog.save()

    render :json => {:ok => true}
  end

  def move_to_sprint
    @sprint = Sprint.find params[:sprint_id]
    issue_id = params[:issue_id]
    issue_id_list = @sprint.ids_to_list
    result = false

    if issue_id_list.index(issue_id).nil?
      issue_id_list.push issue_id
      @sprint.issue_ids = issue_id_list.join(",")
      @sprint.save

      issue_id_list = @product_backlog.ids_to_list
      issue_id_list.delete issue_id
      @product_backlog.issue_ids = issue_id_list.join(",")
      @product_backlog.save

      result = true
    end

    render :json => {:ok => result}
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_backlog_by_backlog_id
    @product_backlog = ProductBacklog.find(params[:backlog_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
