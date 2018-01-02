module ScrumHelper
  def ids_to_list
    result = Array.new
    result += issue_ids.split(',') unless issue_ids.nil? or issue_ids.blank?
    result
  end
end
