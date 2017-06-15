module SearchCource
  private
  def set_search_cource
    if params.include?(:search)
      # TODO: Tìm kiếm theo điều kiện tìm kiếm và trả về kết quả.
      add_breadcrumb I18n.t(:search)
      @courceCategory = Cource.searchCategory(params[:search])
      @courceProvince = Cource.searchProvince(params[:search])
      @courceCost = Cource.searchCost(params[:search])
      @courceTime = Cource.searchTime(params[:search])
      @cources = (@courceCategory).merge(@courceProvince).merge(@courceCost).merge(@courceTime)
      @cources = @cources.paginate(page: params[:page])
    else
      @cources = Cource.all.paginate(page: params[:page])
    end
  end
end