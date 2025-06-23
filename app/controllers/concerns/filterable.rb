module Filterable
  def filter!(resource_class, base_query = nil)
    store_filters(resource_class)
    apply_filters(resource_class, base_query)
  end

  private

  def store_filters(resource_class)
    session["#{resource_class.to_s.underscore}_filters"] = {} unless session.key?("#{resource_class.to_s.underscore}_filters")
    session["#{resource_class.to_s.underscore}_filters"].merge!(filter_params_for(resource_class))
  end

  def apply_filters(resource_class, base_query = nil)
    filters = session["#{resource_class.to_s.underscore}_filters"]

    if base_query
      # 如果有基础查询，在基础查询上应用过滤器
      resource_class.filter(filters).merge(base_query)
    else
      # 否则使用默认的filter方法
      resource_class.filter(filters)
    end
  end

  def filter_params_for(resource_class)
    if resource_class.respond_to?(:FILTERS_PARAMS)
      params.permit(resource_class::FILTERS_PARAMS)
    else
      params.permit(:query, :sort)
    end
  end
end
