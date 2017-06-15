class FrontendController < ApplicationController
  layout 'frontend'
  add_breadcrumb I18n.t(:home), :root_path

  # HÀM TẠO
  def initialize
    super
    shared_cource_vip
    shared_banner_1
  end

  private
  def shared_cource_vip
    @courceVips = Cource.where(featured: 2)
  end

  def shared_banner_1
    @banner1 = Banner.where(status: 1, position: 1).take
  end
end
