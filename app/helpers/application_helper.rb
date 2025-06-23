module ApplicationHelper
  # 显示中文日期和星期
  def chinese_date_with_weekday(date = Date.current)
    I18n.l(date, format: "%Y\u5E74%m\u6708%d\u65E5 %A")
  end

  # 显示中文日期和星期（简短格式）
  def chinese_date_short_with_weekday(date = Date.current)
    I18n.l(date, format: "%m\u6708%d\u65E5 %A")
  end

  # 只显示中文星期
  def chinese_weekday(date = Date.current)
    I18n.l(date, format: "%A")
  end
end
