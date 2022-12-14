require 'google/analytics/data'

class Utils::PvRanking
  CREDENTIAL_FILE_PATH = "config/ga4_credential.json"
  PROPERTY = "properties/342304131"

  # ゲームページのPVランキング
  def self.games
    expires_in = Time.now.at_end_of_day - Time.now
    Rails.cache.fetch("games_pv_ranking", skip_nil: true, expires_in: expires_in) do
      if Rails.env.production?
        report = pv_report
        # pagePath が games の行を抽出
        report[:rows].select!{|row| row[:dimension_values][1][:value].match(/\/games\/\d+/)}
        report[:rows].take(10).map do |row|
          row[:dimension_values][1][:value].slice(/games\/(\d+)/, 1).to_i
        end
      else
        Game.all.limit(10).map{|g| g.id}
      end
    end
  end

  def self.pv_report(start_date: "30daysAgo", end_date: "today")
    client = Google::Analytics::Data.analytics_data do |config|
      config.credentials = CREDENTIAL_FILE_PATH
    end
    # 参考: https://developers.google.com/analytics/devguides/reporting/data/v1/rest/v1beta/properties/runReport
    body = {
      "dimensions": [
        { "name": "pageTitle" },
        { "name": "pagePath"},
      ],
      "metrics": [
        { "name": "screenPageViews" },
      ],
      "date_ranges": [
        { "start_date": start_date, "end_date": end_date }
      ],
      "limit": 100,
      "order_bys": [
        { "desc": true, "metric": {"metric_name": "screenPageViews"} },
      ],
    }
    request = Google::Analytics::Data::V1beta::RunReportRequest.new body
    request.property = PROPERTY
    response = client.run_report request
    response.to_h
  end
end