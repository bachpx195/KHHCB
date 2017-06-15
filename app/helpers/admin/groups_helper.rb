module Admin::GroupsHelper
  def status_convert(str)
    case str
      when 1
        t(:group_status_0)
      when 2
        t(:group_status_1)
      when 3
        t(:group_status_2)
      else
        t(:group_status_3)
    end
  end
end
