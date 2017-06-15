module Admin::CourcesHelper
  def status_convert_cources(str)
    case str
      when 0
        t(:cource_status_0)
      when 1
        t(:cource_status_1)
      when 2
        t(:cource_status_2)
      when 3
        t(:cource_status_3)
      else
        t(:cource_status_4)
    end
  end
  def featured_convert(str)
    case str
      when 0
        t(:cource_featured_0)
      when 1
        t(:cource_featured_1)
      when 2
        t(:cource_featured_2)
      else
        t(:cource_featured_3)
    end
  end
end
