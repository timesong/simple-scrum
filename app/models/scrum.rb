class Scrum
    attr_reader :project, :versions, :cur_ver, :product_backlog, :sprints, :cur_sprint, :statuses

    def initialize project, cur_ver, cur_sprint
        @project = project
        @versions = Version.where(:project => @project).to_a

        if cur_ver.nil?
            @cur_ver = @versions[0]
        else
            @cur_ver = cur_ver
        end

        @product_backlog = ProductBacklog.find_or_create_by(:project => @project, :version => @cur_ver)
        @sprints = Sprint.where(:project => @project, :version => @cur_ver).to_a

        if cur_sprint.nil?
            @cur_sprint = @sprints[0]
        else
            @cur_sprint = cur_sprint
        end

        @statuses = statuses
    end

    def statuses
        result = IssueStatus.sorted

        if Feature.enabled("only_open_statuses")
            result = result.where(is_closed: false) 
        end

        result
    end

    def to_s
        @project.name
    end
end
