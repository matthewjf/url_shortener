namespace :url_shortener do
  desc "prunes urls that haven't been visited in the last week"
  task prune_old_urls: :environment do
    ShortenedUrl.prune(60*24*7)
  end
end
