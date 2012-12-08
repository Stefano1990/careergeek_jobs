module ApplicationHelper
  def blog_last_posts
    parser = CareergeekblogParser.new
    parser.latest_articles
  end
end
