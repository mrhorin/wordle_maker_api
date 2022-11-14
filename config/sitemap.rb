# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "#{Rails.configuration.app[:URL][:UI][:PROTOCOL]}://#{Rails.configuration.app[:URL][:UI][:DOMAIN]}"

SitemapGenerator::Sitemap.create do
  Game.find_each do |g|
    add "/games/#{g.id}", lastmod: g.updated_at
    add "/ja/games/#{g.id}", lastmod: g.updated_at
  end
end

SitemapGenerator.verbose = false
