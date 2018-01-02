Redmine::Plugin.register :scrum do
  name 'Scrum plugin'
  author 'Zhang Kun'
  description 'Redmine Scrum 管理插件'
  version '1.0.0'
  url ''
  author_url ''

  project_module :scrum do
    permission :scrum, scrum: :index
  end

  menu :project_menu, :scrum, { :controller => 'scrum', :action => 'index' }, :caption => 'Scrum 管理', :after => :activity, :param => :project_id

end
