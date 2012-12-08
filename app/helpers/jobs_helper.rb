module JobsHelper
  def category_link(name, url=jobs_path(category: name))
    controller = params[:controller]
    action = params[:action]
    if controller == "jobs" and action == "show" # We are displaying a job
      if Job.find(params[:id]).category.name == name
        active_link(name, url)
      else
        inactive_link(name, url)
      end
    elsif controller == "jobs" and action == "index" and params[:category]
      if params[:category] == name
        active_link(name, url)
      else
        inactive_link(name, url)
      end
    elsif controller == "jobs" and action == "index" and !params[:category]
      if name == "All jobs"
        active_link(name, url)
      else
        inactive_link(name, url)
      end
    else
      inactive_link(name, url)
    end
  end


  private
      def active_link(name, url)
        html = "<li class='active'>#{link_to name, url}</li>".html_safe
      end

      def inactive_link(name, url)
        html = "<li>#{link_to name, url}</li>".html_safe
      end
end
