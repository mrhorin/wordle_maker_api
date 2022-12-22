module WordsHelper
  def parse_edit_params params
    page = params[:page].present? ? params[:page] : 1
    per = params[:per].present? ? params[:per] : 50
    sort = params[:s] == "name" ? "name" : "id"
    order = params[:o] == "d" ? "desc" : "asc"
    { page: page, per: per, sort: sort, order: order }
  end
end