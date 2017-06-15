class Admin::AdminController < ApplicationController
  layout 'admin'

  add_breadcrumb I18n.t(:dashboard_index_title), :admin_dashboards_path

  # CanCanCan
  load_and_authorize_resource
  before_filter :authenticate_user!

  def open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else
        raise "Unknown file type: #{file.original_filename}"
    end
  end
end
