module Admin::BannersHelper
  def convert_status(str)
    if str == 1
      t(:banner_status_1)
    else
      t(:banner_status_0)
    end
  end

  def convert_position(str)
    if str == 1
      t(:banner_position_1)
    else
      t(:banner_position_2)
    end
  end
end
