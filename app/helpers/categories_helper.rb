module CategoriesHelper
  def category_label(category)
    content_tag(:span, category.name, class: "label label-info label-#{category.name.underscore}")
  end
end
