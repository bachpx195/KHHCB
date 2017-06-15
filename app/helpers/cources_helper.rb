# ĐIỀU KIỆN NẾU TIỀN BẰNG O THÌ LÀ MIỄN PHÍ.
module CourcesHelper
  def convert_money(str)
    if str == 0
      "Miễn phí"
    else
      number_with_delimiter(str, delimiter: ".", separator: ",")+" VNĐ"
    end
  end
end
